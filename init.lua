vim.cmd([[set noswapfile]])
vim.cmd([[set expandtab]])
vim.cmd([[set tabstop=4]])
vim.cmd([[set mouse=a]])
vim.cmd([[set selection=exclusive]])
vim.cmd([[set selectmode=mouse,key]])
vim.cmd([[set nu]])
vim.cmd([[let mapleader=" "]])
vim.cmd([[map <C-n> :ToggleTerm direction=float<CR>]])
vim.cmd([[colorscheme catppuccin]])
vim.cmd([[nmap <tab> :bn<cr>]])
vim.cmd([[nmap <C-S> :w<cr>]])
vim.cmd([[set showcmd]])
vim.cmd([[set cursorline]])
vim.cmd([[
    autocmd FileType alpha setlocal nofoldenable
]])
vim.cmd([[set rnu]])

local use = require("packer").use
require("packer").startup(function()
	use({
		"kylechui/nvim-surround",
		tag = "*", -- Use for stability; omit to use `main` branch for the latest features
		config = function()
			require("nvim-surround").setup({
				-- Configuration here, or leave empty to use defaults
			})
		end,
	})
	use({ "simrat39/symbols-outline.nvim" })
	-- using packer.nvim
	use({ "akinsho/bufferline.nvim", tag = "v2.*", requires = "kyazdani42/nvim-web-devicons" })
	use({ "theHamsta/nvim-treesitter-pairs" })
	use({
		"lewis6991/gitsigns.nvim",
		-- tag = 'release' -- To use the latest release (do not use this if you run Neovim nightly or dev builds!)
	})
	use({
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()
		end,
	})
	use({
		"ray-x/lsp_signature.nvim",
	})
	use({
		"nvim-telescope/telescope.nvim",
		tag = "0.1.0",
		-- or                            , branch = '0.1.x',
		requires = { { "nvim-lua/plenary.nvim" }, { "BurntSushi/ripgrep" }, { "sharkdp/fd" } },
	})
	use({
		"glepnir/lspsaga.nvim",
		branch = "main",
	})
	use({
		"goolord/alpha-nvim",
		requires = { "kyazdani42/nvim-web-devicons", { "BlakeJC94/alpha-nvim-fortune" } },
	})
	use("weilbith/nvim-lsp-smag")
	use("jubnzv/virtual-types.nvim")
	use("wbthomason/packer.nvim")
	use("williamboman/nvim-lsp-installer")
	use("neovim/nvim-lspconfig")
	use("hrsh7th/nvim-cmp") -- Autocompletion plugin
	use("hrsh7th/cmp-path") -- Autocompletion plugin
	use("hrsh7th/cmp-buffer") -- Autocompletion plugin
	use("hrsh7th/cmp-cmdline") -- Autocompletion plugin
	use("hrsh7th/cmp-nvim-lsp") -- LSP source for nvim-cmp
	use("saadparwaiz1/cmp_luasnip") -- Snippets source for nvim-cmp
	use("L3MON4D3/LuaSnip") -- Snippets plugin
	use("windwp/nvim-autopairs")
	use("shaunsingh/nord.nvim")
	-- Packer
	use({ "sindrets/diffview.nvim", requires = "nvim-lua/plenary.nvim" })
	use({ "catppuccin/nvim", as = "catppuccin" })
	use({
		"nvim-treesitter/nvim-treesitter",
		requires = "p00f/nvim-ts-rainbow",
	})
	use("yamatsum/nvim-cursorline")
	use({
		"kyazdani42/nvim-tree.lua",
		requires = "kyazdani42/nvim-web-devicons",
	})
	use({
		"nvim-lualine/lualine.nvim",
		requires = { "kyazdani42/nvim-web-devicons", opt = true },
	})
	use({
		"akinsho/toggleterm.nvim",
		tag = "v2.*",
		config = function()
			require("toggleterm").setup()
		end,
	})
	use("karb94/neoscroll.nvim")
	use({ "mhartington/formatter.nvim" })
end)

require("nvim-lsp-installer").setup({
	automatic_installation = false, -- automatically detect which servers to install (based on which servers are set up via lspconfig)
	ui = {
		icons = {
			server_installed = "✓",
			server_pending = "➜",
			server_uninstalled = "✗",
		},
	},
})

require("lspconfig").ocamllsp.setup({ on_attach = require("virtualtypes").on_attach })
require("symbols-outline").setup({ position = "right" })
require("nvim-treesitter.configs").setup({
	highlight = {},
	-- ...
	rainbow = {
		enable = true,
		-- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
		extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
		max_file_lines = nil, -- Do not enable for files with more than n lines, int
		-- colors = {}, -- table of hex strings
		-- termcolors = {} -- table of colour name strings
	},
})

