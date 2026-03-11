##### Regular expression search

Search sentences with a regular expression. The supported regular expression is [Ruby's Regexp](https://docs.ruby-lang.org/en/master/Regexp.html).

Notable expressions:

- [Shorthand Character Classes](https://docs.ruby-lang.org/en/master/Regexp.html#class-regexp-shorthand-character-classes), such as `\d` (a digit)
- [Quantifiers](https://docs.ruby-lang.org/en/master/Regexp.html#class-regexp-quantifiers), such as `\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}` (not-so-correct IPv4 address)
- [Character Classes](https://docs.ruby-lang.org/en/master/Regexp.html#class-regexp-character-classes), such as `[a-zA-Z]` (alphabetic characters).
- [Groups](https://docs.ruby-lang.org/en/master/Regexp.html#class-regexp-groups-and-captures), such as `(foo|bar)` (`foo` or `bar`).
- [Unicode Properties](https://docs.ruby-lang.org/en/master/language/regexp/unicode_properties_rdoc.html), such as `\p{Hiragana}` (all Hiaragana characters).

See [Mastering Ruby Regular Expressions](https://www.rubyguides.com/2015/06/ruby-regex/) for a short summary.

> Regular expression search is slow. Use operators to limit the scope.

##### `site_name` operator

To match sentences from a specific site with a regular expression, use `site_name` operator. When the site name includes spaces, quote the name.  `site_name` can be `OR`-ed.

```
site_name:foo
site_name:"foo bar"
site_name:foo site_name:bar
```

##### `url` operator

`url` limits sentences to match. The value of the operator starts with domain part of URL. That is, it must not start with `http://` or `https://`. `url` can be `OR`-ed.

```
url:www.example.org
url:www.example.org/path/
url:www.example.org url:example.org
```
