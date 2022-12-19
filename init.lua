-- My init.lua

vim.g.mapleader = ' '
vim.opt.number = true
vim.opt.hlsearch = false
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.guifont = 'Cascadia Code PL:h11'

require('packer').startup({ function(use)
	-- Packer can manage itself
	use 'wbthomason/packer.nvim'
	use 'folke/tokyonight.nvim'
	use 'nvim-tree/nvim-web-devicons'

	use {
		'nvim-treesitter/nvim-treesitter',
		run = function()
			require('nvim-treesitter.install').update({ with_sync = true })()
		end,
	}

	use 'windwp/nvim-autopairs'

	use "folke/neodev.nvim"

	use {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"neovim/nvim-lspconfig",
	}

	use 'hrsh7th/cmp-nvim-lsp'
	use 'hrsh7th/cmp-buffer'
	use 'hrsh7th/nvim-cmp'

	use 'L3MON4D3/LuaSnip'
	use 'saadparwaiz1/cmp_luasnip'

end,
	config = {
		display = {
			open_fn = function()
				return require('packer.util').float({ border = 'single' })
			end
		}
	}
})


require('tokyonight').load()

require 'nvim-treesitter.configs'.setup {
	-- A list of parser names, or "all"
	ensure_installed = { "lua", "typescript" },

	-- Install parsers synchronously (only applied to `ensure_installed`)
	sync_install = false,

	-- Automatically install missing parsers when entering buffer
	-- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
	auto_install = true,

	-- List of parsers to ignore installing (for "all")
	ignore_install = { "javascript" },

	---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
	-- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

	highlight = {
		-- `false` will disable the whole extension
		enable = true,

		-- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
		-- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
		-- the name of the parser)
		-- list of language that will be disabled
		-- disable = { "c", "rust" },
		-- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
		disable = function(lang, buf)
			local max_filesize = 100 * 1024 -- 100 KB
			local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
			if ok and stats and stats.size > max_filesize then
				return true
			end
		end,

		-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
		-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
		-- Using this option may slow down your editor, and you may see some duplicate highlights.
		-- Instead of true it can also be a list of languages
		additional_vim_regex_highlighting = false,
	},
}


require('nvim-autopairs').setup({
	check_ts = true,
	ts_config = {
		lua = { 'string' }, -- it will not add a pair on that treesitter node
	}
})


require('neodev').setup()


require("mason").setup()
require("mason-lspconfig").setup()


local cmp = require('cmp')
cmp.setup({
	snippet = {
		-- REQUIRED - you must specify a snippet engine
		expand = function(args)
			require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
		end,
	},
	sources = cmp.config.sources({
		{ name = 'nvim_lsp' },
		-- { name = 'luasnip' }, -- For luasnip users.
	}, {
		{ name = 'buffer' },
	})
})


require('lspconfig').sumneko_lua.setup {
	capabilities = require('cmp_nvim_lsp').default_capabilities(),
	settings = {
		Lua = {
			runtime = {
				-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
				version = 'LuaJIT',
			},
			diagnostics = {
				-- Get the language server to recognize the `vim` global
				globals = { 'vim' },
			},
			workspace = {
				-- Make the server aware of Neovim runtime files
				library = vim.api.nvim_get_runtime_file("", true),
				checkThirdParty = false
			},
			-- Do not send telemetry data containing a randomized but unique identifier
			telemetry = {
				enable = false,
			},
		},
	},
}

require('lspconfig').tsserver.setup {}


------------------ Keymaps --------------------
vim.keymap.set('n', '<leader>f', vim.lsp.buf.format)
vim.keymap.set('n', 'gd', vim.lsp.buf.definition)
