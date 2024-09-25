SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../dependencies.sh"

FROM_SHA="$(git rev-parse HEAD@\{1\})"
TO_SHA="$(git rev-parse HEAD)"

if [[ ! "$FROM_SHA" =~ ^[0-9a-f]{40}$ ]]; then
	echo "Error: The former HEAD commit does not have a valid SHA: $FROM_SHA" >&2
	exit 1
elif [[ ! "$TO_SHA" =~ ^[0-9a-f]{40}$ ]]; then
	echo "Error: The new HEAD commit does not have a valid SHA: $TO_SHA" >&2
	exit 1
fi

echo "Evaluating changes between the former HEAD commit $FROM_SHA and the new HEAD commit $TO_SHA:"
install_nodejs "$FROM_SHA" "$TO_SHA"
install_packages "$FROM_SHA" "$TO_SHA"
install_terraform "$FROM_SHA" "$TO_SHA"
