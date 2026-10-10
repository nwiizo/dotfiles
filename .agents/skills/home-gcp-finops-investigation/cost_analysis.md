# GCP Cost Analysis Learnings

Billing Export (BigQuery)、FinOps Hub、Cost Table / Reports の読み解き罠。

## Billing Export の2種類

- **Standard export**: サービス・SKU・ラベル単位の集計。リソース単位の紐付けは粗い
- **Detailed export**: リソース単位の行もあり、どの VM / どの Disk がコストを出しているか追える
- 分析のためには Detailed 必須。Standard だけだと「どの VM が高い」と特定できない
- 設定後のデータ反映は最大1日ラグあり、過去データは含まれない

## BigQuery クエリの基礎構造

- 料金テーブル: `project.billing_export_dataset.gcp_billing_export_resource_v1_<BILLING_ACCOUNT_ID>`（Detailed の場合）
- 期間指定は `usage_start_time` か `export_time` を明示。`_PARTITIONTIME` フィルタも重要（スキャン量削減）
- コスト算出は `SUM(cost) + SUM((SELECT SUM(amount) FROM UNNEST(credits)))` で実質コスト
- credits は SUD / CUD / Promotional / Commitment Use などを含み、**マイナス値**として計上される
- クレジット除外を忘れると見かけ上のコストが実質より2〜3割高く出る

## 2026 年の仕様変更の影響

- Spend-Based CUD の計上方式が 2026 年から変わった: SKU 価格に**直接適用**、credit offset ではなくなった
- 過去データと新データで計算式が変わるので、長期トレンドで**歴史的データは credit、最新は SKU 価格**が混在
- レポートで「CUD 効果」を語るなら期間で区切って説明する
- 対象サービス拡大: Cloud Run / H3 / M シリーズ / メモリ最適化 VM が Spend-Based CUD 対象化

## Reservation ラベル（2025-09-17 以降）

- Billing Export の行に reservation name がラベルとして付与される
- **使用されているリザベーション** と **空きリザベーション（idle）** を区別できる
- `system_labels` 配下に `compute.googleapis.com/reservation_name` などのキーが入る
- 購入済みだが使われていないリザベーションの検出はこれで可能

## FinOps Hub UI

- Console UI で BigQuery クエリを書かなくても主要な分析が可能
- Recommender 推奨事項、CUD カバレッジ、異常検知も一覧化
- ただし細かいフィルタやグループ化は BigQuery の方が柔軟
- 新機能（Idle Reservation など）は FinOps Hub 経由で先行提供される傾向

## ラベル/タグの取り扱い

- リソースに付与されたラベル（小文字、`:` 区切り）は Billing Export で `labels` 配列として出る
- 継承ルール: プロジェクトラベル → リソースラベル（継承されないことに注意、VM 作成時に明示指定必要）
- ラベル未設定リソースは `labels IS NULL` でしか絞れない。ラベル戦略の導入前データは完全には按分不可
- 組織ポリシーで必須ラベルを強制できる（Organization Policy Service）が、既存リソースには遡及しない

## 数値の分母混在を避ける

- 月平均（過去N ヶ月）: 長期トレンド、外部共有の基準
- 月末確定値: 担当者報告の基準
- 進行中月の推定（N日分 × 30/N）: 推定値であることを明記
- Billing Console の「Cost Breakdown」はデフォルトで進行中月を表示するが、月末予測値か実績かを読み取る

## cost と effective_cost の使い分け

Detailed Billing Export には複数のコスト列がある:

- `cost` — リスト価格ベースの請求発生額（割引前）
- `credits` — SUD / CUD / プロモーションなど、マイナス値で計上
- 実コスト = `cost + SUM(credits.amount)`
- 2026 年からの Spend-Based CUD は credit ではなく SKU 価格に直接適用されるため、`cost` だけでも実コストが出るケースが増えている（過去データと混在に注意）

CUD を「Premium 一括前払い」で買った場合、その前払い額は購入月に一時的に乗る。AWS の Unblended と同じ罠で、購入翌月以降に「コストが下がって見える」。月次推移で議論する際は:

- 短期キャッシュ視点 → `cost + credits` をそのまま見る
- 経済的負担を月平均で見る → 前払いを契約期間で按分して加算した値を併記
- 長期トレンドの比較 → 購入月と非購入月で見え方が違う点を必ず注記

