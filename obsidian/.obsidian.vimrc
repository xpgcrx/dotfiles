" https://github.com/esm7/obsidian-vimrc-support

" --- クリップボード設定 ---
" ヤンク・削除した内容をOSのクリップボードと共有する
set clipboard=unnamed

" --- キーマッピング ---
" <leader>キーをスペースに設定する場合 (任意)
unmap <Space>
"let mapleader = " "

imap jk <Esc>

" タブの移動
exmap tabprev obcommand workspace:previous-tab
nmap gT :tabprev<cr>
exmap tabnext obcommand workspace:next-tab
nmap gt :tabnext<cr>

" Go back and forward with Ctrl+O and Ctrl+I
" (make sure to remove default Obsidian shortcuts for these to work)
exmap back obcommand app:go-back
nmap <C-o> :back<CR>
exmap forward obcommand app:go-forward
nmap <C-i> :forward<CR>

exmap focusRight obcommand editor:focus-right
nmap <C-w>l :focusRight<CR>

exmap focusLeft obcommand editor:focus-left
nmap <C-w>h :focusLeft<CR>

exmap focusTop obcommand editor:focus-top
nmap <C-w>k :focusTop<CR>

exmap focusBottom obcommand editor:focus-bottom
nmap <C-w>j :focusBottom<CR>

" Space押したあとにiを押すと、対象のwordを`と`で囲む
" https://github.com/esm7/obsidian-vimrc-support?tab=readme-ov-file#surround-text-with-surround
exmap surround_backticks surround ` `
map s` :surround_backticks<CR>

" ----- Range Error 対策 -----
" https://github.com/esm7/obsidian-vimrc-support/issues/266
" remove map to o
nunmap o
map o A<CR>
" remove map to O
nunmap O
map O I<CR><Esc>ki
