# AGENTS.md

This is a dotfiles repository. No build/test/lint workflows apply.

## Neovim Configuration

- Base: [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim)
- Plugin manager: lazy.nvim
- Custom plugins: `nvim/lua/custom/plugins/`
- Lazy-lock: `nvim/lazy-lock.json`

### Lua Formatting

- Tool: stylua
- Config: `nvim/.stylua.toml`
- Key settings: `column_width = 160`, `indent_width = 2`, `quote_style = "AutoPreferSingle"`
- Format command: `stylua nvim/`

### Plugin Keybinds

- `<leader>ee` - Neo-tree file explorer
- `<leader>sf` - Telescope find files
- `<leader>sg` - Telescope live grep
- `<leader>sn` - Search Neovim config files

## WezTerm Configuration

- Default shell: pwsh.exe
- Theme: Monokai Pro (Gogh)
- Font: JetBrains Mono
- Vim integration via `smart-splits.nvim` (IS_NVIM user var)

## Scoop

- Config: `scoop/config.json`

## Formatting Commands

- Lua files: `stylua <filepath>`
