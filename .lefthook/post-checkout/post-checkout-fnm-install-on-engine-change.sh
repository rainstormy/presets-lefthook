LEFTHOOK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../"
source "$LEFTHOOK_DIR/prepare-tasks.sh"

FROM_SHA="$(old_head_commit_sha)"
TO_SHA="$(head_commit_sha)"

echo "Evaluating changes between the old HEAD commit $FROM_SHA and the new HEAD commit $TO_SHA:"
fnm_install_on_engine_change "$FROM_SHA" "$TO_SHA"
