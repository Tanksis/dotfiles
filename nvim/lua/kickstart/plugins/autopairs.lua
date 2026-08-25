-- autopairs
-- https://github.com/windwp/nvim-autopairs
--
-- NOTE: nvim-autopairs has no official blink.cmp integration (the old
-- nvim-cmp `confirm_done` hook doesn't apply). blink.cmp's own
-- `completion.accept.auto_brackets` (see init.lua Section 8) now covers
-- "insert () after accepting a function completion" instead.

local function gh(repo) return 'https://github.com/' .. repo end

vim.pack.add { gh 'windwp/nvim-autopairs' }
require('nvim-autopairs').setup {}