--------------------------------------------------------------
-- Eviline config for lualine
-- Author: shadmansaleh
-- Credit: glepnir
local lualine = require("lualine")

-- Color table for highlights
-- stylua: ignore
local colors = {
  bg       = '#202328',
  fg       = '#bbc2cf',
  yellow   = '#ECBE7B',
  cyan     = '#008080',
  darkblue = '#081633',
  green    = '#98be65',
  orange   = '#FF8800',
  violet   = '#a9a1e1',
  magenta  = '#c678dd',
  blue     = '#51afef',
  red      = '#ec5f67',
}

local conditions = {
	buffer_not_empty = function()
		return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
	end,
	hide_in_width = function()
		return vim.fn.winwidth(0) > 80
	end,
	check_git_workspace = function()
		local filepath = vim.fn.expand("%:p:h")
		local gitdir = vim.fn.finddir(".git", filepath .. ";")
		return gitdir and #gitdir > 0 and #gitdir < #filepath
	end,
}

-- Config
local config = {
	options = {
		-- Disable sections and component separators
		component_separators = "",
		section_separators = "",
		theme = {
			-- We are going to use lualine_c an lualine_x as left and
			-- right section. Both are highlighted by c theme .  So we
			-- are just setting default looks o statusline
			normal = { c = { fg = colors.fg, bg = colors.bg } },
			inactive = { c = { fg = colors.fg, bg = colors.bg } },
		},
	},
	sections = {
		-- these are to remove the defaults
		lualine_a = {},
		lualine_b = {},
		lualine_y = {},
		lualine_z = {},
		-- These will be filled later
		lualine_c = {},
		lualine_x = {},
	},
	inactive_sections = {
		-- these are to remove the defaults
		lualine_a = {},
		lualine_b = {},
		lualine_y = {},
		lualine_z = {},
		lualine_c = {},
		lualine_x = {},
	},
}

-- Inserts a component in lualine_c at left section
local function ins_left(component)
	table.insert(config.sections.lualine_c, component)
end

-- Inserts a component in lualine_x ot right section
local function ins_right(component)
	table.insert(config.sections.lualine_x, component)
end

ins_left({
	function()
		return "▊"
	end,
	color = { fg = colors.blue }, -- Sets highlighting of component
	padding = { left = 0, right = 1 }, -- We don't need space before this
})

ins_left({
	-- mode component
	function()
		return ""
	end,
	color = function()
		-- auto change color according to neovims mode
		local mode_color = {
			n = colors.red,
			i = colors.green,
			v = colors.blue,
			[""] = colors.blue,
			V = colors.blue,
			c = colors.magenta,
			no = colors.red,
			s = colors.orange,
			S = colors.orange,
			[""] = colors.orange,
			ic = colors.yellow,
			R = colors.violet,
			Rv = colors.violet,
			cv = colors.red,
			ce = colors.red,
			r = colors.cyan,
			rm = colors.cyan,
			["r?"] = colors.cyan,
			["!"] = colors.red,
			t = colors.red,
		}
		return { fg = mode_color[vim.fn.mode()] }
	end,
	padding = { right = 1 },
})

ins_left({
	-- filesize component
	"filesize",
	cond = conditions.buffer_not_empty,
})

ins_left({
	"filename",
	cond = conditions.buffer_not_empty,
	color = { fg = colors.magenta, gui = "bold" },
})

ins_left({ "location" })

ins_left({ "progress", color = { fg = colors.fg, gui = "bold" } })

ins_left({
	"diagnostics",
	sources = { "nvim_diagnostic" },
	symbols = { error = " ", warn = " ", info = " " },
	diagnostics_color = {
		color_error = { fg = colors.red },
		color_warn = { fg = colors.yellow },
		color_info = { fg = colors.cyan },
	},
})

-- Insert mid section. You can make any number of sections in neovim :)
-- for lualine it's any number greater then 2
ins_left({
	function()
		return "%="
	end,
})

ins_left({
	-- Lsp server name .
	function()
		local msg = "No Active Lsp"
		local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
		local clients = vim.lsp.get_active_clients()
		if next(clients) == nil then
			return msg
		end
		for _, client in ipairs(clients) do
			local filetypes = client.config.filetypes
			if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
				return client.name
			end
		end
		return msg
	end,
	icon = " LSP:",
	color = { fg = "#ffffff", gui = "bold" },
})

