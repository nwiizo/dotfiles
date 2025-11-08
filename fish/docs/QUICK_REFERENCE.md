# 🚨 Fish Shell プロンプト問題 - クイックリファレンス

**最終更新:** 2025-11-08
**対象:** Fish Shell Configuration (2025 Best Practices Edition)

このドキュメントは、Fish shell のプロンプト関連の問題を素早く解決するためのガイドです。

**関連ドキュメント:**
- [README.md](../README.md) - 総合ガイド
- [ASYNC_PROMPT_ISSUE.md](ASYNC_PROMPT_ISSUE.md) - async prompt問題の詳細
- [CHANGES_EXPLAINED.md](CHANGES_EXPLAINED.md) - 設定変更の詳細
- [CLAUDE.md](../CLAUDE.md) - AI向けガイドライン

---

## 問題の症状
プロンプトに以下が表示される：
```
File: /var/folders/.../tmp.xxx
_fish_prompt
1
2 similarity on  main via ...
```

---

## ⚡ 即座の修復 (再発する場合)

### 1. 問題のあるファイルを削除
```fish
rm ~/.config/fish/functions/fish_prompt.fish
rm ~/.config/fish/functions/fish_right_prompt.fish
```

### 2. 関数をクリア
```fish
functions -e fish_prompt fish_right_prompt
```

### 3. 新しい設定を適用
```fish
# 既に修正版が適用されています
# もし問題が続く場合は exec fish で再起動
exec fish
```

### 4. Fishを再起動
```fish
exec fish
```

---

## 🔍 根本原因の特定

### A. conf.d/ をチェック
```fish
ls -la ~/.config/fish/conf.d/
grep -l "fish_prompt" ~/.config/fish/conf.d/*.fish
```

**探すもの：** `fish_prompt` や `functions` を含む行

### B. local.fish をチェック
```fish
cat ~/.config/fish/local.fish
```

**探すもの：** `function fish_prompt` の定義

### C. 診断スクリプトを実行
```fish
fish ~/.config/fish/test_config.fish
```

---

## 📝 重要なルール

### ✅ やるべきこと
1. Starshipは config.fish の**最後**で初期化
2. functions/ ディレクトリに fish_prompt.fish を**作らない**
3. local.fish で fish_prompt を**定義しない**

### ❌ やってはいけないこと
1. config.fish で conf.d/ を手動で読み込む（自動読み込みされる）
2. 複数の場所で fish_prompt を定義する
3. Starship初期化より後に他の設定を読み込む

---

## 🗂️ ファイル構成（推奨）

```
~/.config/fish/
├── config.fish           ← メイン設定（修正版を使用中）
├── conf.d/               ← 追加の設定ファイル（自動読み込み）
│   └── *.fish           ← fish_promptを定義しないこと！
├── functions/            ← カスタム関数
│   ├── ls.fish          ← OK（ラッパー関数）
│   ├── ll.fish          ← OK
│   ├── fish_prompt.fish ← NG（Starshipと競合）
│   └── fish_right_prompt.fish ← NG
└── local.fish           ← ローカル設定（オプション）
                         ← fish_promptを定義しないこと！
```

---

## 🔄 設定の読み込み順序

1. `/etc/fish/config.fish` (システム)
2. `~/.config/fish/config.fish` (ユーザー)
3. `~/.config/fish/conf.d/*.fish` (追加設定・自動)
4. **Starship初期化** ← これが最後であるべき！

---

## 🧪 テスト方法

### 最小構成でテスト
```fish
# 一時的にシンプルな設定でテスト
fish --no-config
# 問題なければ、config.fishに問題がある
```

### 段階的にテスト
```fish
# 1. 基本設定のみ
fish -c "source ~/.config/fish/config.fish"

# 2. Starship初期化のみ
fish -c "starship init fish | source"
```

---

## 🆘 それでも直らない場合

### 完全リセット
```fish
# 現在の設定をバックアップ
mv ~/.config/fish ~/.config/fish.backup

# Fishを再起動（デフォルト設定）
exec fish

# 新しい設定を配置
mkdir -p ~/.config/fish
# 元のconfig.fishを復元（修正版が既に適用されているはず）
```

---

## 📞 よくある質問

**Q: conf.d/ に何も入れられないの？**
A: 入れられます。ただし `fish_prompt` を定義しないこと。

**Q: 右側のプロンプトは使える？**
A: Starshipは右プロンプトも管理します。カスタマイズは `starship.toml` で。

**Q: local.fish は何に使う？**
A: マシン固有の環境変数やエイリアスに使えます。プロンプトの定義は避けてください。

**Q: 元のconfig.fishの何が問題だった？**
A: 主に2つ：
   1. conf.d/ の手動読み込み（二重読み込みの原因）
   2. Starship初期化の前に local.fish を読み込んでいた

---

## 🎯 まとめ

**プロンプト問題の90%は以下で解決：**

1. `functions/fish_prompt.fish` を削除
2. 修正版 `config.fish` を使用（既に適用済み）
3. `exec fish` で再起動

**それでも再発する場合：**

1. `test_config.fish` で診断
2. conf.d/ と local.fish をチェック
3. `fish_prompt` を定義しているファイルを修正
