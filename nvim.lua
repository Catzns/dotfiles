-- vim: ts=2 sts=2 sw=2 et
--[[ VARIABLES ]]
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true

-- [[ OPTIONS ]]
vim.o.number = true
vim.o.relativenumber = true
vim.o.mouse = 'a'
vim.o.showmode = false
vim.o.showcmd = false
-- vim.o.foldminlines = 10
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
vim.o.inccommand = 'split'
vim.o.incsearch = false -- Incompatible with noice.nvim
vim.o.cursorline = true
vim.o.scrolloff = 5
vim.o.sidescrolloff = 10
vim.o.wrap = false
vim.o.confirm = true
vim.o.cinkeys = vim.o.cinkeys .. ",!<Tab>"
vim.o.indentkeys = vim.o.indentkeys .. ",!<Tab>"
vim.o.foldmethod = 'expr'
vim.o.foldcolumn = '1'
vim.o.foldlevelstart = 999

-- [[ KEYMAPS ]]
vim.keymap.set('n', '<s-u>', '<c-r>')
vim.keymap.set('n', '<esc>', '<cmd>nohlsearch<cr>')
vim.keymap.set('t', '<esc><esc>', '<c-\\><c-n>', { desc = 'Exit terminal mode' })
vim.keymap.set({'n', 'v', 'x', 'o'}, 'j', 'gj')
vim.keymap.set({'n', 'v', 'x', 'o'}, 'k', 'gk')
vim.keymap.set({'n', 'v', 'x', 'o'}, 'H', 'g^')
vim.keymap.set({'n', 'v', 'x', 'o'}, 'L', 'g$')

-- Leader menu

-- Q - quit
vim.keymap.set('n', '<leader>q', '<CMD>q<CR>', {desc = '[q]uit Neovim'})

-- W - window
vim.keymap.set({'n', 'v', 'x', 'i'}, '<a-left>', '<CMD>vertical resize -4<CR>', { desc = 'Shrink window horizontally'} )
vim.keymap.set({'n', 'v', 'x', 'i'}, '<a-down>', '<CMD>resize -4<CR>', { desc = 'Shrink window vertically'} )
vim.keymap.set({'n', 'v', 'x', 'i'}, '<a-up>', '<CMD>resize +4<CR>', { desc = 'Expand window vertically'} )
vim.keymap.set({'n', 'v', 'x', 'i'}, '<a-right>', '<CMD>vertical resize +4<CR>', { desc = 'Expand window horizontally'} )

vim.keymap.set('n', '<leader>w<a-h>', '<CMD>vertical resize -16<CR>', { desc = 'Shrink window horizontally'} )
vim.keymap.set('n', '<leader>w<a-j>', '<CMD>resize -16<CR>', { desc = 'Shrink window vertically'} )
vim.keymap.set('n', '<leader>w<a-k>', '<CMD>resize +16<CR>', { desc = 'Expand window vertically'} )
vim.keymap.set('n', '<leader>w<a-l>', '<CMD>vertical resize +16<CR>', { desc = 'Expand window horizontally'} )
vim.keymap.set('n', '<leader>w=', '<c-w>=', { desc = 'Equalize window sizes'})

vim.keymap.set('n', '<leader>wh', '<c-w>h', { desc = 'Shift focus one window left' })
vim.keymap.set('n', '<leader>wj', '<c-w>j', { desc = 'Shift focus one window down' })
vim.keymap.set('n', '<leader>wk', '<c-w>k', { desc = 'Shift focus one window up' })
vim.keymap.set('n', '<leader>wl', '<c-w>l', { desc = 'Shift focus one window right' })
vim.keymap.set('n', '<leader>ww', '<c-w>w', { desc = 'Shift focus to next window' })
vim.keymap.set('n', '<leader>wW', '<c-w>W', { desc = 'Shift focus to previous window' })

vim.keymap.set('n', '<leader>wH', '<c-w>H', { desc = 'Shift window to the left' })
vim.keymap.set('n', '<leader>wJ', '<c-w>J', { desc = 'Shift window to the bottom' })
vim.keymap.set('n', '<leader>wK', '<c-w>K', { desc = 'Shift window to the top' })
vim.keymap.set('n', '<leader>wL', '<c-w>L', { desc = 'Shift window to the right' })
vim.keymap.set('n', '<leader>wx', '<c-w>x', { desc = 'E[x]change windows' })

vim.keymap.set('n', '<leader>wc', '<c-w>c', { desc = '[c]lose window'})
vim.keymap.set('n', '<leader>wC', '<c-w>o', { desc = '[C]lose all other windows'})

-- T - toggle
vim.keymap.set('n', '<leader>td', function()
  local vlines = not vim.diagnostic.config().virtual_lines
  local vtext = not vim.diagnostic.config().virtual_text and {
    source = 'if_many',
    spacing = 1,
  }
  vim.diagnostic.config({
    virtual_lines = vlines,
    virtual_text = vtext,
  })
end, { desc = 'Toggle [d]iagnostic Format' })


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
  virtual_text = {
    source = 'if_many',
    spacing = 1,
  },
}

-- [[ LSP ]]
vim.lsp.enable({
  'lua_ls',
  'cssls',

})

-- [[ AUTOCOMMANDS ]]
-- Open Oil with a preview
vim.api.nvim_create_autocmd("User", {
  pattern = "OilEnter",
  callback = vim.schedule_wrap(function(args)
    local oil = require("oil")
    if vim.api.nvim_get_current_buf() == args.data.buf and oil.get_cursor_entry() then
      oil.open_preview()
    end
  end),
})