-- Add components to right sections
ins_right({
	"o:encoding", -- option component same as &encoding in viml
	fmt = string.upper, -- I'm not sure why it's upper case either ;)
	cond = conditions.hide_in_width,
	color = { fg = colors.green, gui = "bold" },
})

ins_right({
	"fileformat",
	fmt = string.upper,
	icons_enabled = false, -- I think icons are cool but Eviline doesn't have them. sigh
	color = { fg = colors.green, gui = "bold" },
})

ins_right({
	"branch",
	icon = "",
	color = { fg = colors.violet, gui = "bold" },
})

ins_right({
	"diff",
	-- Is it me or the symbol for modified us really weird
	symbols = { added = " ", modified = "柳 ", removed = " " },
	diff_color = {
		added = { fg = colors.green },
		modified = { fg = colors.orange },
		removed = { fg = colors.red },
	},
	cond = conditions.hide_in_width,
})

ins_right({
	function()
		return "▊"
	end,
	color = { fg = colors.blue },
	padding = { left = 1 },
})

-- Now don't forget to initialize lualine
lualine.setup(config)
--------------------------------------------------------------
-- Utilities for creating configurations
local util = require("formatter.util")

-- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
require("formatter").setup({
	-- Enable or disable logging
	logging = true,
	-- Set the log level
	log_level = vim.log.levels.WARN,
	-- All formatter configurations are opt-in
	filetype = {
		-- Formatter configurations for filetype "lua" go here
		-- and will be executed in order
		lua = {
			-- "formatter.filetypes.lua" defines default configurations for the
			-- "lua" filetype
			require("formatter.filetypes.lua").stylua,
			-- You can also define your own configuration
			function()
				-- Supports conditional formatting
				if util.get_current_buffer_file_name() == "special.lua" then
					return nil
				end

				-- Full specification of configurations is down below and in Vim help
				-- files
				return {
					exe = "stylua",
					args = {
						"--search-parent-directories",
						"--stdin-filepath",
						util.escape_path(util.get_current_buffer_file_path()),
						"--",
						"-",
					},
					stdin = true,
				}
			end,
		},
		c = {
			require("formatter.filetypes.c").clangformat,
			function()
				if util.get_current_buffer_file_name() == "special.c" then
					return nil
				end
				return {
					exe = "clang-format",
					stdin = true,
				}
			end,
		},
		py = {
			require("formatter.filetypes.python").pyright,
			function()
				if util.get_current_buffer_file_name() == "special.python" then
					return nil
				end
				return {
					exe = "pyright",
					stdin = true,
				}
			end,
		},
		cc = {
			require("formatter.filetypes.c").clangformat,
			function()
				if util.get_current_buffer_file_name() == "special.c" then
					return nil
				end
				return {
					exe = "clang-format",
					stdin = true,
				}
			end,
		},
		cpp = {
			require("formatter.filetypes.c").clangformat,
			function()
				if util.get_current_buffer_file_name() == "special.c" then
					return nil
				end
				return {
					exe = "clang-format",
					stdin = true,
				}
			end,
		},
		rs = {
			require("formatter.filetypes.rust").rustfmt,
			function()
				if util.get_current_buffer_file_name() == "special.rust" then
					return nil
				end
				return {
					exe = "rustfmt",
					stdin = true,
				}
			end,
		},
		cmake = {
			require("formatter.filetypes.cmake").cmakeformat,
			function()
				if util.get_current_buffer_file_name() == "special.cmakeformat" then
					return nil
				end
				return {
					exe = "cmake-format",
					stdin = true,
				}
			end,
		},
		-- Use the special "*" filetype for defining formatter configurations on
		-- any filetype
		["*"] = {
			-- "formatter.filetypes.any" defines default configurations for any
			-- filetype
			require("formatter.filetypes.any").remove_trailing_whitespace,
		},
	},
})

require("toggleterm").setup({
	-- size can be a number or function which is passed the current terminal
	size = function(term)
		if term.direction == "horizontal" then
			return 15
		elseif term.direction == "vertical" then
			return vim.o.columns * 0.40
		end
	end,
	on_open = function()
		-- Prevent infinite calls from freezing neovim.
		-- Only set these options specific to this terminal buffer.
		vim.api.nvim_set_option_value("foldmethod", "manual", { scope = "local" })
		vim.api.nvim_set_option_value("foldexpr", "0", { scope = "local" })
	end,
	open_mapping = false, -- [[<c-\>]],
	hide_numbers = true, -- hide the number column in toggleterm buffers
	shade_filetypes = {},
	shade_terminals = false,
	shading_factor = "1", -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
	start_in_insert = true,
	insert_mappings = true, -- whether or not the open mapping applies in insert mode
	persist_size = true,
	direction = "horizontal",
	close_on_exit = true, -- close the terminal window when the process exits
	shell = vim.o.shell, -- change the default shell
})

