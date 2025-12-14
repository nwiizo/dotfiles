# Warp Terminal Configuration

開発者向け効率化設定。tmuxライクなペイン操作とVimスタイルのナビゲーションを提供。

## インストール

```bash
# シンボリックリンクを作成
ln -sf ~/ghq/github.com/nwiizo/dotfiles/warp/keybindings.yaml ~/.warp/keybindings.yaml
ln -sf ~/ghq/github.com/nwiizo/dotfiles/warp/themes ~/.warp/themes
```

## キーバインド一覧

### ペイン操作（tmux風）

| キー | 機能 |
|------|------|
| `Cmd+D` | 右に分割 |
| `Cmd+Shift+D` | 下に分割 |
| `Ctrl+H/J/K/L` | ペイン間移動（Vim風） |
| `Cmd+W` | ペインを閉じる |
| `Cmd+Shift+Return` | ペイン最大化トグル |

### ブロック操作（Warp独自機能）

| キー | 機能 |
|------|------|
| `Cmd+Up/Down` | ブロック間移動 |
| `Cmd+Shift+C` | ブロック出力をコピー |
| `Cmd+K` | 全ブロッククリア |
| `Cmd+Shift+B` | ブロックをブックマーク |

### ナビゲーション

| キー | 機能 |
|------|------|
| `Ctrl+\`` | AI（自然言語コマンド） |
| `Ctrl+R` | コマンド履歴検索 |
| `Cmd+\` | Warp Drive（保存済みコマンド） |
| `Cmd+Shift+P` | コマンドパレット |

### タブ操作

| キー | 機能 |
|------|------|
| `Cmd+T` | 新規タブ |
| `Cmd+Shift+W` | タブを閉じる |
| `Cmd+Shift+]` / `[` | 次/前のタブ |

### エディタ（入力）

| キー | 機能 |
|------|------|
| `Ctrl+U` | 行をクリア |
| `Ctrl+W` | 単語削除（後方） |
| `Ctrl+A` / `E` | 行頭/行末に移動 |
| `Ctrl+F` | オートサジェスト確定 |

## 推奨設定（Settings > Features）

Warp UIから以下の設定を有効化することを推奨：

### Editor
- **Edit commands with Vim keybindings**: ON（Vimユーザー向け）

### Session
- **Restore windows, tabs and panes on startup**: ON

### Terminal
- **Show working directory in tab title**: ON

### AI
- **Active AI**: ON（エラー時の自動修正提案）

## テーマ

`themes/custom.yaml` でカスタムテーマを定義可能。

## 参考リンク

- [Warp Keyboard Shortcuts](https://docs.warp.dev/getting-started/keyboard-shortcuts)
- [Warp Keysets Repository](https://github.com/warpdotdev/keysets)
- [Customizing Warp](https://docs.warp.dev/getting-started/quickstart-guide/customizing-warp)