-- [[ PLUGIN MANAGER ]]
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
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
        end
      })
    end
  },

  -- Configuration LSP
  {
    'folke/lazydev.nvim',
    lazy = true,
    ft = 'lua',
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },

  -- Indent tools
  {
    'NMAC427/guess-indent.nvim',
    lazy = true,
    event = 'BufReadPost',
    opts = {},
  },

  -- Autocompletion
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
        nerd_font_variant = 'mono'
      },
      completion = {
        documentation = { auto_show = false }
      },
      sources = {
        default = {'lazydev', 'lsp', 'path', 'snippets', 'buffer' },
        providers = {
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            score_offset = 100,
          },
        }
      },
      snippets = { preset = 'mini_snippets' },
      cmdline = {
        enabled = false
      },
      fuzzy = { implementation = "prefer_rust_with_warning" }
    },
    opts_extend = { "sources.default" }
  },

  -- File loading optimizations, Splash screen, Indent markers, Fuzzy finder
  {
    'folke/snacks.nvim',
    lazy = false,
    priority = 1000,
    opts = {
      quickfile = { enabled = true },
      bigfile = { enabled = true },
      dashboard = { enabled = true },
      input = { enabled = true },
      notifier = { enabled = true },
      indent = {
        animate = {
          enabled = false
        }
      },
      picker = { enabled = true },
    }
  },

  -- Textobjects, ALT moving, Autopairing, Surround macros, f and t extensions,
  -- Git signals, Comment macros, Nerdfont icons, Which-key popups
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
      local miniclue = require('mini.clue')
      miniclue.setup({
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
          { mode = 'n', keys = '<Leader>w', desc = '+[w]indow'},
          { mode = 'n', keys = '<leader>t', desc = '+[t]oggle'},
        },
        window = {
          delay = 0,
          config = {
            anchor = "SE",
            width = "auto",
            row = "auto",
            col = "auto"
          }
        }
      })
      local gen_loader = require('mini.snippets').gen_loader
      require('mini.snippets').setup({
        snippets = {
          gen_loader.from_lang(),
        },
      })
    end
  },

  -- Yank Ring
  {
    "gbprod/yanky.nvim",
    opts = {
      ring = {
        storage = "shada",
      },
      highlight = {
        timer = 125,
      },
      textobj = {
        enabled = true,
      },
    },
    keys = {
      { "<leader>p", "<cmd>YankyRingHistory<cr>", mode = { "n", "x" }, desc = "Open Yank History" },
      { "y", "<Plug>(YankyYank)", mode = { "n", "x" }, desc = "Yank text" },
      { "p", "<Plug>(YankyPutAfter)", mode = { "n", "x" }, desc = "Put yanked text after cursor" },
      { "P", "<Plug>(YankyPutBefore)", mode = { "n", "x" }, desc = "Put yanked text before cursor" },
      { "gp", "<Plug>(YankyGPutAfter)", mode = { "n", "x" }, desc = "Put yanked text after selection" },
      { "gP", "<Plug>(YankyGPutBefore)", mode = { "n", "x" }, desc = "Put yanked text before selection" },
      { "<c-p>", "<Plug>(YankyPreviousEntry)", desc = "Select previous entry through yank history" },
      { "<c-n>", "<Plug>(YankyNextEntry)", desc = "Select next entry through yank history" },
      { "]p", "<Plug>(YankyPutIndentAfterLinewise)", desc = "Put indented after cursor (linewise)" },
      { "[p", "<Plug>(YankyPutIndentBeforeLinewise)", desc = "Put indented before cursor (linewise)" },
      { "]P", "<Plug>(YankyPutIndentAfterLinewise)", desc = "Put indented after cursor (linewise)" },
      { "[P", "<Plug>(YankyPutIndentBeforeLinewise)", desc = "Put indented before cursor (linewise)" },
      { ">p", "<Plug>(YankyPutIndentAfterShiftRight)", desc = "Put and indent right" },
      { "<p", "<Plug>(YankyPutIndentAfterShiftLeft)", desc = "Put and indent left" },
      { ">P", "<Plug>(YankyPutIndentBeforeShiftRight)", desc = "Put before and indent right" },
      { "<P", "<Plug>(YankyPutIndentBeforeShiftLeft)", desc = "Put before and indent left" },
      { "=p", "<Plug>(YankyPutAfterFilter)", desc = "Put after applying a filter" },
      { "=P", "<Plug>(YankyPutBeforeFilter)", desc = "Put before applying a filter" },
    },
  },

  -- File Manager
  ---@type LazySpec
  {
    'mikavilpas/yazi.nvim',
    dependencies = {
      { 'nvim-lua/plenary.nvim', lazy = true },
    },
    keys = {
      { '<leader>-', '<cmd>Yazi<cr>', desc = 'Open yazi at the current file', },
    },
    opts = {
      open_for_directories = true,
      keymaps = {
        show_help = '<f1>',
      },
    },
    init = function()
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
    end,
  },

  -- Pretty UI
  {
    'folke/noice.nvim',
    lazy = true,
    event = 'VeryLazy',
    config = function()
      local noice = require('noice')
      noice.setup({
        presets = {
          command_palette = true,
          long_message_to_split = true,
        },
      })
      require("lualine").setup({
        sections = {
          lualine_x = {
            {
              noice.api.statusline.mode.get,
              cond = noice.api.statusline.mode.has,
              color = { fg = "#e0af68" },
            },
            'encoding',
            'filetype',
          },
        },
      })
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
    },
  },

  -- Statusline
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
        }
      },
    },
  },

  -- Colorscheme
  {
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 9999,
    config = function()
      require('tokyonight').setup({
        style = 'night',
        dim_inactive = true,
        on_colors = function(colors)
        end,
        on_highlights = function(highlights, colors)
        end,
      })
      vim.cmd('colorscheme tokyonight')
    end
  },
  install = {
    colorscheme = { 'tokyonight' }
  }
}
