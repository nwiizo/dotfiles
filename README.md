# dotfiles

nwiizoの開発環境設定ファイル集。macOS向けに最適化されたモダンな開発者向け設定。

## 概要

このリポジトリは、日々の開発作業を効率化するための設定ファイルを管理しています。主にインフラエンジニア・SRE向けの構成で、Rust、Go、TypeScript、Pythonでの開発を想定しています。

## ディレクトリ構成

```
dotfiles/
├── fish/           # Fish shell設定（メインシェル）
├── nvim/           # Neovim設定（メインエディタ）
├── warp/           # Warpターミナル設定
├── starship/       # Starshipプロンプト設定
├── git/            # Git関連スクリプト
├── bash/           # Bash設定
├── zsh/            # Zsh設定
├── vim/            # Vim設定（レガシー）
├── lvim/           # LunarVim設定
├── nvchad/         # NvChad設定
├── ssh/            # SSH設定テンプレート
├── tmux/           # tmux設定（レガシー）
└── dockerfile/     # Dockerfileテンプレート
```

## 主要コンポーネント

### Fish Shell (`fish/`)

メインシェルとして使用。モダンCLIツールとの統合が特徴。

- **モダンCLI置き換え**: `eza`(ls), `bat`(cat), `ripgrep`(grep), `zoxide`(cd)
- **FZF統合**: `Ctrl+R`(履歴), `Ctrl+G`(ghqリポジトリ)
- **開発ツール**: mise(ランタイム管理), Docker, Kubernetes
- **プロンプト**: Starship

### Neovim (`nvim/`)

メインエディタ。lazy.nvimによるプラグイン管理。

- **LSP**: 各言語のLanguage Server対応
- **補完**: nvim-cmp
- **ファイル操作**: neo-tree, telescope
- **Git**: gitsigns, diffview

### Starship (`starship/`)

クロスシェル対応のプロンプト。Git状態、言語バージョン、クラウド環境を表示。

### Warp Terminal (`warp/`)

[Warp](https://www.warp.dev/)を使用。AI機能、ブロックベースの出力、セッション管理などtmux相当の機能を内蔵。

- **keybindings.yaml**: カスタムキーバインド（ペイン分割など）
- **themes/**: カスタムテーマ

## インストール

### 前提条件

- macOS (Apple Silicon / Intel)
- [Homebrew](https://brew.sh/)
- Git

### 基本ツールのインストール

```bash
# Homebrew経由で必要なツールをインストール
brew install fish neovim starship
brew install eza bat ripgrep fd fzf zoxide ghq

# Fisherプラグインマネージャ
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher

# miseランタイムマネージャ
brew install mise
```

### シンボリックリンクの作成

```bash
# Fish
ln -sf ~/ghq/github.com/nwiizo/dotfiles/fish/config.fish ~/.config/fish/config.fish

# Neovim
ln -sf ~/ghq/github.com/nwiizo/dotfiles/nvim ~/.config/nvim

# Starship
ln -sf ~/ghq/github.com/nwiizo/dotfiles/starship/starship.toml ~/.config/starship.toml

# Warp
ln -sf ~/ghq/github.com/nwiizo/dotfiles/warp/keybindings.yaml ~/.warp/keybindings.yaml
ln -sf ~/ghq/github.com/nwiizo/dotfiles/warp/themes ~/.warp/themes
```

## 主要なキーバインド

### Fish Shell

| キー | 機能 |
|------|------|
| `Ctrl+R` | 履歴検索 (fzf) |
| `Ctrl+G` | リポジトリ検索 (ghq + fzf) |
| `Ctrl+F` | ファイル検索 (fzf) |

### 主要なエイリアス/abbreviations

```fish
# Git
g    = git
gst  = git status
gc   = git commit -v
gp   = git push

# Docker
d    = docker
dc   = docker compose

# Kubernetes
k    = kubectl
kgp  = kubectl get pods
```

## 技術スタック

このdotfilesは以下の技術スタックでの開発を想定:

- **言語**: Rust, Go, TypeScript, Python
- **インフラ**: Docker, Kubernetes, Terraform
- **クラウド**: GCP, AWS
- **ツール**: GitHub CLI, mise, cargo, uv

## ファイル構成詳細

| ディレクトリ | 主要ファイル | 説明 |
|-------------|-------------|------|
| `fish/` | `config.fish` | 13セクション構成のFish設定 |
| `nvim/` | `init.lua`, `lua/plugins/` | lazy.nvimベースのNeovim設定 |
| `warp/` | `keybindings.yaml`, `themes/` | Warpターミナル設定 |
| `starship/` | `starship.toml` | プロンプトテーマ設定 |
| `git/` | `power_pull.sh` | Git便利スクリプト |

## Author

[nwiizo](https://github.com/nwiizo)

## License

MIT