require("nvim-autopairs").setup({})

require("neoscroll").setup()

local kind_icons = {
	Text = "",
	Method = "m",
	Function = "",
	Constructor = "",
	Field = "",
	Variable = "",
	Class = "",
	Interface = "",
	Module = "",
	Property = "",
	Unit = "",
	Value = "",
	Enum = "",
	Keyword = "",
	Snippet = "",
	Color = "",
	File = "",
	Reference = "",
	Folder = "",
	EnumMember = "",
	Constant = "",
	Struct = "",
	Event = "",
	Operator = "",
	TypeParameter = "",
}

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

local lspconfig = require("lspconfig")

-- Enable some language servers with the additional completion capabilities offered by nvim-cmp
local servers = { "clangd", "pyright", "bashls", "cmake", "rust_analyzer", "sumneko_lua", "awk_ls" }

for _, lsp in ipairs(servers) do
	lspconfig[lsp].setup({
		capabilities = capabilities,
	})
end

lspconfig["sumneko_lua"].setup({
	settings = {
		Lua = {
			runtime = {
				-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
				version = "LuaJIT",
				-- Setup your lua path
				path = vim.split(package.path, ";"),
			},
			diagnostics = {
				-- Get the language server to recognize the `vim` global
				globals = { "vim" },
			},
			workspace = {
				-- Make the server aware of Neovim runtime files
				library = {
					[vim.fn.expand("$VIMRUNTIME/lua")] = true,
					[vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
				},
				maxPreload = 10 * 1024,
				preloadFileSize = 10 * 1024,
			},
		},
	},
	capabilities = capabilities,
})

lspconfig["clangd"].setup({
	cmd = {
		"clangd",
		"--pch-storage=memory",
		-- You MUST set this arg ↓ to your clangd executable location (if not included)!
		"--background-index",
		"--clang-tidy-checks=performance-*,bugprone-*",
		"--limit-references=20",
		"--limit-results=20",
		"--query-driver=/usr/bin/gcc*,/usr/bin/clang++*,/usr/bin/clang*,/usr/bin/g++*,/opt/petalinux/2021.2/sysroots/x86_64-petalinux-linux/usr/bin/aarch64-xilinx-linux/aarch64-xilinx-linux-gcc, \
                /opt/petalinux/2021.2/sysroots/x86_64-petalinux-linux/usr/bin/aarch64-xilinx-linux/aarch64-xilinx-linux-g++, \
                /opt/petalinux/2019.2/sysroots/x86_64-petalinux-linux/usr/bin/arm-xilinx-linux/arm-xilinx-linux-gcc, \
                /opt/petalinux/2019.2/sysroots/x86_64-petalinux-linux/usr/bin/arm-xilinx-linux/arm-xilinx-linux-g++",
		"--clang-tidy",
		"--all-scopes-completion",
		"--completion-style=detailed",
		"--header-insertion=iwyu",
		"-j=12",
	},
})

-- luasnip setup
local luasnip = require("luasnip")

-- nvim-cmp setup
local cmp = require("cmp")
cmp.setup({
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<C-d>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		}),
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			else
				fallback()
			end
		end, { "i", "s" }),
		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),
	}),
	formatting = {
		fields = { "kind", "abbr", "menu" },
		format = function(entry, vim_item)
			-- Kind icons
			vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
			vim_item.menu = ({
				nvim_lsp = "[LSP]",
				ultisnips = "[Snippet]",
				buffer = "[Buffer]",
				path = "[Path]",
			})[entry.source.name]
			return vim_item
		end,
	},
	sources = {
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		{ name = "buffer" },
		{ name = "path" },
	},
	options = {
		indexing_interval = 10,
	},
})

cmp.setup.cmdline("/", {
	completion = { autocomplete = false },
	sources = {
		{ name = "buffer" },
	},
})

cmp.setup.cmdline(":", {
	completion = { autocomplete = false },
	sources = cmp.config.sources({
		{ name = "path" },
	}, {
		{ name = "cmdline" },
	}),
})

