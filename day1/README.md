I realized part 1 can be solved with a perl one liner;

```bash
perl -ne '$c += int ($_ / 3) - 2;END {print $c}' < part1.in
```
