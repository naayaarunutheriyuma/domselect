# Domselect

Domselect provides high-level API to work with structure of HTML document using one of HTML processing backend.
To work with HTML document you have to create so-called selector object from raw content of HTML document.
That selector will be bound to the root node of HTML structure. Then you can call different methods of these selector
to build other selectors bound to nested parts of HTML structure. Selector object use DOM constructed by HTML processing
backend to extract low-level raw nodes and wrap then into selector interface. In case of non-standard scenario you can
get raw node from selector node to do some low-level operations.

### Selector Backends

Domselect library provides these selectors:

1. LexborSelector powered by [selectolax](https://github.com/rushter/selectolax)
    and [lexbor](https://github.com/lexbor/lexbor) libraries. The type of raw node is `selectolax.lexbor.LexborNode`.

2. LxmlSelector powered by [lxml](https://github.com/lxml/lxml) library. The type of raw node is `lxml.html.HtmlElement`.

### Selector Creating

Let's have some HTML document `HTML = "<div>test</div>"`

To create lexbor selector from content of HTML document:

```
from domselect import LexborSelector
sel = LexborSelector.from_content(HTML)
```

Also you can create selector from raw node:

```
from domselect import LexborSelector
from selectolax.lexbor import LexborHTMLParser
node = LexborHTMLParser(HTML).css_first("div")
sel = LexborSelector(node)
```

Same goes for lxml backend. Here is an example of creating lxml selector from raw node:

```
from lxml.html import fromstring
node = fromstring(HTML)
sel = LxmlSelector(node)
```

### Selector Traversal Methods

Each of these methods return other selectors of same type i.e. LexborSelector return
other LexborSelectors and LxmlSelector returns other LxmlSelectors.

Method `find(query: str)` returns list of selectors bound to raw nodes found by CSS query.

Method `find_one(query: str)` returns `None` of selector bound to first raw node found by CSS query.

There is similar `find_raw` and `find_raw_one` methods which works in same way but returns low-level raw nodes
i.e. they do not wrap found nodes into selector interface.

Method `parent()` returns selector bound to raw node which is parent to raw node of current selector.

Method `grep_one(query: str, pattern: str[, default: None])` returns selector bound to first raw node
found by CSS query and which contains text as `pattern` parameter. If node is not found then
`NodeNotFoundError` is raised. You can pass `default=None` optional parameter to return `None` in case
of node is not found.

### Boolean Methods

Method `exists(query: str)` returns boolean flag indicates if any node has been found by CSS query.

### String Methods

Method `attr(name: str[, default: None|str])` returns content of node's attribute of given name.
If node does not have such attribute the `AttributeNotFoundError` is raised. If you pass optional
`default: None|str` parameter the method will return `None` or `str` if attribute does not exists.

Method `text([strip: bool])` returns text content of current node and all its sub-nodes. By default
returned text is stripped at beginning and ending from whitespaces, tabulations and line-breaks. You
can turn off striping by passing `strip=False` parameter.

Method `tag()` returns tag name of raw node to which current selector is bound.

Method `find_attr(query: str, name: str[, default: None|str])` returns content of attribute of given name of node
found by given query.  If node does not have such attribute the `AttributeNotFoundError` is raised.
If node is not found by given query the `NodeNotFoundError` is raised. If you pass optional
`default: None|str` parameter the method will return `None` or `str` instead of rasing exceptions.

Method `find_text(query: str[, default: None|str, strip: bool])` returns text content of raw node (and all its
sub-nodes) found by given query. If node is not found the `NodeNotFoundError` is raised. Use optional `default: None|str`
parametere to return `None` or `str` instead of raising exceptions. You can control text stripping with `strip`
parameter (see description of `text()` method).
