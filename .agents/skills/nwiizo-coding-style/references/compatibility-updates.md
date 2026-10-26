# 利用側の互換性と依存更新

公開API・CLI・依存を変更する場合に使う。変更しない内部処理へ一律に検証を増やさない。
2026-10-27にCargoとGitHubの公式資料を確認。コマンドや対応機能は対象のtoolchainと
運用方針に合わせ、固定した「最新バージョン表」を更新判断の根拠にしない。

## 利用者が観測する動作を確認する

- 型とシグネチャだけでなく、既存の呼び出し方、結果の意味、失敗時の動作、順序、
  既定値を調べる。文書にない挙動への依存も、実際の呼び出し元と再現例から判断する。
- Rustの全フィールドが公開されたstructへの追加は、`Option`型でも既存のstruct literalを
  壊す。enumのvariant追加、trait境界の変更、後付けの`non_exhaustive`も影響を確認する。
  「追加だから互換」という分類を型や形式を跨いで適用しない。
- CLIは引数、設定と環境変数の優先順位、stdout/stderr、終了コード、JSONなどの
  機械向け出力、非対話時の動作を必要な範囲で確かめる。結果へ診断文を混ぜない。
- 代表的な外部利用コードや既存スクリプトを検証例にする。workspace内部だけでは、
  非公開項目の扱いやfeature統合により利用側の失敗が隠れることがある。
  packageの内容を変える場合は配布される成果物も確認し、開発checkoutの成功と分ける。
- 意図的な非互換変更なら、影響する利用者、具体的な移行例、対応期間や公開方針を示す。
  必要な更新を無条件に禁止せず、依頼なしに破壊的リリースやMSRV変更へ進まない。

## 必要な依存だけを更新する

セキュリティ修正、通常の更新、機能導入を区別する。修正版、release notes、MSRV、
features、ライセンス、実際に使うAPIを確認して、要求を満たす更新範囲を選ぶ。
同時更新が必要な組合せはまとめ、無関係な更新やtoolchain変更を混ぜない。
脆弱性は直接依存だけでなく、推移的依存、build依存、proc macroへの経路も確認する。

Rustでは対象workspace、target、feature条件に合う`cargo tree`で逆依存と有効化経路を
調べる。必要なら`-i`、`-e features`、`--workspace`を使う。表示したグラフと実ビルドが
常に同一とは限らない。複数版の併存も、見つけただけで一括統合の理由にはしない。
更新は対象を指定した`cargo update`など既存の方法で行い、manifestとlockfileの差分を
確認する。lockfileを消して全依存を再解決することを初手にしない。

更新後の確認では、宣言したMSRV、提供するfeature構成、対象OSと、修正した問題の経路を
選ぶ。最新stableでの成功、`--all-features`一回、アドバイザリの消失だけで全対応範囲を
確認済みとはしない。既存CIと利用側の動作を照合し、実施していない組合せは明記する。

Dependabot等の更新グループはレビューと検証の単位として選ぶ。PR数を減らすためだけに
影響の異なる更新をまとめない。Dependabotのversion updatesとsecurity updatesでは
グループの対象が別なので、設定と実際のPRを確認する。bot作成やgreen CIは自動マージの
許可にも、実行時の安全性の証明にもならない。

## 仕様を確かめる参照先

- [Cargoの互換性分類](https://doc.rust-lang.org/cargo/reference/semver.html)
- [rust-versionの意味と検証](https://doc.rust-lang.org/cargo/reference/rust-version.html)
- [cargo treeの範囲と制限](https://doc.rust-lang.org/cargo/commands/cargo-tree.html)、[cargo update](https://doc.rust-lang.org/cargo/commands/cargo-update.html)
- [Dependabotの現行設定](https://docs.github.com/en/code-security/reference/supply-chain-security/dependabot-options-reference)
