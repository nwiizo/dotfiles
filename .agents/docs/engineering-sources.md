# 設計方針の参考資料

スキルの由来や適用範囲を保守するときに読む。通常の実装では、各スキルに記載した
判断基準と手順を使う。本文はnwiizoの作業方針に合わせて再構成しており、外部の著者の
主張をそのまま採用したものでも、元の概念を独自に発案したとするものでもない。

## 判断、仕様、引継ぎ

2026-10-27に確認したAddy Osmaniの論考・公開スキルを参考にした。

| 参照資料 | この環境での使い方 |
|---|---|
| [Intent Debt（2026-06-05）](https://addyosmani.com/blog/intent-debt/)、[Comprehension Debt（2026-03-14）](https://addyosmani.com/blog/comprehension-debt/) | 重要な理由を記録し、検証結果と処理の理解を区別する。コードから過去の意図を創作せず、研究の紹介から利用者の理解力を推測しない |
| [Own the Outer Loop（2026-07-15）](https://addyosmani.com/blog/own-the-outer-loop/) | 実装の証拠と採用・公開の判断を分ける。許可済みの実装は進め、操作ごとの再承認は増やさない |
| [The Good Spec（2026-01-13）](https://addyosmani.com/blog/good-spec/) | 利用者の操作と検証可能な結果から作業を分ける。固定の仕様書や段階ごとの承認を必須にしない |
| [Context Engineering（2026-09-05）](https://github.com/addyosmani/agent-skills/blob/a1c9bd627c38ac46630c4cdf0399c6985fb83f27/skills/context-engineering/SKILL.md) | 再開時に照合できる状態・根拠・失敗を渡す。固定トークン数で作業を分断しない |
| [Source-Driven Development（2026-07-21）](https://github.com/addyosmani/agent-skills/blob/6681f80a1141b07377272649d9a3b2b041551d00/skills/source-driven-development/SKILL.md)、[Doubt-Driven Development（2026-05-07）](https://github.com/addyosmani/agent-skills/blob/97e12d03e787fb5e68d313c693f080173027ffe3/skills/doubt-driven-development/SKILL.md) | 対象版の根拠と反例を照合する。全判断への引用や固定回数の独立レビューを要求しない |

## 継続作業と測定

同日、次の実装・資料も確認した。更新日だけでなく、採用する考え方が本文にあることを確認している。

| 参照資料 | この環境での使い方 |
|---|---|
| [Factory（2026-08-18）](https://github.com/addyosmani/factory/blob/e340d991f152c0549c0f4c88e99a3319d3b8241a/template/.claude/skills/factory-implement/SKILL.md) | レビュー待ち、再開可能な記録、必須検証の欠損を扱う。件数・変更量・再試行数の固定値、既存テストの編集禁止は採用しない |
| [agent-house（2026-06-20）](https://github.com/addyosmani/agent-house/blob/dc29aa52b40d1830ba11212e333e7dacd3622257/src/audit/audits/parallelizable.ts) | 経過時間と費用を調べる。同じ親spanだけでは並列化可能とせず、入出力・副作用を確認する |
| [Agent Engineer 第9章（2026-07-16版）](https://github.com/addyosmani/agent-engineer/blob/57522790c1c3d8120d376791f1610ffe7682e027/09-evaluating-and-testing-agents/README.md) | 成果物と実行過程を分けて評価する。同じ結果に至る異なる有効な手順も認める。章の追加は2026-03-19 |
| [Web Quality Skills（2026-08-24）](https://github.com/addyosmani/web-quality-skills/blob/c6b06ad1285cd6b129b58455b2eec96ab6b67fa7/skills/performance/SKILL.md) | 実ユーザー計測、検証環境での測定、ソースからの仮説を区別する。固定スコアや特定MCPの導入は要求しない |

## 役割の分担とレビュー

2026-10-27に本文とファイルの更新履歴を確認した。スキルの追加に限らず、共通ルールと
Claude/Codex両方の計画役・レビュー役へ反映している。

| 参照資料 | この環境での使い方 |
|---|---|
| [Orchestration Patterns（2026-04-20版）](https://github.com/addyosmani/agent-skills/blob/0bf7398e0d2d6180db4d7f6da916cd8f84c10cd1/references/orchestration-patterns.md) | 許可された委譲に担当範囲・依存・検証を渡す。ファイルが別でも共有状態を調べ、結果の統合は呼び出し側が担う。自動的な増員や役割からの再委譲は追加しない |
| [Code Reviewer（2026-10-13版）](https://github.com/addyosmani/agent-skills/blob/2bdbe1f5a69e97bed1bb2d37eec41230216313d3/agents/code-reviewer.md) | 要求と利用側からテストを読む。変更したテストの成功だけで回帰を見逃さず、影響と根拠で優先順位を付ける。定型の称賛や空の節は要求しない |
| [Definition of Done（2026-06-22追加）](https://github.com/addyosmani/agent-skills/blob/b89a675b4d4c05a5ae83dbda46491dc99e6c7202/references/definition-of-done.md) | 個別の受入条件と共通の品質要件を区別する。重要な不足は総合点で相殺せず、未確認と不具合を分ける。すべての変更への固定テスト・再承認は追加しない |

## 配布・操作権限・検証基準

2026-10-27に以下の本文と2026年の実質的な改訂を確認した。CLI・Rust・インフラ運用へ
適用範囲を絞り、既存スキルへ統合した。公開の準備と実行は `home-release-readiness` が受け持つ。

| 参照資料 | この環境での使い方 |
|---|---|
| [Shipping and Launch（2026-10-03版）](https://github.com/addyosmani/agent-skills/blob/a31135a26d4adbfb0687544f0bd736a73163e78a/skills/shipping-and-launch/SKILL.md) | 検証した成果物と配布物の一致、公開先の状態、保存データを含む復旧を確認する。固定のcanary割合・待機時間・エラーバジェット基準、全機能へのflagは採用しない。10月2日の復旧コマンド訂正も確認 |
| [Security and Hardening（2026-09-20版）](https://github.com/addyosmani/agent-skills/blob/d1463fd0d6675c6e145d9c57802d70faf84d1f51/skills/security-and-hardening/SKILL.md)と同skillの補助資料 | 値の入手経路より書ける主体を見て、削除対象・所有の証拠・確認後の競合を調べる。Rust APIの保護範囲は公式資料で照合。Web専用の固定設定や許可済み作業への再承認は追加しない |
| [Constraint-Driven Development（2026-08-28改訂）](https://github.com/addyosmani/agent-skills/blob/4be4bb7c03e168a17903639f54c40b64ddc02e78/skills/constraint-driven-development/SKILL.md) | CI高速化では基準の変更も比較し、必要な検出能力を残す。固定のカバレッジ・所要秒数、CONSTRAINTS.md新設、ツールの一括導入は要求しない。測定値を合否基準へ移す前にばらつきを確認する |

## 継続運用・Web品質・ツール設計の補足

同日に次の箇所を追加で読み、既存手順との差分を確認した。資料全体やコード例を丸ごと
導入せず、実際の操作・失敗・権限に結び付く部分を選んでいる。

| 参照資料 | この環境での使い方 |
|---|---|
| [Factoryの共有手順（2026-08-18）](https://github.com/addyosmani/factory/blob/0863128ef838de316faca81b862aa553d8e9b9f9/template/docs/factory/CONTRACT.md)、[検証スクリプト](https://github.com/addyosmani/factory/blob/937b9fb70efceddfcf5e908044ae98656d7b54c0/template/.factory/scripts/prove-test.sh) | 実行ごとの記録と結果不明時の照合を作業キューへ追加。スクリプトは非ゼロ終了をPROVENとするため、その判定は採用しない。隔離した環境で意図した動作の失敗かを見る既存TDD方針を使う。既存テスト変更の一律禁止や固定人数の検証も導入しない |
| [Web Quality Audit](https://github.com/addyosmani/web-quality-skills/blob/c6b06ad1285cd6b129b58455b2eec96ab6b67fa7/skills/web-quality-audit/SKILL.md)、[Accessibility（2026-08-24版）](https://github.com/addyosmani/web-quality-skills/blob/c6b06ad1285cd6b129b58455b2eec96ab6b67fa7/skills/accessibility/SKILL.md) | 操作・実表示・支援技術向け情報から該当ソースへたどる。自動点数を適合判定にせず、固定の重要度表やCSS数値を転記しない。dialogとフォームはWAI一次資料へ照合し、ログイン状態や入力を壊す再読込にも配慮する |
| [Agent Engineer 第3章](https://github.com/addyosmani/agent-engineer/blob/57522790c1c3d8120d376791f1610ffe7682e027/03-tools-giving-agents-hands/README.md)、[第11章（2026-07-16版）](https://github.com/addyosmani/agent-engineer/blob/57522790c1c3d8120d376791f1610ffe7682e027/11-from-prototype-to-production/README.md) | ツールの選択、入力、結果、エラーを作業単位で設計する。空結果と部分結果・失敗、書き込み後の結果不明を区別する。キャッシュは権限と鮮度を含めて評価し、運用の失敗を回帰課題へ戻す。固定のツール数、費用・時間目標、モデル用途表、成功率による安全保証は採用しない |

Web品質は2026-10-27に追加照合。上記と同じ2026-08-24版の
[SEO](https://github.com/addyosmani/web-quality-skills/blob/c6b06ad1285cd6b129b58455b2eec96ab6b67fa7/skills/seo/SKILL.md)、
[Best Practices](https://github.com/addyosmani/web-quality-skills/blob/c6b06ad1285cd6b129b58455b2eec96ab6b67fa7/skills/best-practices/SKILL.md)、
[Core Web Vitals](https://github.com/addyosmani/web-quality-skills/blob/c6b06ad1285cd6b129b58455b2eec96ab6b67fa7/skills/core-web-vitals/SKILL.md)、
[性能計測手順](https://github.com/addyosmani/web-quality-skills/blob/c6b06ad1285cd6b129b58455b2eec96ab6b67fa7/skills/performance/references/MEASUREMENT.md)を読み、
既存Webレビューの条件付き参照と性能診断へ統合した。別スキル群の一括導入はしていない。
ページ分割のcanonicalを先頭へ寄せる例、Permissions-Policyのmeta設定例、hidden source mapを
非公開とみなす判断は採用せず、Google・MDN・Viteの公式資料で補正。固定の予算、
全リンクの先読み、公開画面かを問わないSEO必須項目も採用しない。各参照に照合先を残した。

## 応答と簡略化

過去の独立した調査メモはここへ集約した。運用手順や測定結果は重複させない。

| 参照資料 | この環境での使い方 |
|---|---|
| [i-have-adhd（2026-09-19確認版）](https://github.com/ayghri/i-have-adhd/tree/b15d0be58f55b33972ba3e39709e0e5208ef30cb) | 結果や次の操作を先に示し、成功と残る失敗を分ける。読者への診断、固定行数、常時フックは採用しない。上流評価には判定不能・退行・未達の項目があり、一般的な効果の証明とは扱わない |
| [Ponytailの確認項目との対応](../skills/nwiizo-coding-style/references/ponytail-coverage.md) | 既存コードから調べ、小さく明瞭に変更する。最新の参照版と取り込み範囲は対応表、操作と測定条件は同スキルの `operations.md` で管理する。短さのために型・検証・要求された機能を落とさない |

これらは設計の参考であり、この環境で効果が実証された普遍的な規則ではない。
現在の技術仕様は対象版の公式資料と実行結果で確認する。出典を更新するときも、
利用者に見える動作、理解・検証・運用の負担にどう影響するかで採否を決める。
