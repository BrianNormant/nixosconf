lua << EOF
vim.g.mapleader = " "
require 'legendary'.setup {
	keymaps = {
        {"<A-p>", "<cmd>Legendary<cr>"},
        {"<C-s>", "<cmd>wa<cr>"},
        {"<C-q>", "<cmd>wqa!<cr>"},
        {"\\", '<cmd>split<cr><C-w>j', description="Split horizontal"},
        {"|", '<cmd>vsplit<cr><C-w>l', description="Split vertical"},
		--- Telescope
		{"<leader>ft",  function()  require('telescope.builtin').builtin()     end},
		{"<leader>ff",  function()  require('telescope.builtin').find_files()  end},
		{"<leader>fF",  function()  require('telescope.builtin').live_grep()   end},
		{"<leader>fb",  function()  require('telescope.builtin').buffers()     end},
		{"<leader>f/",  function()  require('telescope.builtin').current_buffer_fuzzy_find()     end},

		--- Telescope &| LSP
		{"<leader>fd",  function()  require('telescope.builtin').lsp_definitions()      end},
		{"<leader>fr",  function()  require('telescope.builtin').lsp_references()       end},
		{"<leader>fi",  function()  require('telescope.builtin').lsp_implementations()  end},
		{"<leader>L", "<Cmd>SymbolsOutline<cr>"},
		{"<leader>la", function()
			if vim.bo.filetype == "java" then
				vim.lsp.buf.code_action()
			else
				require'actions-preview'.code_actions()
			end
		end },


		--- Muren
		{"<F3>", "<cmd>MurenFresh<cr>", mode = "n"},
		{"<F3>", ":'<,'>MurenFresh<cr>", mode = "v"},

		--- DAP
{"<F9>",   function()  require'dap'.toggle_breakpoint()  end,  description="DAP  Toggle           breakpoint"},
{"<F10>",  function()  require'dap'.continue()           end,  description="DAP  Start/Resume"},
{"<F58>",  function()  require'dap'.terminate()          end,  description="DAP  Stop"},
{"<F11>",  function()  require'dap'.step_over()          end,  description="DAP  Step"},
{"<F12>",  function()  require'dap'.step_into()          end,  description="DAP  Step             into"},
{"<F60>",  function()  require'dap'.step_out()           end,  description="DAP  Step             out"},
        ---                   Icon Picker
        {"<C-e>", "<cmd>IconPickerInsert<cr>", mode="i"},
        {"<C-e>", "<cmd>IconPickerNormal<cr>", mode="n"},

		{"<leader>gg", "<cmd>LazyGit<cr>"},

		---               Compiler Explorer
		{"<F5>", "<cmd>CECompile<cr>" },

		{"<F1>", "<cmd>Gen<cr>"},
		{"<F1>", ":'<,'>Gen<cr>"},
		{"<F2>", function() require('dropbar.api').pick() end},
	}
}

EOF
