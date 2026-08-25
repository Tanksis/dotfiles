-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim
--
-- NOTE: no explicit nvim-web-devicons dependency here — mini.icons'
-- MiniIcons.mock_nvim_web_devicons() (see init.lua Section 4) satisfies
-- neo-tree's `require('nvim-web-devicons')` calls.

local function gh(repo) return 'https://github.com/' .. repo end

vim.pack.add {
  gh 'nvim-lua/plenary.nvim',
  gh 'MunifTanjim/nui.nvim',
  gh 'nvim-neo-tree/neo-tree.nvim',
  { src = gh 's1n7ax/nvim-window-picker', version = vim.version.range '2.*' },
}

require('window-picker').setup {
  filter_rules = {
    include_current_win = false,
    autoselect_one = true,
    -- filter using buffer options
    bo = {
      -- if the file type is one of following, the window will be ignored
      filetype = { 'neo-tree', 'neo-tree-popup', 'notify' },
      -- if the buffer type is one of following, the window will be ignored
      buftype = { 'terminal', 'quickfix' },
    },
  },
}

require('neo-tree').setup {
  close_if_last_window = true,
  enable_git_status = true,
  enable_diagnostics = true,
  popup_border_style = 'rounded',

  window = {
    width = 25,
    position = 'left',
  },
  mapping_options = {
    noremap = true,
    nowait = true,
  },

  default_component_configs = {
    container = {
      enable_character_fade = true,
    },
    indent = {
      -- indent guides
      with_markers = true,
      indent_marker = '│',
      last_indent_marker = '└',
      highlight = 'NeoTreeIndentMarker',
      -- expander config, needed for nesting files
      with_expanders = nil, -- if nil and file nesting is enabled, will enable expanders
      expander_collapsed = '',
      expander_expanded = '',
      expander_highlight = 'NeoTreeExpander',
    },
    icon = {
      folder_closed = '',
      folder_open = '',
      folder_empty = '󰜌',
      -- The next two settings are only a fallback, if you use nvim-web-devicons and configure default icons there
      -- then these will never be used.
      default = '*',
      highlight = 'NeoTreeFileIcon',
    },
    modified = {
      symbol = '[+]',
      highlight = 'NeoTreeModified',
    },
    name = {
      trailing_slash = false,
      use_git_status_colors = true,
      highlight = 'NeoTreeFileName',
      use_default_name = false,
    },
    git_status = {
      symbols = {
        -- Change type
        added = '', -- or "✚", but this is redundant info if you use git_status_colors on the name
        modified = '', -- or "", but this is redundant info if you use git_status_colors on the name
        deleted = '✖', -- this can only be used in the git_status source
        renamed = '󰁕', -- this can only be used in the git_status source
        -- Status type
        untracked = '',
        ignored = '',
        unstaged = '󰄱',
        staged = '',
        conflict = '',
      },
    },

    filesystem = {
      filtered_items = {
        visible = false,
        hide_dotfiles = false,
        hide_gitignored = false,
        hide_hidden = false,
      },
      window = {
        mappings = {
          ['<leader>ee'] = 'close_window',
        },
        position = 'left',
        width = 25,
      },
    },
  },
}

vim.keymap.set('n', '<leader>ee', '<cmd>silent! Neotree filesystem reveal left toggle<CR>', { desc = 'NeoTree reveal' })
