-- 📦 Установка и инициализация vim-plug через VimScript
vim.cmd([[
  call plug#begin('~/.local/share/nvim/plugged')

  Plug 'lambdalisue/suda.vim'                        " Запись без прав
  Plug 'preservim/nerdtree'                          " Файловый менеджер
  Plug 'tpope/vim-fugitive'                          " Git-интеграция
  Plug 'airblade/vim-gitgutter'                      " Git-метки
  Plug 'itchyny/lightline.vim'                       " Статусная строка
  Plug 'junegunn/fzf', { 'do': './install --all' }   " Поиск fzf
  Plug 'junegunn/fzf.vim'                            " Интеграция fzf
  Plug 'neoclide/coc.nvim', { 'branch': 'release' }  " Автодополнение
  Plug 'ryanoasis/vim-devicons'                      " Иконки
  Plug 'morhetz/gruvbox'                             " Цветовая схема gruvbox
  Plug 'ghifarit53/tokyonight-vim'                   " Цветовая схема tokyonight
  Plug 'jiangmiao/auto-pairs'                        " Автоскобки

  call plug#end()
]])

-- ⚙️ Основные настройки
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.autoindent = true
vim.opt.cursorline = true
vim.opt.hidden = true
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.termguicolors = true
vim.opt.mouse = ""
vim.opt.completeopt = { "menuone", "noinsert", "noselect" }
vim.opt.clipboard:append("unnamedplus")

-- 🛡️ suda.vim — редактирование от root
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
    filename = 'lightlinefilename'
  }
}

-- 🧠 coc.nvim — автодополнение
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

-- 🗃️ NERDTree — автозапуск при запуске без аргументов
vim.cmd([[
  autocmd StdinReadPre * let s:std_in = 1
  autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
]])

