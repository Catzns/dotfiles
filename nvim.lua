-- vim: ts=2 sts=2 sw=2 et
--[[ VARIABLES ]]
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.c_syntax_for_h = true
vim.g.have_nerd_font = true
vim.g.virtual_lines = true
vim.g.autofmt = true

-- [[ OPTIONS ]]
vim.o.number = true
vim.o.relativenumber = true
vim.o.mouse = 'a'
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.showmode = false
vim.o.showcmd = false
vim.o.foldminlines = 10
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
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.o.termguicolors = true
vim.o.inccommand = 'split'
vim.o.incsearch = false -- Incompatible with noice.nvim
vim.o.cursorline = true
vim.o.scrolloff = 5
vim.o.sidescrolloff = 10
vim.o.wrap = false
vim.o.confirm = true
vim.o.foldmethod = 'expr'
vim.o.foldcolumn = '1'
vim.o.foldlevelstart = 999

-- [[ FUNCTIONS ]]
local function is_landscape()
  return (vim.api.nvim_win_get_width(0) > (vim.api.nvim_win_get_height(0) * 2.75))
end

local function split()
  if is_landscape() then
    vim.api.nvim_open_win(0, true, {
      vertical = true,
      win = 0,
    })
  else
    vim.api.nvim_open_win(0, true, {
      vertical = false,
      win = 0,
    })
  end
end

local function get_git_dir()
  local gitdir = vim.fn.finddir('.git/..', '.;')
  return (gitdir == '' and vim.fn.getcwd()) or gitdir
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

-- Bind TAB to reindent, use <C-i> to insert literal tabs
vim.keymap.set('i', '<TAB>', '<C-f>', { desc = 'Reindent Line' })

-- Leader menu
vim.keymap.set({ 'n', 'x' }, '<leader>l', '<CMD>Lazy<CR>', { desc = '[l]azy Package Manager' })
vim.keymap.set({ 'n', 'x' }, '<leader>m', '<CMD>messages<CR>', { desc = 'Open [m]essages' })

-- B - buffer
vim.keymap.set({ 'n', 'x' }, '<leader>bC', '<CMD>hide<CR>', { desc = '[C]lose Buffer & Window' })
vim.keymap.set({ 'n', 'x' }, '<leader>bn', '<CMD>enew<CR>', { desc = '[n]ew Buffer' })
vim.keymap.set({ 'n', 'x' }, '<leader>bs', function()
  if is_landscape() then
    return '<CMD>vert enew<CR>'
  else
    return '<CMD>enew<CR>'
  end
end, { expr = true, desc = 'New Buffer in [s]plit' })

-- C - Code
vim.keymap.set('n', '<leader>cn', vim.lsp.buf.rename, { desc = 'LSP Re[n]ame Symbol' })
vim.keymap.set({ 'n', 'x' }, '<leader>ca', vim.lsp.buf.code_action, { desc = 'LSP [a]ctions' })

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
      vim.cmd('saveas ' .. input)
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

vim.keymap.set({ 'n', 'x' }, '<leader>ws', split, { desc = '[s]plit Active Window' })
vim.keymap.set({ 'n', 'x' }, '<leader>wc', '<c-w>c', { desc = '[c]lose window' })
vim.keymap.set({ 'n', 'x' }, '<leader>wC', '<c-w>o', { desc = '[C]lose all other windows' })

-- T - toggle
vim.keymap.set({ 'n', 'x' }, '<leader>tl', function()
  vim.o.number = not vim.o.number
  vim.o.relativenumber = not vim.o.relativenumber
  vim.o.signcolumn = (vim.o.signcolumn == 'yes' and 'no') or 'yes'
  vim.o.foldcolumn = (vim.o.foldcolumn == '1' and '0') or '1'
end, { desc = 'Toggle [l]ine Columns' })
vim.keymap.set({ 'n', 'x' }, '<leader>tv', function()
  local lines = not vim.g.virtual_lines
  vim.g.virtual_lines = lines
  vim.diagnostic.config {
    virtual_lines = lines,
  }
end, { desc = 'Toggle [v]irtual Lines' })

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
  virtual_lines = vim.g.virtual_lines,
}

