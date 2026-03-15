##### Domain

A pattern to match normalized URLs. When you create a Site Name Correction, the system searches for articles with a matching normalized URL. When matching articles are found, it rewrites site names of these articles.

A normalized URL is a URL without scheme part. For example, when the URL is `https://example.org/path/to/article.html`, the normalized URL is, `example.org/path/to/article.html`. As such, do not include `https://` or `http://`.


Matching is "Prefix Match", meaning `example.org` matches `example.org`, `example.org/index.html`, `example.org/foo/bar` and so on, but NOT `example.net/index.html`.

Wild-card is NOT supported. To match multiple normalized URLs, `foo.example.org` and `bar.example.org` for instance, create two different Site Name Corrections, such as `foo.example.org` and `bar.example.org` and both Site Name Corrections has the same name, `Example Site`.
