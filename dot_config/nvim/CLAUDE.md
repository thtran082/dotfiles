# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a Neovim configuration built on [LazyVim](https://lazyvim.org/) using `lazy.nvim` as the plugin manager. It targets web development workflows, particularly Angular/TypeScript projects.

## Common Commands

```bash
# Format Lua files
stylua lua/

# Check Lua formatting
stylua --check lua/
```

Stylua config (`stylua.toml`): 2-space indentation, 120-column width.

## Architecture

### Entry Point
`init.lua` bootstraps `lazy.nvim` and loads `lua/config/lazy.lua`.

### Directory Structure
- `lua/config/` — Core configuration: `lazy.lua` (plugin manager setup), `keymaps.lua`, `options.lua`, `autocmds.lua`
- `lua/plugins/` — One file per plugin or plugin group; each file returns a lazy.nvim spec table
- `lazyvim.json` — Tracks enabled LazyVim extras (currently: `lang.angular`)
- `lazy-lock.json` — Locked plugin versions (commit SHAs)

### Plugin Configuration Pattern
All files in `lua/plugins/` follow the lazy.nvim spec format:

```lua
return {
  -- Override LazyVim defaults by using the same plugin name
  {
    "plugin/name",
    opts = { key = value },       -- merged with LazyVim defaults
  },
  -- Or with function form to extend existing opts
  {
    "plugin/name",
    opts = function(_, opts)
      vim.list_extend(opts.some_list, { "extra_item" })
    end,
  },
}
```

To disable a LazyVim-provided plugin: `{ "plugin/name", enabled = false }`.

### Key Plugin Groups
- **LSP**: `nvim-lspconfig` + `mason.nvim` (ensures `nxls`, `prettierd`, `eslint-lsp`, `angular-language-server` are installed). `nxls` (`lua/plugins/nxls.lua`) is wired to `json`/`jsonc` and roots on `nx.json`/`.git`.
- **Angular LSP (NX-aware)**: handled by nvim-lspconfig's upstream `lsp/angularls.lua` (Nvim 0.11+ `vim.lsp.config` model), which already has `root_markers = { "angular.json", "nx.json" }`, a dynamic `cmd` that probes the project + mason `angular-language-server` node_modules with the correct `--ngProbeLocations`/`--angularCoreVersion`, and `filetypes` including `html` (what `*.component.html` resolves to → template intellisense works). **`lua/plugins/angular.lua` is intentionally empty** — do NOT re-add a static `cmd`/`on_new_config` override; that breaks `.html` template support on Nvim 0.11+. Rename is disabled on `angularls` by the LazyVim `lang.angular` extra.
- **ESLint**: `lua/plugins/eslint.lua` — `eslint` LSP with `workingDirectories=auto` (per-NX-project config), `format=false`, and fix-on-save via `EslintFixAll` on `BufWritePre`.
- **Completion**: `blink.cmp` + `LuaSnip`
- **Formatting**: single path — `conform.nvim` → `prettierd` (fallback `prettier`), configured in `lua/plugins/prettier.lua`. Covers `htmlangular` (Angular templates). `:f`/`:F` triggers `conform.format` (see keymaps).
- **NX runner**: `lua/plugins/nx-runner.lua` — Telescope picker + `<leader>nx*` keymaps (see below).
- **File tree**: `neo-tree.nvim` (custom `Y` path-copy, `O` reveal-in-Finder keymaps)
- **Fuzzy find**: `telescope.nvim` + `fzf-lua`. Telescope extensions loaded: `neoclip` (clipboard history, `<leader>mm`), `file_browser` (`<leader>sB`), `package_info` (`<leader>ns`)
- **Angular**: `ngswitcher.vim` for switching between TS/HTML/CSS/spec files (`<leader>nu/ni/no/np`)
- **UI**: `noice.nvim` (custom cmdline/popupmenu positioning); `nvim-notify` is disabled in `lua/plugins/disabled.lua`
- **Images**: `snacks.image` (`lua/plugins/ui-media.lua`) renders images inline + neo-tree/picker hover previews. Requires a Kitty-graphics-protocol terminal (Ghostty/Kitty/WezTerm). Replaced the old `luarocks.nvim`/`3rd/image.nvim` neo-tree deps. Icons use LazyVim's default `mini.icons`.
- **Git**: `git-blame.nvim` (inline blame, enabled on startup)
- **Editing**: `vim-abolish` (smart substitution/casing), `nvim-colorizer.lua` (color preview), `nvim-neoclip.lua` (clipboard manager)

### Non-Obvious: Custom HTML LSP for angular-three
`lua/plugins/html.lua` overrides the `html` LSP setup to load custom data from `angular-three` / `angular-three-soba` metadata (in both `libs/` and `node_modules/`) and implements a `html/customDataContent` handler. This is specific to Angular + THREE.js (`angular-three`) projects — don't remove it assuming it's boilerplate.

### LazyVim Extras
Extras are managed via `:LazyExtras` UI (writes to `lazyvim.json`) or by editing `lua/config/lazy.lua` directly. Currently active extras beyond `lazyvim.json`:
- `lang.typescript`, `lang.json`, `lang.tailwind`, `formatting.prettier`, `editor.navic` (in `lua/config/lazy.lua`)
- `lang.angular` (in `lazyvim.json`)

### Notable Custom Keymaps (`lua/config/keymaps.lua`)
- `<leader>ig` — interactive find & replace for word under cursor
- `<leader>y`/`<leader>Y` — yank to system clipboard; `<leader>d` — delete to void register (no yank)
- `<leader>p` (visual) — paste without overwriting yank register
- `J`/`K` (visual) — move selected lines down/up
- `<leader>x` — `chmod +x` current file
- `<leader>bb` — Telescope buffers; `<leader>mm` — Telescope neoclip; `<leader>bsd` — delete surrounding buffers
- `:w`/`:W` — write all buffers; `:f`/`:F` — `conform.format`; `:Q` → `:q`; `:e`/`:E` → `:e!` (force reload)
- `<C-d>`/`<C-u>` — page scroll + center; `n`/`N` — search nav + center
- `<leader>oo` — reveal current file in Finder; `<leader>oO` — open cwd in Finder; `<leader>oq` — Quick Look preview
- **NX runner (`<leader>nx`)**: `<leader>nxp` projects/targets picker · `<leader>nxs` serve · `<leader>nxb` build · `<leader>nxt` test · `<leader>nxl` lint · `<leader>nxa` affected · `<leader>nxg` graph · `<leader>nxG` generate (all run against the current file's project / workspace in a snacks terminal split)
- **Angular file switch (`<leader>n`)**: `<leader>nu` TS · `<leader>ni` CSS · `<leader>no` HTML · `<leader>np` spec (ngswitcher)
