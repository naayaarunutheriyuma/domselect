from html import unescape
from urllib.request import urlopen

from domselect import LxmlXpathSelector


def main() -> None:
    content = urlopen("https://t.me/s/centralbank_russia").read()
    sel = LxmlXpathSelector.from_content(content)
    for msg_node in sel.find('//*[contains(@class, "tgme_widget_message_wrap")]'):
        msg_date = msg_node.first_attr(
            './/*[contains(@class, "tgme_widget_message_date")]/time',
            "datetime",
            default=None,
        )
        for text_node in msg_node.find(
            './/*[contains(@class, "tgme_widget_message_text")]'
        ):
            print("Message by {}".format(msg_date))
            for link_node in text_node.find(".//a[@href]"):
                url = link_node.attr("href")
                if url.startswith("http"):
                    print(" - {}".format(unescape(url)))


if __name__ == "__main__":
    main()
