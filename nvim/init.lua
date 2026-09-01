-- Neovim config, based on kickstart.nvim
-- Rewritten to track kickstart.nvim's 2026 rewrite: native `vim.pack` plugin
-- manager, native LSP config (`vim.lsp.config`/`vim.lsp.enable`), blink.cmp,
-- and the new nvim-treesitter `main` branch API.
--
--
-- ============================================================
-- SECTION 1: OPTIONS
-- ============================================================
do
  -- Enable faster startup by caching compiled Lua modules
  vim.loader.enable()

  -- Set <space> as the leader key
  vim.g.mapleader = ' '
  vim.g.maplocalleader = ' '

  -- Set to true if you have a Nerd Font installed and selected in the terminal
  vim.g.have_nerd_font = true

  -- [[ Setting options ]]
  vim.o.textwidth = 80
  vim.o.number = true
  vim.o.relativenumber = true
  vim.o.mouse = 'a'
  vim.o.showmode = false

  -- Sync clipboard between OS and Neovim.
  --  Scheduled after `UiEnter` because it can increase startup-time.
  vim.schedule(function()
    vim.o.clipboard = 'unnamedplus'
  end)

  vim.o.breakindent = true
  vim.o.undofile = true

  -- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
  vim.o.ignorecase = true
  vim.o.smartcase = true

  vim.o.signcolumn = 'yes'
  vim.o.updatetime = 250
  vim.o.timeoutlen = 300
  vim.o.splitright = true
  vim.o.splitbelow = true

  vim.o.list = true
  vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

  -- Indentation baseline. guess-indent.nvim adapts these per-buffer when it can
  -- detect a definite style from an existing file, but it does nothing on new
  -- buffers or when detection is ambiguous, so we need sane defaults underneath.
  -- 2-space + expandtab matches Prettier and stylua (see SECTION 7); per-filetype
  -- overrides for black / gofmt live in SECTION 2.
  vim.o.expandtab = true
  vim.o.tabstop = 2
  vim.o.softtabstop = 2
  vim.o.shiftwidth = 2

  vim.o.inccommand = 'split'
  vim.o.cursorline = true
  vim.o.scrolloff = 10
  vim.o.termguicolors = true
  vim.o.hlsearch = true

  -- If performing an operation that would fail due to unsaved changes in the
  -- buffer (like `:q`), instead raise a dialog asking if you wish to save.
  vim.o.confirm = true
end

