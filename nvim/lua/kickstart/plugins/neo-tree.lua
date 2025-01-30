-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
    {
      's1n7ax/nvim-window-picker',
      version = '2.*',
      config = function()
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
      end,
    },
  },

  cmd = 'Neotree',

  keys = {
    {
      '<leader>ee',
      function()
        vim.cmd 'silent! Neotree filesystem reveal left toggle'
      end,
      { desc = 'NeoTree reveal' },
    },
    opts = {
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
          expander_collapsed = '',
          expander_expanded = '',
          expander_highlight = 'NeoTreeExpander',
        },
        icon = {
          folder_closed = '',
          folder_open = '',
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
            modified = '', -- or "", but this is redundant info if you use git_status_colors on the name
            deleted = '✖', -- this can only be used in the git_status source
            renamed = '󰁕', -- this can only be used in the git_status source
            -- Status type
            untracked = '',
            ignored = '',
            unstaged = '󰄱',
            staged = '',
            conflict = '',
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
    },
  },
}
