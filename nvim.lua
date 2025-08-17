-- vim: ts=2 sts=2 sw=2 et
--[[ VARIABLES ]]
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true
vim.g.format_on_save = true

-- [[ OPTIONS ]]
vim.o.number = true
vim.o.relativenumber = true
vim.o.mouse = 'a'
vim.o.showmode = false
vim.o.showcmd = false
vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)
vim.o.breakindent = true
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.signcolumn = 'yes'
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.timeout = false
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.termguicolors = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.o.inccommand = 'split'
vim.o.incsearch = false -- Incompatible with noice.nvim
vim.o.cursorline = true
vim.o.scrolloff = 5
vim.o.sidescrolloff = 10
vim.o.wrap = false
vim.o.confirm = true
vim.o.cinkeys = vim.o.cinkeys .. ',!<Tab>'
vim.o.indentkeys = vim.o.indentkeys .. ',!<Tab>'
vim.o.foldmethod = 'expr'
vim.o.foldcolumn = '1'
vim.o.foldminlines = 7
vim.o.foldlevelstart = 999

-- [[ FUNCTIONS ]]
local function win_is_landscape()
  if vim.api.nvim_win_get_width(0) < vim.api.nvim_win_get_height(0) * 2.75 then
    return false
  else
    return true
  end
end

local function split_dynamic()
  return vim.api.nvim_open_win(0, true, {
    vertical = win_is_landscape(),
  })
end

local function close_if_empty(win)
  vim.schedule(function()
    vim.fn.win_gotoid(win)
    if vim.fn.wordcount()['chars'] == 0 then
      vim.cmd [[bdelete]]
    end
  end)
end

-- [[ KEYMAPS ]]
vim.keymap.set({ 'n', 'x' }, '<s-u>', '<c-r>')
vim.keymap.set({ 'n', 'x' }, '<esc>', '<cmd>nohlsearch<cr><esc>')
vim.keymap.set('t', '<esc><esc>', '<c-\\><c-n>', { desc = 'Exit terminal mode' })
vim.keymap.set({ 'n', 'x', 'o' }, 'j', 'gj')
vim.keymap.set({ 'n', 'x', 'o' }, 'k', 'gk')
-- H and L jump to end of visual line if text is wrapped, real line if not
vim.keymap.set({ 'n', 'x', 'o' }, 'H', function()
  if vim.wo.wrap then
    return 'g^'
  else
    return '^'
  end
end, { expr = true, noremap = true })
vim.keymap.set({ 'n', 'x', 'o' }, 'L', function()
  if vim.wo.wrap then
    return 'g$'
  else
    return '$'
  end
end, { expr = true, noremap = true })

-- Leader menu
vim.keymap.set({ 'n', 'x' }, '<leader>l', '<CMD>Lazy<CR>', { desc = '[l]azy Package Manager' })
vim.keymap.set({ 'n', 'x' }, '<leader>q', '<CMD>q<CR>', { desc = '[q]uit Neovim' })
vim.keymap.set({ 'n', 'x' }, '<leader>H', '<CMD>helpclose<CR>', { desc = 'Close [H]elp' })

-- B - buffer
vim.keymap.set({ 'n', 'x' }, '<leader>bC', '<CMD>hide<CR>', { desc = '[C]lose Buffer & Window' })
vim.keymap.set({ 'n', 'x' }, '<leader>bn', '<CMD>enew<CR>', { desc = '[n]ew Buffer' })
vim.keymap.set({ 'n', 'x' }, '<leader>bs', function()
  split_dynamic()
  vim.cmd [[enew]]
end, { desc = 'New Buffer in [s]plit' })
vim.keymap.set({ 'n', 'x' }, '<leader>bd', '<CMD>bdelete<CR>', { desc = '[d]elete Buffer & Window' })
-- C - code
vim.keymap.set({ 'n', 'x' }, '<leader>ca', vim.lsp.buf.code_action, { desc = 'List LSP [a]ctions' })
vim.keymap.set({ 'n', 'x' }, '<leader>cr', vim.lsp.buf.rename, { desc = 'LSP [r]ename Symbol' })

