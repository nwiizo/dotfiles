# dotfiles

自分用の開発環境設定。

**注意**: 破壊的な変更が発生する可能性あり。飽きたらやめる。

## 構成

```
dotfiles/
├── fish/           # Fish shell
├── nvim/           # Neovim (NvChad)
├── warp/           # Warp terminal
├── starship/       # Prompt
├── git/            # Git scripts
│
# Legacy (未使用)
├── bash/, zsh/, vim/, tmux/, lvim/, nvchad/
```

## セットアップ

```bash
# ツール
brew install fish neovim starship
brew install eza bat ripgrep fd fzf zoxide ghq direnv delta lazygit

# シンボリックリンク
ln -sf ~/ghq/github.com/nwiizo/dotfiles/fish/config.fish ~/.config/fish/config.fish
ln -sf ~/ghq/github.com/nwiizo/dotfiles/nvim ~/.config/nvim
ln -sf ~/ghq/github.com/nwiizo/dotfiles/starship/starship.toml ~/.config/starship.toml
```

---

## Fish Shell

### キーバインド

| キー | 動作 |
|------|------|
| `Ctrl+G` | ghqリポジトリ選択 (fzf) |
| `Ctrl+R` | 履歴検索 (fzf) |
| `Ctrl+F` | ファイル検索 (fzf) |
| `Ctrl+L` | 画面クリア |

fzf内:
```
Ctrl+J/K    上下移動
Ctrl+/      プレビュー切替
Ctrl+U/D    プレビュースクロール
Enter       確定
Esc         キャンセル
```

### 移動

```bash
z <部分文字列>        # zoxideでジャンプ (学習型)
zi                    # zoxide インタラクティブ選択
-                     # 前のディレクトリに戻る
..                    # cd ..
...                   # cd ../..
```

### モダンCLI

```bash
# ls → eza
ls                    # アイコン付き
ll                    # 詳細 + Git status
la                    # 隠しファイル含む
lt                    # ツリー表示

# cat → bat
cat file.rs           # シンタックスハイライト

# grep → ripgrep
grep "pattern" .      # 再帰検索
grep -t rust "fn"     # ファイルタイプ指定
grep -C 3 "error"     # 前後3行表示

# find → fd
fd "*.rs"             # パターン検索
fd -t d config        # ディレクトリのみ
fd -e json            # 拡張子指定
```

### Abbreviations

```bash
# Git
g       = git
gst     = git status
gaa     = git add --all
gc      = git commit -v
gcm     = git commit -m
gco     = git checkout
gcb     = git checkout -b
gp      = git push
gpl     = git pull
gd      = git diff
gl      = git log
gf      = git commit --amend --no-edit

# Docker
d       = docker
dc      = docker compose
dcu     = docker compose up
dcd     = docker compose down
dps     = docker ps

# Kubernetes
k       = kubectl
kgp     = kubectl get pods
kgs     = kubectl get svc
kgd     = kubectl get deploy

# その他
v       = nvim
lg      = lazygit
c       = claude
```

### direnv

```bash
echo 'export API_KEY="xxx"' > .envrc
direnv allow
# ディレクトリに入ると自動で環境変数セット
```

### 便利コマンド

```bash
update_all            # brew, mise, rustup 全部更新
sysinfo               # システム情報表示
mkcd <dir>            # mkdir + cd
port 8080             # ポート使用プロセス確認
```

### lazygit (lg)

```
j/k         上下移動
h/l         パネル移動
Space       ステージ/アンステージ
c           コミット
P           プッシュ
p           プル
s           stash
S           stash pop
/           検索
?           ヘルプ
q           終了
```

### delta (git diff)

`git diff`や`git log -p`でシンタックスハイライト付き表示。
自動設定済み（`GIT_PAGER=delta`）。

```bash
git diff              # ハイライト付きdiff
git log -p            # パッチ付きログ
git show              # コミット詳細
```

