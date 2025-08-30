from domselect import LexborSelector


def test_text_strip_issue() -> None:
    html = "<span><bold>foo</bold> bar</span>"
    assert LexborSelector.from_content(html).text() == "foo bar"
