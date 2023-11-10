-- set <space> as the leader key
-- see `:help mapleader`
--  note: must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- disable netrw at the very start of init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwplugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

-- カーソル行をハイライト
vim.opt.cursorline = true

-- 基本設定のロード
require("custom.conf")
-- keymap設定ファイルのロード
require("custom.keymap")

-- F8: init.luaの編集
vim.api.nvim_set_keymap("n", "<F8>", ":e ~/.config/nvim/init.lua<CR>", { noremap = true, silent = true })

-- F9: init.luaのリロード
--vim.api.nvim_set_keymap('n', '<F9>', ':source ~/.config/nvim/init.lua<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<F9>", ":lua reload_config()<CR>", { noremap = true, silent = true })

-- function for Reload the configuration
function _G.reload_config()
	vim.cmd("source ~/.config/nvim/init.lua")
	vim.cmd("luafile %")
	print("Configuration reloaded")
end

-- ===========================================================
-- Lazyのセットアップ
-- ===========================================================
-- Install package manager
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
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

-- ===========================================================
-- Lazyでインストールするプラグインの設定
-- ===========================================================
-- NOTE: Here is where you install your plugins.
--  You can configure plugins using the `config` key.
--
--  You can also configure plugins after the setup call,
--    as they will be available in your neovim runtime.
require("lazy").setup({
	-- vim helpを日本語化
	"vim-jp/vimdoc-ja",

	-- Detect tabstop and shiftwidth automatically
	"tpope/vim-sleuth",

	-- fire tree
	"nvim-tree/nvim-tree.lua",
	-- 'nvim-tree/nvim-web-devicons',

	{
		-- color scheme OneDark
		"navarasu/onedark.nvim",
		priority = 1000,
		lazy = false,
	},

	-- LSPに関連するプラグインの設定
	-- NOTE: This is where your plugins related to LSP can be installed.
	--  The configuration is done below. Search for lspconfig to find it below.
	{
		-- LSP Configuration & Plugins
		"neovim/nvim-lspconfig",
		dependencies = {
			-- Automatically install LSPs to stdpath for neovim
			{ "williamboman/mason.nvim", config = true },
			"williamboman/mason-lspconfig.nvim",

			-- Additional lua configuration, makes nvim stuff amazing!
			"folke/neodev.nvim",
		},
	},

	{
		-- Autocompletion
		"hrsh7th/nvim-cmp",
		dependencies = {
			-- Snippet Engine & its associated nvim-cmp source
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",

			-- Adds LSP completion capabilities
			"hrsh7th/cmp-nvim-lsp",
		},
	},

	-- Fuzzy Finder (files, lsp, etc)
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			-- Fuzzy Finder Algorithm which requires local dependencies to be built.
			-- Only load if `make` is available. Make sure you have the system
			-- requirements installed.
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				-- NOTE: If you are having trouble with this installation,
				--       refer to the README for telescope-fzf-native for more instructions.
				build = "make",
				cond = function()
					return vim.fn.executable("make") == 1
				end,
			},
		},
	},

	--   {
	--     -- tree-sitterを使ったシンタックスハイライト・構文解析
	--     -- インデントがいい感じに動かないので未使用とする
	--     -- Highlight, edit, and navigate code
	--     'nvim-treesitter/nvim-treesitter',
	--     dependencies = {
	--       'nvim-treesitter/nvim-treesitter-textobjects',
	--     },
	--     build = ':TSUpdate',
	--   },

	-- null-ls(none-ls)
	{
		--'jose-elias-alvarez/null-ls.nvim',
		"nvimtools/none-ls.nvim",
	},

	-- Pretttier
	{
		"prettier/vim-prettier",
		build = "yarn install --frozen-lockfile",
	},
}, {})

-- ===========================================================
-- Color scheme - OneDark
-- ===========================================================
require("onedark").setup({
	style = "dark",
	highlights = {
		["@lsp.type.comment"] = { fg = "#6c8182" },
		["Comment"] = { fg = "#6c8182" },
	},
})

require("onedark").load()

