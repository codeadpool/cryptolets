"License checks, so a pool is capped by what is free"
import re
import subprocess


# The licenses each tool checks out. A job needs all of them, so the one
# with the fewest free sets how many jobs can run.
PRODUCT_TO_LMSTAT_NAMES = {
    "catapult_ultra": ["CatapultUltra_c"],
    "dc": ["Design-Compiler", "DC-Expert", "DC-Ultra-Opt", "DC-Ultra-Features"],
    "prime_power": ["PrimePower"],
}

def get_license_info(product="catapult_ultra"):
    "Issued, in use and available licenses of the product's scarcest feature"
    out = subprocess.run(["lmstat", "-a"], stdout=subprocess.PIPE, stderr=subprocess.PIPE,
                         universal_newlines=True, check=True).stdout

    tightest = None
    for name in PRODUCT_TO_LMSTAT_NAMES[product]:
        m = re.search(rf"Users of {re.escape(name)}:.*?Total of (\d+).*?issued.*?Total of (\d+).*?in use", out)
        if not m:
            return None
        issued, in_use = int(m.group(1)), int(m.group(2))
        info = {"feature": name, "issued": issued, "in_use": in_use, "available": issued - in_use}
        if tightest is None or info["available"] < tightest["available"]:
            tightest = info
    return tightest
