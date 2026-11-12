import unittest

from tip import per_person


class PerPersonTest(unittest.TestCase):
    def test_fifteen_percent_tip_split_two_ways(self):
        self.assertEqual(per_person(100, 2, 15), 57.5)


if __name__ == "__main__":
    unittest.main()
