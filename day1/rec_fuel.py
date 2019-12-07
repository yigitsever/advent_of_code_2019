import sys


def recfuel(mass):
    """Calculate the fuel required for the module
    use the new weight of the fuel recursively
    r(M) = r(M / 3 - 2)
    """
    M = mass // 3 - 2

    if M < 0:
        return 0
    else:
        return M + recfuel(M)


total = 0

for mass in sys.stdin:
    ret = recfuel(int(mass))
    total += ret

print(total)