-- ============================================================
-- SECTION 2: KEYMAPS & AUTOCMDS
-- ============================================================
do
  -- Clear highlights on search when pressing <Esc> in normal mode
  vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

  -- Diagnostic config & keymaps
  vim.diagnostic.config {
    update_in_insert = false,
    severity_sort = true,
    float = { border = 'rounded', source = 'if_many' },
    underline = { severity = { min = vim.diagnostic.severity.WARN } },
    virtual_text = true,
    virtual_lines = false,
    -- Auto open the float, so you can easily read the errors when jumping with `[d` and `]d`
    jump = {
      on_jump = function(_, bufnr)
        vim.diagnostic.open_float { bufnr = bufnr, scope = 'cursor', focus = false }
      end,
    },
  }
  vim.keymap.set('n', '<leader>E', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
  vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

  -- Exit terminal mode in the builtin terminal with a shortcut that is a bit
  -- easier for people to discover than <C-\><C-n>.
  vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

  vim.keymap.set('i', 'jk', '<ESC>', { desc = 'Exit insert mode with jk' })

  -- Splits
  vim.keymap.set('n', '<leader>sv', '<C-w>v', { desc = '[S] plit window [V]ertically' })
  vim.keymap.set('n', '<leader>sh', '<C-w>s', { desc = '[S] plit window [H]orizontally' })
  vim.keymap.set('n', '<leader>se', '<C-w>=', { desc = 'Make split equal size' })
  vim.keymap.set('n', '<leader>sx', '<cmd>close<CR>', { desc = 'Close current split' })

  -- Tabs
  vim.keymap.set('n', '<leader>to', '<cmd>tabnew<CR>', { desc = 'Open new tab' })
  vim.keymap.set('n', '<leader>tx', '<cmd>tabclose<CR>', { desc = 'Close current tab' })
  vim.keymap.set('n', '<leader>tn', '<cmd>tabn<CR>', { desc = 'Go to next tab' })
  vim.keymap.set('n', '<leader>tp', '<cmd>tabp<CR>', { desc = 'Go to previous tab' })
  vim.keymap.set('n', '<leader>tf', '<cmd>tabnew %<CR>', { desc = 'Open current buffer in new tab' })

  -- NOTE: <C-hjkl> window navigation is intentionally NOT bound here.
  -- smart-splits.nvim (see custom/plugins/smart-splits.lua) owns <C-hjkl>
  -- with wezterm-aware pane navigation, which supersedes the plain
  -- kickstart default of `<C-w><C-h>` etc.

  -- Highlight when yanking (copying) text
  vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function()
      vim.hl.on_yank()
    end,
  })

  -- Per-filetype indent overrides for formatters that aren't 2-space-soft.
  -- These run on FileType (before guess-indent's BufReadPost), so guess-indent
  -- still wins for existing files where it detects a concrete style.
  local indent_group = vim.api.nvim_create_augroup('kickstart-indent', { clear = true })
  vim.api.nvim_create_autocmd('FileType', {
    desc = 'Python: 4-space indent (black)',
    group = indent_group,
    pattern = 'python',
    callback = function()
      vim.bo.tabstop = 4
      vim.bo.softtabstop = 4
      vim.bo.shiftwidth = 4
    end,
  })
  vim.api.nvim_create_autocmd('FileType', {
    desc = 'Go: real tabs (gofmt)',
    group = indent_group,
    pattern = { 'go', 'gomod', 'gowork', 'gotmpl' },
    callback = function()
      vim.bo.expandtab = false
      vim.bo.tabstop = 4
      vim.bo.shiftwidth = 4
    end,
  })
end

-- ============================================================
-- SECTION 3: PLUGIN MANAGER (vim.pack)
-- ============================================================
do
  -- See `:help vim.pack`.
  -- To check for updates:  :lua vim.pack.update(nil, { offline = true })
  -- To update plugins:     :lua vim.pack.update()

  local function run_build(name, cmd, cwd)
    local result = vim.system(cmd, { cwd = cwd }):wait()
    if result.code ~= 0 then
      local stderr = result.stderr or ''
      local stdout = result.stdout or ''
      local output = stderr ~= '' and stderr or stdout
      if output == '' then
        output = 'No output from build command.'
      end
      vim.notify(('Build failed for %s:\n%s'):format(name, output), vim.log.levels.ERROR)
    end
  end

  vim.api.nvim_create_autocmd('PackChanged', {
    callback = function(ev)
      local name = ev.data.spec.name
      local kind = ev.data.kind
      if kind ~= 'install' and kind ~= 'update' then
        return
      end

      if name == 'telescope-fzf-native.nvim' and vim.fn.executable 'make' == 1 then
        run_build(name, { 'make' }, ev.data.path)
        return
      end

      if name == 'LuaSnip' then
        if vim.fn.has 'win32' ~= 1 and vim.fn.executable 'make' == 1 then
          run_build(name, { 'make', 'install_jsregexp' }, ev.data.path)
        end
        return
      end

      if name == 'nvim-treesitter' then
        if not ev.data.active then
          vim.cmd.packadd 'nvim-treesitter'
        end
        vim.cmd 'TSUpdate'
        return
      end
    end,
  })
end

---Most plugins are hosted on GitHub; helper to cut down repetition.
---@param repo string
---@return string
local function gh(repo)
  return 'https://github.com/' .. repo
end

-- ============================================================
-- SECTION 4: UI / CORE UX PLUGINS
-- ============================================================
do
  -- Detect tabstop/shiftwidth/indent style automatically
  vim.pack.add { gh 'NMAC427/guess-indent.nvim' }
  require('guess-indent').setup {}

  -- Git signs in the gutter + hunk navigation/staging keymaps
  vim.pack.add { gh 'lewis6991/gitsigns.nvim' }
  require('gitsigns').setup {
    signs = {
      add = { text = '+' }, ---@diagnostic disable-line: missing-fields
      change = { text = '~' }, ---@diagnostic disable-line: missing-fields
      delete = { text = '_' }, ---@diagnostic disable-line: missing-fields
      topdelete = { text = '‾' }, ---@diagnostic disable-line: missing-fields
      changedelete = { text = '~' }, ---@diagnostic disable-line: missing-fields
    },
    on_attach = function(bufnr)
      local gitsigns = require 'gitsigns'

      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      -- Navigation
      map('n', ']c', function()
        if vim.wo.diff then
          vim.cmd.normal { ']c', bang = true }
        else
          gitsigns.nav_hunk 'next'
        end
      end, { desc = 'Jump to next git [c]hange' })

      map('n', '[c', function()
        if vim.wo.diff then
          vim.cmd.normal { '[c', bang = true }
        else
          gitsigns.nav_hunk 'prev'
        end
      end, { desc = 'Jump to previous git [c]hange' })

      -- Actions
      map('v', '<leader>hs', function()
        gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
      end, { desc = 'stage git hunk' })
      map('v', '<leader>hr', function()
        gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
      end, { desc = 'reset git hunk' })
      map('n', '<leader>hs', gitsigns.stage_hunk, { desc = 'git [s]tage hunk' })
      map('n', '<leader>hr', gitsigns.reset_hunk, { desc = 'git [r]eset hunk' })
      map('n', '<leader>hS', gitsigns.stage_buffer, { desc = 'git [S]tage buffer' })
      map('n', '<leader>hu', gitsigns.undo_stage_hunk, { desc = 'git [u]ndo stage hunk' })
      map('n', '<leader>hR', gitsigns.reset_buffer, { desc = 'git [R]eset buffer' })
      map('n', '<leader>hp', gitsigns.preview_hunk, { desc = 'git [p]review hunk' })
      map('n', '<leader>hb', gitsigns.blame_line, { desc = 'git [b]lame line' })
      map('n', '<leader>hd', gitsigns.diffthis, { desc = 'git [d]iff against index' })
      map('n', '<leader>hD', function()
        gitsigns.diffthis '@'
      end, { desc = 'git [D]iff against last commit' })
      map('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = '[T]oggle git show [b]lame line' })
      map('n', '<leader>tD', gitsigns.toggle_deleted, { desc = '[T]oggle git show [D]eleted' })
    end,
  }

  -- Pending-keybind popup
  vim.pack.add { gh 'folke/which-key.nvim' }
  require('which-key').setup {
    delay = 0,
    icons = { mappings = vim.g.have_nerd_font },
    spec = {
      { '<leader>s', group = '[S]earch', mode = { 'n', 'v' } },
      { '<leader>t', group = '[T]oggle / [T]ab' },
      { '<leader>w', group = '[W]orkspace / session' },
      { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
      { '<leader>e', group = 'Filetree Explorer' },
      { '<leader>c', group = '[C]ode' },
      { '<leader>d', group = '[D]ocument' },
      { '<leader>r', group = '[R]ename' },
    },
  }

  -- [[ Colorscheme ]]
  vim.pack.add { { src = 'https://github.com/catppuccin/nvim', name = 'catppuccin' } }
  require('catppuccin').setup {
    auto_integrations = true,
  }

  vim.cmd.colorscheme 'catppuccin-mocha'
  -- vim.pack.add { gh 'loctvl842/monokai-pro.nvim' }
  -- require('monokai-pro').setup {
  --   transparent_background = false,
  --   devicons = true,
  --   filter = 'pro',
  --   styles = {
  --     type = { italic = true },
  --     comment = { italic = true },
  --     keyword = { italic = true },
  --     structure = { italic = true },
  --     annotation = { italic = true },
  --   },
  --   plugins = {
  --     bufferline = {
  --       underline_selected = false,
  --       underline_visible = false,
  --       underline_fill = true,
  --       bold = false,
  --     },
  --     indent_blankline = {
  --       context_highlight = 'pro',
  --       context_start_underline = true,
  --     },
  --   },
  --   override = function()
  --     return {
  --       ['@keyword.javascript'] = { fg = '#78dce8' },
  --       ['@lsp.type.parameter.javascript'] = { fg = '#ffffff' },
  --       ['@variable.member.javascript'] = { fg = '#ffffff' },
  --     }
  --   end,
  -- }
  -- require('monokai-pro').load()

  -- Highlight todo, notes, etc in comments
  vim.pack.add { gh 'folke/todo-comments.nvim' }
  require('todo-comments').setup { signs = false }

  -- [[ mini.nvim ]] (org moved from echasnovski/mini.nvim to nvim-mini/mini.nvim)
  vim.pack.add { gh 'nvim-mini/mini.nvim' }

  -- mini.icons replaces nvim-web-devicons; mock it so plugins that call
  -- require('nvim-web-devicons') (telescope, bufferline, lualine, neo-tree)
  -- keep working without installing the real plugin.
  if vim.g.have_nerd_font then
    require('mini.icons').setup()
    MiniIcons.mock_nvim_web_devicons()
  end

  require('mini.ai').setup {
    mappings = { around_next = 'aa', inside_next = 'ii' },
    n_lines = 500,
  }
  require('mini.surround').setup()
end

-- ============================================================
-- SECTION 5: SEARCH & NAVIGATION (Telescope)
-- ============================================================
do
  ---@type (string|vim.pack.Spec)[]
  local telescope_plugins = {
    gh 'nvim-lua/plenary.nvim',
    gh 'nvim-telescope/telescope.nvim',
    gh 'nvim-telescope/telescope-ui-select.nvim',
  }
  if vim.fn.executable 'make' == 1 then
    table.insert(telescope_plugins, gh 'nvim-telescope/telescope-fzf-native.nvim')
  end
  vim.pack.add(telescope_plugins)

  require('telescope').setup {
    defaults = {
      path_display = { 'smart' },
    },
    extensions = {
      ['ui-select'] = { require('telescope.themes').get_dropdown() },
    },
  }

  pcall(require('telescope').load_extension, 'fzf')
  pcall(require('telescope').load_extension, 'ui-select')

  local builtin = require 'telescope.builtin'
  -- vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
  vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
  vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
  vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
  vim.keymap.set({ 'n', 'v' }, '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
  vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
  vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
  vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
  vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
  vim.keymap.set('n', '<leader>sc', builtin.commands, { desc = '[S]earch [C]ommands' })
  vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

  -- Telescope-backed LSP pickers, bound on LspAttach
  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('telescope-lsp-attach', { clear = true }),
    callback = function(event)
      local buf = event.buf
      vim.keymap.set('n', 'gd', builtin.lsp_definitions, { buffer = buf, desc = '[G]oto [D]efinition' })
      vim.keymap.set('n', 'gr', builtin.lsp_references, { buffer = buf, desc = '[G]oto [R]eferences' })
      vim.keymap.set('n', 'gI', builtin.lsp_implementations, { buffer = buf, desc = '[G]oto [I]mplementation' })
      vim.keymap.set('n', '<leader>D', builtin.lsp_type_definitions, { buffer = buf, desc = 'Type [D]efinition' })
      vim.keymap.set('n', '<leader>ds', builtin.lsp_document_symbols, { buffer = buf, desc = '[D]ocument [S]ymbols' })
      vim.keymap.set('n', '<leader>wS', builtin.lsp_dynamic_workspace_symbols, { buffer = buf, desc = '[W]orkspace [S]ymbols' })
    end,
  })

  vim.keymap.set('n', '<leader>/', function()
    builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown { winblend = 10, previewer = false })
  end, { desc = '[/] Fuzzily search in current buffer' })

  vim.keymap.set('n', '<leader>s/', function()
    builtin.live_grep { grep_open_files = true, prompt_title = 'Live Grep in Open Files' }
  end, { desc = '[S]earch [/] in Open Files' })

  vim.keymap.set('n', '<leader>sn', function()
    builtin.find_files { cwd = vim.fn.stdpath 'config', follow = true }
  end, { desc = '[S]earch [N]eovim files' })
end

-- ============================================================
-- SECTION 6: LSP
-- ============================================================
do
  vim.pack.add { gh 'j-hui/fidget.nvim' }
  require('fidget').setup {}

  -- Default config applied to every server: keep inlay hints off unless
  -- toggled on with <leader>th (see the LspAttach autocmd below).
  vim.lsp.config('*', {
    on_attach = function(_, bufnr)
      vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })
    end,
  })

  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
    callback = function(event)
      local map = function(keys, func, desc, mode)
        mode = mode or 'n'
        vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
      end

      map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
      map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })
      map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
      map('K', vim.lsp.buf.hover, 'Hover Documentation')

      -- Highlight references of the word under the cursor while it rests there
      local client = vim.lsp.get_client_by_id(event.data.client_id)
      if client and client:supports_method('textDocument/documentHighlight', event.buf) then
        local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
        vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
          buffer = event.buf,
          group = highlight_augroup,
          callback = vim.lsp.buf.document_highlight,
        })

        vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
          buffer = event.buf,
          group = highlight_augroup,
          callback = vim.lsp.buf.clear_references,
        })

        vim.api.nvim_create_autocmd('LspDetach', {
          group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
          callback = function(event2)
            vim.lsp.buf.clear_references()
            vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
          end,
        })
      end

      -- Toggle inlay hints, if the server supports them
      if client and client:supports_method('textDocument/inlayHint', event.buf) then
        map('<leader>th', function()
          vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
        end, '[T]oggle Inlay [H]ints')
      end
    end,
  })

  -- Enable the following language servers.
  -- See `:help lsp-config` for available keys.
  ---@type table<string, vim.lsp.Config>
  local servers = {
    gopls = {},
    eslint = {},
    cssls = {},
    html = {},
    jsonls = {},
    pyright = {},
    ruff = {
      on_attach = function(client)
        -- pyright already provides hover; avoid duplicate hover popups from ruff
        client.server_capabilities.hoverProvider = false
      end,
    },
    ts_ls = {
      init_options = {
        preferences = {
          disableSuggestions = true,
        },
      },
    },

    -- Special Lua config, as recommended by the Neovim help docs
    lua_ls = {
      on_init = function(client)
        client.server_capabilities.documentFormattingProvider = false -- formatting is done by stylua via conform

        if client.workspace_folders then
          local path = client.workspace_folders[1].name
          if path ~= vim.fn.stdpath 'config' and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc')) then
            return
          end
        end

        local current_settings = client.config.settings --[[@as lspconfig.settings.lua_ls]]
        client.config.settings.Lua = vim.tbl_deep_extend('force', current_settings.Lua, {
          runtime = {
            version = 'LuaJIT',
            path = { 'lua/?.lua', 'lua/?/init.lua' },
          },
          workspace = {
            checkThirdParty = false,
            library = vim.api.nvim_get_runtime_file('', true),
          },
        })
      end,
      ---@type lspconfig.settings.lua_ls
      settings = {
        Lua = {
          completion = { callSnippet = 'Replace' },
          format = { enable = false }, -- formatting is done by stylua via conform
        },
      },
    },
  }

  vim.pack.add {
    gh 'neovim/nvim-lspconfig',
    gh 'mason-org/mason.nvim',
    gh 'mason-org/mason-lspconfig.nvim',
    gh 'WhoIsSethDaniel/mason-tool-installer.nvim',
  }

  require('mason').setup()

  -- automatic_enable = false: we explicitly vim.lsp.enable() below instead
  require('mason-lspconfig').setup { automatic_enable = false }

  local ensure_installed = vim.tbl_keys(servers or {})
  vim.list_extend(ensure_installed, {
    'tailwindcss',
    'stylua', -- Used to format Lua code
    'prettier',
    'isort',
    'black',
    'pylint',
  })
  require('mason-tool-installer').setup { ensure_installed = ensure_installed }

  for name, server in pairs(servers) do
    vim.lsp.config(name, server)
    vim.lsp.enable(name)
  end
