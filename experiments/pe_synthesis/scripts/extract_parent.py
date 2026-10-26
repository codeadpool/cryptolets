"""Reachable RTL extraction, including helpers inside generate blocks.

Copied from the validated historical DC driver; no arithmetic transformations.
"""
from pathlib import Path
from tree_sitter import Language, Parser
import tree_sitter_verilog

def walk(node):
    yield node
    for child in node.children:
        yield from walk(child)

def modules(path):
    """Read only module boundaries/instances, avoiding numerical RTL rewrites."""
    data = Path(path).read_bytes()
    tree = Parser(Language(tree_sitter_verilog.language())).parse(data)
    answer = {}
    for node in walk(tree.root_node):
        if node.type != 'module_declaration':
            continue
        identifiers = [n for n in walk(node) if n.type == 'simple_identifier']
        name = identifiers[0].text.decode()
        refs = []
        for inst in walk(node):
            # Tree-sitter's Verilog grammar may classify parameterized
            # module instances inside generate blocks as interface instances
            # (the syntax is ambiguous). Catapult FIFO register helpers use
            # this form. Follow all syntactically equivalent instantiations.
            if inst.type in {'module_instantiation', 'interface_instantiation', 'program_instantiation'}:
                identifier = next(n for n in walk(inst) if n.type == 'simple_identifier')
                refs.append(identifier.text.decode())
        answer[name] = {'text': node.text.decode(), 'refs': refs}
    if not answer:
        raise RuntimeError(f'No modules found in {path}')
    return answer

def parent_rtl(raw_path, concat_path, top, boundary, destination):
    """Keep reachable parent/helper logic, stopping at the real mapped child.

    Catapult concat RTL contains entire child implementations. Never analyze
    those again after loading the mapped DDC. Helper modules shared with the
    child (ccs/mgc) are still retained when the parent itself references them.
    """
    definitions = modules(concat_path)
    definitions.update(modules(raw_path))
    selected, pending, unresolved = {}, [top], set()
    while pending:
        name = pending.pop()
        if name in selected or name == boundary:
            continue
        if name not in definitions:
            unresolved.add(name)
            continue
        selected[name] = definitions[name]
        pending.extend(definitions[name]['refs'])
    # DW primitives may legitimately come from the configured synthetic library.
    unsupported = sorted(x for x in unresolved if not x.startswith('DW'))
    if unsupported:
        raise RuntimeError(f'Unresolved RTL references before DC: {unsupported}')
    if top not in selected:
        raise RuntimeError(f'Top {top} not found')
    destination.write_text('// Extracted reachable parent/helper modules; real child supplied by mapped DDC.\n'
                           + '\n\n'.join(x['text'] for x in selected.values()) + '\n')
    return {'modules': sorted(selected), 'synthetic_references': sorted(unresolved),
            'protected_boundary': boundary,
            'boundary_reference_count': sum(x['refs'].count(boundary) for x in selected.values())}
