local o = vim.opt
local g = vim.g

-- Autocmds
vim.cmd [[
augroup CursorLine
    au!
    au VimEnter * setlocal cursorline
    au WinEnter * setlocal cursorline
    au BufWinEnter * setlocal cursorline
    au WinLeave * setlocal nocursorline
augroup END

autocmd FileType nix setlocal shiftwidth=2
]]

-- Enable auto-formatting
-- NOTE: some format-on-save is also enabled in null-ls config.
vim.cmd [[
autocmd BufWritePre * lua vim.lsp.buf.format()
]]

-- Keybinds
local map = vim.api.nvim_set_keymap
local opts = { silent = true, noremap = true }

map('n', '<C-f>', ':Telescope live_grep <CR>', opts)
map('n', '<C-p>', ':Telescope find_files <CR>', opts)
map('n', '<C-b>', ':NvimTreeToggle <CR>', opts)
-- map('n', 'j', 'gj', opts)
-- map('n', 'k', 'gk', opts)
-- map('n', ';', ':', { noremap = true } )

g.mapleader = ' '

-- Performance
o.lazyredraw = true;
o.shell = "fish"
o.shadafile = "NONE"

-- Colors
o.termguicolors = true
o.guifont = "VictorMono Nerd Font:h10"

-- Undo files
o.undofile = true

-- Indentation
o.smartindent = true
o.tabstop = 4
o.shiftwidth = 4
o.shiftround = true
o.expandtab = true
o.scrolloff = 3

-- Set clipboard to use system clipboard
o.clipboard = "unnamedplus"

-- Use mouse
o.mouse = "a"

-- Nicer UI settings
o.cursorline = true
-- o.relativenumber = true
o.number = true

-- Get rid of annoying viminfo file
o.viminfo = ""
o.viminfofile = "NONE"

-- Miscellaneous quality of life
o.ignorecase = true
o.ttimeoutlen = 5
-- o.hidden = true
o.shortmess = "atI"
o.wrap = false
-- o.backup = false
o.writebackup = false
o.errorbells = false
o.swapfile = false
o.showmode = false
o.laststatus = 3
o.pumheight = 6
o.splitright = true
o.splitbelow = true
o.completeopt = "menuone,noselect"
