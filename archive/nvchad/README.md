# Neovim Configuration with NvChad

このリポジトリには、NvChadをベースにした私のNeovim設定ファイルが含まれています。

## 前提条件

- [Neovim 0.10](https://github.com/neovim/neovim/releases/tag/v0.10.0)以降
- [Nerd Font](https://www.nerdfonts.com/)（ターミナルのフォントとして使用）
  - フォント名が"Mono"で終わらないものを選択してください
- [Ripgrep](https://github.com/BurntSushi/ripgrep)（Telescopeでのgrep検索に必要、オプション）

## インストール

1. 古いNeovimフォルダを削除してください。

2. NvChadをインストールします：

   ```
   git clone https://github.com/NvChad/starter ~/.config/nvim && nvim
   ```

3. プラグインのダウンロードが完了したら、Neovim内で次のコマンドを実行します：

   ```
   :MasonInstallAll
   ```

4. nvimフォルダから`.git`フォルダを削除します。

5. このディレクトリの設定ファイルを反映させる

## ディレクトリ構造

```
/Users/nwiizo/.config/nvim/
├── LICENSE
├── init.lua
├── lazy-lock.json
└── lua
    ├── chadrc.lua
    ├── configs
    │   ├── conform.lua
    │   ├── lazy.lua
    │   └── lspconfig.lua
    ├── mappings.lua
    ├── options.lua
    └── plugins
        └── init.lua
```

## 主要ファイルの説明

- `init.lua`: Neovimの初期化スクリプト
- `lazy-lock.json`: Lazy.nvimによって管理されるプラグインのロックファイル
- `lua/chadrc.lua`: NvChadのカスタム設定ファイル
- `lua/configs/`: 各種プラグインの設定ファイル
- `lua/mappings.lua`: キーマッピングの設定
- `lua/options.lua`: Neovimのオプション設定
- `lua/plugins/init.lua`: プラグインの定義と設定

## カスタマイズ

- NvChadのカスタム設定は`lua/chadrc.lua`ファイルで行います。
- プラグインの追加や削除は`lua/plugins/init.lua`ファイルで行います。
- キーマッピングの変更は`lua/mappings.lua`ファイルで行います。
- Neovimのオプション設定は`lua/options.lua`ファイルで行います。

## 更新

NvChadの更新は以下のコマンドで行います：

```
:Lazy sync
```

## アンインストール

OS別のアンインストールコマンド：

```bash
# Linux / macOS
rm -rf ~/.config/nvim
rm -rf ~/.local/state/nvim
rm -rf ~/.local/share/nvim

# Windows (CMD)
rd -r ~\AppData\Local\nvim
rd -r ~\AppData\Local\nvim-data

# Windows (PowerShell)
rm -Force ~\AppData\Local\nvim
rm -Force ~\AppData\Local\nvim-data
```

## 注意事項

- この設定はNvChadをベースにしているため、NvChadの更新によって影響を受ける可能性があります。
- 問題が発生した場合は、NvChadの[公式ドキュメント](https://nvchad.com/docs/quickstart/post-install)を参照するか、issueを開いてください。

ご質問やフィードバックがありましたら、お気軽にお問い合わせください。
