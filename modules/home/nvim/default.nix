{ pkgs, inputs, colorscheme, ... }:

let
  settings = ./settings.lua;
  goSettings = ./go.lua;
in

# Required to use vimThemeFromScheme to set colorscheme.
with inputs.nix-colors.lib-contrib { inherit pkgs; };

{
  home.packages = with pkgs; [
    tree-sitter
    # Shell
    shfmt
    shellcheck
    # neovide
    # Nix
    nil
    nixpkgs-fmt
    # Lua
    stylua
    # Terraform
    terraform
    terraform-ls
    tflint
    # Protobufs
    buf
    # Bazel
    buildifier
    # Typescript langauge server.
    nodePackages.typescript
    nodePackages.typescript-language-server
    nodePackages.prettier # Code formatter.
  ];

  programs.neovim = {
    enable = true;
    vimAlias = true;

    extraConfig = ''
      luafile ${settings}
      luafile ${goSettings}
    '';

    plugins = with pkgs.vimPlugins; [
      # Set theme to nix-colors'.
      {
        plugin = vimThemeFromScheme { scheme = colorscheme; };
        config = ''
          colorscheme nix-${colorscheme.slug}
        '';
      }

      # Languages support.
      vim-nix
      editorconfig-nvim
      vim-terraform
      vim-bazel

      # Productivity enhancements.
      vim-visual-multi

      # Presentation and layout.
      nvim-web-devicons
      vim-better-whitespace
      indentLine
      {
        plugin = bufferline-nvim;
        config = ''
          lua require('bufferline').setup{}
        '';
      }
      {
        plugin = lualine-nvim;
        config = ''
          lua require('lualine').setup{}
        '';
      }
      {
        plugin = nvim-tree-lua;
        config = ''
          lua require('nvim-tree').setup()
        '';
      }
      {
        plugin = nvim-treesitter;
        config = ''
          lua << EOF
            require('nvim-treesitter.configs').setup {
              highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
              },
            }
          EOF
        '';
      }
      {
        plugin = telescope-nvim;
        config = ''
          lua require('telescope').setup()
        '';
      }

      # Language servers and autocompletion.
      {
        plugin = nvim-lspconfig;
        config = ''
          lua << EOF
            local lsp = require('lspconfig')

            local on_attach = function(client, bufnr)
              -- Enable completion triggered by <c-x><c-o>
              vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

              -- Mappings.
              -- See `:help vim.lsp.*` for documentation on any of the below functions
              local bufopts = { noremap=true, silent=true, buffer=bufnr }

              vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
              vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
              vim.keymap.set('n', '<space>h', vim.lsp.buf.hover, bufopts)
              vim.keymap.set('n', 'td', vim.lsp.buf.type_definition, bufopts)
              vim.keymap.set('n', '<C-d>', vim.lsp.buf.references, bufopts)
              vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
            end

            -- FIXME: use lua lsp instead, gotta figure out which one is it for Lua.
            -- lsp.sumneko_lua.setup{ on_attach = on_attach }
            lsp.gopls.setup{ on_attach = on_attach }
            lsp.terraformls.setup{ on_attach = on_attach }
            lsp.tflint.setup{ on_attach = on_attach }

            lsp.nil_ls.setup {
              on_attach = on_attach,
              autostart = true,
              settings = {
                ['nil'] = {
                  formatting = {
                    command = { "nixpkgs-fmt" },
                  },
                },
              },
            }

            lsp.rust_analyzer.setup{
              on_attach = on_attach,
              settings = {
                ["rust-analyzer"] = {
                  cargo = {
                    features = "all"
                  },
                  lens = {
                    enable = true,
                  },
                  checkOnSave = {
                    command = "clippy",
                  },
                }
              }
            }

            -- For some reason, tsserver requires some explicit path setting.
            lsp.ts_ls.setup{
              on_attach = function(client, bufnr)
                on_attach(client, bufnr)

                -- NOTE: disabling formatting through tsserver, since null-ls will do that instead.
                client.resolved_capabilities.document_formatting = false
              end,
              cmd = { "typescript-language-server", "--stdio", "--tsserver-path", "${pkgs.nodePackages.typescript}/bin/tsserver" },
            }
          EOF
        '';
      }
      plenary-nvim # Dependency for null-ls.
      {
        plugin = null-ls-nvim;
        config = ''
          lua << EOF
            local null_ls = require('null-ls')

            local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
            local format_on_save = function(client, bufnr)
              if client.supports_method("textDocument/formatting") then
                vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
                vim.api.nvim_create_autocmd("BufWritePre", {
                  group = augroup,
                  buffer = bufnr,
                  callback = function()
                    vim.lsp.buf.format({ bufnr = bufnr })
                  end,
                })
              end
            end

            null_ls.setup({
              on_attach = format_on_save,
              sources = {
                null_ls.builtins.formatting.prettier.with({
                  filetypes = { "html", "json", "yaml", "markdown", "css", "javascript", "javascriptreact", "typescript", "typescriptreact" },
                  extra_filetypes = { "toml" },
                }),

                null_ls.builtins.formatting.shfmt,
                null_ls.builtins.diagnostics.shellcheck,

                null_ls.builtins.formatting.buildifier,
                null_ls.builtins.diagnostics.buildifier,

                null_ls.builtins.formatting.buf,
                null_ls.builtins.diagnostics.buf,
              },
            })
          EOF
        '';
      }
      vim-vsnip
      cmp-vsnip
      cmp-nvim-lsp
      cmp-nvim-lsp-signature-help
      cmp-buffer
      cmp-path
      cmp-emoji
      {
        plugin = nvim-cmp;
        config = ''
          lua << EOF
            -- Setup nvim-cmp.
            local cmp = require('cmp')

            cmp.setup({
              snippet = {
                expand = function(args)
                  vim.fn["vsnip#anonymous"](args.body)
                end,
              },
              mapping = cmp.mapping.preset.insert({
                ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                ['<C-f>'] = cmp.mapping.scroll_docs(4),
                ['<C-Space>'] = cmp.mapping.complete(),
                ['<C-e>'] = cmp.mapping.abort(),
                ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
              }),
              sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'nvim_lsp_signature_help' },
                { name = 'vsnip' },
              }, {
                { name = 'buffer' },
              })
            })
          EOF
        '';
      }
    ];
  };
}

