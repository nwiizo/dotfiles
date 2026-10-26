# Asideで画面と操作を確認する

`aside-browser` と `rtk proxy aside guide` を先に読む。以下は品質確認への適用方法であり、
CLI全体の説明の複製ではない。バージョンが変わったら導入済みのguideとhelpを確認する。

## 操作経路を選ぶ

- ブラウザー作業をAsideのエージェントへ任せる場合は `rtk proxy aside exec` を使う。
  対象URL・profile、確認する操作、変更や送信の可否、返す証拠を渡す。
  許可されていない再委譲、ログイン切替、投稿まで依頼を広げない。
- DOM、focus、操作結果を直接検証する場合は `rtk proxy aside guide repl` を読み、
  `rtk proxy aside skills list` で対象サービスの専用スキルを探す。該当すれば先に読む。
  連続操作では対話式 `rtk proxy aside repl` を維持し、同じセッションへ入力する。
  一回ごとのCLI呼び出しで変数や参照が引き継がれるとは考えない。
  PTYへは1回につき1行を送り、処理結果とプロンプトの復帰を確認して次へ進む。
  複数行をまとめて送ると、後続行が実行されない場合がある。
- account/profileの指定は必要な対象へ限定する。検証のために既定設定や保存方針を変更しない。
  REPLの起動出力にはアカウント情報が含まれる。ツール結果を会話へ返す前に
  account・sessionDir等の個人情報を除き、session IDと操作に必要な結果だけを返す。
  CLIが表示するメールアドレスやセッション情報を、品質レポートや共有fixtureへ転記しない。

## 読み取り、操作、結果確認

既存画面を対象にする場合は `listBrowserTabs()` で一致するタブを探し、target IDでattachする。
「現在の画面」という依頼のときだけactive tabを選ぶ。別の対象がなければ `openTab(url)` で
開き、自分で開いたタブを記録する。タブ管理は `openTab` / `closeTab` を使う。

最初は `snapshot(page, { interactive: true })` の `tree` を読む。見出し・説明が足りなければ
full snapshotへ進む。出力を文字数で切り詰めず、必要ならguideにあるselector/refで絞る。
得られたrefを `page.locator(ref)` へ渡す。refはCSSのidではなく、最新snapshotを基準に選ぶ。

たとえば最新snapshotの対象refを `currentRef` に入れた後、REPLでは次のように確認する。
変数名はセッション内で重複しないものにする。

```js
await page.locator(currentRef).press('Tab');
const afterTab1 = await snapshot(page, { interactive: true });
console.log(afterTab1.diff);
```

上の例も1行ずつ送信する。出力がないときは、操作自体を再送する前にsnapshotで状態を確認する。

clickやEnter/Space、Tab/Shift+Tab、Escapeを、確認したい操作に合わせて使う。
locatorへの`press`は対象へfocusを移すことがあるため、Tab順序の試験ではsnapshotの
現在のfocused要素を使う。未到達の要素へlocatorでfocusを移して、Tabで到達できたと報告しない。
操作成功の戻り値だけで完了とせず、毎回新しいsnapshotのdiffで状態とfocusを見る。
操作後の固定sleepは追加せず、遷移中の証拠がある場合だけ待つ。

視覚確認が必要なら `await display(await page.screenshot())` で画像を取得し、表示された
保存先の画像を画像閲覧ツールで実際に見る。保存されたことだけで重なりやfocus可視性を
確認済みとしない。snapshotの名前・role・focusと画面の見た目を照合する。

## 困ったときと終了時

CLI/APIエラー、失効したref、操作の対象違い、画面側の不具合を区別する。
失効や状態の不一致ならsnapshotを取り直し、guideにないAPIを推測して連打しない。
対応しない検査は未確認として残す。asideのsnapshotだけでVoiceOverの読み上げや
Lighthouse実行まで確認したとは報告しない。

検証用の入力を残さず、自分で開いたタブだけを `closeTab` で閉じる。既存タブは閉じない。
報告は操作、操作前後の状態、証拠、未確認事項を示し、アカウント情報は含めない。