end

-- ============================================================
-- SECTION 7: FORMATTING
-- ============================================================
do
  vim.pack.add { gh 'stevearc/conform.nvim' }
  require('conform').setup {
    notify_on_error = false,
    format_on_save = function(bufnr)
      -- Languages without a well standardized coding style skip LSP fallback formatting
      local disable_filetypes = { c = true, cpp = true }
      return {
        timeout_ms = 500,
        lsp_format = disable_filetypes[vim.bo[bufnr].filetype] and 'never' or 'fallback',
      }
    end,
    default_format_opts = {
      lsp_format = 'fallback',
    },
    formatters_by_ft = {
      javascript = { 'prettier' },
      typescript = { 'prettier' },
      javascriptreact = { 'prettier' },
      typescriptreact = { 'prettier' },
      svelte = { 'prettier' },
      css = { 'prettier' },
      html = { 'prettier' },
      json = { 'prettier' },
      yaml = { 'prettier' },
      markdown = { 'prettier' },
      graphql = { 'prettier' },
      liquid = { 'prettier' },
      lua = { 'stylua' },
      python = { 'isort', 'black' },
      go = { { 'gofmt' } },
    },
  }

  vim.keymap.set({ 'n', 'v' }, '<leader>f', function()
    require('conform').format { async = true }
  end, { desc = '[F]ormat buffer' })
