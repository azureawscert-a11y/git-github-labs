"""pocket-budget: add up what you spent this month, by category."""
import csv
import sys
from collections import defaultdict


def totals(rows):
    """Return {category: total} for rows of (date, category, amount)."""
    out = defaultdict(float)
    for _date, category, amount in rows:
        out[category.strip().lower()] += float(amount)
    return dict(out)


def main(path):
    with open(path, newline="") as f:
        rows = [r for r in csv.reader(f) if r and not r[0].startswith("#")]
    for category, amount in sorted(totals(rows).items()):
        print(f"{category:<12} {amount:>8.2f}")


if __name__ == "__main__":
    main(sys.argv[1] if len(sys.argv) > 1 else "sample.csv")