---

## Neovim

### 基本操作

| キー | 動作 |
|------|------|
| `;` | `:` (コマンドモード) |
| `jk` | `<Esc>` (Insert mode) |
| `<Esc>` | 検索ハイライト消去 |
| `<C-s>` | 保存 |

### ナビゲーション

| キー | 動作 |
|------|------|
| `<C-d>` | 半ページ下 + 中央 |
| `<C-u>` | 半ページ上 + 中央 |
| `n` / `N` | 検索結果移動 + 中央 |

### ウィンドウ

| キー | 動作 |
|------|------|
| `<C-h/j/k/l>` | ウィンドウ移動 |
| `<C-Up/Down>` | 高さ調整 |
| `<C-Left/Right>` | 幅調整 |

### バッファ

| キー | 動作 |
|------|------|
| `<S-h>` | 前のバッファ |
| `<S-l>` | 次のバッファ |
| `<leader>x` | バッファ閉じる |

### 行操作

| キー | 動作 |
|------|------|
| `J` (Visual) | 行を下に移動 |
| `K` (Visual) | 行を上に移動 |
| `<leader>p` | ヤンクせずペースト |
| `<leader>d` | ヤンクせず削除 |

### 便利なテキストオブジェクト

```vim
ciw     " 単語を変更
ci"     " ""内を変更
ci(     " ()内を変更
ci{     " {}内を変更
ca{     " {}含めて変更
diw     " 単語を削除
yiw     " 単語をヤンク
vi{     " {}内を選択
vat     " タグ含めて選択
```

### インデント

| キー | 動作 |
|------|------|
| `>` (Visual) | インデント増 |
| `<` (Visual) | インデント減 |
| `=` (Visual) | 自動インデント |
| `gg=G` | ファイル全体を整形 |

### Telescope (検索)

| キー | 動作 |
|------|------|
| `<C-p>` | ファイル検索 |
| `<leader>ff` | ファイル検索 |
| `<leader>fg` | grep検索 |
| `<leader>fw` | カーソル下の単語検索 |
| `<leader>fb` | バッファ一覧 |
| `<leader>fr` | 最近のファイル |
| `<leader>fh` | ヘルプ検索 |
| `<leader>fc` | Gitコミット |
| `<leader>fs` | Gitステータス |
| `<leader>fd` | 診断一覧 |
| `<leader><leader>` | バッファ切替 |

Telescope内:
```
<C-j>/<C-k>   上下移動
<CR>          開く
<C-v>         vsplit
<C-s>         split
<C-q>         quickfixに送る
<Esc>         閉じる
```

### Oil.nvim (ファイル管理)

| キー | 動作 |
|------|------|
| `-` | 親ディレクトリ |
| `<leader>e` | Oil開く |

Oil内:
```
<CR>          開く
<C-v>         vsplit
<C-s>         split
<C-t>         新タブ
<C-p>         プレビュー
<C-c>         閉じる
<C-r>         更新
g.            隠しファイル表示
gs            ソート変更
gx            外部で開く

# ファイル操作 (通常のVim編集)
dd            削除
o             新規作成
cw            リネーム
p             移動/コピー
:w            変更を実行
```

### Flash.nvim (ジャンプ)

| キー | 動作 |
|------|------|
| `s` | Flash jump |
| `S` | Treesitter選択 |
| `r` (Operator) | リモートFlash |
| `R` (Visual/Operator) | Treesitter検索 |
| `<C-s>` (検索時) | Flash切替 |

### LSP

| キー | 動作 |
|------|------|
| `gd` | 定義へ |
| `gD` | 宣言へ |
| `gi` | 実装へ |
| `gr` | 参照一覧 |
| `K` | ホバー情報 |
| `<leader>rn` | リネーム |
| `<leader>ca` | コードアクション |
| `<leader>fm` | フォーマット |
| `<leader>ld` | 診断表示 (float) |

