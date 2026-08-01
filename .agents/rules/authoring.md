---
paths:
  - "**/AGENTS.md"
  - "**/CLAUDE.md"
  - "**/SKILL.md"
  - "**/.agents/**/*"
  - "**/.claude/**/*"
  - "**/.codex/**/*"
  - "**/.claude-plugin/**/*"
  - "**/.codex-plugin/**/*"
---

# Authoring Policy

- 基盤モデルが既知の汎用知識は書かない（言語の基本、doc template、一般的ベストプラクティス）
- **制約・好み・ドメイン知識**のみ記載する
- agents/, skills/ は `home-` prefix でグローバルとプロジェクト固有を区別
- Claude Code と Codex の両方で使う persona は `.agents/agents/<name>.md` と `.agents/codex/agents/<name>.toml` を同名で保つ
- 読み取り専用 persona は prose だけに頼らず、Claude Code の `permissionMode: plan` と Codex の `sandbox_mode = "read-only"` を対応させる。Claude で Bash を許可する場合も診断用途に限定する
- 常時必要な事実・コマンド・制約は AGENTS.md / CLAUDE.md、path 固有の規則は rules、反復手順・参照資料は skills に置く
- CLAUDE.md の `@path` import は常時contextへ入るため、遅延ロード目的で rules / skills の代わりに使わない
- 厳密に強制する処理を prose rule にせず、hook・設定・検証 script を使う
- 1 skill は1つのjobと明確なinput / outputに絞り、determinismや外部toolが必要な場合だけscriptを足す
- SKILL.md は `name` と `description` を必須とし、用途・trigger・対象外を description の先頭へ簡潔に書く
- 共有 skill の共通核はこの2項目にする。Claude の実行制御は SKILL.md frontmatter、Codex の表示・依存・暗黙起動 policy は `agents/openai.yaml` に置く
- side effect を明示起動だけに限定する skill は、Claude の `disable-model-invocation: true` と Codex の `policy.allow_implicit_invocation: false` を両方設定する
- SKILL.md 本文は命令形・目安100行、上限500行にし、variant 固有の詳細は直接リンクした `references/` へ分岐する
- 参照を作るときは「いつ読むか」を SKILL.md に明記し、同じ説明を本文と参照へ重複させない
- `agents/openai.yaml` に `interface` がある skill は、表示名・説明・default prompt が SKILL.md と一致するか更新時に確認する。policy だけの metadata に interface 項目を足さない
- skill description は明示起動・暗黙起動・対象外の代表 prompt で forward-test する
- portable frontmatter だけの skill は、現在の client が提供する `skill-creator` の validator で検証する。リポジトリ相対に validator の場所を仮定しない
- validator が対応しない client 拡張を検証のために削除せず、対象 client とリポジトリ固有の audit で確認する
