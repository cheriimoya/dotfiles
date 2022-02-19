require("colorizer").setup()

require('gitsigns').setup {}

local lsp = require'lspconfig'
local util = require'lspconfig/util'
local cmp = require("cmp")

vim.fn.sign_define("DiagnosticSignError", {
  text = " ",
  texthl = "DiagnosticError",
})
vim.fn.sign_define("DiagnosticSignWarn", {
   text = " ",
   texthl = "DiagnosticWarn"
 })
vim.fn.sign_define("DiagnosticSignInfo", {
   text = " ",
   texthl = "DiagnosticInfo"
 })
vim.fn.sign_define("DiagnosticSignHint", {
  text = "ﯦ ",
  texthl = "DiagnosticHint"
})

vim.cmd [[
  hi DiagnosticError guifg=Red guibg=#282a2e
  hi DiagnosticWarn guifg=Orange guibg=#282a2e
  hi DiagnosticInfo guifg=LightBlue guibg=#282a2e
  hi DiagnosticHint guifg=LightGrey guibg=#282a2e
]]

vim.opt.completeopt = { "menuone", "noinsert", "noselect" }
vim.opt.shortmess:append("c")
vim.opt.pumblend = 10



cmp.setup {
  mapping = {
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-n>"] = cmp.mapping.select_next_item(),
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.close(),
    ["<CR>"] = cmp.mapping.confirm{
      select = true,
    },
  },
  sources = {
    { name = "nvim_lsp" },
    { name = "path" },
    { name = "buffer", keyword_length = 3 },
  },
  experimental = {
    native_menu = false,
  },
}


vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
        underline = false,
        virtual_text = {
            spacing = 4,
        },
        signs = true,
        update_in_insert = true,
    }
)

vim.lsp.protocol.CompletionItemKind = {
    ' [text]',
    ' [method]',
    'ƒ [function]',
    ' [constructor]',
    ' [field]',
    ' [variable]',
    ' [class]',
    ' [interface]',
    ' [module]',
    ' [property]',
    ' [unit]',
    ' [value]',
    ' [enum]',
    ' [keyword]',
    '﬌ [snippet]',
    ' [color]',
    ' [file]',
    ' [reference]',
    ' [dir]',
    ' [enummember]',
    ' [constant]',
    ' [struct]',
    '  [event]',
    ' [operator]',
    ' [type]',
}

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)


local on_attach = function(_, bufnr)
    -- keymap
    local function buf_set_keymap(...)
        vim.api.nvim_buf_set_keymap(bufnr, ...)
    end

    -- Mappings.
    local opts = { noremap = true, silent = true }

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    buf_set_keymap('i', '<C-s>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    buf_set_keymap('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)

    vim.cmd [[autocmd CursorHold,CursorHoldI <buffer> lua require'nvim-lightbulb'.update_lightbulb()]]
    if vim.bo.filetype == 'rust' then
        vim.cmd('autocmd InsertLeave,BufEnter,BufWinEnter,TabEnter,BufWritePost <buffer> ' ..
        'lua require"lsp_extensions".inlay_hints{ prefix = " » ", highlight = "NonText", ' ..
        'aligned = true, enabled = {"TypeHint", "ChainingHint", "ParameterHint"} }')
    end
end

local function setup_ls(ls, ls_cmd)
    if type(ls_cmd) == "string" then
        ls_cmd = { ls_cmd }
    end

    if util.has_bins(ls_cmd[1]) then
        lsp[ls].setup{
            on_attach = on_attach,
            cmd = ls_cmd,
            capabilities = capabilities,
        }
    else
        vim.notify("Missing LS for " .. ls)
    end
end


local function get_python_path(workspace)
  -- Use activated virtualenv.
  if vim.env.VIRTUAL_ENV then
    return util.path.join(vim.env.VIRTUAL_ENV, 'bin', 'python')
  end

  -- Check for a poetry.lock file
  if vim.fn.glob(util.path.join(workspace, 'poetry.lock')) ~= '' then
    return util.path.join(vim.fn.trim(vim.fn.system('poetry env info -p')), 'bin', 'python')
  end

  -- Find and use virtualenv from pipenv in workspace directory.
  local match = vim.fn.glob(util.path.join(workspace, 'Pipfile'))
  if match ~= '' then
    local venv = vim.fn.trim(vim.fn.system('PIPENV_PIPFILE=' .. match .. ' pipenv --venv'))
    return util.path.join(venv, 'bin', 'python')
  end

  -- Fallback to system Python.
  return vim.fn.exepath('python3') or vim.fn.exepath('python') or 'python'
end


lsp.pyright.setup{
    on_attach = on_attach,
    capabilities = capabilities,
    on_init = function(client)
        client.config.settings.python.pythonPath = get_python_path(client.config.root_dir)
    end,
    settings = {
        python = {
            analysis = {
                autoImportCompletions = true,
                stubPath = "typings",
                typeCheckingMode = "strict",
            },
        }
    }
}


require("null-ls").setup({
    -- you must define at least one source for the plugin to work
    sources = {
      require("null-ls").builtins.diagnostics.pylint,
      require("null-ls").builtins.diagnostics.flake8.with {
          extra_args = { "--config", vim.fn.expand("~/.config/flake8") },
      },
    }
})

setup_ls("cmake", "cmake-language-server")
setup_ls("cssls", { "css-languageserver", "--stdio" })
setup_ls("jsonls", { "vscode-json-languageserver", "--stdio" })
setup_ls("rust_analyzer", "rust-analyzer")
setup_ls("texlab", "texlab")
setup_ls("tsserver", { "typescript-language-server", "--stdio" })
setup_ls("vimls", { "vim-language-server", "--stdio" })
setup_ls("yamlls", { "yaml-language-server", "--stdio" })


-- Treesitter
--
require'nvim-treesitter.configs'.setup {
  -- One of "all", "maintained" (parsers with maintainers), or a list of languages
  ensure_installed = "maintained",

  -- Install languages synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- List of parsers to ignore installing
  ignore_install = { "markdown" },

  highlight = {
    -- `false` will disable the whole extension
    enable = true,

    -- list of language that will be disabled
    disable = { },

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}
