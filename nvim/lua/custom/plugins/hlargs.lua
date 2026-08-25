local function gh(repo) return 'https://github.com/' .. repo end

vim.pack.add { gh 'm-demare/hlargs.nvim' }
require('hlargs').setup()