### 診断移動

| キー | 動作 |
|------|------|
| `[d` | 前の診断 |
| `]d` | 次の診断 |
| `[q` | 前のquickfix |
| `]q` | 次のquickfix |
| `<leader>q` | quickfix開く |

### Trouble.nvim (診断UI)

| キー | 動作 |
|------|------|
| `<leader>xx` | 全診断 |
| `<leader>xX` | バッファ診断 |
| `<leader>xs` | シンボル |
| `<leader>xl` | LSP定義 |
| `<leader>xL` | Location list |
| `<leader>xQ` | Quickfix list |
| `<leader>xt` | TODO一覧 |
| `<leader>xT` | TODO検索 (Telescope) |
| `]t` / `[t` | TODO移動 |

### Git

| キー | 動作 |
|------|------|
| `<leader>gd` | Diffview開く |
| `<leader>gh` | ファイル履歴 |
| `<leader>gH` | ブランチ履歴 |
| `<leader>gq` | Diffview閉じる |
| `<leader>gp` | hunkプレビュー |
| `<leader>gb` | blame |
| `]c` | 次のhunk |
| `[c` | 前のhunk |

Gitsignsコマンド:
```vim
:Gitsigns stage_hunk        " hunkをステージ
:Gitsigns undo_stage_hunk   " ステージ取消
:Gitsigns reset_hunk        " hunkをリセット
:Gitsigns stage_buffer      " バッファ全体ステージ
:Gitsigns reset_buffer      " バッファ全体リセット
:Gitsigns diffthis          " 現在ファイルのdiff
:Gitsigns toggle_deleted    " 削除行表示切替
```

### AI

| キー | 動作 |
|------|------|
| `<leader>aa` | Avante: 質問 |
| `<leader>ae` | Avante: 編集 |
| `<leader>ar` | Avante: 再生成 |
| `<leader>ao` | ours採用 |
| `<leader>at` | theirs採用 |
| `<leader>ab` | 両方採用 |
| `<leader>a0` | 両方却下 |
| `]]` / `[[` | 次/前の差分 |
| `<leader>cc` | CodeCompanion Chat |
| `<leader>ct` | CodeCompanion Toggle |
| `<leader>cl` | Claude Code |
| `<leader>cr` | Claude Code Resume |
| `<leader>cv` | Claude Code Verbose |
| `<C-a>` | Cody補完 (Insert) |

CopilotChat:
```vim
:CopilotChat          " チャット
:CopilotChatExplain   " 説明
:CopilotChatFix       " 修正提案
:CopilotChatTests     " テスト生成
:CopilotChatReview    " コードレビュー
:CopilotChatOptimize  " 最適化提案
:CopilotChatDocs      " ドキュメント生成
```

Claude Code:
```vim
:ClaudeCode           " ターミナルウィンドウ開く
:ClaudeCodeContinue   " 直近の会話を続ける
:ClaudeCodeResume     " 会話選択UI
:ClaudeCodeVerbose    " 詳細ログモード
```

### 補完 (nvim-cmp)

| キー | 動作 |
|------|------|
| `<C-Space>` | 補完開く |
| `<C-n>` / `<C-p>` | 選択 |
| `<Tab>` / `<S-Tab>` | 選択 |
| `<CR>` | 確定 |
| `<C-e>` | キャンセル |
| `<C-d>` / `<C-f>` | ドキュメントスクロール |

### Rust (cargo.nvim)

```vim
:CargoBuild           " ビルド
:CargoRun             " 実行
:CargoRunTerm         " ターミナルで実行
:CargoTest            " テスト
:CargoClippy          " Lint
:CargoFmt             " フォーマット
:CargoCheck           " チェック
:CargoBench           " ベンチマーク
:CargoDoc             " ドキュメント生成
:CargoNew <name>      " 新規プロジェクト
:CargoUpdate          " 依存更新
:CargoClean           " ビルド成果物削除
:CargoAutodd          " 依存自動追加
```

