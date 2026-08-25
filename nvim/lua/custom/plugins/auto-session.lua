local function gh(repo) return 'https://github.com/' .. repo end

vim.pack.add { gh 'rmagatti/auto-session' }

require('auto-session').setup {
  auto_restore = false,
  suppressed_dirs = { '~/', '~/Dev/', '~/Downloads', '~/Documents', '~/Desktop/' },
}

vim.keymap.set('n', '<leader>wr', '<cmd>SessionRestore<CR>', { desc = 'Restore session for cwd' })
vim.keymap.set('n', '<leader>ws', '<cmd>SessionSave<CR>', { desc = 'Save session for auto session root dir' })
