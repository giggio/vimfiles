" Vim syntax file
" Language: Navi cheatsheets
" Maintainer: Giovanni Bassi
" Latest Revision: 11 February 2026
" Filenames: *.cheat

if exists("b:current_syntax")
  finish
endif

" Case sensitivity
syn case match

" ==============================================================================
" Syntax Elements
" ==============================================================================

" 1. Cheat tags/titles (% lines)
syn match naviTagLine "^%.*$" contains=naviTagMarker,naviTagContent
syn match naviTagMarker "^%" contained
syn match naviTagContent "%\s*\zs.*$" contained

" 2. Cheat descriptions (# lines) - but not inside code blocks
syn match naviDescription "^#.*$" contains=naviDescMarker,naviDescText
syn match naviDescMarker "^#" contained
syn match naviDescText "#\s*\zs.*$" contained

" 3. Metacomments (; lines)
syn match naviMetacomment "^;.*$" contains=naviMetaMarker,naviMetaText
syn match naviMetaMarker "^;" contained
syn match naviMetaText ";\s*\zs.*$" contained

" 4. Variable definitions ($ lines)
syn match naviVariableDef "^$.*$" contains=naviVarMarker,naviVarName,naviVarColon,naviVarCommand,naviFzfSeparator,naviFzfParam
syn match naviVarMarker "^$" contained
syn match naviVarName "$\s*\zs[a-zA-Z0-9_]\+\ze\s*:" contained
syn match naviVarColon ":\s*" contained
syn match naviVarCommand "$\s*[a-zA-Z0-9_]\+\s*:\s*\zs.\+" contained contains=naviFzfSeparator,naviFzfParam,naviVarRef

" 5. FZF parameter separator
syn match naviFzfSeparator "\s\+---\s\+" contained

" 6. FZF parameters (both navi-specific and forwarded to fzf)
syn match naviFzfParam "\s\+--\%(column\|map\|prevent-extra\|fzf-overrides\|expand\|multi\|header-lines\|delimiter\|query\|filter\|header\|preview\|preview-window\)\>" contained

" 7. Variable references in commands (<varname>)
syn match naviVarRef "<[a-zA-Z0-9_]\+>" contains=naviVarRefMarker,naviVarRefName
syn match naviVarRefMarker "<\|>" contained
syn match naviVarRefName "<\zs[a-zA-Z0-9_]\+\ze>" contained

" 8. Extended cheats (@ lines)
syn match naviExtendLine "^@.*$" contains=naviExtendMarker,naviExtendContent
syn match naviExtendMarker "^@" contained
syn match naviExtendContent "@\s*\zs.*$" contained

" 9. Markdown code blocks for multiline snippets
syn region naviCodeBlock start="^```\(sh\|bash\|zsh\|shell\)\?$" end="^```$" keepend contains=naviVarRef,naviCommand

" 10. Executable commands (anything not matching special markers)
" Must come AFTER all other patterns to avoid overriding them
syn match naviCommand "^[^#%;@$` \t].*$" contains=naviVarRef

" 11. Empty lines (for completeness)
syn match naviEmptyLine "^\s*$"

" ==============================================================================
" Highlighting Groups
" ==============================================================================

" Default highlighting (fallback)
hi def link naviTagMarker          Special
hi def link naviTagContent         Title
hi def link naviDescMarker         Comment
hi def link naviDescText           Comment
hi def link naviMetacomment        Comment
hi def link naviMetaMarker         Comment
hi def link naviMetaText           Comment
hi def link naviVarMarker          PreProc
hi def link naviVarName            Identifier
hi def link naviVarColon           Normal
hi def link naviVarCommand         String
hi def link naviFzfSeparator       Delimiter
hi def link naviFzfParam           Special
hi def link naviVarRefMarker       Delimiter
hi def link naviVarRefName         Identifier
hi def link naviExtendMarker       PreProc
hi def link naviExtendContent      Type
hi def link naviCommand            Statement
hi def link naviCodeBlock          String
hi def link naviEmptyLine          Normal

" ==============================================================================
" Filetype detection
" ==============================================================================

let b:current_syntax = "navi"
