local set = vim.o
set.number = true
set.relativenumber = true
-- keybindings

local opt = { noremap = ture, silent = true }
vim.g.mapleader = " "
vim.keymap.set("i", "jk", "<Esc>", opt)
vim.keymap.set("n", "<C-l>", "<C-w>l", opt)
vim.keymap.set("n", "<C-h>", "<C-w>h", opt)
vim.keymap.set("n", "<C-j>", "<C-w>j", opt)
vim.keymap.set("n", "<C-k>", "<C-w>k", opt)
vim.keymap.set("n", "<Leader>|", "<C-w>v", opt)
vim.keymap.set("n", "<Leader>-", "<C-w>s", opt)
-- keybindings-lspconfig
-- Global mappings
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set("n", "<space>e", vim.diagnostic.open_float)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		-- Enable completion triggered by <c-x><c-o>
		vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

		-- Buffer local mappings.
		-- See `:help vim.lsp.*` for documentation on any of the below functions
		local opts = { buffer = ev.buf }
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
		vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
		vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
		vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
		vim.keymap.set("n", "<space>wl", function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, opts)
		vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, opts)
		vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
		vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, opts)
		vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
		vim.keymap.set("n", "<space>f", function()
			vim.lsp.buf.format({ async = true })
		end, opts)
	end,
})

-- lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({

	{
		"windwp/nvim-autopairs",
	},

	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"neovim/nvim-lspconfig",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"L3MON4D3/LuaSnip",
			"hrsh7th/vim-vsnip",
			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-vsnip",
			-- "SirVer/ultisnips",
		},
	},

	{
		"folke/neodev.nvim",
	},

	{
		"folke/which-key.nvim",
		lazy = false,
	},

	{
		"EdenEast/nightfox.nvim",
		lazy = false,
	},

	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		cmd = "Telescope",
		keys = {
			{ "<Leader>p", ":Telescope find_files<CR>", desc = "find files" },
			{ "<leader>s", ":Telescope live_grep<CR>", desc = "grep file" },
			{ "<leader>pr", ":Telescope resume<CR>", desc = "resume" },
			{ "<leader>po", ":Telescope oldfiles<CR>", desc = "oldfiles" },
		},
	},

	{
		"williamboman/mason.nvim",
		build = ":MasonUpdate", -- :MasonUpdate updates registry contents
	},

	{
		"neovim/nvim-lspconfig",
	},

	{
		"williamboman/mason-lspconfig.nvim",
	},

	{
		"jose-elias-alvarez/null-ls.nvim",
	},
})

-- colorscheme
vim.cmd("colorscheme Carbonfox")

-- mason
require("mason").setup()

-- Set up lspconfig.
local capabilities = require("cmp_nvim_lsp").default_capabilities()
require("neodev").setup({
	-- add any options here, or leave empty to use the default settings
})

-- lspconfig.nvim
-- local lspconfig = require("lspconfig")

-- mason-lspconfig
require("mason-lspconfig").setup({
	ensure_installed = {
		"lua_ls",
		"rust_analyzer",
	},
})

-- lspconfig
-- lua-lspconfig
require("lspconfig").lua_ls.setup({
	capabilities = capabilities,
	settings = {
		Lua = {
			runtime = {
				-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
				version = "LuaJIT",
			},
			diagnostics = {
				-- Get the language server to recognize the `vim` global
				globals = { "vim", "hs" },
			},
			workspace = {
				-- Make the server aware of Neovim runtime files
				-- library = vim.api.nvim_get_runtime_file("", true), -- Don't know where is wrong.
				checkThirdParty = false,
				library = {
					vim.api.nvim_get_runtime_file("", true),
					vim.fn.expand("~/lualib/share/lua/5.4"),
					vim.fn.expand("~/lualib/lib/luarocks/rocks-5.4"),
					"/opt/homebrew/opt/openresty/lualib",
				},
			},
			completion = {
				callSnippet = "Replace",
			},
			-- Do not send telemetry data containing a randomized but unique identifier
			telemetry = {
				enable = false,
			},
		},
	},
})

-- the before config of keymapping of cmp
local has_words_before = function()
	unpack = unpack or table.unpack
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local feedkey = function(key, mode)
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

-- nvim-cmp.
local cmp = require("cmp")

cmp.setup({
	snippet = {
		-- REQUIRED - you must specify a snippet engine
		expand = function(args)
			vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
			-- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
			-- require('snippy').expand_snippet(args.body) -- For `snippy` users.
			-- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
		end,
	},
	window = {
		-- completion = cmp.config.window.bordered(),
		-- documentation = cmp.config.window.bordered(),
	},
	mapping = cmp.mapping.preset.insert({
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif vim.fn["vsnip#available"](1) == 1 then
				feedkey("<Plug>(vsnip-expand-or-jump)", "")
			elseif has_words_before() then
				cmp.complete()
			else
				fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
			end
		end, { "i", "s" }),

		["<S-Tab>"] = cmp.mapping(function()
			if cmp.visible() then
				cmp.select_prev_item()
			elseif vim.fn["vsnip#jumpable"](-1) == 1 then
				feedkey("<Plug>(vsnip-jump-prev)", "")
			end
		end, { "i", "s" }),
		["<C-b>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-m>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.abort(),
		["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
	}),
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "vsnip" }, -- For vsnip users.
		-- { name = 'luasnip' }, -- For luasnip users.
		-- { name = 'ultisnips' }, -- For ultisnips users.
		-- { name = 'snippy' }, -- For snippy users.
	}, {
		{ name = "buffer" },
	}),
})

-- Set configuration for specific filetype.
cmp.setup.filetype("gitcommit", {
	sources = cmp.config.sources({
		{ name = "cmp_git" }, -- You can specify the `cmp_git` source if you were installed it.
	}, {
		{ name = "buffer" },
	}),
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ "/", "?" }, {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = "buffer" },
	},
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = "path" },
	}, {
		{ name = "cmdline" },
	}),
})

-- autopairs
require("nvim-autopairs").setup({})

-- local lsp_formatting = function(bufnr)
-- 	vim.lsp.buf.format({
-- 		filter = function(client)
-- 			-- apply whatever logic you want (in this example, we'll only use null-ls)
-- 			return client.name == "null-ls"
-- 		end,
-- 		bufnr = bufnr,
-- 	})
-- end

-- if you want to set up formatting on save, you can use this as a callback
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

-- null-ls
local null_ls = require("null-ls")
null_ls.setup({
	sources = {
		null_ls.builtins.formatting.stylua,
		null_ls.builtins.diagnostics.eslint,
		null_ls.builtins.completion.spell,
	},
	on_attach = function(client, bufnr)
		if client.supports_method("textDocument/formatting") then
			vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				buffer = bufnr,
				callback = function()
					-- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
					vim.lsp.buf.format({ bufnr = bufnr })
				end,
			})
		end
	end,
})

-- -- add to your shared on_attach callback
-- local on_attach = function(client, bufnr)
-- 	if client.supports_method("textDocument/formatting") then
-- 		vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
-- 		vim.api.nvim_create_autocmd("BufWritePre", {
-- 			group = augroup,
-- 			buffer = bufnr,
-- 			callback = function()
-- 				lsp_formatting(bufnr)
-- 			end,
-- 		})
-- 	end
-- end
