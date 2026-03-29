# dotfiles

個人開発環境の設定リポジトリ。Fish + Neovim + Ghostty + Starship。

## 構成

| ディレクトリ | 役割 | 状態 |
|---|---|---|
| `fish/` | Fish shell (config.fish, plugins) | Active |
| `nvim/` | Neovim LazyVim (lua/) | Active |
| `ghostty/` | Ghostty terminal (config) | Active |
| `starship/` | Starship prompt (starship.toml) | Active |
| `git/` | Git scripts | Active |
| `warp/`, `bash/`, `zsh/`, `vim/`, `tmux/`, `lvim/`, `nvchad/`, `nvchad-v2.5/` | Archive | 参照のみ |

## 変更時の制約

- **fish/config.fish**: セクション構造（13セクション）を維持。新しいabbreviationは既存カテゴリに追加
- **nvim/lua/plugins/**: モジュール分割（ui, navigation, git, diagnostics, lsp, ai, completion, coding, lang）を維持。新プラグインは適切なモジュールに配置
- **nvim/lua/config/keymaps.lua**: leader keyは `<Space>`。LazyVimデフォルトキーマップとの衝突を確認してから追加
- **ghostty/config**: セクションコメント付き。Vim式キーバインドのパターンを維持
- Archiveディレクトリは変更しない

## テスト

```bash
# Fish: 構文チェック + 再読み込み
fish -n fish/config.fish && exec fish

# Neovim: 起動エラー確認
nvim --headless -c 'qall'
nvim --startuptime /tmp/nvim.log  # 起動時間

# Ghostty: 設定は再起動で反映
```

## 各設定の詳細ドキュメント

- `fish/CLAUDE.md` - Fish設定の詳細仕様・アーキテクチャ
- `fish/docs/` - Fish関連ドキュメント
