local nixvim_options = {
    autowrite = true,
    background = "dark",
    backspace = {"indent", "eol", "start"},
    backup = false,
    backupcopy = "auto",
    backupdir = {"~/.vim/backup"},
    breakindent = true,
    complete = {".", "w", "b", "u", "t", "i"},
    completeopt = {"menuone", "preview"},
    conceallevel = 0,
    cursorline = false,
    expandtab = true,
    formatoptions = "jtcroql",
    gdefault = true,
    grepprg = "rg --vimgrep",
    hidden = true,
    history = 50,
    hlsearch = false,
    ignorecase = true,
    inccommand = "split",
    incsearch = true,
    laststatus = 2,
    lazyredraw = true,
    linebreak = true,
    list = false,
    modeline = true,
    mouse = "a",
    number = false,
    relativenumber = false,
    ruler = false,
    scrolloff = 8,
    shiftround = true,
    shiftwidth = 4,
    shortmess = "tToOFIWa",
    showcmd = true,
    signcolumn = "yes",
    smartcase = true,
    smartindent = true,
    splitbelow = true,
    splitright = true,
    swapfile = true,
    switchbuf = {"useopen", "uselast"},
    synmaxcol = 1024,
    tabstop = 4,
    tags = {".git/tags"},
    termguicolors = true,
    textwidth = 0,
    timeoutlen = 500,
    ttimeoutlen = 10,
    undofile = true,
    updatetime = 4000,
    wildmode = {"list:longest", "list:full"},
    winwidth = 80,
    wrap = false,
    writebackup = false
}

for k, v in pairs(nixvim_options) do vim.opt[k] = v end

