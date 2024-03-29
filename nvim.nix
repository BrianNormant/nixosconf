{ pkgs, ... }:
let 
nvim-treesitter-parsers-http = pkgs.vimPlugins.nvim-treesitter-parsers.http.overrideAttrs  (final: self: {
	version = "test";
	src = pkgs.fetchFromGitHub {
		owner = "rest-nvim";
		repo = "tree-sitter-http";
		rev = "261d78f";
		sha256 = "sha256-Kh5CeVc6wtqRHb/RzFALk3pnnzzC/OR3qkDwIQH+XlA=";
	};
});
/*
nvim-treesitter = pkgs.vimPlugins.nvim-treesitter.overrideAttrs (final: self: {
	version = "HEAD";
	src = pkgs.fetchFromGitHub {
		owner = "nvim-treesitter";
		repo  = "nvim-treesitter";
		rev   = "HEAD";
		sha256 = "sha256-U/0F/q2hfewO00nDBwdCGvQZoGv3EE0j1j47UO0u0p8=";
	};
});
*/
in {
	home-manager.users.brian.programs.neovim = {
		enable = true;
		withPython3 = true;
		extraPackages = with pkgs; [
			jdt-language-server
			ccls
			phpactor
			ripgrep
			fswatch
			fd
			yarn nodejs_21
			gdb
			lua-language-server
			nil
			oracle-instantclient
			curl
			jq
			html-tidy
			tree-sitter
			luajitPackages.luarocks
		];

		plugins = with pkgs.vimPlugins; [
			{ plugin = dressing-nvim;
			  config = "lua require(\"dressing\").setup {}"; }
			gruvbox-material
			{ plugin = dropbar-nvim;
			  config = "lua require('dropbar').setup {}"; }
			ccc-nvim
			{ plugin = gitsigns-nvim;
			  config = "lua require('gitsigns').setup {}"; }

			{ plugin = lualine-nvim;
			  config = (builtins.readFile ./bar.vim);}
			# QOL
			{ plugin = comment-nvim;
			  config = "lua require('Comment').setup {}";}
			vim-surround
			vim-repeat
			vim-lastplace
			{ plugin = leap-nvim;
			  config=''
hi LeapBackdrop guifg=#888888
hi LeapLabelPrimary guifg=#FF0000
lua require 'leap'.create_default_mappings()
			'';}
			{ plugin = nvim-autopairs;
			  config = "lua require 'nvim-autopairs'.setup {}";}
			{ plugin = boole-nvim;
			  config = ''
lua << EOF
require 'boole'.setup {
	mappings = {
		increment = '<C-a>',
		decrement = '<C-x>',
	}
}
EOF
			'';}
			{ plugin = registers-nvim;
			  config = "lua require 'registers'.setup {}"; }
			{ plugin = marks-nvim;
			  config = "lua require 'marks'.setup {}"; }
			{ plugin = indent-blankline-nvim;
			  config = ''
lua << EOF
local highlight = {
    "RainbowRed",
    "RainbowYellow",
    "RainbowBlue",
    "RainbowOrange",
    "RainbowGreen",
    "RainbowViolet",
    "RainbowCyan",
}

local hooks = require "ibl.hooks"
-- create the highlight groups in the highlight setup hook, so they are reset
-- every time the colorscheme changes
hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
    vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
    vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
    vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
    vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
    vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
    vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
    vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
end)

require("ibl").setup { 
	indent = { highlight = highlight }, 
	scope = { enabled=true, highlight = highlight } 
}
EOF

			'';}
			{ plugin = guess-indent-nvim;
			  config = "lua require'guess-indent'.setup {}";}
			{ plugin = vim_current_word;
			  config = ''
hi CurrentWord gui=underline guibg=#00000000
hi CurrentWordTwings gui=underline,bold
					''; }
			# Features
			telescope-lsp-handlers-nvim
			{ plugin = telescope-nvim;
			  config = ''
lua << EOF
local telescope = require "telescope"
telescope.setup {
	defaults = {
		layout_strategy = "flex",
	},
}
telescope.load_extension('lsp_handlers')
EOF
			'';}
			fzf-vim
			{ plugin = pkgs.vimUtils.buildVimPlugin {
				pname = "fzfx.nvim";
				version = "lastest";
				src = pkgs.fetchFromGitHub {
					owner = "linrongbin16";
					repo = "fzfx.nvim";
					rev = "HEAD";
					sha256 = "sha256-gY9P+XQhoraEM8OwHMakTpfBLFthkh99QCdf/JeN+Xo=";
				};
			  };
			  config = "lua require(\"fzfx\").setup {}";
			}
			vim-wakatime
			{ plugin = nvim-web-devicons;
			  config = ''
lua require("nvim-web-devicons").setup {}
			''; }
			{ plugin = ( pkgs.vimUtils.buildVimPlugin {
				pname = "icon-picker-nvim";
				version = "HEAD";
				src = pkgs.fetchFromGitHub {
					owner = "ziontee113";
					repo = "icon-picker.nvim";
					rev = "HEAD";
					sha256 = "VZKsVeSmPR3AA8267Mtd5sSTZl2CAqnbgqceCptgp4w=";
				};
			} );
			  config = "lua require('icon-picker').setup {}";}
			lazygit-nvim
			{ plugin = ( pkgs.vimUtils.buildVimPlugin {
				pname = "muren-nvim";
				version = "HEAD";
				src = pkgs.fetchFromGitHub {
					owner = "AckslD";
					repo = "muren.nvim";
					rev = "b6484a1";
					sha256 = "hv8IfNJ+3O1L1PPIZlPwXc37Oa4u8uZPJmISLnNkBGw=";
				};
				} );
				config = "lua require('muren').setup {}"; }
			{ plugin = oil-nvim;
			  config = "lua require('oil').setup {}";}
			{ plugin = coq_nvim;
			  config = ''
lua << EOF
local coq = require 'coq'
vim.g.coq_settings = {
	["xdg"] = true,
	["clients.tabnine.enabled"] = true,
}
EOF
			'';}
			coq-artifacts
			coq-thirdparty

			# LSP
			{ plugin = goto-preview;
			  config = "lua require('goto-preview').setup {}";}
			{ plugin = nvim-navbuddy;
			  config = ''
lua << EOF
require 'nvim-navbuddy'.setup {
	window = {
		border = "rounded",
		size = "50%",
	},
	lsp = { auto_attach = true },
}
EOF
			''; }
			{ plugin = ( pkgs.vimUtils.buildVimPlugin {
				pname = "boo-nvim";
				version = "8384bc";
				src = pkgs.fetchFromGitHub {
			     owner = "LukasPietzschmann";
			     repo = "boo.nvim";
			     rev = "8384bc";
			     sha256 = "sha256-FSPJHWpvkw8wY1h+h4pdpS9ChyZOO+/XQqmPvm0iKSI=";
			   };
			} );
			  config = "lua require ('boo').setup {}";}

			{ plugin = lsp_lines-nvim;
			  config = ''
lua << EOF
require 'lsp_lines'.setup {}
vim.diagnostic.config {
	virtual_text = false
}
EOF
			''; }
			{ plugin = actions-preview-nvim;
			  config = "lua require 'actions-preview'.setup {}";}
			# LSP
			{ plugin = nvim-lspconfig;
			  config = ''
lua << EOF
local coq = require 'coq'
local lspconfig = require('lspconfig')
local common_config = {
	coq.lsp_ensure_capabilities(),
}

lspconfig.ccls.setup(common_config)
lspconfig.lua_ls.setup(common_config)
lspconfig.nil_ls.setup(common_config)
lspconfig.phpactor.setup(common_config)
EOF
		   '';}
		   nvim-dap
		   { plugin = nvim-dap-ui;
			 config = (builtins.readFile ./dap.vim); }
		   { plugin = ( pkgs.vimUtils.buildVimPlugin {
				pname = "gen-nvim";
				version = "HEAD";
				src = pkgs.fetchFromGitHub {
					owner = "David-Kunz";
					repo = "gen.nvim";
					rev = "2cb643b";
					sha256 = "aZ/ZMmatoIXnY3qtRjUqJStlpg0VGbJ1XdRjyDMhHqU=";
				};
			} );
			  config = "lua require 'gen'.setup { model = 'mistral' }"; }
			{ plugin = nvim-jdtls;
			  config = ''
lua << EOF
local jdtls = require 'jdtls'
local config = {
	cmd = {
		'${pkgs.jdt-language-server}/bin/jdtls'
	},
	settings = {
		java = {
			configuration = {
				runtimes = {
					{name = "JavaSE-17", path = "~/.gradle/jdks/eclipse_adoptium-17-amd64-linux/jdk-17.0.10+7/"},
					{name = "JavaSE-21", path = "~/.gradle/jdks/eclipse_adoptium-21-amd64-linux/jdk-21.0.2+13/"},
				}
			}
		},
	},

	root_dir = jdtls.setup.find_root({'.git', 'mvnw', 'gradlew'}),
}

vim.api.nvim_create_autocmd(
	'BufEnter',
	{ 	pattern = {'*.java'},
		callback = function() jdtls.start_or_attach(config) end,
	})
EOF
				''; }
			# HTTP
			/*
			{ plugin = ( pkgs.vimUtils.buildVimPlugin {
				pname = "rest.nvim";
				version = "1234";
				src = pkgs.fetchFromGitHub {
			     owner = "rest-nvim";
			     repo = "rest.nvim";
			     rev = "5300ae0";
			     hash = "sha256-EuQ4RCwFRA99QJ4onQKulFDK3s6MOrWA5f55nlDf45w=";
			   };
			} );
			  config = with pkgs.luajitPackages; ''

lua << EOF
package.path = package.path .. ";/home/brian/.luarocks/share/lua/5.1/?.lua" .. ";/home/brian/.luarocks/share/lua/5.1/?/init.lua"
package.path = package.path .. ";${nvim-nio}/share/lua/5.1/?.lua" .. ";${nvim-nio}/share/lua/5.1/?/init.lua"
package.path = package.path .. ";${lua-curl}/share/lua/5.1/?.lua" .. ";${lua-curl}/share/lua/5.1/?/init.lua"
package.path = package.path .. ";${xml2lua}/share/lua/5.1/?.lua" .. ";${xml2lua}/share/lua/5.1/?/init.lua"

require 'rest-nvim'.setup {}
EOF
			''; } */

			# DataBase
			vim-dadbod-ui
			{ plugin = vim-dadbod;
			  config = ''
lua << EOF
vim.g.db_ui_use_nerd_fonts = 1
vim.g.dbs = {
	['DB Oracle locale'] = "oracle://SYSTEM:welcome123@localhost:1521/FREE"
}
EOF
			  ''; }
			# Markdown
			markdown-preview-nvim
			{ plugin = legendary-nvim;
			  config = ( builtins.readFile ./legend.vim ); }

			# Treesitter
			nvim-treesitter
			nvim-treesitter-parsers.java
			nvim-treesitter-parsers.lua
			nvim-treesitter-parsers.c
			nvim-treesitter-parsers.xml
			nvim-treesitter-parsers.json
			nvim-treesitter-parsers.graphql
			nvim-treesitter-parsers-http
		];
		extraLuaConfig = ''
vim.opt.clipboard:append "unnamedplus"
vim.opt.scrolloff = 5

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = false -- set to true to use space instead of tab

vim.o.cursorline = true
vim.o.number = true
vim.o.relativenumber = true

vim.cmd "colorscheme gruvbox-material"
vim.cmd "COQnow"
vim.cmd "set laststatus=3"
		'';
	};
	
	programs.neovim = {
		enable = true;
		defaultEditor = true;
		viAlias = true;
		vimAlias = true;

		withPython3 = true;
		configure = {
			customRC = ''
			luafile ${./nvim.lua}
			let g:gruvbox_italic=1
			let g:gruvbox_contrast_dark="soft"

			colorscheme gruvbox
			hi CurrentWord cterm=underline
			hi CurrentWordTwins cterm=underline
			'';
			packages.myVimPackage = with pkgs.vimPlugins; {
				opt = [];
				start = [
					gruvbox
					comment-nvim
					vim-surround
					vim_current_word
					vim-wordy
				];
			};
		};
	};
	nixpkgs.overlays = [                                                                           
    	(import (builtins.fetchTarball {                                                           
         	url = "https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz";
        }))
	];
}
