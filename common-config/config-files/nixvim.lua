require('gruvbox-material').setup {
	contrast = "soft",
}
vim.cmd [[
	hi NormalFloat ctermfg=223 ctermbg=236 guifg=#d4be98 guibg=#32302f
	hi FloatBorder ctermfg=245 ctermbg=236 guifg=#928374 guibg=#32302f
	hi FloatTitle  ctermfg=208 ctermbg=236 guifg=#e78a4e guibg=#32302f cterm=bold
]]

-- Default nvim settings
vim.opt.laststatus = 3
vim.opt.scrolloff = 5

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = false -- set to true to use space instead of tab

vim.o.cursorline = true
vim.o.number = true
vim.o.relativenumber = true

vim.g.mapleader = "<space>"

vim.opt.spell = true
vim.opt.spelllang = "en_us"
vim.cmd [[
	hi clear SpellBad
	hi clear SpellCap
	hi clear SpellLocal
	hi clear SpellRare
]]

vim.keymap.set("n", "z=", MiniExtra.pickers.spellsuggest)
