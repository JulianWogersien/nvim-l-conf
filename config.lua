-- Example configs: https://github.com/LunarVim/starter.lvim
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny

vim.opt.cmdheight = 1
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.relativenumber = false
vim.opt.wrap = false
vim.opt.number = true
vim.opt.hlsearch = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.cursorline = false
vim.opt.expandtab = true
vim.opt.scrolloff = 15
vim.opt.showcmd = true
vim.opt.showmode = true
vim.opt.wildmenu = true
vim.opt.wildmode = "list:longest"
vim.opt.shell = "zsh"

lvim.keys.normal_mode["<Space>bx"] = ":bd<CR>"
lvim.keys.normal_mode["<Space>nb"] = ":bn<CR>"
lvim.keys.normal_mode["<Space>b!"] = ":bd!<CR>"

lvim.plugins = {
    { "wakatime/vim-wakatime" },
    { "mfussenegger/nvim-dap" },
    {
        "mrcjkb/rustaceanvim",
        version = "^4",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "mfussenegger/nvim-dap",
        },
        ft = { "rust" },
        config = function()
            vim.g.rustaceanvim = {
                inlay_hints = {
                    highlight = "NonText",
                },
                tools = {
                    hover_actions = {
                        auto_focus = true,
                    },
                },
                server = {
                    on_attach = require("lvim.lsp").common_on_attach
                }
            }
        end
    },
    {
        "kevinhwang91/nvim-bqf",
        event = { "BufRead", "BufNew" },
        config = function ()
            require("bqf").setup({
                auto_enable = true,
                preview = {
                    win_height = 12,
                    win_vheight = 12,
                    delay_syntay = 80,
                    border_chars = { "┃", "┃", "━", "━", "┏", "┓", "┗", "┛", "█" },
                },
                func_map = {
                    vsplit = "",
                    ptogglemode = "z,",
                    stoggleup = "",
                },
                filter = {
                    fzf = {
                        action_for = { ["ctrl-s"] = "split" },
                        extra_opts = { "--bind", "ctrl-o:toggle-all", "--prompt", "> " },
                    },
                },
            })
        end,
    },
    {
        "sindrets/diffview.nvim",
        event = "BufRead",
    },
    {
        "f-person/git-blame.nvim",
        event = "BufRead",
        config = function ()
            vim.cmd "highlight default link gitblame SpecialComment"
            require("gitblame").setup { enabled = false }
        end,
    },
    {
        "tpope/vim-fugitive",
        cmd = {
        "G",
        "Git",
        "Gdiffsplit",
        "Gread",
        "Gwrite",
        "Ggrep",
        "GMove",
        "GDelete",
        "GBrowse",
        "GRemove",
        "GRename",
        "Glgrep",
        "Gedit"
        },
        ft = {"fugitive"}
    },
    {
        "windwp/nvim-ts-autotag",
        config = function ()
            require("nvim-ts-autotag").setup()
        end
    },
    {
        "JoosepAlviste/nvim-ts-context-commentstring",
        event = "BufRead",
    },
    {
        "mrjones2014/nvim-ts-rainbow",
    },
    {
        "romgrk/nvim-treesitter-context",
        config = function()
            require("treesitter-context").setup{
            enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
            throttle = true, -- Throttles plugin updates (may improve performance)
            max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
            patterns = { -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
            -- For all filetypes
            -- Note that setting an entry here replaces all other patterns for this entry.
            -- By setting the 'default' entry below, you can control which nodes you want to
            -- appear in the context window.
            default = {
                'class',
                'function',
                'method',
            },
            },
            }
        end
    },
    {
        "norcalli/nvim-colorizer.lua",
        config = function()
            require("colorizer").setup({ "css", "scss", "html", "javascript" }, {
            RGB = true, -- #RGB hex codes
            RRGGBB = true, -- #RRGGBB hex codes
            RRGGBBAA = true, -- #RRGGBBAA hex codes
            rgb_fn = true, -- CSS rgb() and rgba() functions
            hsl_fn = true, -- CSS hsl() and hsla() functions
            css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
            css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
            })
        end,
    },
    {
        "simrat39/symbols-outline.nvim",
        config = function()
            require('symbols-outline').setup()
        end
    },
    {
        "EdenEast/nightfox.nvim"
    },
    {
        "andweeb/presence.nvim",
        config = function()
            require('presence').setup({
                enable_line_number = true
            })
        end
    }
}

--LINTER/FORMATTER/LSP
local linters = require "lvim.lsp.null-ls.linters"
linters.setup {
    {
        name = "shellcheck",
        args = { "--severity", "warning" },
    },
}

vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "rust_analyzer" })

lvim.builtin.treesitter.rainbow.enable = true

lvim.colorscheme = "carbonfox"
local version = vim.version()
if version.minor >= 10 or version.major >= 1 then
    vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client.server_capabilities.inlayHintProvider then
            vim.lsp.inlay_hint.enable(args.buf, true)
        end
    end
})
end
