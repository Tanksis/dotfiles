return {
  'akinsho/bufferline.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  version = '*',
  opts = {
    options = {
      mode = 'tabs',

      offsets = {
        {
          filetype = 'neo-tree',
          text = 'File Explorer',
          highlight = 'Directory',
          separator = true, -- use a "true" to enable the default, or set your own character
          text_align = 'center', -- can be "center", "left", or "right":w
        },
      },
    },
  },
}
