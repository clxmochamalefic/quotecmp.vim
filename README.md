# quotecmd.vim

## usage:

下記の設定例のように設定を記述すると、同じクオート文字を二度入力することで任意のキーワードを任意のクオートで囲むことができます
please write your vim preference file feel below (|quotecmp-preference-example|)
if set the preference, this plugin exec quoting any word

e.g.

before

```
aaaa bbbb
    ^
    (cursor here)
```

after

```
``aaaa`` bbbb
      ^
      (cursor here)
```

## preference example

こんな感じで設定を書きます
please write it your .vimrc or init.vim

```init.vim
command! InsertQuoteBack    call quotecmp#completion_quote('`')
command! InsertQuoteSingle  call quotecmp#completion_quote("'")
command! InsertQuoteDouble  call quotecmp#completion_quote('"')

inoremap `` <Esc>:InsertQuoteBack<CR>
inoremap '' <Esc>:InsertQuoteSingle<CR>
inoremap "" <Esc>:InsertQuoteDouble<CR>
```

`dein.toml` みたいに `.toml` で書いている場合はこんな感じに書きます
if you use `dein` and use `toml` for plugin manage, you can write below

```dein.toml
hook_add = '''
  command! InsertQuoteBack    call quotecmp#completion_quote('`')
  command! InsertQuoteSingle  call quotecmp#completion_quote("'")
  command! InsertQuoteDouble  call quotecmp#completion_quote('"')

  inoremap `` <Esc>:InsertQuoteBack<CR>
  inoremap '' <Esc>:InsertQuoteSingle<CR>
  inoremap "" <Esc>:InsertQuoteDouble<CR>
'''
```

## FAQ ...?

### Q. 設定をユーザーに書かせる意味あるん？

A. ごめん
