# 📊 Config.fish 修正内容の詳細説明

**最終更新:** 2025-11-08
**対象:** Fish Shell Configuration (2025 Best Practices Edition)

このドキュメントでは、config.fishに加えられた修正の背景と理由を詳しく説明します。

**関連ドキュメント:**
- [README.md](../README.md) - 総合ガイド
- [QUICK_REFERENCE.md](QUICK_REFERENCE.md) - クイックリファレンス
- [ASYNC_PROMPT_ISSUE.md](ASYNC_PROMPT_ISSUE.md) - async prompt問題
- [CLAUDE.md](../CLAUDE.md) - AI向けガイドライン

---

## 🔴 元のconfig.fishの問題点

### 問題1: conf.d/ の二重読み込み
```fish
# ❌ 元のconfig.fish（最後の部分）
# 12. LOAD CUSTOM CONFIGS (最後に読み込む)
if test -d $XDG_CONFIG_HOME/fish/conf.d
    for conf in $XDG_CONFIG_HOME/fish/conf.d/*.fish
        if test -f $conf
            source $conf
        end
    end
end
```

**問題：**
- Fishは自動的に `conf.d/` を読み込む
- config.fishで再度読み込むと**二重読み込み**になる
- conf.d/内で `fish_prompt` を定義すると、それが2回実行される

**影響：**
- プロンプトが壊れる
- 意図しない動作が発生する

---

### 問題2: Starshipとlocal.fishの読み込み順序
```fish
# ❌ 元のconfig.fish（最後の部分）
# 10. TOOL INTEGRATIONS
if type -q starship
    starship init fish | source
end

# 12. LOAD CUSTOM CONFIGS
if test -f $XDG_CONFIG_HOME/fish/local.fish
    source $XDG_CONFIG_HOME/fish/local.fish
end
```

**問題：**
- Starshipを初期化した**後**に local.fish を読み込んでいる
- local.fish で `fish_prompt` を定義すると、Starshipが上書きされる

**影響：**
- Starshipのプロンプトが表示されない
- local.fishのプロンプト定義に問題があると、エラーが表示される

---

## ✅ 修正版config.fishの改善点

### 改善1: conf.d/ の手動読み込みを削除
```fish
# ✅ 修正版config.fish
# conf.d/ の手動読み込みを完全に削除
# Fishが自動的に読み込むため不要
```

**メリット：**
- 二重読み込みがなくなる
- シンプルで予測可能な動作

---

### 改善2: 読み込み順序の最適化
```fish
# ✅ 修正版config.fish
# 11. TOOL INTEGRATIONS (local.fishより前に読み込む)
mise activate fish | source
zoxide init fish | source
# ... その他のツール

# 12. LOAD LOCAL CONFIG (Starshipより前に)
if test -f $XDG_CONFIG_HOME/fish/local.fish
    source $XDG_CONFIG_HOME/fish/local.fish
end

# 13. STARSHIP PROMPT (必ず最後に初期化)
if type -q starship
    starship init fish | source
end
```

**メリット：**
- Starshipが最後に初期化されるため、確実にプロンプトを制御できる
- local.fishでStarshipより前に環境変数などを設定できる
- 予測可能な動作

---

### 改善3: 明確な注意書き
```fish
# ✅ 修正版config.fish（最後の部分）
# ═══════════════════════════════════════════════════════════════════════════
# 注意事項
# ═══════════════════════════════════════════════════════════════════════════
# 1. conf.d/ は Fish が自動的に読み込むため、ここで手動読み込みはしない
# 2. local.fish で fish_prompt を定義しないこと（Starshipと競合）
# 3. functions/fish_prompt.fish は削除すること（Starshipと競合）
# 4. Starshipの初期化は必ず最後に行うこと
```

**メリット：**
- 将来の混乱を防ぐ
- ベストプラクティスが明確

---

## 📋 変更点まとめ

