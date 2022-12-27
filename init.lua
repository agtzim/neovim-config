-- My init file
-- Install packer
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.o.guifont = 'Cascadia Code PL:h11'
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.number = true

require('packer').startup({ function(use)

	-- Package manager
	use 'wbthomason/packer.nvim'

	use 'folke/tokyonight.nvim'

	use 'Pocco81/auto-save.nvim'

	use {
		'nvim-treesitter/nvim-treesitter',
		run = function() require('nvim-treesitter.install').update({ with_sync = true }) end,
	}

	use 'windwp/nvim-autopairs'

	use "lukas-reineke/indent-blankline.nvim"

	use { -- LSP Configuration & Plugins
		'neovim/nvim-lspconfig',
		requires = {
			-- Automatically install LSPs to stdpath for neovim
			'williamboman/mason.nvim',
			'williamboman/mason-lspconfig.nvim',

			-- Useful status updates for LSP
			--'j-hui/fidget.nvim',

			-- Additional lua configuration, makes nvim stuff amazing
			'folke/neodev.nvim',
		},
	}

	-- Completion
	use {
		'hrsh7th/nvim-cmp',
		requires = { 'hrsh7th/cmp-nvim-lsp', 'L3MON4D3/LuaSnip', 'saadparwaiz1/cmp_luasnip' },
	}

end,
	config = {
		display = {
			open_fn = function()
				return require('packer.util').float({ border = 'single' })
			end
		}

	}
})


vim.cmd.colorscheme('tokyonight')


require('auto-save').setup {}


require 'nvim-treesitter.configs'.setup {
	-- A list of parser names, or "all"
	ensure_installed = { "lua", "help" },

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
		-- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
		disable = function(lang, buf)
			print(lang)
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
	}
}



-- TODO - Learn more about autopairs configuration
require('nvim-autopairs').setup({
	check_ts = true
})


require("indent_blankline").setup {
	-- for example, context is off by default, use this to turn it on
	show_current_context = true,
	show_current_context_start = true,
}


require('neodev').setup()
require('mason').setup()
require('mason-lspconfig').setup {
	ensure_installed = { 'sumneko_lua' }
}


local lspconfig = require('lspconfig')

lspconfig.sumneko_lua.setup {
	settings = {
		Lua = {
			workspace = {
				checkThirdParty = false
			},
			telemetry = {
				enable = false
			}
		}
	}
}


-- KEYMAPS
vim.keymap.set('n', '<leader>f', vim.lsp.buf.format)
