local function gh(repo) return 'https://github.com/' .. repo end

vim.pack.add { gh 'nvim-lualine/lualine.nvim' }

require('lualine').setup {
  options = {
    theme = 'monokai-pro',
  },
}
