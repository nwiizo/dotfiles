# 公開URLと検索への伝わり方

公開ページの技術的SEOや、検索向けの設定を確認するときに読む。
対象URLと公開意図を先に確認し、管理画面・検証環境の非公開設定を改善対象と取り違えない。

## 応答と描画結果を照合する

1. 最終URL、HTTP status、redirect、robots.txt、meta robotsとX-Robots-Tagを確認する。
   robots.txtによるクロール制御、noindexによる検索登録の制御、認証によるアクセス制御を分ける。
   robots.txtで遮断するとcrawlerがnoindexを読めない場合がある。非公開情報を検索対策だけで守らない。
2. 描画後のtitle・主見出し・description・canonicalを、実際のページ内容と照合する。
   SPAでは初期HTMLと描画後の差も確認し、タグの存在だけで全crawlerが読めるとはしない。
   文字数やh1の個数だけで不合格にせず、ページの内容・階層が伝わるかを見る。
3. 内部リンク、sitemap、canonicalが対象URLを一貫して指すか確認する。
   内容が異なるページ分割をすべて1ページ目へcanonical指定しない。通常は各ページ自身を指す。
   無限スクロールでは後続内容へたどれるURLとリンクを確認する。Googleはrel=prev/nextを
   ページ分割の判定に使わないため、それだけで到達できると判断しない。
4. 構造化データは描画された事実と一致させ、構文、対象種別の要件、実際の検索表示を区別する。
   修正後は同じURLと状態で再確認する。検索側の再取得・登録・順位変化は別の結果として残す。

HTTP情報は対象URLに必要な範囲で取得し、cookie・認証header・個人情報をレポートへ含めない。
URLを外部の診断サービスへ送る場合は、公開URLかを確認する。私有URLや認証情報を渡さない。
Search Consoleへの権限がなければ、確認できた配信設定と未確認の検索側状態を分ける。

## 人とエージェントが理解できることを優先する

意味のあるHTML、操作名、読み取れる内容を先に整える。LighthouseのAgentic Browsing等の
診断結果、検索への登録、AI製品による取得・引用は別の結果であり、互いを保証しない。
llms.txtやWebMCPを点数のために追加しない。依頼や具体的な利用先があるときに対象仕様を調べる。
検索用・学習用・利用者の指示による取得用のbotを一括で扱わず、必要な製品の現行資料を確認する。

2026-10-27に照合した一次資料:
- [Googleのnoindex](https://developers.google.com/search/docs/crawling-indexing/block-indexing)
- [ページ分割と段階的な読み込み](https://developers.google.com/search/docs/specialty/ecommerce/pagination-and-incremental-page-loading)

由来と採用範囲は[設計方針の参考資料](../../../docs/engineering-sources.md)に残す。
