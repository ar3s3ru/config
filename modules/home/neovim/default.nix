{ pkgs, inputs, colorscheme, ... }:

let
  settings = builtins.readFile ./settings.lua;
  goSettings = builtins.readFile ./go.lua;
in

# Required to use vimThemeFromScheme to set colorscheme.
with inputs.nix-colors.lib-contrib { inherit pkgs; };

{
  # CLI tools needed at runtime by neovim plugins (conform formatters, LSPs, treesitter).
  # Project-specific tools (terraform, buf, buildifier, tflint, etc.) are intentionally
  # NOT installed here -- get them from project devShells via direnv.
  home.packages = with pkgs; [
    tree-sitter # used by nvim-treesitter for on-the-fly parser builds (rare with Nix)

    # Shell
    shfmt
    shellcheck

    # Nix
    nil # LSP server
    nixpkgs-fmt # formatter

    # Lua
    stylua # formatter

    # Terraform (LSP only -- the `terraform` binary is unfree (BUSL-1.1) and
    # project-specific; install it via your project's devShell).
    terraform-ls

    # TypeScript / web
    typescript
    typescript-language-server
    prettier
  ];

  programs.neovim = {
    enable = true;
    vimAlias = true;

    # We don't use Ruby/Python providers; disabling shrinks closure significantly
    # and silences home-manager's deprecation warning.
    withRuby = false;
    withPython3 = false;

    initLua = ''
      ${settings}
      ${goSettings}
    '';

    plugins = with pkgs.vimPlugins; [
      # Theme generated from nix-colors scheme.
      {
        type = "lua";
        plugin = vimThemeFromScheme { scheme = colorscheme; };
        config = ''
          vim.cmd.colorscheme("nix-${colorscheme.slug}")
        '';
      }

      # Languages support.
      vim-nix

      # Productivity enhancements.
      vim-visual-multi

      # Presentation and layout.
      nvim-web-devicons
      vim-better-whitespace

      {
        type = "lua";
        plugin = indent-blankline-nvim;
        config = ''
          require("ibl").setup()
        '';
      }
      {
        type = "lua";
        plugin = bufferline-nvim;
        config = ''
          require('bufferline').setup{}
        '';
      }
      {
        type = "lua";
        plugin = lualine-nvim;
        config = ''
          require('lualine').setup{}
        '';
      }
      {
        type = "lua";
        plugin = nvim-tree-lua;
        config = ''
          require('nvim-tree').setup()
        '';
      }
      {
        # nvim-treesitter `main` branch: the old `configs.setup{ highlight = {...} }`
        # API was removed. Parsers are pre-installed via Nix (.withAllGrammars);
        # we enable highlighting/indentation per-buffer via an autocmd.
        type = "lua";
        plugin = nvim-treesitter.withAllGrammars;
        config = ''
          local function ts_attach(bufnr)
            local ft = vim.bo[bufnr].filetype
            if ft == "" then return end
            local lang = vim.treesitter.language.get_lang(ft) or ft
            if not lang then return end
            local ok = pcall(vim.treesitter.start, bufnr, lang)
            if ok then
              vim.bo[bufnr].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            end
          end

          vim.api.nvim_create_autocmd({ "FileType", "BufReadPost", "BufNewFile" }, {
            callback = function(args) ts_attach(args.buf) end,
          })

          -- Attach to any buffer already open at startup (init.lua runs after
          -- the first file's FileType has already fired).
          for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
            if vim.api.nvim_buf_is_loaded(bufnr) then ts_attach(bufnr) end
          end
        '';
      }
      plenary-nvim # telescope dependency
      {
        type = "lua";
        plugin = telescope-nvim;
        config = ''
          require('telescope').setup()
        '';
      }

      # Language servers: nvim-lspconfig is now a "configs registry" only --
      # it ships default cmd/filetypes/root_patterns under
      # ~/.../nvim-lspconfig/lsp/<server>.lua. Use vim.lsp.config()/enable()
      # (Neovim 0.11+) to consume them.
      {
        type = "lua";
        plugin = nvim-lspconfig;
        config = ''
          -- Register filetypes that LSP servers reference but nvim doesn't
          -- detect by default (silences :checkhealth vim.lsp warnings).
          vim.filetype.add({
            extension = {
              gotmpl = "gotmpl",
              gowork = "gowork",
              tfvars = "terraform-vars",
            },
            filename = {
              ["go.work"] = "gowork",
            },
          })

          -- Broadcast nvim-cmp's completion capabilities to every LSP client.
          local ok_cmp, cmp_lsp = pcall(require, 'cmp_nvim_lsp')
          if ok_cmp then
            vim.lsp.config('*', { capabilities = cmp_lsp.default_capabilities() })
          end

          -- Per-server tweaks layered on top of the bundled defaults.
          vim.lsp.config('nil_ls', {
            settings = {
              ['nil'] = {
                formatting = { command = { "nixpkgs-fmt" } },
              },
            },
          })

          vim.lsp.config('rust_analyzer', {
            settings = {
              ["rust-analyzer"] = {
                cargo = { features = "all" },
                lens = { enable = true },
                checkOnSave = { command = "clippy" },
              },
            },
          })

          vim.lsp.config('ts_ls', {
            cmd = {
              "typescript-language-server",
              "--stdio",
              "--tsserver-path", "${pkgs.typescript}/bin/tsserver",
            },
          })

          -- Enable the servers we use, but only if their binary is reachable.
          -- This avoids :checkhealth warnings for project-specific LSPs
          -- (gopls, rust-analyzer) that come from per-project devShells.
          local servers = {
            gopls          = { 'gopls' },
            terraformls    = { 'terraform-ls' },
            nil_ls         = { 'nil' },
            rust_analyzer  = { 'rust-analyzer' },
            ts_ls          = { 'typescript-language-server' },
          }
          for name, bins in pairs(servers) do
            for _, bin in ipairs(bins) do
              if vim.fn.executable(bin) == 1 then
                vim.lsp.enable(name)
                break
              end
            end
          end

          -- Buffer-local keymaps + per-client tweaks via LspAttach.
          vim.api.nvim_create_autocmd('LspAttach', {
            callback = function(args)
              local bufnr = args.buf
              local client = vim.lsp.get_client_by_id(args.data.client_id)

              vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'

              local opts = { noremap = true, silent = true, buffer = bufnr }
              vim.keymap.set('n', 'gD',       vim.lsp.buf.declaration,     opts)
              vim.keymap.set('n', 'gd',       vim.lsp.buf.definition,      opts)
              vim.keymap.set('n', '<space>h', vim.lsp.buf.hover,           opts)
              vim.keymap.set('n', 'td',       vim.lsp.buf.type_definition, opts)
              vim.keymap.set('n', '<C-d>',    vim.lsp.buf.references,      opts)
              vim.keymap.set('n', '<space>ca',vim.lsp.buf.code_action,     opts)

              -- ts_ls: let conform/prettier handle formatting instead of tsserver.
              if client and client.name == 'ts_ls' then
                client.server_capabilities.documentFormattingProvider = false
                client.server_capabilities.documentRangeFormattingProvider = false
              end
            end,
          })
        '';
      }

      # Formatting (replaces null-ls/none-ls, which is archived).
      {
        type = "lua";
        plugin = conform-nvim;
        config = ''
          require("conform").setup({
            formatters_by_ft = {
              lua        = { "stylua" },
              nix        = { "nixpkgs_fmt" },
              sh         = { "shfmt" },
              bash       = { "shfmt" },
              javascript = { "prettier" },
              javascriptreact = { "prettier" },
              typescript = { "prettier" },
              typescriptreact = { "prettier" },
              json       = { "prettier" },
              yaml       = { "prettier" },
              html       = { "prettier" },
              css        = { "prettier" },
              markdown   = { "prettier" },
              toml       = { "prettier" },
            },
            format_on_save = {
              timeout_ms = 1000,
              lsp_format = "fallback", -- fall back to LSP formatter (e.g. gopls, rust-analyzer, nil) when no conform formatter exists
            },
          })
        '';
      }

      # Linting (replaces null-ls diagnostics).
      {
        type = "lua";
        plugin = nvim-lint;
        config = ''
          local lint = require('lint')
          lint.linters_by_ft = {
            sh   = { 'shellcheck' },
            bash = { 'shellcheck' },
          }

          vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
            callback = function() require('lint').try_lint() end,
          })
        '';
      }

      # Completion: nvim-cmp + vsnip stack (kept as-is to preserve UX).
      vim-vsnip
      cmp-vsnip
      cmp-nvim-lsp
      cmp-nvim-lsp-signature-help
      cmp-buffer
      cmp-path
      cmp-emoji
      {
        type = "lua";
        plugin = nvim-cmp;
        config = ''
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
              ['<CR>'] = cmp.mapping.confirm({ select = true }),
            }),
            sources = cmp.config.sources({
              { name = 'nvim_lsp' },
              { name = 'nvim_lsp_signature_help' },
              { name = 'vsnip' },
            }, {
              { name = 'buffer' },
            }),
          })
        '';
      }
    ];
  };
}
