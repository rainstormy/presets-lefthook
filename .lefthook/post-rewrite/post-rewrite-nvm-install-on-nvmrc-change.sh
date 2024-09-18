LEFTHOOK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../"
source "$LEFTHOOK_DIR/prepare-tasks.sh"

FROM_SHA="$(base_commit_sha)"
TO_SHA="$(head_commit_sha)"

echo "Evaluating changes between the base commit $FROM_SHA and the rebased commit $TO_SHA:"
nvm_install_on_nvmrc_change "$FROM_SHA" "$TO_SHA"
