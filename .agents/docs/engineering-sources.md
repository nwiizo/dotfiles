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

これらは設計の参考であり、この環境で効果が実証された普遍的な規則ではない。
現在の技術仕様は対象版の公式資料と実行結果で確認する。出典を更新するときも、
利用者に見える動作、理解・検証・運用の負担にどう影響するかで採否を決める。
