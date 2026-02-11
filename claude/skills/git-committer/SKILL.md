---
name: git-committer
description: Gitのcommitについてのガイドライン。commitを作成する前に使用する。
user-invocable: false
---

# Gitコミット標準

## Conventional Commits

以下のようなConventional Commitsの作法に従ったコミットメッセージを作成すること。

```bash
# フォーマット: <type>(<scope>): <subject>
git commit -m "feat(auth): add JWT token refresh"
git commit -m "fix(api): handle null response correctly"
git commit -m "docs(readme): update installation steps"
git commit -m "perf(db): optimize query performance"
git commit -m "refactor(core): extract validation logic"
```

## コミットその他

以下のような使用ツールに関する文言はコミットメッセージには不要。

```bash
Generated with [Claude Code](https://claude.ai/code)

Co-Authored-By: Claude <noreply@anthropic.com>
```
