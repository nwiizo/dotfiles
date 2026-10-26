---
name: home-terraform-change-review
description: Terraformの変更やモジュール分割を、planと利用側の動作からレビューする。再作成、権限、停止、データ移行、復旧への影響を確認したいときに使う。費用分析だけの依頼や実行中の障害対応は対象外。
---

# Terraformの変更と運用への影響

HCLの差分を、何が失われるか、誰が使えなくなるか、どう戻せるかへ結び付ける。
レビュー依頼では指摘と確認手順まで。修正依頼では許可された設定変更と検証を進める。
このスキルの適用だけでは、apply、import、stateの書き換え、実環境のテストは許可されない。

## 変更の根拠を揃える

- 対象のaccount/project、workspace、backend、Terraform/providerのバージョン、
  lockfile、入力変数と、planを生成したコードの版を確認する。秘密値は報告へ出さない。
- 既存のplanが今回の差分と対象環境に対応するか確かめる。古いplan、`-target`、
  `-refresh=false`、不足した権限による観測範囲の制限を、変更がない証拠にしない。
- `fmt`と`validate`は形式や構成の検証。実リソースへの影響は別に確かめる。
  planを作れない場合もコードレビューは進め、分からない影響を明記する。

## planを利用側の動作へ読み替える

| 変化 | 確認する影響 |
| --- | --- |
| delete / replace | 保存データ、名前やID、接続先、停止時間、復旧に使えるバックアップ |
| update in-place | IAMの許可範囲、通信経路、アプリが依存する設定や値の変化 |
| create | 接続・権限・クォータ、旧リソースと併存する期間と費用 |
| unknown / computed | applyまで確定しない値と、それを使う設定・利用者への影響 |

同じアクションでも影響はproviderと属性で異なる。planの表示と利用側の根拠を対応させ、
未確認の停止時間や費用を断定しない。再作成がなくても安全とは限らない。
`create_before_destroy`だけでは名前の競合、二重稼働、データ移行は解決しない。

## モジュール分割と復旧

- アドレスの移動と実リソースの交換を区別する。対応バージョンなら`moved`ブロックで
  旧→新の対応をコードに残し、`count`/`for_each`では各インスタンスの対応も確認する。
  モジュール化だけの変更で、意図しないdestroy/createや属性変更が出ていないかplanで確かめる。
- 移動宣言は未移行の利用者にも必要になる。手元で移行済みという理由だけで削除しない。
- 復旧では、設定の差し戻し、stateの整合、データの復元、利用側の接続切替を分ける。
  Gitのrevertやstateのバックアップだけで、削除された実データが戻るとは扱わない。

## 検証と報告

planはproviderやdata sourceを実行し、外部サービスへ接続することがある。
既存の認証・検証手順と依頼範囲に従う。`terraform test`は既定のrunがapplyとなり得るため、
実行前にrun、setup、providerを読む。planモードやmockでも、その検証範囲を超えて
実環境での移行や復旧が確認済みとは報告しない。

`plan -detailed-exitcode`の0は差分なし、1はエラー、2は差分あり。
生成失敗や未確定値を「変更なし」にまとめない。保存planとJSON/stateには秘密値が
含まれ得るため、全体をコメントやリポジトリへ貼らず、必要な属性だけを秘匿して示す。

報告は対象リソース、確認できた変化、利用側への影響、必要な修正や次の検証を結び付ける。
実行も依頼されている場合は、適用するplanと対象を最終確認し、既存の承認範囲を守る。

## 仕様を確かめるときの参照先

- [planの動作と終了コード](https://developer.hashicorp.com/terraform/cli/commands/plan)
- [アドレス移動とmovedブロック](https://developer.hashicorp.com/terraform/language/modules/develop/refactoring)
- [showのJSONと秘密値](https://developer.hashicorp.com/terraform/cli/commands/show)
- [testの実行とリソースの後片付け](https://developer.hashicorp.com/terraform/cli/commands/test)
