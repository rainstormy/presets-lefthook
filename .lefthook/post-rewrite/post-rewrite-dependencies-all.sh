SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../dependencies.sh"

read -r FIRST_SHA _

if [[ ! "$FIRST_SHA" =~ ^[0-9a-f]{40}$ ]]; then
	echo "Error: The first commit being rebased does not have a valid SHA: $FROM_SHA" >&2
	exit 1
fi

FROM_SHA="$(git rev-parse "$FIRST_SHA~1")"
TO_SHA="$(git rev-parse HEAD)"

if [[ ! "$FROM_SHA" =~ ^[0-9a-f]{40}$ ]]; then
	echo "Error: The base commit does not have a valid SHA: $FROM_SHA" >&2
	exit 1
elif [[ ! "$TO_SHA" =~ ^[0-9a-f]{40}$ ]]; then
	echo "Error: The rebased commit does not have a valid SHA: $TO_SHA" >&2
	exit 1
fi

echo "Evaluating changes between the base commit $FROM_SHA and the rebased commit $TO_SHA:"
install_nodejs "$FROM_SHA" "$TO_SHA"
install_packages "$FROM_SHA" "$TO_SHA"
install_terraform "$FROM_SHA" "$TO_SHA"
