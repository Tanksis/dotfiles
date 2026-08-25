local function gh(repo) return 'https://github.com/' .. repo end

vim.pack.add {
  gh 'nvim-lua/plenary.nvim',
  gh 'kdheepak/lazygit.nvim',
}

vim.keymap.set('n', '<leader>lg', '<cmd>LazyGit<cr>', { desc = 'Open lazy git' })