-- [[ LSP ]]
-- JS garbage
local vue_plugin = {
  name = '@vue/typescript-plugin',
  location = '/usr/bin/vue-language-server',
  languages = { 'vue' },
  configNamespace = 'typescript',
}
local ts_filetypes = {
  'typescript',
  'javascript',
  'javascriptreact',
  'typescriptreact',
  'vue',
}
-- Typescript Addons
vim.lsp.config('ts_ls', {
  init_options = {
    plugins = {
      vue_plugin,
    },
    filetypes = ts_filetypes,
  },
})
-- Vue w/ Typescript
vim.lsp.config('vtsls', {
  settings = {
    vtsls = {
      tsserver = {
        globalPlugins = {
          vue_plugin,
        },
      },
    },
  },
  filetypes = 'vue',
})

vim.lsp.enable {
  'clangd',
  'lua_ls',
  'html',
  'cssls',
  'ts_ls',
  'vtsls',
  'vue_ls',
  'jsonls',
  'yamlls',
}

-- [[ AUTOCOMMANDS ]]
-- Initialize buffer-local variables
vim.api.nvim_create_autocmd('BufWinEnter', {
  callback = function(event)
    vim.b[event.buf].autofmt = vim.g.autofmt
  end,
})
-- Open Help and Man pages vertically
vim.api.nvim_create_autocmd('BufWinEnter', {
  pattern = {
    '*.txt',
    '*(*)',
  },
  callback = function()
    local ft = {
      'help',
      'man',
      'text',
    }
    if vim.tbl_contains(ft, vim.bo.filetype) and (vim.api.nvim_win_get_width(0) > vim.api.nvim_win_get_height(0) * 5.5) then
      vim.cmd 'wincmd L'
    end
  end,
})
-- Disable virtual lines in insert mode
vim.api.nvim_create_autocmd('InsertEnter', {
  callback = function()
    vim.diagnostic.config {
      virtual_lines = false,
    }
  end,
})
vim.api.nvim_create_autocmd('InsertLeave', {
  callback = function()
    vim.schedule(function()
      vim.diagnostic.config {
        virtual_lines = vim.g.virtual_lines,
      }
    end)
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
---@module 'lazy'
---@type LazyConfig
require('lazy').setup {
  spec = {
    -- LSP configurations
    ---@type LazySpec
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
          'c',
          'lua',
          'javascript',
          'jsx',
          'typescript',
          'tsx',
          'vue',
          'html',
          'css',
          'scss',
          'yaml',
          'json',
          'toml',
          'hyprlang',
          'markdown',
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

    -- Formatting
    ---@type LazySpec
    {
      'stevearc/conform.nvim',
      lazy = true,
      event = 'BufWritePre',
      cmd = 'ConformInfo',
      config = function()
        ---@module 'conform'
        ---@type conform.setupOpts
        require('conform').setup {
          formatters_by_ft = {
            lua = { 'stylua' },
            c = { 'clang-format' },
            javascript = { 'prettier' },
            javascriptreact = { 'prettier' },
            typescript = { 'prettier' },
            typescriptreact = { 'prettier' },
            html = { 'prettier' },
            css = { 'prettier' },
            scss = { 'prettier' },
            vue = { 'prettier' },
            json = { 'prettier' },
            yaml = { 'prettier' },
          },
          formatters = {},
          default_format_opts = {
            lsp_format = 'fallback',
          },
          format_on_save = function()
            if vim.g.autofmt then
              return { timeout_ms = 500, lsp_format = 'fallback' }
            else
              return
            end
          end,
        }
        vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
      end,
      keys = {
        {
          '<leader>bf',
          function()
            require('conform').format { async = true }
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', true)
          end,
          mode = 'x',
          desc = '[f]ormat Selection',
        },
        {
          '<leader>bf',
          function()
            require('conform').format { async = true }
          end,
          mode = 'n',
          desc = '[f]ormat Buffer',
        },
        {
          '<leader>tf',
          function()
            local fmt = not vim.g.autofmt
            vim.g.autofmt = fmt
            print((fmt and 'Autoformatting enabled') or 'Autoformatting disabled')
          end,
          mode = { 'n', 'x' },
          desc = 'Toggle Auto[f]ormat',
        },
      },
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
      'tpope/vim-sleuth',
      lazy = true,
      cmd = 'Sleuth',
      event = {
        'BufReadPost',
        'BufNewFile',
        'BufFilePost',
      },
      keys = {
        { '<leader>i', '<CMD>verbose Sleuth<CR>', mode = { 'n', 'x' }, desc = 'Adjust [i]indentation' },
      },
    },

    -- Autocompletion
    ---@type LazySpec
    {
      'saghen/blink.cmp',
      lazy = true,
      version = '1.*',
      event = 'BufWinEnter',
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

    -- File loading optimizations, Splash screen, Indent markers, Fuzzy finder
    ---@type LazySpec
    {
      'folke/snacks.nvim',
      lazy = false,
      priority = 1000,
      config = function()
        ---@module 'snacks'
        ---@type snacks.Config
        require('snacks').setup {
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
        }
        vim.api.nvim_create_autocmd('BufNewFile', {
          callback = Snacks.indent.enable,
        })
      end,
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
            Snacks.picker.files { dirs = { vim.fn.expand '%:h' } }
          end,
          mode = { 'n', 'x' },
          desc = 'Search [f]iles in CFD',
        },
        {
          '<leader>fF',
          function()
            Snacks.picker.files { dirs = { get_git_dir() } }
          end,
          mode = { 'n', 'x' },
          desc = 'Search [F]iles in Root',
        },
        -- G - git
        {
          '<leader>g/',
          function()
            Snacks.picker.git_grep()
          end,
          mode = { 'n', 'x' },
          desc = 'Search Repo by Content',
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
            { mode = 'n', keys = '<leader>f', desc = '+[f]ile' },
            { mode = 'x', keys = '<leader>f', desc = '+[f]ile' },
            { mode = 'n', keys = '<leader>c', desc = '+[c]ode' },
            { mode = 'x', keys = '<leader>c', desc = '+[c]ode' },
            { mode = 'n', keys = '<leader>g', desc = '+[g]it' },
            { mode = 'x', keys = '<leader>g', desc = '+[g]it' },
            { mode = 'n', keys = '<leader>d', desc = '+[d]ebug' },
            { mode = 'x', keys = '<leader>d', desc = '+[d]ebug' },
          },
          window = {
            delay = 0,
            config = {
              anchor = 'SE',
              width = 'auto',
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

    -- HTML Tag Matching
    ---@type LazySpec
    {
      'windwp/nvim-ts-autotag',
      lazy = true,
      event = 'BufWinEnter',
      opts = {
        opts = {
          enable_close_on_slash = true,
        },
      },
    },

    -- Code Runner
    ---@type LazySpec
    {
      'michaelb/sniprun',
      lazy = true,
      build = 'sh install.sh 1',
      cmd = {
        'SnipRun',
        'SnipReset',
        'SnipReplMemoryClean',
        'SnipInfo',
        'SnipClose',
        'SnipLive',
      },
      config = function()
        ---@module 'sniprun'
        require('sniprun').setup {
          selected_interpreters = { 'Lua_nvim' },
          display = {
            'TempFloatingWindow',
          },
          snipruncolors = {
            SniprunFloatingWinOk = {
              fg = '#7dcfff',
              ctermfg = 'Cyan',
            },
            SniprunFloatingWinError = {
              fg = '#f7768e',
              ctermfg = 'DarkRed',
            },
          },
        }
      end,
      keys = {
        { 'S', '<Plug>SnipRun', mode = 'x', desc = 'Run Selected [S]nippet' },
        { 'S', '<Plug>SnipRunOperator', mode = 'n', desc = 'Run [S]nippet' },
        { '<leader>cR', '<CMD>%SnipRun<CR>', mode = { 'n', 'x' }, desc = '[R]un in REPL' },
      },
    },

    -- Yank Ring
    ---@type LazySpec
    {
      'gbprod/yanky.nvim',
      lazy = true,
      dependencies = 'folke/snacks.nvim',
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
        {
          '<leader>p',
          function()
            Snacks.picker.yanky()
          end,
          desc = '[p]ut from Yankring',
        },
      },
    },

    -- File Manager
    ---@type LazySpec
    {
      'stevearc/oil.nvim',
      lazy = false,
      ---@module 'oil'
      opts = {
        default_file_explorer = true,
        delete_to_trash = true,
        watch_for_changes = true,
        columns = {
          'icon',
          'permissions',
        },
        keymaps = {
          ['L'] = { 'actions.select', mode = 'n' },
          ['H'] = { 'actions.parent', mode = 'n' },
          ['J'] = 'actions.open_cwd',
          ['K'] = 'actions.cd',
          ['<A-h>'] = 'actions.toggle_hidden',
        },
      },
      keys = {
        { '<leader>-', '<CMD>Oil<CR>', mode = { 'n', 'x' }, desc = 'Browse Files in CFD' },
        { '-', '<CMD>Oil<CR>', mode = { 'n', 'x' }, desc = 'Browse Files in CFD' },
        { '<leader>fb', '<CMD>Oil<CR>', mode = { 'n', 'x' }, desc = '[b]rowse Files in CFD' },
        {
          '<leader>fB',
          function()
            require('oil').open(get_git_dir())
          end,
          mode = { 'n', 'x' },
          desc = '[B]rowse Files in Root',
        },
      },
    },

    -- Debugger
    ---@type LazySpec
    {
      'mfussenegger/nvim-dap',
      lazy = true,
      dependencies = {
        'folke/snacks.nvim',
        {
          'theHamsta/nvim-dap-virtual-text',
          lazy = true,
          cmd = {
            'DapVirtualTextEnable',
            'DapVirtualTextDisable',
            'DapVirtualTextToggle',
            'DapVirtualTextForceRefresh',
          },
          opts = {},
        },
        {
          'Jorenar/nvim-dap-disasm',
          lazy = true,
          cmd = {
            'DapDisasm',
            'DapDisasmSetMemref',
            'DapViewOpen',
            'DapViewClose',
            'DapViewToggle',
            'DapViewWatch',
            'DapViewJump',
            'DapViewShow',
            'DapViewNavigate',
          },
          opts = {
            dapui_register = false,
            dapview = {
              keymap = 'A',
              label = '[A]ssembly',
              short_label = '󰒓 [A]',
            },
          },
          dependencies = {
            'igorlfs/nvim-dap-view',
            lazy = true,
            cmd = {
              'DapViewOpen',
              'DapViewClose',
              'DapViewToggle',
              'DapViewWatch',
              'DapViewJump',
              'DapViewShow',
              'DapViewNavigate',
            },
            config = function()
              ---@module 'dap-view'
              local dapview = require 'dap-view'
              local dap = require 'dap'
              ---@type dapview.Config
              dapview.setup {
                winbar = {
                  sections = { 'repl', 'scopes', 'watches', 'exceptions', 'breakpoints', 'threads', 'disassembly' },
                  default_section = 'repl',
                  base_sections = {
                    repl = {
                      label = '[R]EPL',
                    },
                    scopes = {
                      label = '[S]copes',
                    },
                    watches = {
                      label = '[W]atches',
                    },
                    exceptions = {
                      label = '[E]xceptions',
                    },
                    breakpoints = {
                      label = '[B]reakpoints',
                    },
                    threads = {
                      label = '[T]hreads',
                    },
                  },
                },
                auto_toggle = true,
                follow_tab = true,
              }
              vim.api.nvim_create_autocmd({ 'FileType' }, {
                pattern = { 'dap-view', 'dap-view-term', 'dap-repl', 'dap_disassembly' },
                callback = function(event)
                  vim.keymap.set('n', 'q', '<C-w>q', { buffer = event.buf })
                end,
              })
              dap.listeners.after.event_exited.dapview = function()
                dapview.close()
              end
              dap.listeners.after.disconnect.dapview = function()
                dapview.close()
              end
            end,
            keys = {
              { '<leader>dv', '<CMD>DapViewToggle<CR>', mode = { 'n', 'x' }, desc = 'Toggle [v]iew' },
              { '<leader>dw', '<CMD>DapViewWatch<CR>', mode = { 'n', 'x' }, desc = '[w]atch Selection' },
            },
          },
        },
      },
      cmd = {
        'DapContinue',
        'DapDisconnect',
        'DapNew',
        'DapTerminate',
        'DapRestartFrame',
        'DapStepInto',
        'DapStepOut',
        'DapStepOver',
        'DapPause',
        'DapEval',
        'DapToggleRepl',
        'DapClearBreakpoints',
        'DapToggleBreakpoint',
        'DapSetLogLevel',
        'DapShowLog',
      },
      config = function()
        ---@module 'dap'
        local dap = require 'dap'
        ---@module 'dap.utils'
        local utils = require 'dap.utils'

        vim.fn.sign_define('DapBreakpoint', { text = '', texthl = '@constant' })
        vim.fn.sign_define('DapBreakpointCondition', { text = '', texthl = '@constant' })
        vim.fn.sign_define('DapLogPoint', { text = '', texthl = '@constant' })
        vim.fn.sign_define('DapStopped', { text = '', texthl = '@constant' })
        vim.fn.sign_define('DapBreakpointRejected', { text = '', texthl = 'Error' })

        local exec_pick = function()
          local co = coroutine.running()
          ---@module 'snacks'
          Snacks.picker.files {
            title = 'Executable',
            cmd = 'fd',
            args = { '-tx', '--color', 'never' },
            confirm = function(picker, item)
              coroutine.resume(co, picker, item.text)
            end,
            on_close = function(picker)
              coroutine.resume(co, picker, dap.ABORT)
            end,
          }
          local picker, elf = coroutine.yield()
          if elf ~= dap.ABORT then
            picker:close()
          end
          return elf
        end

        local args_pick = function()
          return utils.splitstr(vim.fn.input 'Arguments?: ')
        end

        dap.defaults.fallback.auto_continue_if_many_stopped = false

        -- C Family
        dap.defaults.c.autostart = 'Launch w/ Args'
        dap.adapters.gdb = {
          type = 'executable',
          command = 'gdb',
          args = { '--quiet', '--interpreter=dap', '--eval-command', 'set print pretty on' },
        }
        dap.configurations.c = {
          {
            name = 'Launch',
            type = 'gdb',
            request = 'launch',
            program = exec_pick,
            cwd = '${workspaceFolder}',
            stopAtBeginningOfMainSubprogram = true,
          },
          setmetatable({
            name = 'Launch w/ Args',
            type = 'gdb',
            request = 'launch',
          }, {
            __call = function()
              local p = exec_pick()
              if not p then
                return { abort = dap.ABORT }
              end
              local r = args_pick()
              return {
                name = 'Launch w/ Args',
                type = 'gdb',
                request = 'launch',
                program = p,
                args = r,
                cwd = '${workspaceFolder}',
                stopAtBeginningOfMainSubprogram = true,
              }
            end,
          }),
          {
            name = 'Attach to Process',
            type = 'gdb',
            request = 'attach',
            program = exec_pick,
            pid = function()
              local name = vim.fn.input 'Process Name: '
              return require('dap.utils').pick_process { filter = name }
            end,
            cwd = '${workspaceFolder}',
          },
        }
      end,
      keys = {
        { '<leader>dd', '<CMD>DapNew<CR>', mode = { 'n', 'x' }, desc = 'Start [d]ebug Session' },
        { '<leader>dc', '<CMD>DapContinue<CR>', mode = { 'n', 'x' }, desc = '[c]ontinue Session' },
        {
          '<leader>dr',
          function()
            require('dap').restart()
          end,
          mode = { 'n', 'x' },
          desc = '[r]estart Session',
        },
        { '<leader>db', '<CMD>DapToggleBreakpoint<CR>', mode = { 'n', 'x' }, desc = 'Set [b]reakpoint' },
        {
          '<leader>dB',
          function()
            local cond = vim.input 'Condition: '
            if cond == '' then
              return
            end
            require('dap').toggle_breakpoint(cond, nil, nil, true)
          end,
          mode = { 'n', 'x' },
          desc = 'Conditional [B]reakpoint',
        },
        {
          '<leader>dl',
          function()
            local log = vim.fn.input 'Message: '
            if log == '' then
              return
            end
            local cond = vim.fn.input 'Condition?: '
            require('dap').toggle_breakpoint(cond, nil, log, true)
          end,
          mode = { 'n', 'x' },
          desc = 'Set [l]ogpoint',
        },
        { '<leader>di', '<CMD>DapStepInto<CR>', mode = { 'n', 'x' }, desc = 'Step [i]nto Scope' },
        { '<leader>do', '<CMD>DapStepOut<CR>', mode = { 'n', 'x' }, desc = 'Step [o]ut of Scope' },
        { '<leader>dn', '<CMD>DapStepOver<CR>', mode = { 'n', 'x' }, desc = '[n]ext Line' },
        {
          '<leader>dN',
          function()
            require('dap').step_over { steppingGranularity = 'instruction' }
          end,
          mode = { 'n', 'x' },
          desc = '[N]ext Instruction',
        },
        {
          '<leader>dp',
          function()
            require('dap').step_back()
          end,
          mode = { 'n', 'x' },
          desc = '[p]revious Line',
        },
        {
          '<leader>dP',
          function()
            require('dap').step_back { steppingGranularity = 'instruction' }
          end,
          mode = { 'n', 'x' },
          desc = '[p]revious Instruction',
        },
        { '<leader>dt', '<CMD>DapTerminate<CR>', mode = { 'n', 'x' }, desc = '[t]erminate Session' },
      },
    },

    -- Git Client
    ---@type LazySpec
    {
      'tpope/vim-fugitive',
      lazy = true,
      cmd = {
        'G',
        'Git',
        'Ggrep',
        'Gclog',
        'Gllog',
        'Gcd',
        'Glcd',
        'Gedit',
        'Gsplit',
        'Gvsplit',
        'Gtabedit',
        'Gpedit',
        'Gdrop',
        'Gread',
        'Gwrite',
        'Gwq',
        'Gdiffsplit',
        'Gvdiffsplit',
        'Ghdiffsplit',
        'GMove',
        'GRename',
        'GDelete',
        'GRemove',
        'GUnlink',
        'GBrowse',
      },
      config = function()
        vim.api.nvim_create_autocmd('BufWinEnter', {
          pattern = '*/\\.git/*',
          callback = function(event)
            if vim.bo[event.buf].filetype == 'fugitive' then
              vim.keymap.set('n', 'S', function()
                local cwd = vim.fn.getcwd(-1, 0)
                vim.cmd [[Glcd]]
                vim.cmd [[Git add .]]
                vim.cmd('lcd ' .. cwd)
              end, { buffer = true, desc = 'Stage All Files' })
            end
          end,
        })
        vim.api.nvim_create_autocmd('FileType', {
          pattern = 'git',
          callback = function()
            vim.api.nvim_win_close(0, false)
          end,
        })
        vim.api.nvim_create_autocmd('WinLeave', {
          callback = function(event)
            if vim.bo[event.buf].filetype == 'fugitive' then
              vim.api.nvim_win_close(0, false)
            end
          end,
        })
      end,
      keys = {
        { '<leader>gg', '<CMD>Git<CR>', mode = { 'n', 'x' }, desc = 'Open [g]it Status' },
        { '<leader>gc', '<CMD>Gcd<CR>', mode = { 'n', 'x' }, desc = '[c]hange Directory to Repo' },
        { '<leader>gr', '<CMD>Gread<CR>', mode = { 'n', 'x' }, desc = '[r]evert to Last Commit' },
        { '<leader>gw', '<CMD>Gwrite<CR>', mode = { 'n', 'x' }, desc = '[w]rite & Stage File' },
        { '<leader>gd', '<CMD>Gdiffsplit<CR>', mode = { 'n', 'x' }, desc = '[d]iff Current File' },
      },
    },

    -- Diagnostics
    ---@type LazySpec
    {
      'folke/trouble.nvim',
      lazy = true,
      cmd = 'Trouble',
      config = function()
        ---@type trouble.Config
        require('trouble').setup {
          auto_close = true,
          focus = true,
        }
        vim.api.nvim_create_autocmd('WinLeave', {
          callback = function(event)
            if vim.bo[event.buf].filetype == 'trouble' then
              vim.cmd [[Trouble close]]
            end
          end,
        })
      end,
      keys = {
        { '<leader>cc', '<CMD>Trouble diagnostics toggle filter.buf=0<CR>', mode = { 'n', 'x' }, desc = '[c]ode Diagnostics' },
        { '<leader>cd', '<CMD>Trouble lsp_declarations toggle<CR>', mode = { 'n', 'x' }, desc = 'LSP [d]eclarations' },
        { '<leader>cD', '<CMD>Trouble lsp_definitions toggle<CR>', mode = { 'n', 'x' }, desc = 'LSP [D]efinitions' },
        { '<leader>ct', '<CMD>Trouble lsp_type_definitions toggle<CR>', mode = { 'n', 'x' }, desc = 'LSP [t]ype Defs' },
        { '<leader>cs', '<CMD>Trouble lsp_document_symbols toggle win.position=right<CR>', mode = { 'n', 'x' }, desc = 'LSP [s]ymbols' },
        { '<leader>cr', '<CMD>Trouble lsp_references toggle', mode = { 'n', 'x' }, desc = 'LSP [r]eferences' },
        { '<leader>ci', '<CMD>Trouble lsp_implementations toggle<CR>', mode = { 'n', 'x' }, desc = 'LSP [i]mplementations' },
      },
    },

    -- Color Picker
    ---@type LazySpec
    {
      'uga-rosa/ccc.nvim',
      lazy = true,
      cmd = {
        'CccPick',
        'CccConvert',
        'CccHighlighterEnable',
        'CccHighlighterDisable',
        'CccHighlighterToggle',
      },
      config = function()
        local ccc = require 'ccc'
        local mapping = ccc.mapping
        ccc.setup {
          empty_point_bg = false,
          point_char = '',
          point_color = '',
          point_color_on_dark = '#c0caf5',
          point_color_on_light = '#1a1b26',
          highlighter = {
            auto_enable = true,
            lsp = true,
          },
          recognize = {
            input = true,
            output = true,
          },
          inputs = {
            ccc.input.rgb,
            ccc.input.hsv,
            ccc.input.hsluv,
            ccc.input.cmyk,
          },
          outputs = {
            ccc.output.hex,
            ccc.output.css_rgb,
            ccc.output.css_hsl,
            ccc.output.css_oklab,
          },
          mappings = {
            ['<Esc>'] = mapping.quit,
          },
        }
      end,
      keys = {
        { '<C-c>', '<CMD>CccPick<CR>', mode = 'n', desc = 'Open Ccc' },
      },
    },

    -- Pretty UI
    ---@type LazySpec
    {
      'folke/noice.nvim',
      lazy = true,
      event = 'VeryLazy',
      dependencies = {
        {
          'MunifTanjim/nui.nvim',
          lazy = true,
        },
        'folke/snacks.nvim',
      },
      config = function()
        ---@module 'noice'
        local noice = require 'noice'
        noice.setup {
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
      keys = {
        { '<leader>n', '<CMD>Noice<CR>', mode = { 'n', 'x' }, desc = 'Open [n]otifications' },
      },
    },

    -- Statusline
    ---@type LazySpec
    {
      'nvim-lualine/lualine.nvim',
      lazy = true,
      event = 'VeryLazy',
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
  },
  dev = {
    path = '~/Code/Neovim',
    patterns = { 'catzs', 'Catzs', 'Catzns' },
  },
  install = {
    colorscheme = { 'tokyonight' },
  },
}
