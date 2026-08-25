local function gh(repo) return 'https://github.com/' .. repo end

vim.pack.add {
  gh 'ray-x/guihua.lua',
  gh 'neovim/nvim-lspconfig',
  { src = gh 'nvim-treesitter/nvim-treesitter', version = 'main' },
  gh 'ray-x/go.nvim',
}

require('go').setup()

-- Auto-formatting configuration
local format_sync_grp = vim.api.nvim_create_augroup('GoFormat', {})
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*.go',
  callback = function() require('go.format').goimports() end,
  group = format_sync_grp,
})

vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    if ev.data.spec.name == 'go.nvim' and (ev.data.kind == 'install' or ev.data.kind == 'update') then require('go.install').update_all_sync() end
  end,
})
