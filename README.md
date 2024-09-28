# Opinionated Presets for Lefthook

This package provides predefined,
opinionated [Lefthook](https://github.com/evilmartians/lefthook) presets to be
applied to the [`remotes`](https://github.com/evilmartians/lefthook/blob/master/docs/configuration.md#remotes)
property in `lefthook.yml`.

## Usage
1. Create a [`lefthook.yml`](https://github.com/evilmartians/lefthook/blob/master/docs/configuration.md#config-file)
   configuration file.
2. Add `https://github.com/rainstormy/presets-lefthook` as
   a [remote](https://github.com/evilmartians/lefthook/blob/master/docs/configuration.md#remotes).
   Use `ref` to specify the version of the presets to use.
3. Extend some of the following configurations to enable the Git hooks that you
   need:

   | Configuration           | Description                                                       |
   |-------------------------|-------------------------------------------------------------------|
   | `dependencies.yml`      | Install dependencies automatically upon checking out or rebasing. |
   | `quality-assurance.yml` | Validate the software quality before committing or pushing.       |

For example:

```yaml
remotes:
  - git_url: https://github.com/rainstormy/presets-lefthook
    ref: v1
    configs:
      - dependencies.yml
      - quality-assurance.yml
```

### `dependencies.yml`
This configuration installs dependencies automatically upon checking out or
rebasing if they have changed between the previous HEAD commit and the current
HEAD commit.

> [!TIP]  
> Use this configuration to avoid having to manually run `npm install` etc. when
> you check out a branch or rebase a branch onto `main`.

For Node.js engines:
- If [fnm](https://github.com/Schniz/fnm) is installed and the
  [`node` engine](https://docs.npmjs.com/cli/v10/configuring-npm/package-json#engines)
  in `package.json` has changed, fnm installs Node.js and enables Corepack (only
  when using [pnpm](https://pnpm.io) or [Yarn](https://yarnpkg.com)).
- If [nvm](https://github.com/nvm-sh/nvm) is installed and `.nvmrc` has changed,
  nvm installs Node.js and enables Corepack (only when
  using [pnpm](https://pnpm.io) or [Yarn](https://yarnpkg.com)).

For Node.js packages:
- If `package-lock.json` has changed,
  [npm](https://nodejs.org/en/learn/getting-started/an-introduction-to-the-npm-package-manager)
  installs packages in `node_modules`.
- If `pnpm-lock.yaml` has changed, [pnpm](https://pnpm.io) installs packages in
  `node_modules`.
- If `bun.lockb` has changed, [Bun](https://bun.sh) installs packages in
  `node_modules`.
- If `yarn.lock` has changed, [Yarn](https://yarnpkg.com) installs unplugged
  packages in `.yarn/unplugged`.

For [Terraform](https://www.terraform.io):
- If [tfswitch](https://tfswitch.warrensbox.com) is installed and the
  [`required_version`](https://developer.hashicorp.com/terraform/language/terraform#terraform-required_version)
  field in `terraform/versions.tf` has changed, tfswitch installs Terraform.

### `quality-assurance.yml`
This configuration validates the software quality before committing or pushing.

- Before committing, it runs a task named `fmt` on staged files to format files
  automatically.
- Before pushing, it runs the tasks named `check` and `test` in parallel to
  validate the software quality.

It aborts the commit or push operation if any of the tasks fail.

> [!TIP]  
> Commit or push with the `--no-verify` option to skip the validation procedure
> once.

When using the [Just](https://just.systems) task runner, it expects the tasks to
be defined as [recipes in the `justfile`](https://just.systems/man/en).

For example:
```just
check:
  biome check --error-on-warnings && tsc

fmt:
  biome check --write

test:
  vitest run
```

Alternatively, when
using [npm](https://nodejs.org/en/learn/getting-started/an-introduction-to-the-npm-package-manager),
[pnpm](https://pnpm.io), [Bun](https://bun.sh), or [Yarn](https://yarnpkg.com),
it expects the tasks to be defined as
[scripts in `package.json`](https://docs.npmjs.com/cli/v10/using-npm/scripts).

For example:
```json
{
  "scripts": {
    "check": "biome check --error-on-warnings && tsc",
    "fmt": "biome check --write",
    "test": "vitest run"
  }
}
```
