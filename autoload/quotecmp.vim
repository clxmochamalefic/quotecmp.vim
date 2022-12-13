""
" completion quote character
" クオートの補完
"
" @param {string} a:quote_character Quote character / クオート文字 
""
function! quotecmp#completion_quote(quote_character) abort "{{{1
  redraw

  echon 'insert to: backward prev space => H / forward => other key / cancel => <ESC> > / cancel and insert triple it => same quote (' . a:quote_character . ')'
  let l:input       = nr2char(getchar())
  let l:current_col = col('.')
  let l:new_col     = col('.')
  let l:last_col    = col('$')

  if l:input == "\e" "{{{1
    " <Esc> is cancel
    echon 'canceled'
    "}}}
  elseif l:input ==? a:quote_character "{{{1
    execute "normal! i" . a:quote_character . a:quote_character . a:quote_character . "\<Esc>"
    "}}}
  elseif l:input ==? 'h' "{{{1
    " backward
    execute "normal! a" . a:quote_character . "\<Esc>"
    call search(' ', 'b', line('.'))

    let l:new_col = col('.')
    if l:new_col >= l:current_col
      execute "normal! I" . a:quote_character . "\<Esc>"
    else
      execute "normal! a" . a:quote_character . "\<Esc>"
    endif

    " move cursor to quote end / クオートの終端に戻す
    call search(a:quote_character, '', line('.'))

    echon 'backward'
    "}}}
  else "{{{1
    " forward
    execute "normal! i" . a:quote_character . "\<Esc>"
    call search(' ', '', line('.'))

    let l:new_col = col('.')
    let l:mode = "i"

    if l:new_col == l:current_col
      execute "normal! A" . a:quote_character . "\<Esc>"
      let l:current_col = col('.')
      let l:last_col    = col('$')
    else
      execute "normal! i" . a:quote_character . "\<Esc>"
    endif

    echon 'forward'
    "}}}
  endif

  " modify mode to insert / 挿入モードに戻す
  execute "normal! l"

  if l:current_col == l:last_col - 1 || l:new_col == l:last_col - 1
    execute "startinsert!"
  else
    execute "startinsert"
  endif
  "}}}
endfunction

