# Sets $base: the commit to compare with, or empty when the history does not hold it.
base="${BASELINE:-${PR_BASE:-${PUSH_BEFORE:-}}}"
# A push that creates a branch has no commit before it.
if [ "$base" = "0000000000000000000000000000000000000000" ]; then base=""; fi
if [ -n "$base" ] && ! git cat-file -e "$base^{commit}" 2>/dev/null; then
  echo "::warning::the commit $base is not in the checkout, so the step scans everything. Use actions/checkout with fetch-depth: 0."
  base=""
fi
