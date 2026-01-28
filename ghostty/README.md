# Ghostty Terminal Configuration

高速でGPUアクセラレーションされたターミナルエミュレータ [Ghostty](https://ghostty.org/) の設定。

## インストール

```bash
# Ghosttyをインストール（macOS）
brew install ghostty

# シンボリックリンクを作成
mkdir -p ~/.config/ghostty
ln -sf ~/ghq/github.com/nwiizo/dotfiles/ghostty/config ~/.config/ghostty/config
```

## 特徴

- **Tokyo Night テーマ** - 目に優しいダークテーマ
- **Hack Nerd Font Mono** - アイコン対応フォント
- **tmux風ペイン操作** - Warpと統一されたキーバインド
- **Vim風ナビゲーション** - Ctrl+H/J/K/Lでペイン移動
- **フォーカス表示** - アクティブ/非アクティブウィンドウの明確な区別

## キーバインド一覧

### ペイン操作（Warp統一）

| キー | 機能 |
|------|------|
| `Cmd+D` | 右に分割 |
| `Cmd+Shift+D` | 下に分割 |
| `Ctrl+H/J/K/L` | ペイン間移動（Vim風） |
| `Cmd+W` | ペイン/タブを閉じる |
| `Cmd+Shift+Return` | ペイン最大化トグル |

### タブ操作

| キー | 機能 |
|------|------|
| `Cmd+T` | 新規タブ |
| `Cmd+N` | 新規ウィンドウ |
| `Cmd+Shift+]` / `[` | 次/前のタブ |

### フォントサイズ

| キー | 機能 |
|------|------|
| `Cmd++` | フォントサイズ拡大 |
| `Cmd+-` | フォントサイズ縮小 |
| `Cmd+0` | フォントサイズリセット |

### スクロール（Vim風）

| キー | 機能 |
|------|------|
| `Ctrl+U` | 半ページ上 |
| `Ctrl+B` | 1ページ上 |
| `Ctrl+F` | 1ページ下 |
| `Alt+G` | 最上部へ |
| `Alt+Shift+G` | 最下部へ |

### プロンプト間移動（Fish Shell統合）

| キー | 機能 |
|------|------|
| `Ctrl+Shift+Up` | 前のプロンプトへ |
| `Ctrl+Shift+Down` | 次のプロンプトへ |

### クイックターミナル

| キー | 機能 |
|------|------|
| `Cmd+Shift+Space` | クイックターミナルをトグル |

## 設定ハイライト

### フォーカス状態の差別化

```
# アクティブウィンドウ: 明るい背景
background = #24283b
background-opacity = 1.0

# 非アクティブウィンドウ: 暗く表示
unfocused-split-opacity = 0.4
unfocused-split-fill = #0d0d0d
```

### シェル統合（Fish）

```
shell-integration = fish
shell-integration-features = no-cursor,sudo,title
window-inherit-working-directory = true
```

### セッション復元

```
window-save-state = always
```

## Warpからの移行

Warpから移行する場合、以下のキーバインドは同じ操作感を維持しています：

- ペイン分割: `Cmd+D`, `Cmd+Shift+D`
- ペイン移動: `Ctrl+H/J/K/L`
- タブ移動: `Cmd+Shift+]` / `[`
- ペイン最大化: `Cmd+Shift+Return`

## 参考リンク

- [Ghostty Documentation](https://ghostty.org/docs)
- [Ghostty GitHub](https://github.com/ghostty-org/ghostty)
- [Ghostty Configuration Reference](https://ghostty.org/docs/config)