| 項目 | 元のconfig.fish | 修正版config.fish |
|------|----------------|-------------------|
| conf.d/の読み込み | 手動で読み込み（二重読み込み） | 削除（自動読み込みに任せる） |
| local.fishのタイミング | Starship初期化の後 | Starship初期化の前 |
| Starshipの位置 | セクション10 | セクション13（最後） |
| 注意書き | なし | 詳細な注意事項を追加 |
| セクション構成 | 12セクション | 13セクション（明確化） |

---

## 🎯 あなたの環境で見つかった問題

### 現在の状況
1. ✅ `functions/fish_prompt.fish` は存在しない（良好）
2. ✅ `functions/fish_right_prompt.fish` は存在しない（良好）
3. ⚠️ `conf.d/__async_prompt.fish` に `fish_prompt` イベントハンドラーがある
4. ✅ `local.fish` は存在しないか、fish_promptを定義していない

### conf.d/__async_prompt.fish について

このファイルは async prompt プラグインで、以下の処理を行っています：
- `--on-event fish_prompt` でイベントをフック
- fish_promptとfish_right_promptを非同期に処理

**重要：** このファイルは直接 `fish_prompt` 関数を定義していませんが、イベントをフックしています。通常、Starshipと共存できますが、問題が発生する場合は以下を試してください：

```fish
# async promptを無効化する場合
set -g async_prompt_enable 0
```

または、ファイルをリネームして一時的に無効化：
```fish
mv ~/.config/fish/conf.d/__async_prompt.fish \
   ~/.config/fish/conf.d/__async_prompt.fish.disabled
```

---

## 🔧 推奨される次のステップ

### 1. Fishを再起動
```fish
exec fish
```

### 2. プロンプトの動作確認
正常なプロンプトが表示されることを確認

### 3. 問題が続く場合
```fish
# 診断スクリプトを実行
fish ~/.config/fish/test_config.fish

# async promptを無効化してテスト
set -g async_prompt_enable 0
exec fish
```

---

## 💡 ベストプラクティス

### Starshipを使う場合

**✅ やるべきこと：**
- config.fishの**最後**でStarshipを初期化
- Starshipの設定は `~/.config/starship.toml` で行う
- プロンプトのカスタマイズはStarshipに任せる

**❌ やってはいけないこと：**
- `fish_prompt` を定義しない（どこにも！）
- Starship初期化後に設定ファイルを読み込まない
- functions/fish_prompt.fish を作成しない

### カスタムプロンプトを使う場合

**✅ やるべきこと：**
- `~/.config/fish/functions/fish_prompt.fish` に定義
- シンプルで予測可能なコードを書く
- Starshipの初期化は削除

**❌ やってはいけないこと：**
- 複数の場所で定義しない
- conf.d/で定義しない（functions/で定義すること）
- デバッグ用のコードを残さない

---

## 🔍 デバッグ方法

### プロンプトが壊れた時
```fish
# 1. 現在のfish_prompt関数を確認
functions fish_prompt

# 2. fish_promptがどこで定義されているか確認
functions --details fish_prompt

# 3. 関数をリセット
functions -e fish_prompt

# 4. Fishを再起動
exec fish
```

### 設定を段階的に読み込む
```fish
# 設定なしで起動
fish --no-config

# 1つずつ機能を有効化してテスト
fish -c "source ~/.config/fish/config.fish"
```

---

## 📚 参考資料

- [Fish Shell 公式ドキュメント - 設定ファイル](https://fishshell.com/docs/current/language.html#configuration)
- [Fish Shell 公式ドキュメント - プロンプト](https://fishshell.com/docs/current/cmds/fish_prompt.html)
- [Starship 公式ドキュメント](https://starship.rs/)

---

## ✅ チェックリスト

修正後、以下を確認：

- [x] config.fishを修正版に更新（完了）
- [ ] `exec fish` で再起動
- [ ] プロンプトが正常に表示される
- [ ] `<EMPTY>` や行番号が表示されない
- [ ] `functions/fish_prompt.fish` が存在しない
- [ ] `functions/fish_right_prompt.fish` が存在しない
- [ ] conf.d/のファイルで `fish_prompt` 関数を定義していない
- [ ] local.fishで `fish_prompt` 関数を定義していない
- [ ] Starshipの初期化が config.fish の最後にある
