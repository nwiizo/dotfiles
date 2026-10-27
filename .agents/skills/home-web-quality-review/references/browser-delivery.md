# ブラウザーと配信の確認

console・networkの失敗、対応ブラウザー、配信設定が問題に関係するときに読む。
利用者の操作と発生時刻から関係する記録だけを開き、全通信や機密値をまとめて収集しない。

- consoleの警告・例外と、操作や通信の失敗を対応させる。拡張機能由来の記録をサイトの不具合と
  即断しない。例外を握りつぶしたり、必要なログを消したりして「エラーなし」にしない。
  失敗時に入力が残るか、次の操作が分かるか、再送で二重処理しないかも確認する。
- 配信設定はソースだけでなく実際の応答で確認する。HTTPS、mixed content、MIME、CSPなどを
  問題に応じて調べる。CSPやHSTSを一律に強制せず、対象origin・subdomain・必要な機能と
  互換性を確認する。Lighthouse成功をセキュリティ監査の完了としない。
- Permissions-PolicyはHTTP応答headerと必要なiframeのallow設定で確認する。
  meta http-equivを追加しただけで制限が効いたと扱わない。対象browserの対応と、
  camera等の必要な機能が許可・拒否の各状態でどう動くかを見る。
- source mapの公開意図と配信先を確認する。Viteのhiddenは参照コメントを抑える設定で、
  mapファイルの生成や公開を止めるものではない。非公開が必要なら配布物と公開経路を確認し、
  エラー調査用のアップロード先を分ける。公開自体を一律の不具合とせず、秘密値混入は別に扱う。
- 対応browser・端末はプロジェクトの利用対象から選ぶ。新APIは機能検出と必要なfallbackを
  確認し、特定browserで動くことを全環境の保証にしない。polyfillや第三者scriptは既存の
  配布方式・版管理に合わせ、追加で直る問題と新たな読み込み負担を比較する。

変更後は発生していた操作を再実行し、応答・エラー表示・結果の保存まで確かめる。
非公開URLや認証情報を外部スキャナーへ送らない。HAR等を保存する必要があるときも、
機密情報を除去し、設定リポジトリへログを取り込まない。

2026-10-27に照合した一次資料:
- [Permissions-Policy header](https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/Permissions-Policy)
- [Vite build.sourcemap](https://vite.dev/config/build-options#build-sourcemap)

由来と採用範囲は[設計方針の参考資料](../../../docs/engineering-sources.md)に残す。
