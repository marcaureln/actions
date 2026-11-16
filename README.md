# actions

Composite GitHub Actions that run security scanners by capability. Each one runs a pinned scanner image with `docker run`, so it works on any runner that has Docker (`ubuntu-latest` has it).

| Action | Scanner | Fails on |
| --- | --- | --- |
| `sast` | [Semgrep CE](https://github.com/semgrep/semgrep) | A finding in new code |
| `deps-scan` | [Grype](https://github.com/anchore/grype) | A vulnerability with a fix, at or above `fail-on` (default `high`) |
| `secrets-scan` | [TruffleHog](https://github.com/trufflesecurity/trufflehog) | A secret in a new commit that its provider confirms as live |

## Usage

```yaml
on:
  pull_request:
  push:
    branches: [main]
permissions:
  contents: read
jobs:
  scan:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v7
        with:
          fetch-depth: 0
      - uses: marcaureln/actions/sast@main
      - uses: marcaureln/actions/deps-scan@main
      - uses: marcaureln/actions/secrets-scan@main
```

Pin the actions to a commit SHA, not `@main`.

`sast` and `secrets-scan` compare with a baseline commit: the pull request base, or the commit before the push. They need the full history (`fetch-depth: 0`). Without it, or on other events, they scan everything. To set the baseline, use the `baseline` input.

## Inputs

| Action | Input | Default |
| --- | --- | --- |
| `sast` | `rules`: URL of the Semgrep rules | `https://semgrep.dev/c/p/default` |
| `sast`, `secrets-scan` | `baseline`: commit to compare with | Pull request base, or the commit before the push |
| `deps-scan` | `path`: folder to scan | `.` |
| `deps-scan` | `fail-on`: lowest severity that fails | `high` |
