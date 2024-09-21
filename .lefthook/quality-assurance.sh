run_task() {
	if [[ -f 'justfile' ]]; then
		if just --summary | grep --quiet --word-regexp "$1"; then
			echo "Just detected. Running '$1'."
			just "$1"
			return 0
		else
			echo "'justfile' does not define a recipe named '$1'."
		fi
	fi

	if [[ -f 'package.json' ]]; then
		if sed -n '/"scripts": {/,/}/p' 'package.json' | grep --perl-regexp --quiet "\"$1\": \""; then
			if [[ -f 'pnpm-lock.yaml' ]]; then
				echo "pnpm detected. Running '$1'."
				pnpm run "$1"

			elif [[ -f 'bun.lockb' ]]; then
				echo "Bun detected. Running '$1'."
				bun run "$1"

			elif [[ -f 'yarn.lock' ]]; then
				echo "Yarn detected. Running '$1'."
				yarn run "$1"

			elif [[ -f 'package-lock.json' ]]; then
				echo "npm detected. Running '$1'."
				npm run "$1"

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