## VM コストが「Compute Engine」で潰れる罠

サービス名 `Compute Engine` の合計だけでは、削減候補の解像度が出ない。Detailed Billing Export の `sku.description` で内訳を見る。代表的な分割軸:

- VM の Hourly（`<machine type> Instance Core/RAM running in <region>`）
- Persistent Disk（`Storage PD Capacity` / `Storage PD SSD Capacity`）
- Snapshot（`Storage PD Snapshot in <multi-region>`）
- License（`Licensing Fee for ...`）
- Public IPv4（`External IP Charge on a <state> VM`）

AWS の `EC2 - Other` と同様、Disk / Snapshot / Public IP が VM 本体と混ざるので分解必須。

## 権限不足時の迂回

- 自プロジェクトだけ Billing Export を確認できて、組織全体が見えない → 組織レベル Billing Account Viewer を依頼
- BigQuery にデータセットはあるが `SELECT` できない → `roles/bigquery.dataViewer` + `roles/bigquery.jobUser` の2つが必要
- Recommender API が叩けない → `roles/recommender.viewer` が別途必要（`roles/viewer` には含まれない）

## BigQuery Editions 予約の読み方（2026-09 追記）

- autoscale は使用した slot ではなく割り当て容量で課金される。通常は 50 slot 単位・最低 60 秒だが、fluid scaling では最低期間が異なる。対象予約の設定と期間中の料金体系を確認する
- 割り当て時間は `RESERVATIONS_TIMELINE_BY_PROJECT.per_second_details.autoscale_current_slots` を秒単位で合計して 3,600 で割る。分単位の `autoscale.current_slots` だけでは分内の変化を落とす。baseline を別に計上し、秒配列が空の区間を欠落させず、Billing Export の同期間・予約・SKU と突き合わせる
- 実使用は `JOBS_TIMELINE_BY_PROJECT.period_slot_ms` を 3,600,000 で割って slot 時間にする。予約を使う全 project を対象にし、割り当てと同じ期間・範囲で比べる。平均利用率が低いだけでは、上限を下げた場合の削減額は確定しない
- `Σ(max(alloc − cap, 0) × 区間秒数) / 3,600 × slot 時間単価` は、観測した容量の上限超過分を切り取る参考試算。上限変更で実行時間や待ち時間が延びるため、これを実現可能な削減額と扱わない。単価は同じ SKU・期間・credit 条件の請求と使用量から求める
- 上限を下げる前に、開始待ち（`start_time − creation_time` の p95）、実行時間、完了期限、同時実行数を確認する。実際の削減額は変更後も同じ処理量を完了した期間の請求と比較する
- SCRIPT 親ジョブは子の使用量を集計した値を含む。親と子の二重計上を防ぐため、使用量集計では親を除く
- 同じ処理の識別は `query_info.query_hashes.normalized_literals`。生成 SQL は hash が多数になるので参照テーブルの組み合わせで束ねる
- 月次の急増は「月 × ワークロード種別（job_id 接頭辞）」の slot と件数を比べる。実行件数が減っても slot が増える場合は、生成 SQL と入力データ量の変化を調べる
- 結果キャッシュはコメント・空白を含む本文一致が必要。毎回変わる実行 ID は label へ移す候補だが、参照テーブルの更新や非決定的関数など、ほかの不使用条件も確認する。特定のヒット率を保証しない

2026-10-10 に集計方法を再確認:
[slot と autoscaling](https://docs.cloud.google.com/bigquery/docs/slots)、
[予約の秒単位データ](https://docs.cloud.google.com/bigquery/docs/information-schema-reservation-timeline)、
[キャッシュの条件](https://docs.cloud.google.com/bigquery/docs/cached-results)。

## 請求の追加確認（2026-09 追記）

- promotional credit で全額相殺の SKU（Network Intelligence Center 等）は cost と credit を分けて記録し、credit 終了時の増加として注記する
- 非本番 project の on-demand Analysis が単月で数十倍になる事故がある。12 か月の単月の山を探し、custom quota を提案する
- 配賦可能な net の割合を測り、credit で net がゼロ・負になる範囲は別に示す。予約の課金ラベルと job label は別物なので、予約費用をワークロードへ按分する場合は JOBS の label と使用 slot 時間を用い、未使用分・ラベル欠落分の扱いを明記する
- 調査クエリの課金バイト合計を証跡に残す
