#!/usr/bin/env bash

# Modmul command to RTL verification
# With l0_int_mul and l0_int_cmul as blackboxes

# We can do generate only
python3 -m tessera run l1_mod_mul -s demo/merif_modmul.yaml -t 64 -p 1 --only gen

# We can do HLS and then verify the script
python3 -m tessera run l1_mod_mul -s demo/merif_modmul.yaml -t 64 -p 1 --to rtl

# Have on another terminal
watch -n2 "python3 -m tessera analyze l0_int_mul"

watch -n2 "python3 -m tessera analyze l0_int_cmul"

watch -n2 "python3 -m tessera analyze l1_mod_mul"


# Modadd full end-to-end flow (6:30 minutes)
# We use 200 threads and 8 threads per design flow
python3 -m tessera run l1_mod_add -s demo/merif_modadd.yaml -t 200 -p 8 --to pwr

# Have on another terminal
watch -n2 "python3 -m tessera analyze l1_mod_add"