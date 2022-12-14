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
  let l:last_col    = col('$')
  let l:result      = v:false

  if l:input == "\e" "{{{1
    " <Esc> is cancel
    let l:result = s:cancel_completion(a:quote_character, 2)
    "}}}
  elseif l:input ==? a:quote_character "{{{1
    " want triple same quote input
    let l:result = s:cancel_completion(a:quote_character, 3)
    "}}}
  elseif l:input ==? 'h' "{{{1
    " backward
    let l:result = s:backward_completion(a:quote_character, l:current_col)
    "}}}
  else "{{{1
    " forward
    let l:result = s:forward_completion(a:quote_character, l:current_col)
  "}}}
  endif

  if l:result
    let l:current_col = col('.')
    let l:last_col    = col('$')
  endif

  " change mode to insert / 挿入モードに戻す
  execute "normal! l"

  if l:current_col == l:last_col - 1
    execute "startinsert!"
  else
    execute "startinsert"
  endif

"}}}
endfunction

""
" cancel completion
" クオートの補完の中止
"
" @param {string}   a:quote_character Quote character / クオート文字 
" @param {integer}  a:number          number of write quote count / クオート文字を出力する数
"
" @return {bool} v:true: need update cursor position for after routine / 以後の処理に対してカーソル位置情報の更新を要求
""
function! s:cancel_completion(quote_character, number) abort "{{{1
  let l:quote_string = ""

  for i in range(1, a:number)
    let l:quote_string .= a:quote_character
  endfor

  execute "normal! a" . l:quote_string . "\<Esc>"

  return v:true
"}}}
endfunction

""
" completion quote character for backward completion
" 後方方向へのクオートの補完
"
" @param {string}   a:quote_character Quote character / クオート文字 
" @param {integer}  a:current_col     current cursor position / 現在のカーソル位置
"
" @return {bool} v:true: need update cursor position for after routine / 以後の処理に対してカーソル位置情報の更新を要求
""
function! s:backward_completion(quote_character, current_col) abort "{{{1
  execute "normal! a" . a:quote_character . "\<Esc>"
  call search(' ', 'b', line('.'))

  let l:new_col = col('.')
  let l:mode = l:new_col >= a:current_col ? "I" : "a"
  execute "normal! " . l:mode . a:quote_character . "\<Esc>"

  " move cursor to quote end / クオートの終端に戻す
  call search(a:quote_character, '', line('.'))

  echon 'backward'
  return v:false
"}}}
endfunction

""
" completion quote character for forward completion
" 前方方向へのクオートの補完
"
" @param {string}   a:quote_character Quote character / クオート文字 
" @param {integer}  a:current_col     current cursor position / 現在のカーソル位置
"
" @return {bool} v:true: need update cursor position for after routine / 以後の処理に対してカーソル位置情報の更新を要求
""
function! s:forward_completion(quote_character, current_col) abort "{{{1
  let l:mode_first = a:current_col == 1 ? "i" : "a"
  execute "normal! " . l:mode_first . a:quote_character . "\<Esc>"
  call search(' ', '', line('.'))

  let l:new_col = col('.')
  let l:result = l:new_col == a:current_col + 1 || l:new_col == 1
  let l:mode_last = l:result ? "A" : "i"
  execute "normal! " . l:mode_last . a:quote_character . "\<Esc>"

  echon 'forward'
  return l:result
"}}}
endfunction
