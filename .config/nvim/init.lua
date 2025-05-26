-- 📦 Установка lazy.nvim (если не установлен)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

-- 📦 Инициализация плагинов
require("lazy").setup({
  { "lambdalisue/suda.vim" },                          -- Запись без прав
  { "preservim/nerdtree" },                            -- Файловый менеджер
  { "tpope/vim-fugitive" },                            -- Git-интеграция
  { "airblade/vim-gitgutter" },                        -- Git-метки
  { "itchyny/lightline.vim" },                         -- Статусная строка
  { "junegunn/fzf", build = "./install --all" },       -- FZF
  { "junegunn/fzf.vim", dependencies = { "junegunn/fzf" } }, -- FZF интеграция
  { "neoclide/coc.nvim", branch = "release" },         -- Автодополнение
  { "ryanoasis/vim-devicons" },                        -- Иконки
  { "morhetz/gruvbox" },                               -- Цветовая схема
  { "ghifarit53/tokyonight-vim" },                     -- Цветовая схема
  { "jiangmiao/auto-pairs" },                          -- Автоскобки
  { "fladson/vim-kitty" },                             -- Поддержка kitty
})

-- ⚙️ Основные настройки
local opt = vim.opt
opt.number = true
opt.relativenumber = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true
opt.autoindent = true
opt.cursorline = true
opt.hidden = true
opt.scrolloff = 8
opt.signcolumn = "yes"
opt.termguicolors = true
opt.mouse = ""
opt.completeopt = { "menuone", "noinsert", "noselect" }
opt.clipboard:append("unnamedplus")

-- 🛡️ suda.vim
vim.g.suda_smart_edit = 1

-- 🌈 Синтаксис и поведение
vim.cmd("syntax on")
vim.cmd("filetype plugin indent on")

-- 🎨 Цветовая схема
vim.g.tokyonight_style = "night"
vim.g.tokyonight_enable_italic = 1
vim.cmd("colorscheme tokyonight")

-- 📟 lightline с отображением полного пути
_G.lightlinefilename = function()
  local path = vim.fn.expand('%:p')
  local home = vim.fn.expand('$HOME')
  return path:gsub(home, '~')
end

vim.g.lightline = {
  active = {
    left = {
      { 'mode', 'paste' },
      { 'readonly', 'filename', 'modified' }
    }
  },
  component_function = {
    filename = 'LightlineFilename'
  }
}

vim.cmd([[
  function! LightlineFilename() abort
    return v:lua.lightlinefilename()
  endfunction
]])

-- 🧠 coc.nvim
local keyset = vim.keymap.set
local opts = { silent = true, noremap = true, expr = true, replace_keycodes = false }

function _G.check_back_space()
  local col = vim.fn.col('.') - 1
  return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
end

keyset("i", "<TAB>", 'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()', opts)
keyset("i", "<S-TAB>", 'coc#pum#visible() ? coc#pum#prev(1) : "<C-h>"', opts)
keyset("i", "<CR>", 'coc#pum#visible() ? coc#pum#confirm() : "\\<C-g>u\\<CR>\\<c-r>=coc#on_enter()\\<CR>"', opts)
keyset("i", "<C-Space>", "coc#refresh()", { silent = true, expr = true })

-- 🗃️ NERDTree автозапуск при запуске без аргументов
vim.cmd([[
  autocmd StdinReadPre * let s:std_in = 1
  autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
]])

