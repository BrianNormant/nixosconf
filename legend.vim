lua << EOF
vim.g.mapleader = " "
require 'legendary'.setup {
	keymaps = {
		{"<A-p>", "<cmd>Legendary<cr>"},
		{"<C-s>", "<cmd>wa<cr>"},
		{"<C-q>", "<cmd>wqa<cr>"},
		{"\\", '<cmd>split<cr><C-w>j', description="Split horizontal"},
		{"|", '<cmd>vsplit<cr><C-w>l', description="Split vertical"},



		--- Boo.nvim

		{"gi", function() require('boo').boo() end },
		
		-- goto-preview
		{"gpd",  function()  require('goto-preview').goto_preview_definition()       end  },
		{"gpt",  function()  require('goto-preview').goto_preview_type_definition()  end  },
		{"gpi",  function()  require('goto-preview').goto_preview_implementation()   end  },
		{"gpD",  function()  require('goto-preview').goto_preview_declaration()      end  },
		{"gP",   function()  require('goto-preview').close_all_win()                 end  },
		{"gpr",  function()  require('goto-preview').goto_preview_references()       end  },

		--- default neovim LSP
		{"<leader>e", vim.diagnostic.open_float},

		{"<leader>oo",  '<cmd>Oil<cr>'},
		
		--- Fzfx
		{"<leader>ft",  function() require('telescope.builtin').builtin() end},
		{"<leader>ff",  '<cmd>FzfxFiles<cr>'       },
		{"<leader>fF",  '<cmd>FzfxLiveGrep<cr>'    },
		{"<leader>fb",  '<cmd>FzfxBuffers<cr>'     },
		{"<leader>f/",  '<cmd>FzfxBufLiveGrep<cr>' },

		--- Fzfx & LSP
		{"<leader>fd",  '<cmd>FzfxLspDefinitions<cr>'   },
		{"<leader>fr",  '<cmd>FzfxReferences<cr>'       },
		{"<leader>fi",  '<cmd>FzfxImplementations<cr>'  },
		{"<leader>L",  function() require("nvim-navbuddy").open() end},
		{"<leader>la", function()
			if vim.bo.filetype == "java" then
				vim.lsp.buf.code_action()
			else
				require'actions-preview'.code_actions()
			end
		end },



		--- Muren And Spectre
		{"<F3>", "<cmd>MurenFresh<cr>",  mode = "n"},
		{"<F3>", ":'<,'>MurenFresh<cr>", mode = "v"},
		{"<leader>S", function() require('spectre').toggle() end},

		--- Compiler
		{"<F5>", "<cmd>CompilerOpen<cr>"},
		{"<F6>", "<cmd>CompilerToggleResults<cr>"},

		--- Neotest
		{"<F7>", function() require("neotest").run.run() end},
		{"<F8>", function() require("neotest").run.run(vim.fn.extend("%")) end},

		--- DAP
		{"<F9>",   function()  require'dap'.toggle_breakpoint()  end,  description="DAP  Toggle breakpoint"},
		{"<F10>",  function()  require'dap'.continue()           end,  description="DAP  Start/Resume"},
		{"<F58>",  function()  require'dap'.terminate()          end,  description="DAP  Stop"},
		{"<F11>",  function()  require'dap'.step_over()          end,  description="DAP  Step"},
		{"<F12>",  function()  require'dap'.step_into()          end,  description="DAP  Step into"},
		{"<F60>",  function()  require'dap'.step_out()           end,  description="DAP  Step out"},
		---                   Icon Picker
		{"<C-e>", "<cmd>IconPickerInsert<cr>", mode="i"},
		{"<C-e>", "<cmd>IconPickerNormal<cr>", mode="n"},

		--- lazygit
		{"<leader>gg", "<cmd>LazyGit<cr>"},
		{"<leader>gG", "<cmd>FzfxGStatus<cr>"},

		--- Term
		{"<leader>tt", require('FTerm').toggle },

		{"<F1>", "<cmd>Gen<cr>"},
		{"<F1>", ":'<,'>Gen<cr>"},
		{"<F2>", function() require('dropbar.api').pick() end},

		---              UI settings
		--- Treesitter
		{"<leader>uh", "<cmd>TSToggle highlight<cr>"},
		--- true-zen
		{"<leader>uz", "<cmd>TZAtaraxis<cr>"},
		{"<C-w>z",     "<cmd>TZFocus<cr>"},
		--- blame
		{"<leader>ub", "<cmd>ToggleBlame virtual<cr>"},
		{"<leader>uu", function()
			if vim.o.background == "dark" then
				vim.o.background = "light"
			else
				vim.o.background = "dark"
			end
		end}

	},
	commands = {},
}
EOF
