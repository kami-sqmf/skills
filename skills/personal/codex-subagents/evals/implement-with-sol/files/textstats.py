"""Small text statistics helpers."""


def top_words(text: str, n: int = 3) -> list[tuple[str, int]]:
    """Return the n most frequent words, case-insensitive, ignoring punctuation.

    Ties are broken alphabetically. Words are runs of letters/digits/apostrophes.
    """
    raise NotImplementedError
