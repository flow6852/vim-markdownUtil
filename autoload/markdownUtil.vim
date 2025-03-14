function! markdownUtil#formatter(file)
    if (!executable("deno"))
        echohl ErrorMsg
        echom "This formatter uses deno. Please install deno"
        echohl None
    endif

    let s:i = 1
    let s:text = join(readfile(a:file), "\n")
    let s:cmd = "echo " . s:text . " | deno fmt --ext md -"

    call execute("write")

    let s:cursor = getcurpos(".")

    call execute("%delete")

    for line in systemlist(s:cmd)
        call setline(s:i, line)
        let s:i = s:i + 1
    endfor
    call execute("%s/\\\\$/  /g", "silent!")

    call cursor(slice(s:cursor, 1))
endfunction

function! markdownUtil#insertTableFormatter()
    let s:lineString = getline(line("."))
    let s:tables = split(s:lineString, "|")
    if (match(s:tables[0], "[^ ]") > -1)
        call insert(s:tables, "")
    endif

    let s:index = 1
    while s:index < len(s:tables)
        let s:tables[s:index] = ":-:"
        let s:index = s:index + 1
    endwhile
    call append(line("."), join(s:tables, "|") .. "|")
endfunction

function! markdownUtil#createTableOfContents()
    let s:bufnr = bufnr()
    let s:linecount = get(get(getbufinfo(s:bufnr), 0), "linecount")
    let s:titles = [] " string, depth, lnum
    let s:lnum = 1
    while s:lnum < s:linecount
        let s:line = getline(s:lnum)
        if (match(s:line, "#") == 0)
            let s:string = join(slice(split(s:line, " "), 1), " ")
            let s:depth =  count(get(split(s:line, " "), 0), "#")
            let s:link = get(split(s:line, " "), 0) . s:string
            call add(s:titles, #{string: s:string, depth: s:depth, lnum: s:lnum, link: s:link})
        endif
        let s:lnum = s:lnum + 1
    endwhile

    let s:startComment = "<!--start:toc:markdownUtil -->"
    let s:endComment = "<!--end:toc:markdownUtil -->"
    let s:tocCommentStartLnum = 3

    if getline(s:tocCommentStartLnum) == s:startComment
        let s:lnum = s:tocCommentStartLnum
        while getline(s:lnum) != s:endComment && s:lnum < s:linecount
            let s:lnum = s:lnum + 1
        endwhile

        if s:lnum >= s:linecount
            echoerr "TOC end marker not exists.\nmarker: " . s:endComment
            return 1
        endif

        call deletebufline(bufname("%"), s:tocCommentStartLnum, s:lnum + 1)
    endif

    call append(s:tocCommentStartLnum - 1, s:startComment)
    let s:index = 0
    while s:index < len(s:titles)
        let s:titleString = repeat("  ", get(s:titles, s:index).depth-1) . "+ [" . get(s:titles, s:index).string . "](" . get(s:titles, s:index).link . ")"
        call append(s:index + s:tocCommentStartLnum, s:titleString)
        let s:index = s:index + 1
    endwhile

    call append(s:index + s:tocCommentStartLnum, s:endComment)
    call append(s:index + s:tocCommentStartLnum + 1, "") 
endfunction
