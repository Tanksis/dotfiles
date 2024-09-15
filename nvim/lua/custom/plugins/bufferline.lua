return {
  'akinsho/bufferline.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  version = '*',
  opts = {
    options = {
      mode = 'tabs',
      custom_filter = function(buf_number)
        if vim.bo[buf_number].filetype ~= 'neo-tree' then
          return true
        end
      end,

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