-- ===========================================================
-- Telescope
-- ===========================================================
-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require("telescope").setup({
	defaults = {
		mappings = {
			i = {
				["<C-u>"] = false,
				["<C-d>"] = false,
			},
		},
	},
})

-- Enable telescope fzf native, if installed
pcall(require("telescope").load_extension, "fzf")

-- See `:help telescope.builtin`
vim.keymap.set("n", "<leader>?", require("telescope.builtin").oldfiles, { desc = "[?] Find recently opened files" })
vim.keymap.set("n", "<leader><space>", require("telescope.builtin").buffers, { desc = "[ ] Find existing buffers" })
vim.keymap.set("n", "<leader>/", function()
	-- You can pass additional configuration to telescope to change theme, layout, etc.
	require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
		winblend = 10,
		previewer = false,
	}))
end, { desc = "[/] Fuzzily search in current buffer" })

vim.keymap.set("n", "<leader>gf", require("telescope.builtin").git_files, { desc = "Search [G]it [F]iles" })
vim.keymap.set("n", "<leader>sf", require("telescope.builtin").find_files, { desc = "[S]earch [F]iles" })
vim.keymap.set("n", "<leader>sh", require("telescope.builtin").help_tags, { desc = "[S]earch [H]elp" })
vim.keymap.set("n", "<leader>sw", require("telescope.builtin").grep_string, { desc = "[S]earch current [W]ord" })
vim.keymap.set("n", "<leader>sg", require("telescope.builtin").live_grep, { desc = "[S]earch by [G]rep" })
vim.keymap.set("n", "<leader>sd", require("telescope.builtin").diagnostics, { desc = "[S]earch [D]iagnostics" })
vim.keymap.set("n", "<leader>sr", require("telescope.builtin").resume, { desc = "[S]earch [R]resume" })

-- -- ===========================================================
-- -- Treesitterの設定
-- -- ===========================================================
-- -- [[ Configure Treesitter ]]
-- -- See `:help nvim-treesitter`
-- require('nvim-treesitter.configs').setup {
--   -- Add languages to be installed here that you want installed for treesitter
--   ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'tsx', 'javascript', 'typescript', 'vimdoc', 'vim', 'graphql', 'sql' },
--
--   -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
--   auto_install = false,
--
--   sync_install = false,
--   ignore_install = {},
--   modules = {},
--
--   highlight = { enable = true },
--   indent = { enable = false },
--   incremental_selection = {
--     enable = true,
--     keymaps = {
--       init_selection = '<c-space>',
--       node_incremental = '<c-space>',
--       scope_incremental = '<c-s>',
--       node_decremental = '<M-space>',
--     },
--   },
--   textobjects = {
--     select = {
--       enable = true,
--       lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
--       keymaps = {
--         -- You can use the capture groups defined in textobjects.scm
--         ['aa'] = '@parameter.outer',
--         ['ia'] = '@parameter.inner',
--         ['af'] = '@function.outer',
--         ['if'] = '@function.inner',
--         ['ac'] = '@class.outer',
--         ['ic'] = '@class.inner',
--       },
--     },
--     move = {
--       enable = true,
--       set_jumps = true, -- whether to set jumps in the jumplist
--       goto_next_start = {
--         [']m'] = '@function.outer',
--         [']]'] = '@class.outer',
--       },
--       goto_next_end = {
--         [']M'] = '@function.outer',
--         [']['] = '@class.outer',
--       },
--       goto_previous_start = {
--         ['[m'] = '@function.outer',
--         ['[['] = '@class.outer',
--       },
--       goto_previous_end = {
--         ['[M'] = '@function.outer',
--         ['[]'] = '@class.outer',
--       },
--     },
--     swap = {
--       enable = true,
--       swap_next = {
--         ['<leader>a'] = '@parameter.inner',
--       },
--       swap_previous = {
--         ['<leader>A'] = '@parameter.inner',
--       },
--     },
--   },
-- }

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

