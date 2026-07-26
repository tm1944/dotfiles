local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.undofile = true
opt.ignorecase = true
opt.smartcase = true
opt.inccommand = "split"
opt.splitbelow = true
opt.splitright = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.completeopt = { "menu", "menuone", "noselect" }
opt.updatetime = 250
opt.timeoutlen = 400
opt.confirm = true
opt.wrap = false
opt.termguicolors = true

opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.expandtab = false
opt.smartindent = true

vim.g.have_nerd_font = true

-- Allow `theme` CLI to update running Neovim instances.
if vim.fn.serverstart() == "" then
  vim.notify("Could not start Neovim server socket", vim.log.levels.WARN)
end
