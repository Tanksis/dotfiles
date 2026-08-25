-- snacks.nvim replaces two archived plugins:
--   - dressing.nvim (archived; author recommends snacks.nvim's input module)
--   - alpha-nvim dashboard (still works, but snacks.dashboard is the
--     current standard companion for a kickstart+snacks setup)
--
-- barbecue.nvim (winbar breadcrumbs) is archived with no snacks equivalent
-- and was dropped without a replacement.

local function gh(repo) return 'https://github.com/' .. repo end

vim.pack.add { gh 'folke/snacks.nvim' }

require('snacks').setup {
  input = { enabled = true },

  dashboard = {
    enabled = true,
    preset = {
      header = [[

  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
                                                     ]],
      keys = {
        { icon = '', key = 'e', desc = 'New File', action = ':enew' },
        { icon = '', key = 't', desc = 'Toggle file explorer', action = ':silent! Neotree filesystem reveal left toggle' },
        { icon = '', key = 'f', desc = 'Find File', action = function() require('telescope.builtin').find_files() end },
        { icon = '', key = 'g', desc = 'Find Word', action = function() require('telescope.builtin').live_grep() end },
        { icon = '', key = 'r', desc = 'Restore Session For Current Directory', action = ':SessionRestore' },
        { icon = '', key = 'q', desc = 'Quit NVIM', action = ':qa' },
      },
    },
  },
}
