local function gh(repo)
  return 'https://github.com/' .. repo
end

vim.pack.add {
  gh 'Cannon07/code-preview.nvim',
}

require('code-preview').setup {
  diff = {
    layout = 'vsplit',
  },
  neo_tree = {
    enabled = true,
    reveal = true,
    refresh_on_change = true,
    position = 'left',
  },
}
