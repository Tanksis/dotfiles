local function gh(repo) return 'https://github.com/' .. repo end

vim.pack.add { gh 'andrewferrier/wrapping.nvim' }
require('wrapping').setup()
