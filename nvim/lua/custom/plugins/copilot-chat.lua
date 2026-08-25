local function gh(repo) return 'https://github.com/' .. repo end

-- NOTE: dependency is plenary.nvim only — CopilotChat.nvim's own auth talks
-- to Copilot directly and doesn't need copilot.lua or copilot.vim as a
-- dependency (github/copilot.vim, installed separately in copilot.lua, is
-- what actually provides inline completions). Default branch is now `main`
-- (the old `canary` branch was merged into it).
vim.pack.add {
  gh 'nvim-lua/plenary.nvim',
  gh 'CopilotC-Nvim/CopilotChat.nvim',
}

require('CopilotChat').setup {
  debug = true,
  mappings = {},
}
