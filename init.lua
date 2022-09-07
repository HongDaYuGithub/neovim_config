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
	use({ "rcarriga/nvim-dap-ui", requires = { "mfussenegger/nvim-dap" } })
	use({ "mhartington/formatter.nvim" })
	-- using packer.nvim
	use({
		"kdheepak/tabline.nvim",
		config = function()
			require("tabline").setup({ enable = false })
		end,
		requires = { "hoob3rt/lualine.nvim", "kyazdani42/nvim-web-devicons" },
	})
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

local colors = {
	red = "#ca1243",
	grey = "#a0a1a7",
	black = "#383a42",
	white = "#f3f3f3",
	light_green = "#83a598",
	orange = "#fe8019",
	green = "#8ec07c",
}

local theme = {
	normal = {
		a = { fg = colors.white, bg = colors.black },
		b = { fg = colors.white, bg = colors.grey },
		c = { fg = colors.black, bg = colors.white },
		z = { fg = colors.white, bg = colors.black },
	},
	insert = { a = { fg = colors.black, bg = colors.light_green } },
	visual = { a = { fg = colors.black, bg = colors.orange } },
	replace = { a = { fg = colors.black, bg = colors.green } },
}

local empty = require("lualine.component"):extend()
function empty:draw(default_highlight)
	self.status = ""
	self.applied_separator = ""
	self:apply_highlights(default_highlight)
	self:apply_section_separators()
	return self.status
end

-- Put proper separators and gaps between components in sections
local function process_sections(sections)
	for name, section in pairs(sections) do
		local left = name:sub(9, 10) < "x"
		for pos = 1, name ~= "lualine_z" and #section or #section - 1 do
			table.insert(section, pos * 2, { empty, color = { fg = colors.white, bg = colors.white } })
		end
		for id, comp in ipairs(section) do
			if type(comp) ~= "table" then
				comp = { comp }
				section[id] = comp
			end
			comp.separator = left and { right = "" } or { left = "" }
		end
	end
	return sections
end

local function search_result()
	if vim.v.hlsearch == 0 then
		return ""
	end
	local last_search = vim.fn.getreg("/")
	if not last_search or last_search == "" then
		return ""
	end
	local searchcount = vim.fn.searchcount({ maxcount = 9999 })
	return last_search .. "(" .. searchcount.current .. "/" .. searchcount.total .. ")"
end

local function modified()
	if vim.bo.modified then
		return "+"
	elseif vim.bo.modifiable == false or vim.bo.readonly == true then
		return "-"
	end
	return ""
end

require("lualine").setup({
	options = {
		theme = theme,
		component_separators = "",
		section_separators = { left = "", right = "" },
	},
	sections = process_sections({
		lualine_a = { "mode" },
		lualine_b = {
			"branch",
			"diff",
			{
				"diagnostics",
				source = { "nvim" },
				sections = { "error" },
				diagnostics_color = { error = { bg = colors.red, fg = colors.white } },
			},
			{
				"diagnostics",
				source = { "nvim" },
				sections = { "warn" },
				diagnostics_color = { warn = { bg = colors.orange, fg = colors.white } },
			},
			{ "filename", file_status = false, path = 1 },
			{ modified, color = { bg = colors.red } },
			{
				"%w",
				cond = function()
					return vim.wo.previewwindow
				end,
			},
			{
				"%r",
				cond = function()
					return vim.bo.readonly
				end,
			},
			{
				"%q",
				cond = function()
					return vim.bo.buftype == "quickfix"
				end,
			},
		},
		lualine_c = {},
		lualine_x = {},
		lualine_y = { search_result, "filetype" },
		lualine_z = { "%l:%c", "%p%%/%L" },
	}),
	inactive_sections = {
		lualine_c = { "%f %y %m" },
		lualine_x = {},
	},
})

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

