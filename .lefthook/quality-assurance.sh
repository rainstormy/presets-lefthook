run_task() {
	# mise-en-place
	# https://mise.jdx.dev
	if [[ -f 'mise.toml' ]]; then
		if mise tasks ls | grep --quiet --word-regexp "$1"; then
			echo "mise-en-place detected. Running '$1'."
			mise run "$1"
			EXIT_CODE=$?
			return $EXIT_CODE # Unquoted to retain the numeric type of the exit code.
		else
			echo "'mise.toml' does not define a task named '$1'."
		fi
	fi

	# Just
	# https://just.systems
	if [[ -f 'justfile' ]]; then
		if just --summary | grep --quiet --word-regexp "$1"; then
			echo "Just detected. Running '$1'."
			just "$1"
			EXIT_CODE=$?
			return $EXIT_CODE # Unquoted to retain the numeric type of the exit code.
		else
			echo "'justfile' does not define a recipe named '$1'."
		fi
	fi

	if [[ -f 'package.json' ]]; then
		if sed -n '/"scripts": {/,/}/p' 'package.json' | grep --perl-regexp --quiet "\"$1\": \""; then
			# pnpm
            # https://pnpm.io
			if [[ -f 'pnpm-lock.yaml' ]]; then
				echo "pnpm detected. Running '$1'."
				pnpm run "$1"
				EXIT_CODE=$?
				return $EXIT_CODE # Unquoted to retain the numeric type of the exit code.

			# Bun
			# https://bun.sh
			elif [[ -f 'bun.lockb' ]]; then
				echo "Bun detected. Running '$1'."
				bun run "$1"
				EXIT_CODE=$?
				return $EXIT_CODE # Unquoted to retain the numeric type of the exit code.

			# Yarn
			# https://yarnpkg.com
			elif [[ -f 'yarn.lock' ]]; then
				echo "Yarn detected. Running '$1'."
				yarn run "$1"
				EXIT_CODE=$?
				return $EXIT_CODE # Unquoted to retain the numeric type of the exit code.

			# npm
			# https://nodejs.org/en/learn/getting-started/an-introduction-to-the-npm-package-manager
			elif [[ -f 'package-lock.json' ]]; then
				echo "npm detected. Running '$1'."
				npm run "$1"
				EXIT_CODE=$?
				return $EXIT_CODE # Unquoted to retain the numeric type of the exit code.

			else
				echo "No package manager detected. Skipping '$1'."
			fi
		else
			echo "'package.json' does not define a script named '$1'. Skipping '$1'."
		fi

	else
		echo "'package.json' not found. Skipping '$1'."
	fi
}