-- F - file
vim.keymap.set({ 'n', 'x' }, '<leader>fw', '<CMD>w<CR>', { desc = '[w]rite' })
vim.keymap.set({ 'n', 'x' }, '<leader>fW', '<CMD>wq<CR>', { desc = '[W]rite & Close' })
vim.keymap.set({ 'n', 'x' }, '<leader>fs', function()
  vim.ui.input({
    prompt = 'Save as: ',
    completion = 'dir',
    default = vim.fn.getcwd() .. '/' .. vim.fn.expand '%',
  }, function(input)
    if input then
      vim.cmd('saveas ++p' .. input)
    end
  end)
end, { desc = '[s]ave as...' })
vim.keymap.set({ 'n', 'x' }, '<leader>fc', '<CMD>edit ' .. vim.fn.stdpath 'config' .. '/init.lua<CR>', { desc = 'Open [c]onfig' })

-- W - window
vim.keymap.set({ 'n', 'x', 'i' }, '<a-left>', '<CMD>vertical resize -4<CR>', { desc = 'Shrink window horizontally' })
vim.keymap.set({ 'n', 'x', 'i' }, '<a-down>', '<CMD>resize -4<CR>', { desc = 'Shrink window vertically' })
vim.keymap.set({ 'n', 'x', 'i' }, '<a-up>', '<CMD>resize +4<CR>', { desc = 'Expand window vertically' })
vim.keymap.set({ 'n', 'x', 'i' }, '<a-right>', '<CMD>vertical resize +4<CR>', { desc = 'Expand window horizontally' })

vim.keymap.set({ 'n', 'x' }, '<leader>w<a-h>', '<CMD>vertical resize -16<CR>', { desc = 'Shrink window horizontally' })
vim.keymap.set({ 'n', 'x' }, '<leader>w<a-j>', '<CMD>resize -16<CR>', { desc = 'Shrink window vertically' })
vim.keymap.set({ 'n', 'x' }, '<leader>w<a-k>', '<CMD>resize +16<CR>', { desc = 'Expand window vertically' })
vim.keymap.set({ 'n', 'x' }, '<leader>w<a-l>', '<CMD>vertical resize +16<CR>', { desc = 'Expand window horizontally' })
vim.keymap.set({ 'n', 'x' }, '<leader>w=', '<c-w>=', { desc = 'Equalize window sizes' })

vim.keymap.set({ 'n', 'x' }, '<leader>wh', '<c-w>h', { desc = 'Shift focus one window left' })
vim.keymap.set({ 'n', 'x' }, '<leader>wj', '<c-w>j', { desc = 'Shift focus one window down' })
vim.keymap.set({ 'n', 'x' }, '<leader>wk', '<c-w>k', { desc = 'Shift focus one window up' })
vim.keymap.set({ 'n', 'x' }, '<leader>wl', '<c-w>l', { desc = 'Shift focus one window right' })
vim.keymap.set({ 'n', 'x' }, '<leader>ww', '<c-w>w', { desc = 'Shift focus to next window' })
vim.keymap.set({ 'n', 'x' }, '<leader>wW', '<c-w>W', { desc = 'Shift focus to previous window' })

vim.keymap.set({ 'n', 'x' }, '<leader>wH', '<c-w>H', { desc = 'Shift window to the left' })
vim.keymap.set({ 'n', 'x' }, '<leader>wJ', '<c-w>J', { desc = 'Shift window to the bottom' })
vim.keymap.set({ 'n', 'x' }, '<leader>wK', '<c-w>K', { desc = 'Shift window to the top' })
vim.keymap.set({ 'n', 'x' }, '<leader>wL', '<c-w>L', { desc = 'Shift window to the right' })
vim.keymap.set({ 'n', 'x' }, '<leader>wx', '<c-w>x', { desc = 'E[x]change windows' })

vim.keymap.set({ 'n', 'x' }, '<leader>wc', '<c-w>c', { desc = '[c]lose window' })
vim.keymap.set({ 'n', 'x' }, '<leader>wC', '<c-w>o', { desc = '[C]lose all other windows' })