require("dapui").setup({
	icons = { expanded = "▾", collapsed = "▸" },
	mappings = {
		-- Use a table to apply multiple mappings
		expand = { "<CR>", "<2-LeftMouse>" },
		open = "o",
		remove = "d",
		edit = "e",
		repl = "r",
		toggle = "t",
	},
	-- Expand lines larger than the window
	-- Requires >= 0.7
	expand_lines = vim.fn.has("nvim-0.7"),
	-- Layouts define sections of the screen to place windows.
	-- The position can be "left", "right", "top" or "bottom".
	-- The size specifies the height/width depending on position. It can be an Int
	-- or a Float. Integer specifies height/width directly (i.e. 20 lines/columns) while
	-- Float value specifies percentage (i.e. 0.3 - 30% of available lines/columns)
	-- Elements are the elements shown in the layout (in order).
	-- Layouts are opened in order so that earlier layouts take priority in window sizing.
	layouts = {
		{
			elements = {
				-- Elements can be strings or table with id and size keys.
				{ id = "scopes", size = 0.25 },
				"breakpoints",
				"stacks",
				"watches",
			},
			size = 40, -- 40 columns
			position = "left",
		},
		{
			elements = {
				"repl",
				"console",
			},
			size = 0.25, -- 25% of total lines
			position = "bottom",
		},
	},
	floating = {
		max_height = nil, -- These can be integers or a float between 0 and 1.
		max_width = nil, -- Floats will be treated as percentage of your screen.
		border = "single", -- Border style. Can be "single", "double" or "rounded"
		mappings = {
			close = { "q", "<Esc>" },
		},
	},
	windows = { indent = 1 },
	render = {
		max_type_length = nil, -- Can be integer or nil.
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
local servers = { "clangd", "pyright", "bashls", "cmake", "rust_analyzer", "sumneko_lua" }
for _, lsp in ipairs(servers) do
	lspconfig[lsp].setup({
		capabilities = capabilities,
	})
end

-- lua lsp config

local sumneko_root_path = "/root/.config/nvim/lua_lsp"
local sumneko_binary = sumneko_root_path .. "/bin/lua-language-server"
lspconfig["sumneko_lua"].setup({
	cmd = { sumneko_binary, "-E", sumneko_root_path .. "/bin/main.lua" },
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

vim.cmd([[set noswapfile]])
vim.cmd([[set expandtab]])
vim.cmd([[set tabstop=4]])
vim.cmd([[set mouse=a]])
vim.cmd([[set selection=exclusive]])
vim.cmd([[set selectmode=mouse,key]])
vim.cmd([[set nu]])

require("nvim-tree").setup({})

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

vim.cmd([[map <C-n> :ToggleTerm direction=float<CR>]])
vim.cmd([[
set guioptions-=e " Use showtabline in gui vim
set sessionoptions+=tabpages,globals " store tabpages and globals in session
]])
vim.cmd([[map <F6> :NvimTreeToggle<CR>]])
vim.g.catppuccin_flavour = "macchiato" -- latte, frappe, macchiato, mocha

-- Theme

require("catppuccin").setup()
vim.cmd([[colorscheme catppuccin]])

-- nord colorscheme
-- vim.cmd[[colorscheme nord]]

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

vim.cmd([[nmap <tab> :bn<cr>]])
vim.cmd([[nmap <C-S> :w<cr>]])
vim.cmd([[set showcmd]])
vim.cmd([[set cursorline]])

local keymap = vim.keymap.set
keymap("n", "gh", "<cmd>Lspsaga lsp_finder<CR>", { silent = true })

-- Code action
keymap("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", { silent = true })
keymap("v", "<leader>ca", "<cmd><C-U>Lspsaga range_code_action<CR>", { silent = true })

-- Rename
keymap("n", "gr", "<cmd>Lspsaga rename<CR>", { silent = true })

-- Definition preview
keymap("n", "gd", "<cmd>Lspsaga preview_definition<CR>", { silent = true })

-- Show line diagnostics
keymap("n", "<leader>cd", "<cmd>Lspsaga show_line_diagnostics<CR>", { silent = true })

-- Show cursor diagnostic
keymap("n", "<leader>cd", "<cmd>Lspsaga show_cursor_diagnostics<CR>", { silent = true })

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

require("lualine").setup({
	tabline = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { require("tabline").tabline_buffers },
		lualine_x = { require("tabline").tabline_tabs },
		lualine_y = {},
		lualine_z = {},
	},
})

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
	dashboard.button("e", " New File", ":ene <BAR> startinsert <CR>"),
	dashboard.button("f", " Find Fine", ":Telescope find_files<CR>"),
	dashboard.button("w", " Find Word", ":Telescope live_grep<CR>"),
	dashboard.button("q", " Quit Nvim", ":qa<CR>"),
}

-- Set footer
--   NOTE: This is currently a feature in my fork of alpha-nvim (opened PR #21, will update snippet if added to main)
--   To see test this yourself, add the function as a dependecy in packer and uncomment the footer lines
--   ```init.lua
--   return require('packer').startup(function()
--       use 'wbthomason/packer.nvim'
--       use {
--           'goolord/alpha-nvim', branch = 'feature/startify-fortune',
--           requires = {'BlakeJC94/alpha-nvim-fortune'},
--           config = function() require("config.alpha") end
--       }
--   end)
--   ```
dashboard.section.footer.val = {
	[[ code code day day up -- HongDaYu ]],
}

-- Send config to alpha
alpha.setup(dashboard.opts)

-- Disable folding on alpha buffer
vim.cmd([[
    autocmd FileType alpha setlocal nofoldenable
]])

local dap, dapui = require("dap"), require("dapui")
dap.listeners.after.event_initialized["dapui_config"] = function()
	dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
	dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
	dapui.close()
end
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
vim.cmd([[set rnu]])

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