### Crates.nvim (Cargo.toml)

Cargo.toml編集時に自動でクレート情報表示。

```vim
:lua require('crates').show_popup()      " クレート情報
:lua require('crates').show_versions()   " バージョン一覧
:lua require('crates').show_features()   " フィーチャー一覧
:lua require('crates').update_crate()    " クレート更新
:lua require('crates').upgrade_crate()   " 最新にアップグレード
```

### ターミナル

| キー | 動作 |
|------|------|
| `<C-x>` | ターミナルモード終了 |

### MCP (Model Context Protocol)

```vim
:MCPHub               " MCPサーバー管理UI
```

### Marp (Markdown Slides)

```vim
:MarpPreview          " スライドプレビュー
:MarpWatch            " 自動更新プレビュー
:MarpExport           " PDF/HTML/PPTXエクスポート
```

### その他便利コマンド

```vim
:Lazy                 " プラグインマネージャー
:Lazy sync            " プラグイン同期
:Lazy update          " プラグイン更新
:Lazy profile         " 起動時間計測
:Mason                " LSP/ツールマネージャー
:LspInfo              " LSP状態確認
:checkhealth          " Neovim診断
:Telescope keymaps    " キーマップ検索
:Telescope commands   " コマンド検索
:Telescope registers  " レジスタ一覧
:Telescope marks      " マーク一覧
```

---

## Warp Terminal

### ペイン

| キー | 動作 |
|------|------|
| `Cmd+D` | 右に分割 |
| `Cmd+Shift+D` | 下に分割 |
| `Ctrl+H/J/K/L` | ペイン移動 |
| `Cmd+W` | ペイン閉じる |
| `Cmd+Shift+Return` | 最大化トグル |

### ブロック

| キー | 動作 |
|------|------|
| `Cmd+↑/↓` | ブロック選択移動 |
| `Cmd+Shift+C` | ブロック出力コピー |
| `Cmd+K` | ブロッククリア |
| `Cmd+Shift+B` | ブックマーク |

### ナビゲーション

| キー | 動作 |
|------|------|
| `Ctrl+`` ` | AI (自然言語コマンド) |
| `Ctrl+R` | 履歴検索 |
| `Cmd+\` | Warp Drive |
| `Cmd+Shift+P` | コマンドパレット |

### タブ

| キー | 動作 |
|------|------|
| `Cmd+T` | 新規タブ |
| `Cmd+Shift+W` | タブ閉じる |
| `Cmd+Shift+]` / `[` | タブ移動 |

### 入力

| キー | 動作 |
|------|------|
| `Ctrl+U` | 行クリア |
| `Ctrl+W` | 単語削除 |
| `Ctrl+A` | 行頭 |
| `Ctrl+E` | 行末 |
| `Ctrl+F` | サジェスト確定 |

---

## トラブル時

```vim
" Neovim
:Lazy sync            " プラグイン同期
:Lazy update          " プラグイン更新
:Mason                " LSP管理
:MasonInstall <name>  " LSPインストール
:LspInfo              " LSP確認
:checkhealth          " 診断
:Copilot auth         " Copilot認証
:Copilot status       " Copilot状態
```

```bash
# Fish
exec fish             # 再読み込み
source ~/.config/fish/config.fish

# 起動計測
nvim --startuptime /tmp/nvim.log
fish --profile-startup /tmp/fish.prof -c exit
```

---

## カスタマイズ

```bash
# Fish個人設定 (gitignore済み)
~/.config/fish/local.fish
```

```lua
-- Neovimプラグイン追加: lua/plugins/init.lua
{
  "author/plugin",
  event = "VeryLazy",
  opts = {},
}

-- キーマップ追加: lua/mappings.lua
vim.keymap.set("n", "<leader>xx", function()
  -- 処理
end, { desc = "説明" })
```
