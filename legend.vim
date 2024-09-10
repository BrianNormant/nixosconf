lua << EOF
vim.g.mapleader = " "
require 'legendary'.setup {
	keymaps = {
		{"<A-p>", "<cmd>Legendary<cr>", description="Open Legendary keybind manager"},
		{"<C-s>", "<cmd>wa<cr>", description="Write and save"},
		{"<C-q>", "<cmd>wqa<cr>", description="Write, save, then exit", },
		{"\\", '<cmd>split<cr><C-w>j', description="Split horizontal"},
		{"|", '<cmd>vsplit<cr><C-w>l', description="Split vertical"},



		--- Boo.nvim

		{"gi", function() require('boo').boo() end, description="open LSP info"},
		
		-- goto-preview
		{"gpd",  function()  require('goto-preview').goto_preview_definition()       end, description="LSP view definition"},
		{"gpt",  function()  require('goto-preview').goto_preview_type_definition()  end, description="LSP view type definition"  },
		{"gpi",  function()  require('goto-preview').goto_preview_implementation()   end, description="LSP view implementation"  },
		{"gpD",  function()  require('goto-preview').goto_preview_declaration()      end, description="LSP view declaration"  },
		{"gpr",  function()  require('goto-preview').goto_preview_references()       end, description="LSP view references"  },
		{"gP",   function()  require('goto-preview').close_all_win()                 end, description="LSP close preview window"  },

		--- default neovim LSP
		{"<leader>e", vim.diagnostic.open_float},

		{"<leader>oo",  '<cmd>Oil<cr>'},
		
		--- Fzfx
		{"<leader>ft",  function() require('telescope.builtin').builtin() end, description="Telescope list builtins"},
		{"<leader>ff",  '<cmd>FzfxFiles<cr>',       description="Fzfx list files"},
		{"<leader>fF",  '<cmd>FzfxLiveGrep<cr>',    description="Fzfx live grep"},
		{"<leader>fb",  '<cmd>FzfxBuffers<cr>',     description="Fzfx list buffers"},
		{"<leader>f/",  '<cmd>FzfxBufLiveGrep<cr>', description="Fzfx live grep in file"},

		--- Fzfx & LSP
		{"<leader>fd",  '<cmd>FzfxLspDefinitions<cr>',  descroption="fzfx list LSP definitions"},
		{"<leader>fr",  '<cmd>FzfxReferences<cr>',      description="fzfx list LSP references"},
		{"<leader>fi",  '<cmd>FzfxImplementations<cr>', description="fzfx list LSP implementations"},
		{"<leader>L",  function() require("nvim-navbuddy").open() end, description="Open Navbuddy"},
		{"<leader>la", function()
			if vim.bo.filetype == "java" then
				vim.lsp.buf.code_action()
			else
				require'actions-preview'.code_actions()
			end
		end, description="LSP view avalaible code actions"},



		--- Muren And Spectre
		{"<F3>", "<cmd>MurenFresh<cr>",  mode = "n", description="Open Muren"},
		{"<F3>", ":'<,'>MurenFresh<cr>", mode = "v", description="Open Muren with range"},
		{"<leader>S", function() require('spectre').toggle() end, description="Open Scectre to quickfind"},

		--- Compiler
		{"<F5>", "<cmd>CompilerOpen<cr>"},
		{"<F6>", "<cmd>CompilerToggleResults<cr>"},

		--- Neotest
		{"<F7>", function() require("neotest").run.run() end, description="Run with neotest"},
		{"<F8>", function() require("neotest").run.run(vim.fn.extend("%")) end, description="Run with neotest"},

		--- DAP
		{"<F9>",   function()  require'dap'.toggle_breakpoint()  end,  description="DAP  Toggle breakpoint"},
		{"<F10>",  function()  require'dap'.continue()           end,  description="DAP  Start/Resume"},
		{"<F58>",  function()  require'dap'.terminate()          end,  description="DAP  Stop"},
		{"<F11>",  function()  require'dap'.step_over()          end,  description="DAP  Step"},
		{"<F12>",  function()  require'dap'.step_into()          end,  description="DAP  Step into"},
		{"<F60>",  function()  require'dap'.step_out()           end,  description="DAP  Step out"},
		---                   Icon Picker
		{"<C-e>", "<cmd>IconPickerInsert<cr>", mode="i", description="Icon Picker insert"},
		{"<C-e>", "<cmd>IconPickerNormal<cr>", mode="n", description="Icon Picker normal"},

		--- lazygit
		{"<leader>gg", "<cmd>LazyGit<cr>",     description="open lazygit"},
		{"<leader>gG", "<cmd>FzfxGStatus<cr>", description="Fzfx git"},

		--- Term
		{"<leader>tt", require('FTerm').toggle, description="Open floating terminal"},

		{"<F1>", "<cmd>Gen<cr>",  description="Open Generative AI"},
		{"<F1>", ":'<,'>Gen<cr>", description="Open Generative AI with range"},
		{"<F2>", function() require('dropbar.api').pick() end, description="Open dropbar"},

		---              UI settings
		--- Treesitter
		{"<leader>uh", "<cmd>TSToggle highlight<cr>", description="Toggle treesiter highlight"},
		--- true-zen
		{"<leader>uz", "<cmd>TZAtaraxis<cr>", description="Toggle Ataraxis mode"},
		{"<C-w>z",     "<cmd>TZFocus<cr>",    description="Toggle focus mode"},
		--- blame
		{"<leader>ub", "<cmd>ToggleBlame virtual<cr>", description="Show git blame"},
		{"<leader>uu", function()
			if vim.o.background == "dark" then
				vim.o.background = "light"
			else
				vim.o.background = "dark"
			end
		end, description="change vim light/dark mode"}

	},
	commands = {},
}
EOF