vim.keymap.set({ 'n', 'x' }, '<leader>ws', split_dynamic, { desc = 'Open new [s]plit' })

-- T - toggle
vim.keymap.set({ 'n', 'x' }, '<leader>tc', function()
  vim.o.number = not vim.o.number
  vim.o.relativenumber = not vim.o.relativenumber
  vim.o.signcolumn = (vim.o.signcolumn == 'yes' and 'no') or 'yes'
  vim.o.foldcolumn = (vim.o.foldcolumn == '1' and '0') or '1'
end, { desc = 'Toggle side [c]olumns' })
vim.keymap.set({ 'n', 'x' }, '<leader>td', function()
  vim.diagnostic.config {
    virtual_lines = not vim.diagnostic.config().virtual_lines,
  }
end, { desc = 'Toggle [d]iagnostic Format' })
vim.keymap.set({ 'n', 'x' }, '<leader>tf', function()
  local fmt = vim.b.format_on_save
  vim.b.format_on_save = not fmt
  print('Format on Write ' .. ((fmt and 'Disabled.') or 'Enabled.'))
end, { desc = 'Toggle [f]ormat On Write in Buffer' })
vim.keymap.set({ 'n', 'x' }, '<leader>tF', function()
  local fmt = vim.g.format_on_save
  vim.g.format_on_save = not fmt
  vim.b.format_on_save = not fmt
  print('Format on Write ' .. ((fmt and 'Disabled.') or 'Enabled.'))
end, { desc = 'Toggle [F]ormat On Write in Session' })

-- [[ DIAGNOSTICS ]]
vim.diagnostic.config {
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  underline = { severity = vim.diagnostic.severity.ERROR },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '󰅚 ',
      [vim.diagnostic.severity.WARN] = '󰀪 ',
      [vim.diagnostic.severity.INFO] = '󰋽 ',
      [vim.diagnostic.severity.HINT] = '󰌶 ',
    },
  },
  virtual_lines = true,
}

-- [[ LSP ]]
vim.lsp.enable {
  'lua_ls',
  'cssls',
}

-- [[ AUTOCOMMANDS ]]
-- Open :help vertically
vim.api.nvim_create_autocmd('BufWinEnter', {
  pattern = { '*.txt', [[*(\d)]] },
  callback = function()
    if (vim.bo.filetype == 'help' or vim.bo.filetype == 'man') and vim.api.nvim_win_get_width(0) > vim.api.nvim_win_get_height(0) * 5.5 then
      vim.cmd 'wincmd L'
    end
  end,
})
-- Set global variables in new buffers
vim.api.nvim_create_autocmd('BufWinEnter', {
  callback = function(e)
    vim.b[e.buf].format_on_save = vim.g.format_on_save
  end,
})

-- [[ PLUGIN MANAGER ]]
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
      { out, 'WarningMsg' },
      { '\nPress any key to exit...' },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- [[ PLUGINS ]]
