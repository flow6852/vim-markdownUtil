function! markdownUtil#formatter(file)
    if (!executable("deno"))
        echohl ErrorMsg
        echom "This formatter uses deno. Please install deno"
        echohl None
    endif

    let s:i = 1
    let s:cmd = ""
    if (&shell == "pwsh.exe" || &shell == "powershell.exe")
        let s:cmd = "Get-Content " . a:file . " | deno fmt --ext md -"
    else
        let s:cmd = "cat " . a:file . " | deno fmt --ext md -"
    endif

    let s:cursor = getcurpos(".")

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