require("nvim-treesitter.configs").setup({
	-- A list of parser names, or "all"
	ensure_installed = { "c", "lua", "python", "cmake", "cpp", "make", "bash", "rust" },
	-- Install parsers synchronously (only applied to `ensure_installed`)
	sync_install = true,
	-- Automatically install missing parsers when entering buffer
	auto_install = false,
	---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
	-- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

	highlight = {
		enable = true,
		additional_vim_regex_highlighting = true,
	},
	rainbow = {
		enable = true,
		-- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
		extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
		max_file_lines = nil, -- Do not enable for files with more than n lines, int
		-- colors = {}, -- table of hex strings
		-- termcolors = {} -- table of colour name strings
	},
})

require("nvim-tree").setup({
	ignore_ft_on_setup = {
		"startify",
		"dashboard",
		"alpha",
	},
	hijack_cursor = true,
	auto_reload_on_write = true,
	hijack_directories = {
		enable = false,
	},
	update_cwd = true,
	diagnostics = {
		show_on_dirs = false,
		icons = {
			hint = "",
			info = "",
			warning = "",
			error = "",
		},
	},
	update_focused_file = {
		enable = true,
		update_cwd = true,
		ignore_list = {},
	},
	system_open = {
		cmd = nil,
		args = {},
	},
	git = {
		enable = true,
		ignore = true,
		timeout = 200,
	},
	view = {
		width = 30,
		height = 30,
		hide_root_folder = false,
		side = "left",
		mappings = {
			custom_only = false,
			list = {},
		},
		number = false,
		relativenumber = false,
		signcolumn = "yes",
	},
	renderer = {
		indent_markers = {
			enable = true,
			icons = {
				corner = "└",
				edge = "│",
				item = "│",
				none = " ",
			},
		},
		icons = {
			glyphs = {
				default = "",
				symlink = "",
				git = {
					unstaged = "",
					staged = "S",
					unmerged = "",
					renamed = "➜",
					deleted = "",
					untracked = "U",
					ignored = "◌",
				},
				folder = {
					default = "",
					open = "",
					empty = "",
					empty_open = "",
					symlink = "",
				},
			},
		},
		highlight_git = true,
		root_folder_modifier = ":t",
	},
	filters = {
		dotfiles = false,
		custom = { "node_modules", "\\.cache" },
		exclude = {},
	},
	trash = {
		cmd = "trash",
		require_confirm = true,
	},
	log = {
		enable = false,
		truncate = false,
		types = {
			all = false,
			config = false,
			copy_paste = false,
			diagnostics = false,
			git = false,
			profile = false,
		},
	},
	actions = {
		use_system_clipboard = true,
		change_dir = {
			enable = true,
			global = false,
			restrict_above_cwd = false,
		},
		open_file = {
			quit_on_open = false,
			resize_window = false,
			window_picker = {
				enable = true,
				chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
				exclude = {
					filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame" },
					buftype = { "nofile", "terminal", "help" },
				},
			},
		},
	},
})

require("nvim-cursorline").setup({
	cursorline = {
		enable = true,
		timeout = 1000,
		number = false,
	},
	cursorword = {
		enable = true,
		min_length = 3,
		hl = { underline = true },
	},
})

vim.g.catppuccin_flavour = "macchiato" -- latte, frappe, macchiato, mocha

-- Theme

require("catppuccin").setup()

-- nord colorscheme

-- Lua
local actions = require("diffview.actions")

