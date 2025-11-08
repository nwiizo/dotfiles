# 🐛 Async Prompt 問題の解決

**解決日:** 2025-11-08
**対応:** `conf.d/__async_prompt.fish` を `.disabled` にリネーム
**ステータス:** ✅ 解決済み

このドキュメントでは、Fish shell 起動時に発生していたプロンプト表示問題と、その解決方法を説明します。

**関連ドキュメント:**
- [README.md](../README.md) - 総合ガイド
- [QUICK_REFERENCE.md](QUICK_REFERENCE.md) - クイックリファレンス
- [CHANGES_EXPLAINED.md](CHANGES_EXPLAINED.md) - 設定変更の詳細

---

## 問題の症状

Fish起動時に以下のような出力が表示される：

```
File: /var/folders/kx/q0v_vzl93g9g7jp0m_7pmdhw0000gn/T/tmp.CpEh63svuB/29507
_fish_right_prompt
<EMPTY>
1
2 programmer-thinking-for-life/docs on  main !?⇡ on ☸ kind-neuvector-test
3 ❯
```

## 原因

`conf.d/__async_prompt.fish` プラグインがStarshipと競合しています。

- async promptは `fish_prompt` と `fish_right_prompt` を非同期処理するためのプラグイン
- Starshipと併用すると、一時ファイルの内容が誤って表示される
- 行番号やファイルパスが表示されるのは、async promptのデバッグ情報

## 解決方法（実施済み）

### ✅ async promptを無効化

```fish
# プラグインを無効化（リネーム）
mv ~/.config/fish/conf.d/__async_prompt.fish \
   ~/.config/fish/conf.d/__async_prompt.fish.disabled
```

**これで解決しました！**

次回のFish起動時から正常なStarshipプロンプトが表示されます。

## 動作確認

```fish
# Fishを再起動
exec fish

# 正常なプロンプトが表示されることを確認
# 以下のような表示になるはずです：
# ~/projects/myapp on  main via 🦀 v1.75.0
# ❯
```

## async promptについて

### async promptとは
- プロンプトの生成を非同期で行うことで、遅いプロンプト（Git情報取得など）を高速化するプラグイン
- しかし、Starship自体が既に非同期処理を実装しているため、併用は不要

### Starshipの利点
- ✅ デフォルトで高速な非同期処理
- ✅ 設定がシンプル（starship.toml）
- ✅ 多機能でカスタマイズ性が高い
- ✅ クロスシェル対応（Fish, Bash, Zsh等）

## もしasync promptを再度有効化したい場合

**非推奨ですが、どうしても必要な場合：**

```fish
# Starshipを無効化
# config.fish の以下の部分をコメントアウト：
# if type -q starship
#     starship init fish | source
# end

# async promptを有効化
mv ~/.config/fish/conf.d/__async_prompt.fish.disabled \
   ~/.config/fish/conf.d/__async_prompt.fish

# カスタムプロンプトを定義
# functions/fish_prompt.fish を作成
```

**しかし、Starshipの使用を強く推奨します。**

## トラブルシューティング

### 問題が再発した場合

```fish
# 1. async promptが有効化されていないか確認
ls ~/.config/fish/conf.d/__async_prompt.fish*

# 2. 有効化されている場合は再度無効化
mv ~/.config/fish/conf.d/__async_prompt.fish \
   ~/.config/fish/conf.d/__async_prompt.fish.disabled

# 3. 関数をクリア
functions -e fish_prompt fish_right_prompt

# 4. Fishを再起動
exec fish
```

### プロンプトが表示されない場合

```fish
# Starshipがインストールされているか確認
type -q starship && echo "Starship installed" || echo "Starship NOT installed"

# インストールされていない場合
brew install starship

# config.fishを確認（最後にStarship初期化があるか）
tail -20 ~/.config/fish/config.fish
```

## まとめ

- ✅ **async promptを無効化** - Starshipと競合するため
- ✅ **Starshipを使用** - 高速で安定した非同期プロンプト
- ✅ **シンプルな構成** - プロンプト関連の競合を避ける

**現在の推奨構成：**
- Starship: プロンプト表示
- conf.d/: プラグイン（async prompt以外）
- functions/: カスタム関数（プロンプト関数以外）

---

**解決日: 2025-11-08**
**対応: async promptを無効化（.disabled にリネーム）**