-- ===========================================================
-- LSPの設定
-- ===========================================================
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
	-- luaはプログラミング言語だから関数とか作れるよ
	-- NOTE: Remember that lua is a real programming language, and as such it is possible
	-- to define small helper and utility functions so you don't have to repeat yourself
	-- many times.
	--
	-- ここではLSP用のマッピング設定の関数を定義している
	-- In this case, we create a function that lets us more easily define mappings specific
	-- for LSP related items. It sets the mode, buffer and description for us each time.
	local nmap = function(keys, func, desc)
		if desc then
			desc = "LSP: " .. desc
		end

		vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
	end

	-- キーマップの設定
	nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
	nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

	nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
	nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
	nmap("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
	nmap("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
	nmap("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
	nmap("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

	-- See `:help K` for why this keymap
	nmap("K", vim.lsp.buf.hover, "Hover Documentation")
	nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

	-- Lesser used LSP functionality
	nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
	nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
	nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
	nmap("<leader>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, "[W]orkspace [L]ist Folders")

	nmap("<leader>f", vim.lsp.buf.format, "Format current buffer")

	-- Create a command `:Format` local to the LSP buffer
	vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
		vim.lsp.buf.format()
	end, { desc = "Format current buffer with LSP" })
end

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
--
--  If you want to override the default filetypes that your language server will attach to you can
--  define the property 'filetypes' to the map in question.
local servers = {
	-- clangd = {},
	-- gopls = {},
	pyright = {},
	-- rust_analyzer = {},
	-- html = { filetypes = { 'html', 'twig', 'hbs'} },

	tsserver = { "lua", "typescript", "graphql", "javascript", "python", "bash", "sql", "dockerfile", "yaml" },

	lua_ls = {
		Lua = {
			workspace = { checkThirdParty = false },
			telemetry = { enable = false },
		},
	},
}

-- Setup neovim lua configuration
require("neodev").setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

-- Ensure the servers above are installed
local mason_lspconfig = require("mason-lspconfig")

mason_lspconfig.setup({
	ensure_installed = vim.tbl_keys(servers),
})

mason_lspconfig.setup_handlers({
	function(server_name)
		require("lspconfig")[server_name].setup({
			capabilities = capabilities,
			on_attach = on_attach,
			settings = servers[server_name],
			filetypes = (servers[server_name] or {}).filetypes,
		})
	end,
})

-- ===========================================================
-- nvim-cmp
-- ===========================================================
require("mason").setup({
	ui = {
		border = "single",
	},
})

-- ===========================================================
-- nvim-cmp
-- ===========================================================
-- [[ Configure nvim-cmp ]]
-- See `:help cmp`
local cmp = require("cmp")
local luasnip = require("luasnip")
require("luasnip.loaders.from_vscode").lazy_load()
luasnip.config.setup({})

cmp.setup({
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<C-n>"] = cmp.mapping.select_next_item(),
		["<C-p>"] = cmp.mapping.select_prev_item(),
		["<C-d>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete({}),
		["<CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		}),
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_locally_jumpable() then
				luasnip.expand_or_jump()
			else
				fallback()
			end
		end, { "i", "s" }),
		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.locally_jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),
	}),
	sources = {
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
	},
})

-- ===========================================================
-- NvimTree
-- ===========================================================
local function my_on_attach(bufnr)
	local api = require("nvim-tree.api")

	local function opts(desc)
		return { desc = "nvim-tree:" .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
	end

	-- api.config.mappings.default_on_attach(bufnr)

	vim.keymap.set("n", ">", api.tree.change_root_to_node, opts("CD"))
	vim.keymap.set("n", "<", api.tree.change_root_to_parent, opts("Up"))
	-- vim.keymap.set('n', '<C-e>', api.node.open.replace_tree_buffer,     opts('Open: In Place'))
	vim.keymap.set("n", "<C-k>", api.node.show_info_popup, opts("Info"))
	-- vim.keymap.set('n', '<C-r>', api.fs.rename_sub,                     opts('Rename: Omit Filename'))
	-- vim.keymap.set('n', '<C-t>', api.node.open.tab,                     opts('Open: New Tab'))
	vim.keymap.set("n", "t", api.node.open.tab, opts("Open: New Tab"))
	vim.keymap.set("n", "v", api.node.open.vertical, opts("Open: Vertical Split"))
	vim.keymap.set("n", "h", api.node.open.horizontal, opts("Open: Horizontal Split"))
	-- vim.keymap.set('n', '<C-v>', api.node.open.vertical,                opts('Open: Vertical Split'))
	-- vim.keymap.set('n', '<C-x>', api.node.open.horizontal,              opts('Open: Horizontal Split'))
	-- vim.keymap.set('n', '<BS>',  api.node.navigate.parent_close,        opts('Close Directory'))
	vim.keymap.set("n", "<CR>", api.node.open.edit, opts("Open"))
	vim.keymap.set("n", "<Tab>", api.node.open.preview, opts("Open Preview"))
	-- vim.keymap.set('n', '>',     api.node.navigate.sibling.next,        opts('Next Sibling'))
	vim.keymap.set("n", "-", api.node.navigate.sibling.next, opts("Next Sibling"))
	-- vim.keymap.set('n', '<',     api.node.navigate.sibling.prev,        opts('Previous Sibling'))
	-- vim.keymap.set('n', '.',     api.node.run.cmd,                      opts('Run Command'))
	-- vim.keymap.set('n', '-',     api.tree.change_root_to_parent,        opts('Up'))
	-- vim.keymap.set('n', 'a',     api.fs.create,                         opts('Create'))
	vim.keymap.set("n", "n", api.fs.create, opts("Create"))
	vim.keymap.set("n", "r", api.fs.rename_node, opts("Rename Node"))
	vim.keymap.set("n", "c", api.fs.copy.node, opts("Copy"))
	vim.keymap.set("n", "x", api.fs.cut, opts("Cut"))
	vim.keymap.set("n", "p", api.fs.paste, opts("Paste"))
	vim.keymap.set("n", "d", api.fs.remove, opts("Delete"))
	--vim.keymap.set("n", "r", api.fs.rename, opts("Rename"))

	vim.keymap.set("n", "y", api.fs.copy.filename, opts("Copy Name"))
	vim.keymap.set("n", "Y", api.fs.copy.relative_path, opts("Copy Relative Path"))
	vim.keymap.set("n", "gy", api.fs.copy.absolute_path, opts("Copy Absolute Path"))
	-- vim.keymap.set('n', 'bd',    api.marks.bulk.delete,                 opts('Delete Bookmarked'))
	-- vim.keymap.set('n', 'bt',    api.marks.bulk.trash,                  opts('Trash Bookmarked'))
	-- vim.keymap.set('n', 'bmv',   api.marks.bulk.move,                   opts('Move Bookmarked'))
	-- vim.keymap.set('n', 'B',     api.tree.toggle_no_buffer_filter,      opts('Toggle Filter: No Buffer'))
	-- vim.keymap.set('n', 'C',     api.tree.toggle_git_clean_filter,      opts('Toggle Filter: Git Clean'))
	-- vim.keymap.set('n', '[c',    api.node.navigate.git.prev,            opts('Prev Git'))
	-- vim.keymap.set('n', ']c',    api.node.navigate.git.next,            opts('Next Git'))
	-- vim.keymap.set('n', 'D',     api.fs.trash,                          opts('Trash'))
	-- vim.keymap.set('n', 'E',     api.tree.expand_all,                   opts('Expand All'))
	-- vim.keymap.set('n', 'e',     api.fs.rename_basename,                opts('Rename: Basename'))
	-- vim.keymap.set('n', ']e',    api.node.navigate.diagnostics.next,    opts('Next Diagnostic'))
	-- vim.keymap.set('n', '[e',    api.node.navigate.diagnostics.prev,    opts('Prev Diagnostic'))
	-- vim.keymap.set('n', 'F',     api.live_filter.clear,                 opts('Clean Filter'))
	vim.keymap.set("n", "f", api.live_filter.start, opts("Filter"))
	vim.keymap.set("n", "?", api.tree.toggle_help, opts("Help"))
	-- vim.keymap.set('n', 'g?',    api.tree.toggle_help,                  opts('Help'))
	-- vim.keymap.set('n', 'H',     api.tree.toggle_hidden_filter,         opts('Toggle Filter: Dotfiles'))
	vim.keymap.set("n", "I", api.tree.toggle_gitignore_filter, opts("Toggle Filter: Git Ignore"))
	-- vim.keymap.set('n', 'J',     api.node.navigate.sibling.last,        opts('Last Sibling'))
	-- vim.keymap.set('n', 'K',     api.node.navigate.sibling.first,       opts('First Sibling'))
	-- vim.keymap.set('n', 'm',     api.marks.toggle,                      opts('Toggle Bookmark'))
	-- vim.keymap.set('n', 'o',     api.node.open.edit,                    opts('Open'))
	-- vim.keymap.set('n', 'O',     api.node.open.no_window_picker,        opts('Open: No Window Picker'))
	-- vim.keymap.set('n', 'p',     api.fs.paste,                          opts('Paste'))
	vim.keymap.set("n", "P", api.node.navigate.parent, opts("Parent Directory"))
	-- vim.keymap.set('n', 'q',     api.tree.close,                        opts('Close'))
	vim.keymap.set("n", "R", api.tree.reload, opts("Refresh"))
	-- vim.keymap.set('n', 's',     api.node.run.system,                   opts('Run System'))
	-- vim.keymap.set('n', 'S',     api.tree.search_node,                  opts('Search'))
	vim.keymap.set("n", "!", api.tree.toggle_custom_filter, opts("Toggle Filter: Hidden"))
	-- vim.keymap.set('n', 'W',     api.tree.collapse_all,                 opts('Collapse'))
	-- vim.keymap.set('n', '<2-LeftMouse>',  api.node.open.edit,           opts('Open'))
	-- vim.keymap.set('n', '<2-RightMouse>', api.tree.change_root_to_node, opts('CD'))
end

require("nvim-tree").setup({
	actions = {
		open_file = {
			window_picker = {
				enable = false,
			},
		},
	},
	filters = {
		git_ignored = false,
	},
	renderer = {
		indent_markers = {
			enable = true,
		},
		highlight_opened_files = "none",
		icons = {
			show = {
				file = true,
				folder = true,
				folder_arrow = false,
				modified = false,
				git = false,
			},
			glyphs = {
				default = " ",
				folder = {
					arrow_closed = "|",
					arrow_open = "|",
					default = "+",
					open = "-",
					empty = "+",
					empty_open = "-",
					symlink = "+",
					symlink_open = "-",
				},
			},
		},
	},
	on_attach = my_on_attach,
})

-- nvim-treeのトグル
vim.api.nvim_set_keymap("n", "<F2>", ":NvimTreeToggle<CR>", { noremap = true, silent = true })

-- nvim-treeを開く関数
local function open_nvim_tree()
	-- open the tree
	require("nvim-tree.api").tree.open()
end
-- vim起動時にnvim-treeを開く
vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })

-- ===========================================================
-- Null-ls, None-ls
-- ===========================================================
local status, null_ls = pcall(require, "null-ls")
if not status then
	return
end

local nullls_group = vim.api.nvim_create_augroup("", { clear = true })
null_ls.setup({
	sources = {
		-- null_ls.builtins.diagnostics.eslint_d.with({
		--   prefer_local = "node_modules/.bin",
		-- }),
		-- Python
		null_ls.builtins.formatting.black,
		null_ls.builtins.formatting.isort,
		null_ls.builtins.diagnostics.pyproject_flake8,
		--null_ls.builtins.diagnostics.flake8.with({
		--  extra_args = { "--max-line-length", "120" },
		--}),
		-- Lua
		null_ls.builtins.formatting.stylua,
		null_ls.builtins.diagnostics.luacheck,
		-- Typescript
		null_ls.builtins.formatting.prettier.with({
			prefer_local = "node_modules/.bin",
		}),
	},
	on_attach = function(client, bufnr)
		if client.supports_method("textDocument/formatting") then
			vim.api.nvim_clear_autocmds({ group = nullls_group, buffer = bufnr })
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = nullls_group,
				buffer = bufnr,
				callback = function()
					vim.lsp.buf.format({ async = false })
				end,
			})
		end
	end,
})
