# vim-markdownUtil

<!--start:toc:markdownUtil -->

- [vim-markdownUtil](#vim-markdownUtil)
  - [Dependencies](##Dependencies)
  - [functions](##functions)
    - [markdownUtil#formatter(path)](###markdownUtil#formatter(path))
    - [markdownUtil#insertTableFormatter()](###markdownUtil#insertTableFormatter())
      - [example](####example)
        - [before](#####before)
        - [after](#####after)
    - [markdownUtil#createTableOfContents()](###markdownUtil#createTableOfContents())

<!--end:toc:markdownUtil -->

markdown util for me

## Dependencies

1. deno

## functions

1. markdownUtil#format(path)
1. markdownUtil#insertTableFormatter()
1. markdownUtil#createOfContents()

### markdownUtil#formatter(path)

format markdown file using `deno fmt` command.

### markdownUtil#insertTableFormatter()

insert table format string as string under cursor is table header.

#### example

##### before

```
| headerA | header B | header C|
```

##### after

```
| headerA | header B | header C|
|:-:|:-:|:-:|
```

### markdownUtil#createTableOfContents()

create or update table of contents.