end

-- ============================================================
-- SECTION 8: AUTOCOMPLETE & SNIPPETS (blink.cmp)
-- ============================================================
do
  -- [[ Snippet engine ]]
  vim.pack.add { { src = gh 'L3MON4D3/LuaSnip', version = vim.version.range '2.*' } }
  require('luasnip').setup {}

  vim.pack.add { gh 'rafamadriz/friendly-snippets' }
  require('luasnip.loaders.from_vscode').lazy_load()

  -- [[ Autocomplete engine ]]
  vim.pack.add { { src = gh 'saghen/blink.cmp', version = vim.version.range '1.*' } }
  require('blink.cmp').setup {
    keymap = { preset = 'default' },

    appearance = {
      nerd_font_variant = 'mono',
    },

    completion = {
      documentation = { auto_show = false, auto_show_delay_ms = 500 },
      -- Auto-insert `()` after accepting a function/method completion
      -- (replaces the old nvim-autopairs + nvim-cmp integration).
      accept = { auto_brackets = { enabled = true } },
    },

    sources = {
      default = { 'lsp', 'path', 'snippets' },
    },

    snippets = { preset = 'luasnip' },

    fuzzy = { implementation = 'lua' },

    signature = { enabled = true },
  }
end

-- ============================================================
-- SECTION 9: TREESITTER
-- ============================================================
do
  vim.pack.add { { src = gh 'nvim-treesitter/nvim-treesitter', version = 'main' } }

  local parsers = {
    'bash',
    'c',
    'css',
    'diff',
    'go',
    'html',
    'javascript',
    'lua',
    'luadoc',
    'markdown',
    'markdown_inline',
    'query',
    'tsx',
    'vim',
    'vimdoc',
  }
  require('nvim-treesitter').install(parsers)

  ---@param buf integer
  ---@param language string
  local function treesitter_try_attach(buf, language)
    if not vim.treesitter.language.add(language) then
      return
    end
    vim.treesitter.start(buf, language)

    local has_indent_query = vim.treesitter.query.get(language, 'indents') ~= nil
    if has_indent_query then
      vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end

  local available_parsers = require('nvim-treesitter').get_available()
  vim.api.nvim_create_autocmd('FileType', {
    callback = function(args)
      local buf, filetype = args.buf, args.match
      local language = vim.treesitter.language.get_lang(filetype)
      if not language then
        return
      end

      local installed_parsers = require('nvim-treesitter').get_installed 'parsers'
      if vim.tbl_contains(installed_parsers, language) then
        treesitter_try_attach(buf, language)
      elseif vim.tbl_contains(available_parsers, language) then
        require('nvim-treesitter').install(language):await(function()
          treesitter_try_attach(buf, language)
        end)
      else
        treesitter_try_attach(buf, language)
      end
    end,
  })
end

-- ============================================================
-- SECTION 10: KICKSTART EXTRA PLUGINS & CUSTOM PLUGINS
-- ============================================================
do
  require 'kickstart.plugins.autopairs'
  require 'kickstart.plugins.neo-tree'

  -- Your own plugins, see lua/custom/plugins/*.lua
  require 'custom.plugins'
end

-- vim: ts=2 sts=2 sw=2 et
