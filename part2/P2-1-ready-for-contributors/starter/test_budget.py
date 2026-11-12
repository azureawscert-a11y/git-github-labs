import unittest

from budget import totals


class TotalsTest(unittest.TestCase):
    def test_categories_are_case_insensitive(self):
        rows = [("d", "Food", "1.50"), ("d", "food", "2.50")]
        self.assertEqual(totals(rows), {"food": 4.0})


if __name__ == "__main__":
    unittest.main()
