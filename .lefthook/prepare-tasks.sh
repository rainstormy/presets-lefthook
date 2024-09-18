fnm_install_on_engine_change() {
	if git diff --quiet "$1" "$2" -- 'package.json' | awk '/"engines": {/,/}/' | grep --quiet '"node": "'; then
		echo "No changes detected in 'engines.node' in 'package.json'. Skipping 'fnm install'."
	else
		echo "Changes detected in 'engines.node' in 'package.json'. Running 'fnm install'."
		fnm install --corepack-enabled --install-if-missing --resolve-engines --version-file-strategy recursive
	fi
}

nvm_install_on_nvmrc_change() {
    if git diff --quiet "$1" "$2" -- '.nvmrc'; then
    	echo "No changes detected in '.nvmrc'. Skipping 'nvm install' and 'corepack enable'."
    else
    	echo "Changes detected in '.nvmrc'. Running 'nvm install' and 'corepack enable'."
    	source "$HOME/.nvm/nvm.sh"
    	nvm install
    	nvm alias default "$(cat .nvmrc)"
    	corepack enable
    fi
}

pnpm_install_on_lockfile_change() {
    if git diff --quiet "$1" "$2" -- 'pnpm-lock.yaml'; then
    	echo "No changes detected in 'pnpm-lock.yaml'. Skipping 'pnpm install'."
    else
    	echo "Changes detected in 'pnpm-lock.yaml'. Running 'pnpm install'."
    	# Skip confirmation prompts when Corepack is about to upgrade pnpm.
    	CI=1 pnpm install
    fi
}

base_commit_sha() {
	while read -r BASE_COMMIT_SHA; do
    	if [[ "$BASE_COMMIT_SHA" =~ ^[0-9a-f]{40}$ ]]; then
    		git rev-parse "$BASE_COMMIT_SHA~1"
	        break
    	fi
    done
}

old_head_commit_sha() {
	git rev-parse HEAD@\{1\}
}

head_commit_sha() {
	git rev-parse HEAD
}
