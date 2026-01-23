
vim.api.nvim_create_autocmd({'ColorScheme'}, {
	pattern = {"*"},
	callback = function(_)
	vim.cmd [[
	hi clear SpellBad
	hi clear SpellCap
	hi clear SpellLocal
	hi clear SpellRare
	]]
	end,
})

for i=1,9 do
	local key = string.format("<A-%d>", i)
	local action = string.format("<cmd>%dtabnext<cr>", i)
	-- Description.
	vim.keymap.set("n", key, action, {silent = true})
end
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

vim.keymap.set("n", "z=", MiniExtra.pickers.spellsuggest)
vim.cmd "colorscheme melange"
