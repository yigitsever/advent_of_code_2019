from itertools import permutations
import os
import subprocess

perm = permutations(range(5))
res = []

for seq in perm:
    signal = 0
    for phase in seq:
        out = subprocess.run(
            ["perl", "intcode.pl", "part1.in"],
            capture_output=True,
            input=b"%d\n%d" % (phase, signal),
        )
        signal = int(out.stdout)
    res.append(signal)

print(sorted(res)[-1])