require('lazy').setup {
  -- LSP configurations
  'neovim/nvim-lspconfig',

  -- Treesitter parser installer
  ---@type LazySpec
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false,
    build = ':TSUpdate',
    config = function()
      local parsers = {
        'lua',
        'hyprlang',
      }
      require('nvim-treesitter').install(parsers)
      vim.api.nvim_create_autocmd('FileType', {
        pattern = parsers,
        callback = function()
          vim.treesitter.start()
          vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
  },

  -- Configuration LSP
  ---@type LazySpec
  {
    'folke/lazydev.nvim',
    lazy = true,
    ft = 'lua',
    opts = {
      library = {
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },

  -- Indent tools
  ---@type LazySpec
  {
    'NMAC427/guess-indent.nvim',
    lazy = true,
    event = 'BufReadPost',
    opts = {},
  },

  -- Formatter
  ---@type LazySpec
  ---@module 'conform'
  {
    'stevearc/conform.nvim',
    lazy = true,
    event = 'BufWritePre',
    cmd = 'ConformInfo',
    ---@type conform.setupOpts
    opts = {
      default_format_opts = {
        lsp_format = 'fallback',
        stop_after_first = true,
      },
      formatters_by_ft = {
        lua = { 'stylua' },
      },
      format_on_save = function(bufnr)
        if vim.g.format_on_save and vim.b[bufnr].format_on_save then
          return { timeout_ms = 500, lsp_format = 'fallback' }
        else
          return nil
        end
      end,
    },
    keys = {
      {
        '<leader>bf',
        function()
          require('conform').format({ async = true }, function(err)
            if not err then
              local mode = vim.api.nvim_get_mode().mode
              if vim.startswith(string.lower(mode), 'v') then
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', true)
              end
            end
          end)
        end,
        desc = '[f]ormat Buffer',
      },
    },
  },

  -- Autocompletion
  ---@type LazySpec
  {
    'saghen/blink.cmp',
    lazy = true,
    event = 'BufReadPost',
    version = '1.*',
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
      -- 'super-tab' for mappings similar to vscode (tab to accept)
      -- 'enter' for enter to accept
      -- 'none' for no mappings
      --
      -- All presets have the following mappings:
      -- C-space: Open menu or open docs if already open
      -- C-n/C-p or Up/Down: Select next/previous item
      -- C-e: Hide menu
      -- C-k: Toggle signature help (if signature.enabled = true)
      --
      -- See :h blink-cmp-config-keymap for defining your own keymap
      keymap = { preset = 'default' },

      appearance = {
        nerd_font_variant = 'mono',
      },
      completion = {
        documentation = { auto_show = false },
      },
      sources = {
        default = { 'lazydev', 'lsp', 'path', 'snippets', 'buffer' },
        providers = {
          lazydev = {
            name = 'LazyDev',
            module = 'lazydev.integrations.blink',
            score_offset = 100,
          },
        },
      },
      snippets = { preset = 'mini_snippets' },
      cmdline = {
        enabled = false,
      },
      fuzzy = { implementation = 'prefer_rust_with_warning' },
    },
    opts_extend = { 'sources.default' },
  },

  -- File loading optimizations, Splash screen, Indent markers, Notifications, Input UI, Fuzzy finder, Picker
  ---@type LazySpec
  {
    'folke/snacks.nvim',
    lazy = false,
    priority = 1000,
    ---@module 'snacks'
    ---@type snacks.Config
    opts = {
      quickfile = { enabled = true },
      bigfile = { enabled = true },
      dashboard = { enabled = true },
      input = { enabled = true },
      notifier = { enabled = true },
      bufdelete = { enabled = true },
      indent = {
        animate = {
          enabled = false,
        },
      },
      picker = { enabled = true },
    },
    keys = {
      -- Leader
      {
        '<leader> ',
        function()
          Snacks.picker.smart()
        end,
        mode = { 'n', 'x' },
        desc = 'Search Files by Name',
      },
      {
        '<leader>/',
        function()
          Snacks.picker.grep()
        end,
        mode = { 'n', 'x' },
        desc = 'Search Files by Content',
      },
      {
        '<leader>,',
        function()
          Snacks.picker.buffers()
        end,
        mode = { 'n', 'x' },
        desc = 'Search Buffers',
      },
      {
        '<leader>h',
        function()
          Snacks.picker.help()
        end,
        mode = { 'n', 'x' },
        desc = 'Search [h]elp',
      },
      {
        '<leader>p',
        function()
          Snacks.picker.yanky()
        end,
        mode = { 'n', 'x' },
        desc = '[p]ut From Yankring',
      },
      -- B - buffer
      {
        '<leader>bb',
        function()
          Snacks.picker.buffers()
        end,
        mode = { 'n', 'x' },
        desc = 'Search [b]uffers',
      },
      {
        '<leader>bc',
        function()
          Snacks.bufdelete()
        end,
        mode = { 'n', 'x' },
        desc = '[c]lose Buffer',
      },
      {
        '<leader>bo',
        function()
          Snacks.bufdelete.other()
        end,
        mode = { 'n', 'x' },
        desc = 'Close [o]ther Buffers',
      },
      -- F - file
      {
        '<leader>ff',
        function()
          Snacks.picker.files()
        end,
        mode = { 'n', 'x' },
        desc = 'Search [f]iles in CWD',
      },
      {
        '<leader>fF',
        function()
          Snacks.picker.files { dirs = { '~' } }
        end,
        mode = { 'n', 'x' },
        desc = 'Search [F]iles in Home',
      },
      {
        '<leader>fs',
        function()
          local win = split_dynamic()
          vim.cmd [[enew]]
          Snacks.picker.files {
            on_close = function()
              close_if_empty(win)
            end,
          }
        end,
        mode = { 'n', 'x' },
        desc = 'Search CWD & Open in [s]plit',
      },
      {
        '<leader>fS',
        function()
          local win = split_dynamic()
          vim.cmd [[enew]]
          Snacks.picker.files {
            dirs = { '~' },
            on_close = function()
              close_if_empty(win)
            end,
          }
        end,
        mode = { 'n', 'x' },
        desc = 'Search Home & Open in [S]plit',
      },
      -- S - search
      {
        '<leader>sa',
        function()
          Snacks.picker.autocmds()
        end,
        mode = { 'n', 'x' },
        desc = '[a]utocmds',
      },
      {
        '<leader>sb',
        function()
          Snacks.picker.lines()
        end,
        mode = { 'n', 'x' },
        desc = 'Current [b]uffer',
      },
      {
        '<leader>sB',
        function()
          Snacks.picker.grep_buffers()
        end,
        mode = { 'n', 'x' },
        desc = 'Open [B]uffers',
      },
      {
        '<leader>sc',
        function()
          Snacks.picker.commands()
        end,
        mode = { 'n', 'x' },
        desc = '[c]ommands',
      },
      {
        '<leader>sd',
        function()
          Snacks.picker.diagnostics()
        end,
        mode = { 'n', 'x' },
        desc = '[d]iagnostics',
      },
      {
        '<leader>sh',
        function()
          Snacks.picker.help()
        end,
        mode = { 'n', 'x' },
        desc = '[h]elp',
      },
      {
        '<leader>sH',
        function()
          Snacks.picker.highlights()
        end,
        mode = { 'n', 'x' },
        desc = '[H]ighlights',
      },
      {
        '<leader>si',
        function()
          Snacks.picker.icons()
        end,
        mode = { 'n', 'x' },
        desc = '[i]cons',
      },
      {
        '<leader>sj',
        function()
          Snacks.picker.jumps()
        end,
        mode = { 'n', 'x' },
        desc = '[j]umps',
      },
      {
        '<leader>sk',
        function()
          Snacks.picker.keymaps()
        end,
        mode = { 'n', 'x' },
        desc = '[k]eymaps',
      },
      {
        '<leader>sl',
        function()
          Snacks.picker.loclist()
        end,
        mode = { 'n', 'x' },
        desc = '[l]ocation List',
      },
      {
        '<leader>sm',
        function()
          Snacks.picker.marks()
        end,
        mode = { 'n', 'x' },
        desc = '[m]arks',
      },
      {
        '<leader>sM',
        function()
          Snacks.picker.man()
        end,
        mode = { 'n', 'x' },
        desc = '[M]an Pages',
      },
      {
        '<leader>sq',
        function()
          Snacks.picker.qflist()
        end,
        mode = { 'n', 'x' },
        desc = '[q]uickfix List',
      },
      {
        '<leader>su',
        function()
          Snacks.picker.undo()
        end,
        mode = { 'n', 'x' },
        desc = '[u]ndo History',
      },
      {
        '<leader>s/',
        function()
          Snacks.picker.grep()
        end,
        mode = { 'n', 'x' },
        desc = 'Files by Content',
      },
    },
  },

  -- Diagnostics window
  ---@type LazySpec
  ---@module 'trouble'
  {
    'folke/trouble.nvim',
    lazy = true,
    cmd = 'Trouble',
    ---@type trouble.Config
    opts = {
      auto_preview = false,
      auto_refresh = false,
      open_no_results = true,
      restore = true,
      focus = true,
    },
    keys = {
      {
        '<leader>cd',
        '<CMD>Trouble diagnostics toggle filter.buf=0<CR>',
        mode = { 'n', 'x' },
        desc = 'Toggle Buffer [d]iagnostics',
      },
      {
        '<leader>cD',
        '<CMD>Trouble toggle diagnostics<CR>',
        mode = { 'n', 'x' },
        desc = 'Toggle Active [D]iagnostics',
      },
      {
        '<leader>cs',
        '<CMD>Trouble toggle lsp_document_symbols win.position=right<CR>',
        mode = { 'n', 'x' },
        desc = 'Toggle [s]ymbols in Buffer',
      },
      {
        '<leader>cl',
        '<CMD>Trouble lsp toggle win.position=right<CR>',
        mode = { 'n', 'x' },
        desc = 'Toggle [l]SP Under Cursor',
      },
    },
  },
  ---@type LazySpec
  ---@module 'sniprun'
  {
    'michaelb/sniprun',
    lazy = true,
    build = 'sh install.sh 1',
    cmd = {
      'SnipRun',
      'SnipInfo',
      'SnipReset',
      'SnipReplMemoryClean',
      'SnipClose',
      'SnipLive',
    },
    config = function()
      require('sniprun').setup {
        selected_interpreters = {
          'Lua_nvim',
        },
        display = {
          'Classic',
        },
      }
    end,
    keys = {
      { '<leader>cr', '<CMD>SnipRun<CR>', desc = '[r]un Line in REPL' },
      { '<leader>cr', '<Plug>SnipRun', mode = 'x', desc = '[r]un Snippet in REPL' },
      { '<leader>cR', '<Plug>SnipReplMemoryClean', mode = { 'n', 'x' }, desc = '[R]eset REPL' },
      { 'S', '<Plug>SnipRunOperator', desc = 'Run [S]nippet' },
      { 'S', '<Plug>SnipRun', mode = 'x', desc = 'Run [S]nippet' },
    },
  },

  -- Textobjects, ALT moving, Autopairing, Surround macros, f and t extensions,
  -- Git signals, Comment macros, Nerdfont icons, Which-key popups
  ---@type LazySpec
  {
    'echasnovski/mini.nvim',
    lazy = false,
    priority = 1000,
    dependencies = {
      'rafamadriz/friendly-snippets',
    },
    config = function()
      require('mini.ai').setup()
      require('mini.move').setup()
      require('mini.pairs').setup()
      require('mini.surround').setup()
      require('mini.jump').setup()
      require('mini.diff').setup()
      require('mini.comment').setup()
      require('mini.icons').setup()
      local hipatterns = require 'mini.hipatterns'
      hipatterns.setup {
        highlighters = {
          fixme = { pattern = '%f[%w]FIXME:?%f[^%w:]', group = 'MiniHipatternsFixme' },
          hack = { pattern = '%f[%w]HACK:?%f[^%w:]', group = 'MiniHipatternsHack' },
          todo = { pattern = '%f[%w]TODO:?%f[^%w:]', group = 'MiniHipatternsTodo' },
          note = { pattern = '%f[%w]NOTE:?%f[^%w:]', group = 'MiniHipatternsNote' },
        },
      }
      local miniclue = require 'mini.clue'
      miniclue.setup {
        triggers = {
          -- Leader triggers
          { mode = 'n', keys = '<Leader>' },
          { mode = 'x', keys = '<Leader>' },

          -- Built-in completion
          { mode = 'i', keys = '<C-x>' },

          -- `g` key
          { mode = 'n', keys = 'g' },
          { mode = 'x', keys = 'g' },

          -- Marks
          { mode = 'n', keys = "'" },
          { mode = 'n', keys = '`' },
          { mode = 'x', keys = "'" },
          { mode = 'x', keys = '`' },

          -- Registers
          { mode = 'n', keys = '"' },
          { mode = 'x', keys = '"' },
          { mode = 'i', keys = '<C-r>' },
          { mode = 'c', keys = '<C-r>' },

          -- Window commands
          { mode = 'n', keys = '<C-w>' },

          -- `z` key
          { mode = 'n', keys = 'z' },
          { mode = 'x', keys = 'z' },
        },

        clues = {
          miniclue.gen_clues.builtin_completion(),
          miniclue.gen_clues.g(),
          miniclue.gen_clues.marks(),
          miniclue.gen_clues.registers(),
          miniclue.gen_clues.windows(),
          miniclue.gen_clues.z(),
          { mode = 'n', keys = '<Leader>w', desc = '+[w]indow' },
          { mode = 'x', keys = '<Leader>w', desc = '+[w]indow' },
          { mode = 'n', keys = '<leader>t', desc = '+[t]oggle' },
          { mode = 'x', keys = '<leader>t', desc = '+[t]oggle' },
          { mode = 'n', keys = '<leader>s', desc = '+[s]earch' },
          { mode = 'x', keys = '<leader>s', desc = '+[s]earch' },
          { mode = 'n', keys = '<leader>b', desc = '+[b]uffer' },
          { mode = 'x', keys = '<leader>b', desc = '+[b]uffer' },
          { mode = 'n', keys = '<leader>c', desc = '+[c]ode' },
          { mode = 'x', keys = '<leader>c', desc = '+[c]ode' },
          { mode = 'n', keys = '<leader>f', desc = '+[f]ile' },
          { mode = 'x', keys = '<leader>f', desc = '+[f]ile' },
          { mode = 'n', keys = '<leader>p', desc = '[p]ut from Yankring' },
          { mode = 'x', keys = '<leader>p', desc = '[p]ut from Yankring' },
        },
        window = {
          delay = 0,
          config = {
            anchor = 'SE',
            width = 'auto',
            row = 'auto',
            col = 'auto',
          },
        },
      }
      local gen_loader = require('mini.snippets').gen_loader
      require('mini.snippets').setup {
        snippets = {
          gen_loader.from_lang(),
        },
      }
    end,
  },

  -- Yank Ring
  ---@type LazySpec
  {
    'gbprod/yanky.nvim',
    lazy = false,
    dependencies = {
      'folke/snacks.nvim',
    },
    ---@module 'yanky'
    opts = {
      ring = {
        storage = 'shada',
      },
      highlight = {
        timer = 125,
      },
      textobj = {
        enabled = true,
      },
    },
    keys = {
      { 'y', '<Plug>(YankyYank)', mode = { 'n', 'x' }, desc = 'Yank text' },
      { 'p', '<Plug>(YankyPutAfter)', mode = { 'n', 'x' }, desc = 'Put yanked text after cursor' },
      { 'P', '<Plug>(YankyPutBefore)', mode = { 'n', 'x' }, desc = 'Put yanked text before cursor' },
      { 'gp', '<Plug>(YankyGPutAfter)', mode = { 'n', 'x' }, desc = 'Put yanked text after selection' },
      { 'gP', '<Plug>(YankyGPutBefore)', mode = { 'n', 'x' }, desc = 'Put yanked text before selection' },
      { '<c-p>', '<Plug>(YankyPreviousEntry)', desc = 'Select previous entry through yank history' },
      { '<c-n>', '<Plug>(YankyNextEntry)', desc = 'Select next entry through yank history' },
      { ']p', '<Plug>(YankyPutIndentAfterLinewise)', desc = 'Put indented after cursor (linewise)' },
      { '[p', '<Plug>(YankyPutIndentBeforeLinewise)', desc = 'Put indented before cursor (linewise)' },
      { ']P', '<Plug>(YankyPutIndentAfterLinewise)', desc = 'Put indented after cursor (linewise)' },
      { '[P', '<Plug>(YankyPutIndentBeforeLinewise)', desc = 'Put indented before cursor (linewise)' },
      { '>p', '<Plug>(YankyPutIndentAfterShiftRight)', desc = 'Put and indent right' },
      { '<p', '<Plug>(YankyPutIndentAfterShiftLeft)', desc = 'Put and indent left' },
      { '>P', '<Plug>(YankyPutIndentBeforeShiftRight)', desc = 'Put before and indent right' },
      { '<P', '<Plug>(YankyPutIndentBeforeShiftLeft)', desc = 'Put before and indent left' },
      { '=p', '<Plug>(YankyPutAfterFilter)', desc = 'Put after applying a filter' },
      { '=P', '<Plug>(YankyPutBeforeFilter)', desc = 'Put before applying a filter' },
    },
  },

  -- File Manager
  ---@type LazySpec
  ---@module 'oil'
  {
    'stevearc/oil.nvim',
    lazy = false,
    opts = {
      columns = {
        'icon',
        'permissions',
      },
      keymaps = {
        ['H'] = 'actions.parent',
        ['J'] = 'actions.open_cwd',
        ['K'] = 'actions.cd',
        ['L'] = 'actions.select',
        ['<A-h>'] = 'actions.toggle_hidden',
        ['<C-s>'] = {
          function()
            local vert = win_is_landscape()
            require('oil').select {
              vertical = vert,
              horizontal = not vert,
            }
          end,
        },
      },
      delete_to_trash = true,
      watch_for_changes = true,
    },
    keys = {
      { '<leader>-', '<CMD>Oil<CR>', mode = { 'n', 'x' }, desc = 'Open Directory in Oil' },
      { '<leader>fb', '<CMD>Oil<CR>', mode = { 'n', 'x' }, desc = '[b]rowse Files' },
      {
        '<leader>fB',
        function()
          split_dynamic()
          vim.cmd [[Oil]]
        end,
        mode = { 'n', 'x' },
        desc = '[b]rowse Files in Split',
      },
    },
  },

  -- Pretty UI
  ---@type LazySpec
  {
    'folke/noice.nvim',
    lazy = true,
    event = 'VeryLazy',
    config = function()
      local noice = require 'noice'
      noice.setup {
        presets = {
          command_palette = true,
          long_message_to_split = true,
        },
      }
      require('lualine').setup {
        sections = {
          lualine_x = {
            {
              noice.api.statusline.mode.get,
              cond = noice.api.statusline.mode.has,
              color = { fg = '#e0af68' },
            },
            'encoding',
            'filetype',
          },
        },
      }
    end,
    opts = {
      presets = {
        command_palette = true,
        long_message_to_split = true,
      },
      routes = {
        {
          view = 'notify',
          filter = { event = 'msg_showmode' },
        },
      },
    },
    dependencies = {
      {
        'MunifTanjim/nui.nvim',
        lazy = true,
        event = 'VeryLazy',
      },
      'folke/snacks.nvim',
      'nvim-lualine/lualine.nvim',
    },
  },

  -- Color Picker
  ---@type LazySpec
  ---@module 'ccc'
  {
    'uga-rosa/ccc.nvim',
    lazy = true,
    event = 'BufReadPost',
    config = function()
      local ccc = require 'ccc'
      local mapping = ccc.mapping
      ccc.setup {
        point_color_on_dark = '#c0caf5',
        point_color_on_light = '#1a1b26',
        highlighter = {
          auto_enable = true,
        },
        mappings = {
          ['q'] = function() end,
          ['<ESC>'] = mapping.quit,
        },
      }
    end,
    opts = {},
    keys = {
      { 'ic', '<Plug>(ccc-select-color)', mode = { 'x', 'o' }, desc = '[i]nside [c]olor' },
      { 'ac', '<Plug>(ccc-select-color)', mode = { 'x', 'o' }, desc = '[a]round [c]olor' },
      { '<C-c>', '<CMD>CccPick<CR>', desc = 'Open Colorpicker' },
    },
  },

  -- Statusline
  ---@type LazySpec
  {
    'nvim-lualine/lualine.nvim',
    lazy = true,
    opts = {
      options = {
        theme = 'tokyonight',
        component_separators = {
          left = '',
          right = '',
        },
        section_separators = {
          left = '',
          right = '',
        },
      },
    },
  },

  -- Colorscheme
  ---@type LazySpec
  {
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 9999,
    config = function()
      require('tokyonight').setup {
        style = 'night',
        dim_inactive = true,
      }
      vim.cmd 'colorscheme tokyonight'
    end,
  },
  install = {
    colorscheme = { 'tokyonight' },
  },
}
