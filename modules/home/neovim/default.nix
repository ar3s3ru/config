{ pkgs, inputs, colorscheme, ... }:

with inputs.nix-colors.lib-contrib { inherit pkgs; };

let
  goSettings = builtins.readFile ./go.lua;
  themePlugin = vimThemeFromScheme { scheme = colorscheme; };
in
{
  home.packages = with pkgs; [
    tree-sitter
    fd
    shfmt
    shellcheck
    nixd
    nixpkgs-fmt
    stylua
    terraform-ls
    typescript
    typescript-language-server
    prettier
  ];

  programs.nixvim = {
    enable = true;
    viAlias = false;
    vimAlias = true;
    withRuby = false;
    withPython3 = false;

    extraPlugins = with pkgs.vimPlugins; [
      themePlugin
      vim-nix
      vim-visual-multi
      vim-better-whitespace
      vim-vsnip
    ];

    extraConfigLua = ''
      vim.cmd.colorscheme("nix-${colorscheme.slug}")

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

      ${goSettings}
    '';

    globals.mapleader = " ";

    opts = {
      lazyredraw = true;
      shell = "fish";
      shadafile = "NONE";
      termguicolors = true;
      guifont = "VictorMono Nerd Font:h10";
      undofile = true;
      smartindent = true;
      tabstop = 4;
      shiftwidth = 4;
      shiftround = true;
      expandtab = true;
      scrolloff = 3;
      clipboard = "unnamedplus";
      mouse = "a";
      cursorline = true;
      number = true;
      viminfo = "";
      viminfofile = "NONE";
      ignorecase = true;
      ttimeoutlen = 5;
      shortmess = "atI";
      wrap = false;
      writebackup = false;
      errorbells = false;
      swapfile = false;
      showmode = false;
      laststatus = 3;
      pumheight = 6;
      splitright = true;
      splitbelow = true;
      completeopt = "menuone,noselect";
    };

    keymaps = [
      { mode = "n"; key = "<C-f>"; action = "<cmd>Telescope live_grep<CR>"; options.silent = true; }
      { mode = "n"; key = "<C-p>"; action = "<cmd>Telescope find_files<CR>"; options.silent = true; }
      { mode = "n"; key = "<C-b>"; action = "<cmd>NvimTreeToggle<CR>"; options.silent = true; }
    ];

    autoGroups.CursorLine = { clear = true; };

    autoCmd = [
      {
        event = [ "VimEnter" "WinEnter" "BufWinEnter" ];
        group = "CursorLine";
        command = "setlocal cursorline";
      }
      {
        event = "WinLeave";
        group = "CursorLine";
        command = "setlocal nocursorline";
      }
      {
        event = "FileType";
        pattern = "nix";
        command = "setlocal shiftwidth=2";
      }
    ];

    plugins = {
      web-devicons.enable = true;
      bufferline.enable = true;
      lualine.enable = true;
      nvim-tree.enable = true;
      indent-blankline.enable = true;
      telescope.enable = true;

      treesitter = {
        enable = true;
        settings.highlight.enable = true;
        settings.indent.enable = true;
        folding.enable = false;
      };

      conform-nvim = {
        enable = true;
        settings = {
          formatters_by_ft = {
            lua = [ "stylua" ];
            nix = [ "nixpkgs_fmt" ];
            sh = [ "shfmt" ];
            bash = [ "shfmt" ];
            javascript = [ "prettier" ];
            javascriptreact = [ "prettier" ];
            typescript = [ "prettier" ];
            typescriptreact = [ "prettier" ];
            json = [ "prettier" ];
            yaml = [ "prettier" ];
            html = [ "prettier" ];
            css = [ "prettier" ];
            markdown = [ "prettier" ];
            toml = [ "prettier" ];
          };
          format_on_save = {
            timeout_ms = 1000;
            lsp_format = "fallback";
          };
        };
      };

      lint = {
        enable = true;
        lintersByFt = {
          sh = [ "shellcheck" ];
          bash = [ "shellcheck" ];
        };
        autoCmd.event = [ "BufWritePost" "BufReadPost" "InsertLeave" ];
      };

      lsp = {
        enable = true;
        servers = {
          gopls.enable = true;
          terraformls.enable = true;
          nixd = {
            enable = true;
            settings.formatting.command = [ "nixpkgs-fmt" ];
          };
          rust_analyzer = {
            enable = true;
            installRustc = false;
            installCargo = false;
            settings = {
              cargo.features = "all";
              checkOnSave.command = "clippy";
            };
          };
          ts_ls = {
            enable = true;
            filetypes = [ "javascript" "javascriptreact" "typescript" "typescriptreact" ];
            cmd = [
              "typescript-language-server"
              "--stdio"
              "--tsserver-path"
              "${pkgs.typescript}/bin/tsserver"
            ];
          };
        };
        keymaps.lspBuf = {
          "gD" = "declaration";
          "gd" = "definition";
          "<space>h" = "hover";
          "td" = "type_definition";
          "<C-d>" = "references";
          "<space>ca" = "code_action";
        };
        onAttach = ''
          if client.name == "ts_ls" then
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
          end
        '';
      };

      cmp = {
        enable = true;
        autoEnableSources = true;
        settings = {
          snippet.expand = ''
            function(args) vim.fn["vsnip#anonymous"](args.body) end
          '';
          mapping = {
            "<C-b>" = "cmp.mapping.scroll_docs(-4)";
            "<C-f>" = "cmp.mapping.scroll_docs(4)";
            "<C-Space>" = "cmp.mapping.complete()";
            "<C-e>" = "cmp.mapping.abort()";
            "<CR>" = "cmp.mapping.confirm({ select = true })";
          };
          sources = [
            { name = "nvim_lsp"; }
            { name = "nvim_lsp_signature_help"; }
            { name = "vsnip"; }
            { name = "buffer"; }
            { name = "path"; }
            { name = "emoji"; }
          ];
        };
      };
    };
  };
}
