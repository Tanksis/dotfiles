return {

  {
    'nvim-tree/nvim-tree.lua',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      require('nvim-tree').setup {}
      vim.api.nvim_set_keymap('n', '<A-;>', ':NvimTreeToggle<CR>', { noremap = true, silent = true })
    end,
  },
}