require("diffview").setup({
	diff_binaries = false, -- Show diffs for binaries
	enhanced_diff_hl = false, -- See ':h diffview-config-enhanced_diff_hl'
	git_cmd = { "git" }, -- The git executable followed by default args.
	use_icons = true, -- Requires nvim-web-devicons
	icons = {
		-- Only applies when use_icons is true.
		folder_closed = "",
		folder_open = "",
	},
	signs = {
		fold_closed = "",
		fold_open = "",
	},
	file_panel = {
		listing_style = "tree", -- One of 'list' or 'tree'
		tree_options = {
			-- Only applies when listing_style is 'tree'
			flatten_dirs = true, -- Flatten dirs that only contain one single dir
			folder_statuses = "only_folded", -- One of 'never', 'only_folded' or 'always'.
		},
		win_config = {
			-- See ':h diffview-config-win_config'
			position = "left",
			width = 35,
		},
	},
	file_history_panel = {
		log_options = {
			-- See ':h diffview-config-log_options'
			single_file = {
				diff_merges = "combined",
			},
			multi_file = {
				diff_merges = "first-parent",
			},
		},
		win_config = {
			-- See ':h diffview-config-win_config'
			position = "bottom",
			height = 16,
		},
	},
	commit_log_panel = {
		win_config = {}, -- See ':h diffview-config-win_config'
	},
	default_args = {
		-- Default args prepended to the arg-list for the listed commands
		DiffviewOpen = {},
		DiffviewFileHistory = {},
	},
	hooks = {}, -- See ':h diffview-config-hooks'
	keymaps = {
		disable_defaults = false, -- Disable the default keymaps
		view = {
			-- The `view` bindings are active in the diff buffers, only when the current
			-- tabpage is a Diffview.
			["<tab>"] = actions.select_next_entry, -- Open the diff for the next file
			["<s-tab>"] = actions.select_prev_entry, -- Open the diff for the previous file
			["gf"] = actions.goto_file, -- Open the file in a new split in the previous tabpage
			["<C-w><C-f>"] = actions.goto_file_split, -- Open the file in a new split
			["<C-w>gf"] = actions.goto_file_tab, -- Open the file in a new tabpage
			["<leader>e"] = actions.focus_files, -- Bring focus to the files panel
			["<leader>b"] = actions.toggle_files, -- Toggle the files panel.
		},
		file_panel = {
			["j"] = actions.next_entry, -- Bring the cursor to the next file entry
			["<down>"] = actions.next_entry,
			["k"] = actions.prev_entry, -- Bring the cursor to the previous file entry.
			["<up>"] = actions.prev_entry,
			["<cr>"] = actions.select_entry, -- Open the diff for the selected entry.
			["o"] = actions.select_entry,
			["<2-LeftMouse>"] = actions.select_entry,
			["-"] = actions.toggle_stage_entry, -- Stage / unstage the selected entry.
			["S"] = actions.stage_all, -- Stage all entries.
			["U"] = actions.unstage_all, -- Unstage all entries.
			["X"] = actions.restore_entry, -- Restore entry to the state on the left side.
			["R"] = actions.refresh_files, -- Update stats and entries in the file list.
			["L"] = actions.open_commit_log, -- Open the commit log panel.
			["<c-b>"] = actions.scroll_view(-0.25), -- Scroll the view up
			["<c-f>"] = actions.scroll_view(0.25), -- Scroll the view down
			["<tab>"] = actions.select_next_entry,
			["<s-tab>"] = actions.select_prev_entry,
			["gf"] = actions.goto_file,
			["<C-w><C-f>"] = actions.goto_file_split,
			["<C-w>gf"] = actions.goto_file_tab,
			["i"] = actions.listing_style, -- Toggle between 'list' and 'tree' views
			["f"] = actions.toggle_flatten_dirs, -- Flatten empty subdirectories in tree listing style.
			["<leader>e"] = actions.focus_files,
			["<leader>b"] = actions.toggle_files,
		},
		file_history_panel = {
			["g!"] = actions.options, -- Open the option panel
			["<C-A-d>"] = actions.open_in_diffview, -- Open the entry under the cursor in a diffview
			["y"] = actions.copy_hash, -- Copy the commit hash of the entry under the cursor
			["L"] = actions.open_commit_log,
			["zR"] = actions.open_all_folds,
			["zM"] = actions.close_all_folds,
			["j"] = actions.next_entry,
			["<down>"] = actions.next_entry,
			["k"] = actions.prev_entry,
			["<up>"] = actions.prev_entry,
			["<cr>"] = actions.select_entry,
			["o"] = actions.select_entry,
			["<2-LeftMouse>"] = actions.select_entry,
			["<c-b>"] = actions.scroll_view(-0.25),
			["<c-f>"] = actions.scroll_view(0.25),
			["<tab>"] = actions.select_next_entry,
			["<s-tab>"] = actions.select_prev_entry,
			["gf"] = actions.goto_file,
			["<C-w><C-f>"] = actions.goto_file_split,
			["<C-w>gf"] = actions.goto_file_tab,
			["<leader>e"] = actions.focus_files,
			["<leader>b"] = actions.toggle_files,
		},
		option_panel = {
			["<tab>"] = actions.select_entry,
			["q"] = actions.close,
		},
	},
})

vim.api.nvim_exec(
	[[
augroup FormatAutogroup
  autocmd!
  autocmd BufWritePost *.rs,*.lua,*.c,*.cc,*.cpp,*.h,*.py FormatWrite
augroup END
]],
	true
)

local keymap = vim.keymap.set
keymap("n", "gh", "<cmd>Lspsaga lsp_finder<CR>", { silent = true })

