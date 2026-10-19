"""
Which kernels to build, in what order, and which designs of each.
"""
import logging
from graphlib import TopologicalSorter

from tessera.const import HW_CONSTRAINTS_PARAMS
from tessera.models.design import Design, PARAMS_MAPPED_TO_STRUCT
from tessera.models.kernel import Kernel
from tessera.parser.cpp import live_instances


def resolve_kernels(kernels, kernel_name, blackbox):
    "Load a kernel and, recursively, the kernels it blackboxes"
    if kernel_name in kernels:
        return
    kernel = kernels[kernel_name] = Kernel(kernel_name)
    kernel.blackbox = blackbox.get(kernel_name, [])
    for dep in kernel.blackbox:
        resolve_kernels(kernels, dep, blackbox)


def descendants(graph, name):
    "Every kernel a kernel blackboxes, at any depth"
    below = set()
    for dep in graph[name]:
        below |= {dep} | descendants(graph, dep)
    return below


def child_design(parent, params, child_kernel, below=()):
    """
    A child design: the parent's values for the child's design key, then
    the template arguments the compiler gave the child, then the hardware
    constraints, which a child inherits.
    """
    design = {k: parent.design[k] for k in child_kernel.config.design_key
              if k in parent.design}
    design.update(params)

    for param in HW_CONSTRAINTS_PARAMS:
        design[param] = parent.design[param]

    deps = {k: v for k, v in parent.design.items() if k.startswith("deps.")}
    own = f"deps.{child_kernel.name}."

    # deps gives this kernel exact times; otherwise the ratios apply, per level
    design["period"] = deps.get(own + "period",
                                parent.design["dep_period_ratio"] * parent.design["period"])

    # The parent's own io_delay is its parent's split, not this child's
    design.pop("io_delay", None)
    io_delay = deps.get(own + "io_delay")
    if "dep_io_ratio" in parent.design:
        design["dep_io_ratio"] = parent.design["dep_io_ratio"]
        if io_delay is None:
            # The parent keeps this share of the child's period at each child port
            io_delay = round(parent.design["dep_io_ratio"] * design["period"], 4)
    if io_delay:
        design["io_delay"] = io_delay

    # A child carries only the settings of kernels it reaches, so a change for
    # one kernel never renames the builds of another
    design.update({k: v for k, v in deps.items() if k.split(".")[1] in below})
    design.update({k: v for k, v in parent.design.items()
                   if k.startswith("catapult.") and k.split(".")[1] in {child_kernel.name, *below}})

    child = Design(design)
    # The parent already holds the structs the child's refs point at
    for param in PARAMS_MAPPED_TO_STRUCT:
        root = design.get(param, "").split("-")[0]
        if root in parent.structs:
            child.structs[root] = parent.structs[root]
    return child


def resolve_designs(parent_kernel, parent_designs, kernels, kernel_designs, graph):
    "Add the child designs each parent design instantiates, deduplicated"
    for parent in parent_designs.values():
        instances = live_instances(parent, parent_kernel)

        for child_name in parent_kernel.blackbox:
            if child_name not in instances:
                logging.debug(f"{parent_kernel.name} {parent.build_dir.name} "
                                f"does not use blackboxed dep '{child_name}'")
                continue

            child_kernel = kernels[child_name]
            below = descendants(graph, child_name)
            for params in instances[child_name]:
                child = child_design(parent, params, child_kernel, below)
                key = child.get_hash(child_kernel.config.design_key)
                child = kernel_designs[child_name].setdefault(key, child)
                parent.deps.setdefault(child_name, {})[key] = child


def get_schedule(kernel_name: str, designs: list[Design], blackbox: dict[str, list[str]]):
    "The kernels in build order, each with the designs it needs"
    kernels = {}
    resolve_kernels(kernels, kernel_name, blackbox)
    graph = {name: kernel.blackbox for name, kernel in kernels.items()}
    order = list(TopologicalSorter(graph).static_order())

    # Only the target and its blackboxed children are built on their own; a
    # setting for an inlined kernel would silently do nothing
    below = descendants(graph, kernel_name)
    built = {"deps": below, "catapult": below | {kernel_name}}
    for block, kernels_built in built.items():
        named = {k.split(".")[1] for d in designs for k in d.design if k.startswith(f"{block}.")}
        for name in sorted(named - kernels_built):
            logging.warning(f"{block}.{name}: {name} is not built on its own under "
                            f"{kernel_name}, so its settings have no effect")
        # Dropped, so they add nothing to the hash
        for design in designs:
            for key in [k for k in design.design if k.startswith(f"{block}.")]:
                if key.split(".")[1] not in kernels_built:
                    del design.design[key]

    # name -> hash -> Design, so each kernel holds a design once
    kernel_designs = {name: {} for name in order}
    design_key = kernels[kernel_name].config.design_key
    kernel_designs[kernel_name] = {d.get_hash(design_key): d for d in designs}

    # Parents first, so a kernel's designs are complete before it passes
    # them down to its own deps
    for name in reversed(order):
        for design in kernel_designs[name].values():
            design.attach(kernels[name])
            design.uses_blackboxes = bool(graph[name])
        resolve_designs(kernels[name], kernel_designs[name], kernels, kernel_designs, graph)

    return [(kernels[name], list(kernel_designs[name].values())) for name in order]
