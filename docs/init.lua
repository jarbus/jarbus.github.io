vim.cmd [[ colo habamax ]]
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.cmd [[set termguicolors]]
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)
require('lazy').setup({
  'nvim-lua/plenary.nvim',
  'lewis6991/gitsigns.nvim',
  'JuliaEditorSupport/julia-vim', 
  'mg979/vim-visual-multi',
  'ggandor/leap.nvim',
  { 'echasnovski/mini.extra', version = '*'},
  { 'echasnovski/mini.pick', version = '*'},
  { 'echasnovski/mini.visits', version = '*'},
  { 'echasnovski/mini.nvim', config = function()
		  require('mini.clue').setup()
		  require('mini.icons').setup()
		  require('mini.ai').setup()
		  require('mini.extra').setup()
		  require('mini.pick').setup()
		  require('mini.visits').setup()
		  require('mini.files').setup({windows = {preview = true}})
		  require('mini.indentscope').setup()
		  require('mini.comment').setup()
		  require('mini.statusline').setup()
  end },
  {
      "kylechui/nvim-surround",
      version = "*", -- Use for stability; omit to use `main` branch for the latest features
      event = "VeryLazy",
      config = function() require("nvim-surround").setup({}) end
  },
  { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
	  { 'williamboman/mason.nvim', opts={}},
      'williamboman/mason-lspconfig.nvim',
      { 'j-hui/fidget.nvim', opts = {}}, -- Useful status updates for LSP
	  'hrsh7th/cmp-nvim-lsp',
    },
  },
  { -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
      'jc-doyle/cmp-pandoc-references' },
  },
 {'nvim-telescope/telescope.nvim', dependencies = { 'nvim-lua/plenary.nvim' } },
  {"nvim-treesitter/nvim-treesitter", build = ":TSUpdate"},
  "nvim-treesitter/nvim-treesitter-textobjects",
  --"nvim-treesitter/nvim-treesitter-refactor",
  {'LukasPietzschmann/telescope-tabs', config = function() require('telescope-tabs').setup() end },
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",         -- required
      "sindrets/diffview.nvim",        -- optional - Diff integration

      -- Only one of these is needed.
      "nvim-telescope/telescope.nvim", -- optional
      "ibhagwan/fzf-lua",              -- optional
      "echasnovski/mini.pick",         -- optional
    },
    config = true
  },
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    version = false, -- Set this to "*" to always pull the latest release version, or set it to false to update to the latest code changes.
    build = "make",
    opts = {
      provider = "claude",
      auto_suggestions_provider = "claude-haiku",
      behaviour = {
        --auto_suggestions = true,
        auto_suggestions = false,
        auto_set_highlight_group = true,
        auto_set_keymaps = true,
        auto_apply_diff_after_generation = false,
        support_paste_from_clipboard = false,
        auto_suggestions_respect_ignore = true,
        enable_claude_text_editor_tool_mode = true, --only works with claude provider
      },
    },
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      "echasnovski/mini.pick", -- for file_selector provider mini.pick
      "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
      "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
      "ibhagwan/fzf-lua", -- for file_selector provider fzf
      "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
      "zbirenbaum/copilot.lua", -- for providers='copilot'
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        'MeanderingProgrammer/render-markdown.nvim',
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
  }

})

require('telescope').setup({ })

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

