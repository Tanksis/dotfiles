local function gh(repo) return 'https://github.com/' .. repo end

vim.pack.add { gh 'windwp/nvim-ts-autotag' }
require('nvim-ts-autotag').setup()
