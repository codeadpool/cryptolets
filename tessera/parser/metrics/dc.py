"""
Parse the metrics Design Compiler reports, per design.
"""
import re


def _field(report, text, name):
    "A 'Name:   value' line of a DC report"
    match = re.search(rf"{re.escape(name)}:\s+(\S+)", text)
    if not match:
        raise Exception(f"No '{name}' in {report}")
    return match.group(1)


def parse_dc_qor(design, passes):
    """
    The cell area DC built, in square micrometres, and the critical path it
    achieved after its last pass, in nanoseconds. The high level run estimated both before
    synthesis, so the pair says whether the design holds once built from cells.
    """
    report = design.build_dir / "reports" / "dc" / f"pass_{passes}" / "qor.rpt"
    text = report.read_text()

    period = float(_field(report, text, "Critical Path Clk Period"))
    slack = _field(report, text, "Critical Path Slack")

    # Each path group has its own section; the first one alone can hide a miss
    # in another, such as the inputs of a child that a parent times as a whole
    slack_dc, tns_dc = {}, {}
    sections = re.split(r"Timing Path Group '(\S+)'", text)[1:]
    for group, body in zip(sections[::2], sections[1::2]):
        group_slack = _field(report, body, "Critical Path Slack")
        # An unconstrained group cannot miss
        slack_dc[group] = None if "uninit" in group_slack else float(group_slack)
        tns_dc[group] = None if "uninit" in group_slack else float(_field(report, body, "Total Negative Slack"))

    check = design.build_dir / "reports" / "dc" / f"pass_{passes}" / "check_design.rpt"
    check_errors = sum(line.startswith("Error") for line in check.read_text().splitlines()) \
        if check.exists() else None

    # Met only on complete evidence: a miss is False, a missing report, no
    # path group or an unconstrained one is None, so neither reads as met
    timed = [(s, t) for s, t in zip(slack_dc.values(), tns_dc.values()) if s is not None]
    if any(s < 0 or t != 0 for s, t in timed) or check_errors:
        met = False
    elif check_errors is None or not slack_dc or len(timed) < len(slack_dc):
        met = None
    else:
        met = True
    return {
        "area_dc": round(float(_field(report, text, "Cell Area")), 4),
        # An unconstrained design reports no slack, so it has no delay
        "delay_dc": None if "uninit" in slack else round(period - float(slack), 4),
        "slack_dc": slack_dc,
        "tns_dc": tns_dc,
        "check_errors": check_errors,
        "met_dc": met,
    }


def parse_dc_power(design, module, passes):
    """
    The power DC estimated, in watts, if every net switched as often as the
    tool assumes. A power run measures the real figure instead. The report
    mixes its units: dynamic power in mW, leakage in uW.
    """
    report = design.build_dir / "reports" / "dc" / f"pass_{passes}" / "power.rpt"

    # The module also names a row in the wire load table, so match the row
    # whose columns are numbers
    row = re.search(rf"^{re.escape(module)}\s+([\d.e+-]+)\s+([\d.e+-]+)\s+([\d.e+-]+)\s",
                    report.read_text(), re.M)
    if not row:
        raise Exception(f"No power row for '{module}' in {report}")

    switching, internal, leakage = (float(v) for v in row.groups())
    return {
        "switching": switching * 1e-3,
        "internal": internal * 1e-3,
        "leakage": leakage * 1e-6,
        # The reported total rounds the mixed units, so it is summed here
        "total": (switching + internal) * 1e-3 + leakage * 1e-6,
    }