local hipatterns = require('mini.hipatterns')
local green = function(_,_) return hipatterns.compute_hex_color_group('#aaffaa', 'fg') end
local yellow = function(_,_) return hipatterns.compute_hex_color_group('#ffffaa', 'fg') end
hipatterns.setup({
  highlighters = {
    fixme = { pattern = '%f[%w]()FIX()%f[%W]', group = 'MiniHipatternsFixme' },
    hack  = { pattern = '%f[%w]()HACK()%f[%W]',  group = 'MiniHipatternsHack'  },
    todo  = { pattern = '%f[%w]()TODO()%f[%W]',  group = green  },
    prog  = { pattern = '%f[%w]()PROG()%f[%W]',  group = yellow  },
    note  = { pattern = '%f[%w]()NOTE()%f[%W]',  group = 'MiniHipatternsNote'  },
    done  = { pattern = '%f[%w]()DONE()%f[%W]',  group = 'MiniHipatternsTodo' },
    hex_color = hipatterns.gen_highlighter.hex_color(), -- Highlight (`#rrggbb`) using that color
  },
})
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
    -- Enhance this by adding descriptions for <Leader> mapping groups
    miniclue.gen_clues.builtin_completion(),
    miniclue.gen_clues.g(),
    miniclue.gen_clues.marks(),
    miniclue.gen_clues.registers(),
    miniclue.gen_clues.windows(),
    miniclue.gen_clues.z(),
  },
})
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  nmap('gD', function()
    vim.cmd('tab split | lua vim.lsp.buf.definition()')
  end, '[G]oto [D]efinition in new split')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
  nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  -- nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    if vim.lsp.buf.format then
      vim.lsp.buf.format()
    elseif vim.lsp.buf.formatting then
      vim.lsp.buf.formatting()
    end
  end, { desc = 'Format current buffer with LSP' })
end

-- Setup mason so it can manage external tooling
--require('mason').setup()

-- Enable the following language servers
-- Feel free to add/remove any LSPs that you want here. They will automatically be installed
local servers = {}

local servers = { 'julials', 'clangd', 'rust_analyzer', 'pyright'}
-- nvim-cmp supports additional completion capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

for _, lsp in ipairs(servers) do
  require('lspconfig')[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
    on_exit = function(_, exit_code, _)
        if exit_code ~= 0 then -- 0 is the normal exit code
          -- Restart the server
          vim.defer_fn(function()
            require'lspconfig'[lsp].start_client()
          end, 500) -- waits 500ms before restarting
        end
      end,
  }
end

-- Turn on lsp status information
require('fidget').setup()

-- Make runtime files discoverable to the server
local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, 'lua/?.lua')
table.insert(runtime_path, 'lua/?/init.lua')

require('lspconfig').lua_ls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT)
        version = 'LuaJIT',
        -- Setup your lua path
        path = runtime_path,
      },
      diagnostics = {
        globals = { 'vim' },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file('', true),
        checkThirdParty = false
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = { enable = false },
    },
  },
}
local cmp = require 'cmp'
local luasnip = require 'luasnip'

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert {
    --["<C-j>"] = cmp.mapping(function(fallback)
    --  cmp.mapping.abort()
    --  local copilot_keys = vim.fn["copilot#Accept"]()
    --  if copilot_keys ~= "" then
    --    vim.api.nvim_feedkeys(copilot_keys, "i", true)
    --  else
    --    fallback()
    --  end
    --end),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'path' },
    { name = 'luasnip' },
    { name = 'pandoc_references'},
  },
}
vim.o.expandtab = true       -- Use spaces instead of tabs
vim.o.tabstop = 4            -- Number of spaces tabs count for
vim.o.shiftwidth = 4         -- Size of an indent
vim.o.hlsearch = false       -- Set highlight on search
vim.o.number = true          -- Show line numbers
vim.wo.relativenumber = true -- Make line numbers default
vim.o.mouse = 'a'            -- Enable mouse mode
vim.o.breakindent = true     -- every wrapped line will continue visually indented
vim.o.undofile = true        -- Persistent undo
vim.o.ignorecase = true      -- Case insensitive searching UNLESS /C or capital in search
vim.o.smartcase = true
vim.o.updatetime = 250       -- Decrease update time
vim.wo.signcolumn = 'yes'
-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'
-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.cmd [[ set clipboard=unnamedplus ]]
--
-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})


vim.g.copilot_no_tab_map = true
vim.g.copilot_assume_mapped = true
vim.g.copilot_tab_fallback = ""

