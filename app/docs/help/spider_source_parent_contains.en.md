Match `<a>` tags whose parent contains the value.  When `parent_contains_text` is `英語記事`, the spider picks all the following `<a>` tags:

```html
<main>
    <p>英語記事: <a href="#">foo</a> / <a href="#">bar</a></p>
</main>
```
