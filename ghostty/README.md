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
rtk proxy ghostty +validate-config --config-file=ghostty/config
rtk proxy ghostty +validate-config
rtk proxy ghostty +show-config --changes-only
rtk proxy ghostty +list-keybinds
rtk proxy ghostty +explain-config keybind
```

`+validate-config` は構文を検査する。キー入力との一致は保証しないため、
`+list-keybinds` と実際のキー操作も確認する。tip の仕様は、導入済みバイナリの
`+explain-config <設定名またはアクション名>` を優先して確認する。

## 現行環境

- Ghostty: `1.3.x` tip channel
- Theme: Catppuccin Mocha
- Font: Hack Nerd Font Mono, 24pt
- Shell integration: Fish 4.9+ with a native transient prompt
- Window: fullscreen by default, native tabs, saved state
- Scrollback: 100 MB per terminal surface (allocated lazily)
- Clipboard reads requested by terminal applications require confirmation
- Quick terminal: configured but default global hotkey is unbound
- AI notifications: macOS banner + sound + transient `🔔` tab marker

## 更新確認（2026-10-10）

導入済みビルドは `1.3.2-main+b699ea79f`。Codex CLI `0.162.1`、
Claude Code `2.1.294`、Neovim `0.12.5` と組み合わせる。
tip には次期版向けの機能も含まれるため、同梱ドキュメントと
[前回の確認ビルドからの差分](https://github.com/ghostty-org/ghostty/compare/7aab0a039...b699ea79f)
を照合した。既存の設定に廃止された項目はなく、文字選択・プロンプトのクリック移動・
ウィンドウ復元などの修正は本体の更新で入る。

- 修飾付きEnterをアプリへ渡し、Neovimの操作とAIへの複数行入力を両立する。
- `Cmd+|` はShiftを含む物理キー指定にし、US/JIS配列に対応する。
- 閉じたタブ・ペインの復元猶予を15秒にし、独自操作をコマンドパレットへ追加する。

開発中の入力と出力を読みやすくするため、アプリ用の `Ctrl` キーを空け、
出力中もスクロール位置を保つ。背景の不透明度は `0.95`、非選択ペインは
`0.85`、文字の最低コントラスト比は `3`。Catppuccin Mocha の色を sRGB で扱う。

### 反映

`Cmd+Shift+,` で設定を再読み込みする。背景の不透明度はmacOSでは
Ghosttyの再起動が必要で、ネイティブフルスクリーン中は常に不透明になる。
フォントの見た目、キー操作、分割ペインの明るさは実際の画面でも確認する。

## キーバインド

### ペイン操作

| キー | 機能 |
|---|---|
| `Cmd+D` | 右に分割 |
| `Cmd+Shift+\`（US） / `Cmd+Shift+¥`（JIS） | 右に分割（`Cmd+\|` の操作） |
| `Cmd+Shift+D` | 下に分割 |
| `Cmd+Shift+-` | 下に分割 |
| `Cmd+Alt+H/J/K/L` | ペイン間移動 |
| `Cmd+Alt+矢印` | ペイン間移動（標準） |
| `Cmd+Shift+Return` | ペイン最大化トグル |
| `Cmd+Ctrl+=` / `Ctrl+Shift+=` | ペインサイズ均等化 |
| `Cmd+Ctrl+R` | resize key table を起動 |
| resize mode `h/j/k/l` | ペインを左/下/上/右へリサイズ |
| resize mode `Esc` / `Ctrl+C` | resize key table を終了 |

`Ctrl+H/J/K/L` と `Ctrl+W` はFish・Neovimでそのまま使える。
`Cmd+|` の `|` だけを設定しても、Shiftを押したキー入力には一致しない。
設定では `cmd+shift+backslash` / `cmd+shift+intl_yen` を使う。
Ghosttyの `performable:` は端末側で操作できるかを判断するもので、
実行中アプリのキーバインドとの競合は判定しない。

### タブ・ウィンドウ

| キー | 機能 |
|---|---|
| `Cmd+N` | 新規ウィンドウ |
| `Cmd+T` | 新規タブ |
| `Cmd+W` | surface を閉じる |
| `Cmd+Shift+]` / `Cmd+Shift+[` | 次/前のタブ |
| `Cmd+Shift+Right` / `Cmd+Shift+Left` | 次/前のウィンドウ |
| `Cmd+Shift+T` | 閉じたタブ・ペインなど直前の操作を取り消す（15秒以内） |
| `Cmd+Shift+P` | コマンドパレット（標準） |

`undo-timeout = 15s` の間は閉じたセッションも保持され、プロセスが動き続ける。
処理を止めたい場合は、閉じる前にアプリ側で中断・終了する。

### Codex・Claude Code・Neovimの入力

`Shift+Enter` と `Ctrl+Enter` はGhostty側で改行文字に変換せず、アプリへ渡す。
[Neovimの拡張キー入力](https://neovim.io/doc/user/tui.html#tui-csiu)を保つことで、
Snacks pickerの `Shift+Enter`（表示先ウィンドウの選択）などが使える。
[Claude CodeはGhosttyで追加設定なしにShift+Enterへ対応する](https://code.claude.com/docs/en/terminal-config#enter-multiline-prompts)。
また、導入済みClaude Codeの `Ctrl+Enter` は
[待機中のメッセージを今すぐ送る操作](https://code.claude.com/docs/en/interactive-mode#general-controls)として使える。
`Cmd+Enter` は従来どおり改行文字（`Ctrl+J`相当）を送る。

長いプロンプトは `Ctrl+G` でNeovimへ渡して編集できる。
Fishで `VISUAL=nvim` と `EDITOR=nvim` を設定済み。
[Codexの外部エディタ](https://learn.chatgpt.com/docs/cli-customization#prompt-editor)では、
保存して終了すると入力欄へ戻る。Claude Codeも `Ctrl+G` で外部エディタを開ける。
AI側のキー変更はCodexの `/keymap`、
Claude Codeの `/keybindings` で行う。
`macos-option-as-alt = true` により、`Alt` を使うアプリの操作も送れる。

### コマンドパレット

`Cmd+Shift+P` から次の独自操作を検索できる。標準の項目もそのまま残す。

| 検索する名前 | 用途 |
|---|---|
| `Resize Panes` | `h/j/k/l` でペイン調整、`Esc` / `Ctrl+C` で終了 |
| `Restore Automatic Tab Title` | 手動のタブ名を解除し、Codex・Claude Code・Fishの動的タイトルへ戻す |

タブに名前を付ける操作は標準の `Change Tab Title` を使う。
現在画面の保存は標準の `Copy Screen to Temporary File and Copy Path` からも実行できる。
画面より前のログを保存する場合は `Cmd+Ctrl+L` を使う。

### フォントサイズ

| キー | 機能 |
|---|---|
| `Cmd++` | フォントサイズ拡大 |
| `Cmd+-` | フォントサイズ縮小 |
| `Cmd+0` | フォントサイズリセット |

### スクロール・プロンプト移動

| キー | 機能 |
|---|---|
| `Cmd+Ctrl+U` / `Cmd+Ctrl+D` | 半ページ上/下へスクロール |
| `Cmd+PageUp` / `Cmd+PageDown` | 1ページ上/下へスクロール（標準） |
| `Cmd+Home` / `Cmd+End` | 最上部/最下部へスクロール（標準） |
| `Ctrl+Shift+Up` | 前のプロンプトへ |
| `Ctrl+Shift+Down` | 次のプロンプトへ |

`Ctrl+U` と `Alt+B` はFishの入力編集やNeovim側の操作に使える。
Home/EndキーがないMacのキーボードでは `Fn+Left/Right`、
PageUp/PageDownには `Fn+Up/Down` を使う。

### 検索・コピー

| キー | 機能 |
|---|---|
| `Cmd+F` | スクロールバックを検索（標準） |
| `Cmd+E` | 選択した文字列を検索（標準） |
| `Cmd+G` / `Cmd+Shift+G` | 次/前の検索結果（標準） |
| `Cmd+Shift+F` | 検索を終了（標準） |
| `Cmd+C` | テキストと書式をコピー（標準） |
| `Cmd+Shift+C` | HTMLとしてコピー |

選択時の自動コピーは `copy-on-select = clipboard` で有効にする。
コピー後も選択範囲が残るので、続けて `Cmd+E` で同じ文字列を探せる。

### AI workflow

| キー | 機能 |
|---|---|
| `Cmd+Shift+S` | 現在の画面を plain text で保存して開く |
| `Cmd+Alt+Shift+S` | scrollback 全体を plain text で保存して開く |
| `Cmd+Ctrl+S` | 選択した出力をファイルに保存し、パスをコピー |
| `Cmd+Ctrl+Shift+S` | 現在の画面をファイルに保存し、パスをコピー |
| `Cmd+Ctrl+L` | スクロールバックをファイルに保存し、パスをコピー |
| `Cmd+Shift+R` | 入力を禁止するreadonly modeを切り替え（出力は継続） |
| `Cmd+Shift+M` | mouse reporting をトグル |

`scroll-to-bottom = keystroke,no-output` により、AIやログの出力中も
遡って読んでいる位置を保つ。最下部にいる間は新しい出力に追従し、
入力するか `Cmd+End` を押すと最下部へ戻る。readonly modeは入力を止める機能で、
プロセスや出力を一時停止する機能ではない。

### Codex・Claude Codeへ出力を渡す

1. 失敗したビルドやテストの出力を選択し、`Cmd+Ctrl+S` を押す。
2. AIの入力欄へファイルパスを貼り付け、「このログを読んで原因を調べて」と依頼する。
3. 全画面で動くAIツールの表示を渡すなら `Cmd+Ctrl+Shift+S` を使う。

画面より前のログが必要なら `Cmd+Ctrl+L` を使う。
`Cmd+Shift+P` の標準コマンドパレットにも、`Copy Screen` や `Copy Selection`
から探せるファイル書き出し操作がある。
[Ghostty標準のファイル書き出し](https://ghostty.org/docs/config/keybind/reference#write_scrollback_file)
を使い、本文はプレーンテキスト、一時ファイルはローカルに保存する。
選択範囲がない場合、選択部分の書き出しは何もしない。
スクロールバックは画面より前の履歴が対象で、代替画面を使うTUIでは利用できない。
その場合は現在の画面か選択範囲を書き出す。
別ホストやファイル参照を制限した環境で動くAIには、ファイル内容を渡す必要がある。

Fishの通常のコマンドなら、`Cmd` を押しながら出力をトリプルクリックすると
そのコマンドの出力を選択できる。
[Shell integration](https://ghostty.org/docs/features/shell-integration) と
プロンプト移動を組み合わせると、失敗したテストの範囲を探しやすい。

作業中のタブは動的タイトルで識別し、完了・入力待ちは下記の通知を使う。
readonly mode中も通知と出力は続くので、出力を読むペインと操作するペインを
分けて使える。

### AI notifications

`./scripts/link.sh` は Ghostty 設定をリンクした後、既存の Claude Code と
Codex のユーザー設定へ通知項目だけをマージする。権限、MCP、モデルなどの
既存設定は上書きしない。変更前のファイルは、実際に差分がある場合だけ
`~/.dotfiles-link-backups/ai-notifications-*` 以下へ保存する。

| 状態 | タブ表示 | macOS通知 |
|---|---|---|
| 作業中 | Codex／Claude Code が設定する動的タイトル | なし |
| 応答・許可待ち | 先頭に `🔔` | バナーと通知音 |
| タブを選択または操作 | `🔔` が消えて元のタイトルへ戻る | 通知を解除 |

通常のシェルコマンドは、30秒以上かかり、Ghosttyを操作していない間に
終了した場合だけバナーで通知する。Codex／Claude Code側の通知と音が重ならないよう、
この通知ではベルを鳴らさない。

```ini
notify-on-command-finish = unfocused
notify-on-command-finish-after = 30s
notify-on-command-finish-action = no-bell,notify
```

Codex は公式の `OSC 9` 通知を使う。

```toml
[tui]
notifications = ["agent-turn-complete", "approval-requested"]
notification_method = "osc9"
notification_condition = "unfocused"
```

Claude Code は公式の `terminal_bell` でGhosttyのタブへ `🔔` を付ける。
公式Notification Hookは `terminalSequence` として `OSC 777` を返し、macOSの
バナーと通知音を出す。Hook子プロセスから `/dev/tty` へ直接書き込む方式は、
制御TTYを継承しない実行環境で動かないため使わない。

```json
{
  "preferredNotifChannel": "terminal_bell",
  "hooks": {
    "Notification": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "~/.local/bin/ghostty-claude-notification"
          }
        ]
      }
    ]
  }
}
```

集中モード中にも受け取りたい場合は、macOSの各集中モードでGhosttyを
「通知を許可するアプリ」に追加する。Ghosttyの通知自体は通常優先度なので、
この許可がない場合はNotification Centerがバナーと音を抑止する。

検証環境 (2026-07-21): macOS 26.5.2、Ghostty 1.3.2 tip、Codex CLI
0.144.6、Claude Code 2.1.216。

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
unfocused-split-opacity = 0.85
unfocused-split-fill = #11111b
split-divider-color = #313244
split-preserve-zoom = navigation
```

## 以前のターミナル設定

現在はGhosttyを使う。Warpの設定は[archive/warp](../archive/warp/README.md)に保管し、
Homebrewとリンクの管理対象から外している。

## 参考リンク

- [Ghostty Documentation](https://ghostty.org/docs)
- [Ghostty GitHub](https://github.com/ghostty-org/ghostty)
- [Ghostty Configuration Reference](https://ghostty.org/docs/config)