keymap("i", "<A-j>", "<Esc>:m .+1<CR>==gi", { silent = true })
keymap("i", "<A-k>", "<Esc>:m .-2<CR>==gi", { silent = true })
keymap("n", "<A-j>", "<Esc>:m .+1<CR>==", { silent = true })
keymap("n", "<A-k>", "<Esc>:m .-2<CR>==", { silent = true })
keymap("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { silent = true })
keymap("v", "<A-j>", ":m '>+1<CR>gv-gv", { silent = true })
keymap("v", "<A-k>", ":m '<-2<CR>gv-gv", { silent = true })
keymap("n", "<A-q>", "<cmd>BufferLineCloseRight<CR>", { silent = true })
keymap("i", "jj", "<Esc><Esc>", { silent = true })
-- Code action
keymap("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", { silent = true })
keymap("v", "<leader>ca", "<cmd><C-U>Lspsaga range_code_action<CR>", { silent = true })
keymap("n", "<leader>w", "<cmd>Telescope live_grep<CR>", { silent = true })
keymap("n", "<leader>f", "<cmd>Telescope find_files<CR>", { silent = true })
keymap("n", "<C-q>", "<cmd>wa!|qa!<CR>", { silent = true })

-- Rename
keymap("n", "gr", "<cmd>Lspsaga rename<CR>", { silent = true })

-- Definition preview
keymap("n", "gd", "<cmd>Lspsaga peek_definition<CR>", { silent = true })

-- Show line diagnostics
keymap("n", "<leader>cd", "<cmd>Lspsaga show_line_diagnostics<CR>", { silent = true })

-- Show cursor diagnostic

-- Diagnsotic jump can use `<c-o>` to jump back
keymap("n", "[e", "<cmd>Lspsaga diagnostic_jump_next<CR>", { silent = true })
keymap("n", "]e", "<cmd>Lspsaga diagnostic_jump_prev<CR>", { silent = true })

-- Only jump to error
keymap("n", "[E", function()
	require("lspsaga.diagnostic").goto_prev({ severity = vim.diagnostic.severity.ERROR })
end, { silent = true })
keymap("n", "]E", function()
	require("lspsaga.diagnostic").goto_next({ severity = vim.diagnostic.severity.ERROR })
end, { silent = true })

-- Outline
keymap("n", "<leader>o", "<cmd>LSoutlineToggle<CR>", { silent = true })

-- Hover Doc
keymap("n", "K", "<cmd>Lspsaga hover_doc<CR>", { silent = true })

-- Float terminal
keymap("n", "<A-d>", "<cmd>Lspsaga open_floaterm<CR>", { silent = true })
-- if you want pass somc cli command into terminal you can do like this
-- open lazygit in lspsaga float terminal
keymap("n", "<A-d>", "<cmd>Lspsaga open_floaterm lazygit<CR>", { silent = true })
-- close floaterm
keymap("t", "<A-d>", [[<C-\><C-n><cmd>Lspsaga close_floaterm<CR>]], { silent = true })

local alpha = require("alpha")
local dashboard = require("alpha.themes.dashboard")

-- Set header
dashboard.section.header.val = {
	"                                                     ",
	"  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
	"  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
	"  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
	"  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
	"  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
	"  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
	"                                                     ",
}

-- Set menu
dashboard.section.buttons.val = {
	dashboard.button("<leader>n", " New File", ":ene <BAR> startinsert <CR>"),
	dashboard.button("<leader>f", " Find Fine", ":Telescope find_files<CR>"),
	dashboard.button("<leader>r", " Recently Used Files", ":Telescope oldfiles<CR>"),
	dashboard.button("<leader>w", " Find Word", ":Telescope live_grep<CR>"),
	dashboard.button("<leader>q", " Quit Nvim", ":qa<CR>"),
}

dashboard.section.footer.val = {
	[[ Code Code Day Day Up -- HongDaYu ]],
}

-- Send config to alpha
alpha.setup(dashboard.opts)

require("lsp_signature").setup({
	bind = true, -- This is mandatory, otherwise border config won't get registered.
	handler_opts = {
		border = "rounded",
	},
})
require("gitsigns").setup({
	signs = {
		add = { hl = "GitSignsAdd", text = "│", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
		change = { hl = "GitSignsChange", text = "│", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
		delete = { hl = "GitSignsDelete", text = "_", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
		topdelete = { hl = "GitSignsDelete", text = "‾", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
		changedelete = { hl = "GitSignsChange", text = "~", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
	},
	signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
	numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
	linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
	word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
	watch_gitdir = {
		interval = 1000,
		follow_files = true,
	},
	attach_to_untracked = true,
	current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
	current_line_blame_opts = {
		virt_text = true,
		virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
		delay = 1000,
		ignore_whitespace = false,
	},
	current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
	sign_priority = 6,
	update_debounce = 100,
	status_formatter = nil, -- Use default
	max_file_length = 40000, -- Disable if file is longer than this (in lines)
	preview_config = {
		-- Options passed to nvim_open_win
		border = "single",
		style = "minimal",
		relative = "cursor",
		row = 0,
		col = 1,
	},
	yadm = {
		enable = false,
	},
})
-- set rnu for vim number line

require("nvim-treesitter.configs").setup({
	pairs = {
		enable = true,
		disable = {},
		highlight_pair_events = { "CursorMoved" }, -- e.g. {"CursorMoved"}, -- when to highlight the pairs, use {} to deactivate highlighting
		highlight_self = true, -- whether to highlight also the part of the pair under cursor (or only the partner)
		goto_right_end = false, -- whether to go to the end of the right partner or the beginning
		fallback_cmd_normal = "call matchit#Match_wrapper('',1,'n')", -- What command to issue when we can't find a pair (e.g. "normal! %")
		keymaps = {
			goto_partner = "<F7>",
			delete_balanced = "X",
		},
		delete_balanced = {
			only_on_first_char = false, -- whether to trigger balanced delete when on first character of a pair
			fallback_cmd_normal = nil, -- fallback command when no pair found, can be nil
			longest_partner = false, -- whether to delete the longest or the shortest pair when multiple found.
			-- E.g. whether to delete the angle bracket or whole tag in  <pair> </pair>
		},
	},
})

vim.opt.termguicolors = true
require("bufferline").setup({
	options = {
		mode = "buffers", -- set to "tabs" to only show tabpages instead
		numbers = "none", -- can be "none" | "ordinal" | "buffer_id" | "both" | function
		close_command = "bdelete! %d", -- can be a string | function, see "Mouse actions"
		right_mouse_command = "vert sbuffer %d", -- can be a string | function, see "Mouse actions"
		left_mouse_command = "buffer %d", -- can be a string | function, see "Mouse actions"
		middle_mouse_command = nil, -- can be a string | function, see "Mouse actions"
		indicator = {
			icon = "▎", -- this should be omitted if indicator style is not 'icon'
			style = "icon", -- can also be 'underline'|'none',
		},
		buffer_close_icon = "",
		modified_icon = "●",
		close_icon = "",
		left_trunc_marker = "",
		right_trunc_marker = "",
		--- name_formatter can be used to change the buffer's label in the bufferline.
		--- Please note some names can/will break the
		--- bufferline so use this at your discretion knowing that it has
		--- some limitations that will *NOT* be fixed.
		name_formatter = function(buf) -- buf contains a "name", "path" and "bufnr"
			-- remove extension from markdown files for example
			if buf.name:match("%.md") then
				return vim.fn.fnamemodify(buf.name, ":t:r")
			end
		end,
		max_name_length = 18,
		max_prefix_length = 15, -- prefix used when a buffer is de-duplicated
		truncate_names = true, -- whether or not tab names should be truncated
		tab_size = 18,
		diagnostics = "nvim_lsp",
		diagnostics_update_in_insert = false,
		-- NOTE: this will be called a lot so don't do any heavy processing here
		offsets = {
			{
				filetype = "undotree",
				text = "Undotree",
				highlight = "PanelHeading",
				padding = 1,
			},
			{
				filetype = "NvimTree",
				text = "File Explorer",
				highlight = "PanelHeading",
				padding = 1,
			},
			{
				filetype = "DiffviewFiles",
				text = "Diff View",
				highlight = "PanelHeading",
				padding = 1,
			},
			{
				filetype = "flutterToolsOutline",
				text = "Flutter Outline",
				highlight = "PanelHeading",
			},
			{
				filetype = "packer",
				text = "Packer",
				highlight = "PanelHeading",
				padding = 1,
			},
		},
		color_icons = true, -- whether or not to add the filetype icon highlights
		show_close_icon = false,
		show_tab_indicators = true,
		persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
		-- can also be a table containing 2 custom separators
		-- [focused and unfocused]. eg: { '|', '|' }
		separator_style = "thin",
		enforce_regular_tabs = false,
		always_show_bufferline = false,
		hover = {
			enabled = false, -- requires nvim 0.8+
			delay = 200,
			reveal = { "close" },
		},
		sort_by = "id",
	},
})
