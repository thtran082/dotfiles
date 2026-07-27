# 💤 LazyVim

A personal [LazyVim](https://github.com/LazyVim/LazyVim) config tuned for **Angular + NX monorepo**
web development. Refer to the [LazyVim docs](https://lazyvim.github.io/installation) to get started.

## Highlights

- **Angular LSP for NX** — `angularls` probes the workspace-root `node_modules` so it works in NX
  monorepos with hoisted dependencies (`lua/plugins/angular.lua`).
- **NX command runner** — `<leader>nx` group: projects/targets picker (`<leader>nxp`), serve/build/
  test/lint against the current project, plus `affected`, `graph`, and `generate`
  (`lua/plugins/nx-runner.lua`).
- **ESLint + Prettier** — ESLint diagnostics with `EslintFixAll` on save; a single prettier path via
  `conform.nvim` → `prettierd`.
- **Media** — inline image rendering and previews via `snacks.image` (needs a Kitty-graphics terminal
  such as **Ghostty**, Kitty, or WezTerm).
- **macOS integration** — `<leader>oo` reveal in Finder, `<leader>oO` open cwd, `<leader>oq` Quick Look.

See `CLAUDE.md` for the full architecture and keymap reference.
