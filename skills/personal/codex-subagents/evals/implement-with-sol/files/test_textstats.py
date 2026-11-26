import unittest

from textstats import top_words


class TopWordsTest(unittest.TestCase):
    def test_basic(self):
        self.assertEqual(top_words("a b a c b a", 2), [("a", 3), ("b", 2)])

    def test_case_and_punctuation(self):
        self.assertEqual(top_words("Hi, hi! HI? there.", 1), [("hi", 3)])

    def test_ties_alphabetical(self):
        self.assertEqual(top_words("b a c", 2), [("a", 1), ("b", 1)])

    def test_apostrophes(self):
        self.assertEqual(top_words("don't don't stop", 1), [("don't", 2)])

    def test_empty(self):
        self.assertEqual(top_words("", 3), [])


if __name__ == "__main__":
    unittest.main()
