### Go環境の構築
:GoInstallBinaries


### Global
:help keyword - open help for keyword  
:saveas file - save file as  
:close - close current pane  
K - open man page for word under the cursor  
カーソル移動  
h - 左に移動  
j - 下に移動  
k - 上に移動  
l - 右に移動  
H - move to top of screen  
M - move to middle of screen  
L - move to bottom of screen  
w - 単語の先頭へジャンプ（区切り文字まで）  
W - 単語の先頭へジャンプ（区切り文字を含めない）  
e - 単語の最後にジャンプ（区切り文字まで）  
E - 単語の最後にジャンプ（区切り文字を含めない）  
b - 単語の先頭へ戻る（区切り文字まで）  
B - 単語の先頭へ戻る（区切り文字を含めない）  
% - move to matching character (default supported pairs: '()', '{}', '[]' - use :h matchpairs in vim for more info)  
0 - (ゼロ)先頭に移動  
^ - 行の最初の文字へ移動  
$ - 行の終わりへ移動  
g_ - jump to the last non-blank character of the line  
gg - go to the first line of the document  
G - 最終行へ移動（番号を付けるとその行へ移動- 5Gは 5行目へ）  
5G - 5行目に移動  
fx - jump to next occurrence of character x  
tx - jump to before next occurrence of character x  
Fx - jump to previous occurence of character x  
Tx - jump to after previous occurence of character x  
; - repeat previous f, t, F or T movement  
, - repeat previous f, t, F or T movement, backwards  
} - jump to next paragraph (or function/block, when editing code)  
{ - jump to previous paragraph (or function/block, when editing code)  
zz - center cursor on screen  
Ctrl + e - move screen down one line (without moving cursor)  
Ctrl + y - move screen up one line (without moving cursor)  
Ctrl + b - move back one full screen  
Ctrl + f - move forward one full screen  
Ctrl + d - move forward 1/2 a screen  
Ctrl + u - move back 1/2 a screen  
Tip これらのコマンドの前に番号を付けるとその回数分繰り返します。例えば、4j は 4行下に移動します。  
挿入モード - テキストを追加/挿入  
i - カーソル位置で挿入モードを開始  
I - 行の先頭で挿入モードを開始  
a - カーソル位置の直後で挿入モードを開始  
A - 行の末尾で挿入モードを開始  
o - 現在の行の下に空白行を追加して挿入モードを開始  
O - 現在の行の上に空白行を追加して挿入モードを開始  
ea - 単語の末尾で挿入モードを開始  
Esc - 挿入モードを終了  
### 編集  
r - 単一の文字を置き換える（挿入モードを使用しません）  
J - 現在の行と次の行を連結する  
gJ - join line below to the current one without space in between  
gwip - reflow paragraph  
cc - 現在の行を削除して挿入モードを開始  
c$ - カーソル位置から行末までを削除して挿入モードを開始  
ciw - change (replace) entire word  
cw - カーソル位置の単語を削除して挿入モードを開始  
s - カーソル位置の文字を削除して挿入モードを開始    
S - 現在の行を削除して挿入モードを開始（ccと同じ）  
xp - カーソル位置と次の文字を入れ替える（技術的にはカットしてペースト）  
u - 元に戻す(アンドゥ)  
Ctrl + r - やり直し(リドゥ)  
. - 最後に使ったコマンドを行う  
テキストの選択（ビジュアルモード）  
v - ビジュアルモード開始。移動すると選択してその後にコマンドを実行できる（例えばY-ヤンク）  
V - 行単位のビジュアルモードを開始  
o - 選択範囲の反対側に移動する  
Ctrl + v - 矩形ビジュアルモードを開始  
O - ブロックの他のコーナーに移動する  
aw - 単語をマーク  
ab - () ブロックを選択(括弧ごと)  
aB - {}ブロックを選択(括弧ごと)  
ib - () ブロックを選択(括弧を除く)  
iB - {}ブロックを選択(括弧を除く)  
Esc - ビジュアルモード終了  
ビジュアルモードでのコマンド  
> - 選択範囲を右シフト  
< - 選択範囲を左シフト  
y - 選択範囲をヤンク（コピー）  
d - 選択範囲を削除する  
~ - 大文字と小文字を入れ替える  
### Registers   
:reg - show registers content  
"xy - yank into register x  
"xp - paste contents of register x  
Tip Registers are being stored in ~/.viminfo, and will be loaded again on next restart of vim.  
Tip Register 0 contains always the value of the last yank command.  
### Marks  
:marks - list of marks  
ma - set current position for mark A  
`a - jump to position of mark A  
y`a - yank text to position of mark A  
### Macros
qa - record macro a  
q - stop recording macro  
@a - run macro a  
@@ - rerun last run macro  
### カット＆ペースト
yy - 現在の行をヤンク（コピー）  
2yy - 2行をヤンク  
yw - カーソル位置の単語をヤンク  
y$ - 現在行の行末までヤンク  
p - カーソル位置の後にペースト  
P - カーソル位置の前にペースト  
dd - 現在の行をカット(コピーして削除)  
2dd - 2行をカット  
dw - カーソル位置の単語をカット   
D - カーソル位置から行末までカット  
d$ - カーソル位置から行末までカット(Dと同じ)  
x - 現在の文字をカットする  
### 終了
:w - 終了せずに保存   
:w !sudo tee % - write out the current file using sudo  
:wq or :x or ZZ - 保存して終了   
:q - 保存せずに終了（変更点がある場合は終了できない）  
:q! or ZQ - 保存せずに終了(変更点がある場合は破棄される)  
:wqa - write (save) and quit on all tabs  
### 検索/置換
/pattern - /文字列 - 文字列を検索  
?pattern - ?文字列 - 文字列を逆方向に検索  
\vpattern - 'very magic' pattern: non-alphanumeric characters are interpreted as special regex symbols (no escaping needed)   
n - 同じ方向に再検索  
N - 逆方向に再検索  
:%s/old/new/g - ファイル全体でoldをnewに置き換える  
:%s/old/new/gc - ファイル全体でoldをnewに置き換える(確認あり)  
:noh - remove highlighting of search matches  
Search in multiple files  
:vimgrep /pattern/ {file} - search for pattern in multiple files  
e.g. :vimgrep /foo/ **/*   
:cn - jump to the next match   
:cp - jump to the previous match   
:copen - open a window containing the list of matches  
### 複数のファイルでの作業
:e file - 新しいバッファでファイルを編集   
:bnext or :bn - 次のバッファに移動   
:bprev or :bp - 前のバッファへ移動   
:bd - バッファを削除（ファイルを閉じる）   
:ls - list all open buffers   
:sp file - 新しいバッファおよび分割ウィンドウでファイルを編集   
:vsp file - 新しいバッファおよび垂直分割ウィンドウでファイルを開きます   
Ctrl + ws - ウィンドウを分割   
Ctrl + ww - ウィンドウを切り替える   
Ctrl + wq - ウィンドウを終了します   
Ctrl + wv - ウィンドウを垂直に分割   
Ctrl + wh - 右のウィンドウに移動   
Ctrl + wl - 左のウィンドウに移動   
Ctrl + wj - move cursor to the window below (horizontal split)   
Ctrl + wk - move cursor to the window above (horizontal split)   
### タブ
:tabnew or :tabnew file - 新しいタブで(ファイル名)を開く  
Ctrl + wT - 独自のタブに現在の分割ウィンドウを移動  
gt or :tabnext or :tabn - 次のタブに移動する  
gT or :tabprev or :tabp - 前のタブに移動する  
#gt - タブ番号(n)への移動  
:tabmove # - 位置(n)番目に移動（左端が0）  
:tabclose or :tabc - カレントタブを閉じる  
:tabonly or :tabo - カレントタブを除く他のすべてのタブを閉じる  
:tabdo command - run the command on all tabs (e.g. :tabdo q - closes all opened tabs)  
