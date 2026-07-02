#!/usr/bin/env python3
"""Summarize prompt-review collector JSON without printing prompt bodies."""

from __future__ import annotations

import argparse
import json
import re
from collections import Counter
from pathlib import Path


CATEGORIES = {
    "commit_push_jj_git": r"コミット|push|プッシュ|jj\b|jujutsu|git\b|PR|pull request",
    "translation_writing": r"翻訳|訳|文体|原稿|ブログ|記事|文章|校正|推敲|日本語",
    "docs_readme_cleanup": r"README|ドキュメント|docs|整理|読みやす|不要|削除|俯瞰",
    "review": r"レビュー|review|レビュ|指摘|LGTM|self-review|code-review",
    "agents_skills_rules": r"agent|agents|skill|skills|rules|\.claude|\.agents|codex|Claude Code|subagent",
    "rust_cli_tooling": r"Rust|cargo|CLI|clap|tui|ratatui|ツール|コマンド",
    "dotfiles_environment": r"dotfiles|nvim|fish|ghostty|warp|brew|Brewfile|環境|設定",
    "marp_slides": r"Marp|slide|slides|スライド|登壇|発表",
    "frontend_visual": r"frontend|React|Next|UI|デザイン|スクリーンショット|Playwright|ブラウザ",
    "prompt_history_nippo": r"プロンプト|履歴|日報|nippo|振り返り|分析",
    "finops_cloud": r"FinOps|AWS|GCP|コスト|請求|billing|Cost Explorer|BigQuery",
    "security_secret": r"セキュリティ|secret|token|API.?key|鍵|公開|漏洩|credential|password|pass:",
}


def is_low_signal(text: str) -> bool:
    return bool(
        len(text) <= 20
        and re.fullmatch(
            r"(?i)(y|yes|ok|はい|うん|お願いします|ありがとう|thanks|進めて|やって|go|do it|doit|それで)",
            text,
        )
    )


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("json_path", type=Path)
    args = parser.parse_args()

    data = json.loads(args.json_path.read_text())
    counts: Counter[str] = Counter()

    for source in data.get("sources", []):
        for message in source.get("messages", []):
            text = (message.get("text") or "").strip()
            if not text or is_low_signal(text):
                continue
            for category, pattern in CATEGORIES.items():
                if re.search(pattern, text, re.IGNORECASE):
                    counts[category] += 1

    output = {
        "summary": data.get("summary", {}),
        "project_count": len(data.get("project_stats", {})),
        "secret_warning_count": len(data.get("secret_warnings", [])),
        "category_counts": dict(counts.most_common()),
    }
    print(json.dumps(output, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
