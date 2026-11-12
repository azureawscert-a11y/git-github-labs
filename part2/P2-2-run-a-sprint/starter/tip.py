"""tip-split: share a restaurant bill fairly."""
import sys


def per_person(total, people, tip_percent):
    """Each person's share of the bill plus tip."""
    with_tip = total + total * tip_percent
    return with_tip / people


if __name__ == "__main__":
    total, people, tip = float(sys.argv[1]), int(sys.argv[2]), float(sys.argv[3])
    print("Each person pays:", per_person(total, people, tip))
