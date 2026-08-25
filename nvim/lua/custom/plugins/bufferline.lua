local function gh(repo) return 'https://github.com/' .. repo end

vim.pack.add { { src = gh 'akinsho/bufferline.nvim', version = vim.version.range '*' } }

require('bufferline').setup {
  options = {
    mode = 'tabs',
    custom_filter = function(buf_number)
      if vim.bo[buf_number].filetype ~= 'neo-tree' then return true end
    end,

    offsets = {
      {
        filetype = 'neo-tree',
        text = 'File Explorer',
        highlight = 'Directory',
        separator = true,
        text_align = 'center',
      },
    },
  },
}
