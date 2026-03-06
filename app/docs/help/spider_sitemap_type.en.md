Specify the type of the `sitemap.xml`. Depending on the type, the spider
rejects certain URLs, i.e., it does not crawl them.

`all`, the default, crawls all the URLs in the `sitemap.xml`.

`wordpress` rejects certain known URLs that point to index pages of tags and
archives. These pages are usually duplicated contents of other pages. Choose
this option when the site is a WordPress site.
