# GCP Auth Learnings

非対話環境での Application Default Credentials (ADC)、サービスアカウント impersonation、Workload Identity Federation の罠。

## ADC の非対話突破

- `gcloud auth application-default login` はブラウザ対話が必要 → 非対話環境では失敗
- 非対話環境での選択肢:
  1. サービスアカウント鍵ファイル（`GOOGLE_APPLICATION_CREDENTIALS` 環境変数）
  2. ユーザー側で対話シェルで鍵を取得し、Claude が読む
  3. gcloud auth print-access-token で短命トークンを一時的に取得

## Impersonation パターン

- 組織ポリシーで SA 鍵のダウンロードが禁じられている場合、`gcloud auth application-default login --impersonate-service-account=SA_EMAIL` で impersonation
- 必要権限: `roles/iam.serviceAccountTokenCreator` を対象 SA に対して自ユーザーに付与
- `gcloud config set auth/impersonate_service_account` でも代替可
- トークンの有効期限はデフォルト1時間

## 組織・フォルダ・プロジェクト階層

- 認証は1つのプロジェクト/ユーザーで確立できても、調査対象が別プロジェクト/組織の場合は別途権限が必要
- Billing Account は組織とは独立の管理単位。Billing Account Viewer 権限は別レイヤー
- `gcloud projects list` で見えない ≠ 権限ゼロ。Folder 階層で区切られていることがある
- クロスプロジェクト調査では `--project` を都度明示、または Config configurations で切り替え

## よくあるエラーパターン

- `PERMISSION_DENIED: The caller does not have permission` — IAM ポリシー未付与、または組織ポリシーで拒否
- `RESOURCE_EXHAUSTED` — プロジェクトの API クォータ超過、大量 describe 時に注意
- `FAILED_PRECONDITION: Billing must be enabled` — 対象プロジェクトに Billing Account が紐づいていない
- トークン切れの症状は `UNAUTHENTICATED` と `invalid_grant` の両方あり得る

## Workload Identity Federation（WIF）

- GitHub Actions / CI から GCP への認証は WIF で SA 鍵レス化が 2026 のベストプラクティス
- Provider + Pool 設定を先に作り、`roles/iam.workloadIdentityUser` で CI の OIDC トークンを特定 SA にマップ
- WIF 経由でも `print-access-token` でトークン取得できれば Claude の bash で利用可能

## コピペ時の罠

- サービスアカウント鍵 JSON はそのまま ADC としては使えない。`GOOGLE_APPLICATION_CREDENTIALS=/path/to/key.json` で環境変数にパスを渡す
- 鍵 JSON の改行コード（CRLF/LF）がエディタで壊れると無効になる
- 鍵ファイルのパーミッションは `chmod 600`、gcloud が警告を出すことがある

## 最小権限で調査する場合

- Viewer ロール相当の組合せ:
  - `roles/viewer`（全リソース read）— 粒度が粗い
  - `roles/billing.viewer`（Billing Account）
  - `roles/recommender.viewer`（Active Assist）
  - `roles/bigquery.dataViewer` + `roles/bigquery.jobUser`（Billing Export 分析）
- より粒度細かくするなら Custom Role を作成

## PAM 経由の一時権限（2026-09 追記）

- entitlement（申請可能な設定）と grant（申請・承認・有効化を管理する単位）は別。grant の ACTIVE と対象 API の成功をそれぞれ確認する。反映待ちの PERMISSION_DENIED は間隔を置いて再確認し、続く場合は対象とロールを調べる。固定の待ち時間で有効化を保証しない
- 既存 grant の状態と期限を確認してから、entitlement の上限内で調査に必要な期間を申請する。SCHEDULED は予約時刻待ちの状態で、すべての grant が通る有効化待ちではない
- `roles/bigquery.resourceViewer` は `bigquery.jobs.listAll` を含み、`INFORMATION_SCHEMA.JOBS.query`（他者の SQL 本文）に到達できる。集計は hash・真偽値・件数に限定し、本文閲覧は利用者の明示判断があるときだけ、保存せずに行う
- 非対話では `Reauthentication failed. cannot prompt during non-interactive execution.` が毎セッション起き得る。`gcloud auth list` の ACTIVE 表示は API 認証の有効性を示さない。最初に軽い実 API を叩いて確かめ、失敗したら利用者に `gcloud auth login` を依頼する
- Cloud Billing Catalog API は quota project で API 有効化が必要（403）。調査で API を有効化しない

参照: [PAM のアクセス申請](https://docs.cloud.google.com/iam/docs/pam-request-temporary-elevated-access)、
[JOBS の必要権限](https://docs.cloud.google.com/bigquery/docs/information-schema-jobs)。
