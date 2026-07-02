# Ghostty Terminal Configuration

高速でGPUアクセラレーションされたターミナルエミュレータ
[Ghostty](https://ghostty.org/) の設定。Homebrew の `ghostty@tip` を使い、
この repo の `ghostty/config` を `~/.config/ghostty/config` に symlink する。

## インストール

```bash
cd ~/ghq/github.com/nwiizo/dotfiles
brew bundle --file Brewfile
./scripts/link.sh
```

設定の検証:

```bash
ghostty +validate-config --config-file=ghostty/config
ghostty +validate-config
```

## 現行環境

- Ghostty: `1.3.x` tip channel
- Theme: Catppuccin Mocha
- Font: Hack Nerd Font Mono, 24pt
- Shell integration: Fish 4.8+
- Window: fullscreen by default, native tabs, saved state
- Scrollback: 100,000 lines
- Quick terminal: configured but default global hotkey is unbound

## キーバインド

### ペイン操作

| キー | 機能 |
|---|---|
| `Cmd+D` | 右に分割 |
| `Cmd+Shift+D` | 下に分割 |
| `Cmd+\|` | 右に分割 |
| `Cmd+Shift+-` | 下に分割 |
| `Ctrl+H/J/K/L` | ペイン間移動。実行中アプリが扱える場合はアプリへ渡す |
| `Cmd+Shift+Return` | ペイン最大化トグル |
| `Cmd+Ctrl+=` / `Ctrl+Shift+=` | ペインサイズ均等化 |
| `Ctrl+W` then `R` | resize key table を起動 |
| resize mode `h/j/k/l` | ペインを左/下/上/右へリサイズ |
| resize mode `Esc` | resize key table を終了 |

### タブ・ウィンドウ

| キー | 機能 |
|---|---|
| `Cmd+N` | 新規ウィンドウ |
| `Cmd+T` | 新規タブ |
| `Cmd+W` | surface を閉じる |
| `Cmd+Shift+]` / `Cmd+Shift+[` | 次/前のタブ |
| `Cmd+Shift+Right` / `Cmd+Shift+Left` | 次/前のウィンドウ |

### フォントサイズ

| キー | 機能 |
|---|---|
| `Cmd++` | フォントサイズ拡大 |
| `Cmd+-` | フォントサイズ縮小 |
| `Cmd+0` | フォントサイズリセット |

### スクロール・プロンプト移動

| キー | 機能 |
|---|---|
| `Ctrl+U` | 半ページ上へスクロール |
| `Alt+B` | 1ページ上へスクロール |
| `Alt+G` | 最上部へスクロール |
| `Alt+Shift+G` | 最下部へスクロール |
| `Ctrl+Shift+Up` | 前のプロンプトへ |
| `Ctrl+Shift+Down` | 次のプロンプトへ |

### AI workflow

| キー | 機能 |
|---|---|
| `Cmd+Shift+S` | 現在の画面を plain text で保存して開く |
| `Cmd+Alt+Shift+S` | scrollback 全体を plain text で保存して開く |
| `Cmd+Shift+R` | readonly mode をトグル |
| `Cmd+Shift+M` | mouse reporting をトグル |

`scroll-to-bottom = keystroke,output` にしているため、AI ツールの streaming
output でも最下部へ追従しやすい。

### Quick Terminal

```ini
keybind = global:cmd+shift+space=unbind
quick-terminal-position = top
quick-terminal-animation-duration = 0.2
quick-terminal-autohide = true
```

`Cmd+Shift+Space` は macOS 側や他ツールとの衝突を避けるため unbind している。
Quick Terminal を使う場合は別の `global:` keybind を割り当てる。

## 設定ハイライト

### Catppuccin Mocha

```ini
background = #1e1e2e
foreground = #cdd6f4
selection-background = #cba6f7
palette-generate = false
```

### Font

```ini
font-family = "Hack Nerd Font Mono"
font-size = 24
font-feature = -calt
font-feature = -liga
font-feature = -dlig
font-synthetic-style = no-bold,no-italic,no-bold-italic
```

### Shell Integration

```ini
shell-integration = fish
shell-integration-features = no-cursor,sudo,title,ssh-env,ssh-terminfo,path
window-inherit-working-directory = true
tab-inherit-working-directory = true
split-inherit-working-directory = true
```

### Split Appearance

```ini
unfocused-split-opacity = 0.65
unfocused-split-fill = #11111b
split-divider-color = #313244
split-preserve-zoom = navigation
```

## Warp との併用

Ghostty は primary terminal として使う。Warp は Agent Mode、block-based output、
notebooks、Warp Drive、reusable workflows 用に残す。

## 参考リンク

- [Ghostty Documentation](https://ghostty.org/docs)
- [Ghostty GitHub](https://github.com/ghostty-org/ghostty)
- [Ghostty Configuration Reference](https://ghostty.org/docs/config)
