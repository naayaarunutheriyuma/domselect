from html import unescape
from urllib.request import urlopen

from domselect import LexborSelector


def main() -> None:
    content = urlopen("https://t.me/s/centralbank_russia").read()
    sel = LexborSelector.from_content(content)
    for msg_node in sel.find(".tgme_widget_message_wrap"):
        msg_date = msg_node.first_attr(
            ".tgme_widget_message_date time", "datetime", default=None
        )
        for text_node in msg_node.find(".tgme_widget_message_text"):
            print("Message by {}".format(msg_date))
            for link_node in text_node.find("a[href]"):
                url = link_node.attr("href")
                if url.startswith("http"):
                    print(" - {}".format(unescape(url)))


if __name__ == "__main__":
    main()