-- disable autowrap for email
vim.api.nvim_create_autocmd("FileType", {
    pattern = "mail",
    callback = function()
        vim.opt_local.textwidth = 0
    end,
})
require('nvim-treesitter.configs').setup {
  -- Add languages to be installed here that you want installed for treesitter
  --ensure_installed = { 'julia','c', 'cpp', 'lua', 'python', 'markdown', 'markdown_inline', 'yaml', 'html', 'javascript'},

  highlight = { enable = false },
  indent = { enable = true },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<c-space>',
      node_incremental = '<c-space>',
      scope_incremental = '<c-s>',
      node_decremental = '<c-backspace>',
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
        ['il'] = '@loop.inner',
        ['al'] = '@loop.outer',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']['] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[]'] = '@class.outer',
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ['<leader>a'] = '@parameter.inner',
      },
      swap_previous = {
        ['<leader>A'] = '@parameter.inner',
      },
    },
  },
  refactor = { highlight_definitions = { enable = true, }, },
}
-- Shell ops
vim.cmd [[ nnoremap <Leader><Leader>t :!kitty & disown<CR> ]]
vim.cmd [[ nnoremap Z :!zathura --fork "%:p:h/%:t:r.pdf"<CR> ]]
-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set({'n', 'x', 'o'}, 's',  '<Plug>(leap-forward)')
vim.keymap.set({'n', 'x', 'o'}, 'S',  '<Plug>(leap-backward)')
vim.keymap.set({'n', 'x', 'o'}, 'gs', '<Plug>(leap-from-window)')

-- open neogit with leader g
vim.keymap.set('n', '<leader>g', function() require('neogit').open({kind="floating"}) end, { desc = 'Open [G]it' })
-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>e', function () MiniFiles.open() end, { desc = 'Open File [E]xplorer' })
vim.keymap.set('n', '<leader>E', function() vim.cmd('tabnew'); MiniFiles.open() end, { desc = 'Open File Explorer in New Tab' })
vim.keymap.set('n', '<leader>v', function() MiniExtra.pickers.visit_paths() end, { desc = 'Visit [V]isited paths' })

vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>t', require('telescope-tabs').list_tabs, {desc = 'Search [T]abs'})
vim.keymap.set('n', '<leader>b', require('telescope.builtin').buffers, { desc = 'Search [b]uffers' })
vim.keymap.set('n', '<leader>f', require('telescope.builtin').find_files, { desc = 'Search [f]iles' })
vim.keymap.set('n', '<leader>T', function() require('telescope.builtin').buffers({ show_all_buffers = true }) end, { desc = '[S]earch [f]iles in open tabs' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [g]rep' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>F', '<cmd>tabnew<CR><cmd>Telescope find_files<CR>', { desc = 'Open [F]ile in new tab' })
vim.keymap.set('n', '<leader>sG', '<cmd>tabnew<CR><cmd>Telescope live_grep<CR>', { desc = 'Open file with [G]repped string in new tab' })
vim.keymap.set('n', '<leader>B', ":tabnew | Telescope buffers<CR>", { desc = 'Open [B]uffer in new tab' })
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer]' })
-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader><leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)
-- open file under cursor in new tab
vim.keymap.set('n', 'gF', '<Cmd>tabnew <cfile><CR>', { desc = 'Open file under cursor in new tab' })

require('gitsigns').setup{
  on_attach = function(bufnr)
    local gitsigns = require('gitsigns')

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map('n', ']c', function()
      if vim.wo.diff then
        vim.cmd.normal({']c', bang = true})
      else
        gitsigns.nav_hunk('next')
      end
    end)

    map('n', '[c', function()
      if vim.wo.diff then
        vim.cmd.normal({'[c', bang = true})
      else
        gitsigns.nav_hunk('prev')
      end
    end)

    -- Actions
    map('n', '<leader>hs', gitsigns.stage_hunk)
    map('n', '<leader>hr', gitsigns.reset_hunk)
    map('v', '<leader>hs', function() gitsigns.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
    map('v', '<leader>hr', function() gitsigns.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
    map('n', '<leader>hS', gitsigns.stage_buffer)
    map('n', '<leader>hu', gitsigns.undo_stage_hunk)
    map('n', '<leader>hR', gitsigns.reset_buffer)
    map('n', '<leader>hU', gitsigns.reset_buffer_index)
    map('n', '<leader>hp', gitsigns.preview_hunk)
    map('n', '<leader>hb', function() gitsigns.blame_line{full=true} end)
    map('n', '<leader>tb', gitsigns.toggle_current_line_blame)
    map('n', '<leader>hd', gitsigns.diffthis)
    map('n', '<leader>hD', function() gitsigns.diffthis('~') end)
    map('n', '<leader>td', gitsigns.toggle_deleted)

    -- Text object
    map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
  end
}
