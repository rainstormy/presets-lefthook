install_devtools() {
	# mise-en-place
	# https://mise.jdx.dev
	if [[ -f 'mise.toml' ]] && command -v mise > /dev/null 2>&1; then
		if git diff --quiet "$1" "$2" -- 'mise.toml'; then
			echo "mise-en-place detected. No changes detected in 'mise.toml'. Skipping 'mise install'."
		else
			echo "mise-en-place detected. Changes detected in 'mise.toml'. Running 'mise install'."
			mise install
		fi

		return 0
	fi

	# fnm + Corepack
	# https://github.com/Schniz/fnm
	if [[ -f 'package.json' ]] && command -v fnm > /dev/null 2>&1; then
		if git diff "$1" "$2" -- 'package.json' | grep --quiet '"node": "'; then
			echo "fnm detected. No changes detected in 'engines.node' in 'package.json'. Skipping 'fnm install'."
		else
			echo "fnm detected. Changes detected in 'engines.node' in 'package.json'. Running 'fnm install'."
			fnm install --resolve-engines
			fnm use

			if [[ -f 'pnpm-lock.yaml' ]]; then
				echo "pnpm detected. Running 'corepack enable'."
				corepack enable
			elif [[ -f 'yarn.lock' ]]; then
				echo "Yarn detected. Running 'corepack enable'."
				corepack enable
			fi
		fi

	# nvm + Corepack
	# https://github.com/nvm-sh/nvm
	elif [[ -f '.nvmrc' && -f "$HOME/.nvm/nvm.sh" ]]; then
		if git diff --quiet "$1" "$2" -- '.nvmrc'; then
			echo "nvm detected. No changes detected in '.nvmrc'. Skipping 'nvm install'."
		else
			echo "nvm detected. Changes detected in '.nvmrc'. Running 'nvm install'."
			source "$HOME/.nvm/nvm.sh"
			nvm install

			NODE_VERSION="$(cat '.nvmrc')"
			nvm alias default "$NODE_VERSION"
			echo "The default Node.js version is now '$NODE_VERSION'."

			if [[ -f 'pnpm-lock.yaml' ]]; then
				echo "pnpm detected. Running 'corepack enable'."
				corepack enable
			elif [[ -f 'yarn.lock' ]]; then
				echo "Yarn detected. Running 'corepack enable'."
				corepack enable
			fi
		fi

	else
		echo "No Node.js version manager detected. Skipping Node.js installation."
	fi

	# Terraform + tfswitch
	# https://tfswitch.warrensbox.com
	if [[ -f 'terraform/versions.tf' ]] && command -v tfswitch > /dev/null 2>&1; then
		if git diff "$1" "$2" -- 'terraform/versions.tf' | grep --quiet 'required_version = "'; then
			echo "Terraform detected. No changes detected in 'required_version' in 'versions.tf'. Skipping 'tfswitch'."
		else
			echo "Terraform detected. Changes detected in 'required_version' in 'versions.tf'. Running 'tfswitch'."
			tfswitch --chdir 'terraform'
		fi
	else
		echo "No Terraform version manager detected. Skipping Terraform installation."
	fi
}

install_nodejs_packages() {
	# pnpm
	# https://pnpm.io
	if [[ -f 'pnpm-lock.yaml' ]]; then
		if git diff --quiet "$1" "$2" -- 'pnpm-lock.yaml'; then
			echo "pnpm detected. No changes detected in 'pnpm-lock.yaml'. Skipping 'pnpm install'."
		else
			echo "pnpm detected. Changes detected in 'pnpm-lock.yaml'. Running 'pnpm install'."
			# Skip confirmation prompts when Corepack is about to upgrade pnpm.
			CI=1 pnpm install
		fi

	# Bun
	# https://bun.sh
	elif [[ -f 'bun.lockb' ]]; then
		if git diff --quiet "$1" "$2" -- 'bun.lockb'; then
			echo "Bun detected. No changes detected in 'bun.lockb'. Skipping 'bun install'."
		else
			echo "Bun detected. Changes detected in 'bun.lockb'. Running 'bun install'."
			bun install
		fi

	# Yarn
	# https://yarnpkg.com
	elif [[ -f 'yarn.lock' ]]; then
		if git diff --quiet "$1" "$2" -- 'yarn.lock'; then
			echo "Yarn detected. No changes detected in 'yarn.lock'. Skipping 'yarn install'."
		else
			echo "Yarn detected. Changes detected in 'yarn.lock'. Running 'yarn install'."
			# Skip confirmation prompts when Corepack is about to upgrade Yarn.
			CI=1 yarn install
		fi

	# npm
	# https://nodejs.org/en/learn/getting-started/an-introduction-to-the-npm-package-manager
	elif [[ -f 'package-lock.json' ]]; then
		if git diff --quiet "$1" "$2" -- 'package-lock.json'; then
			echo "npm detected. No changes detected in 'package-lock.json'. Skipping 'npm install'."
		else
			echo "npm detected. Changes detected in 'package-lock.json'. Running 'npm install'."
			npm install
		fi

	else
		echo "No Node.js package manager detected. Skipping package installation."
	fi
}
