let
  keymap = {
    key,
    action,
    mode ? "n",
    lua ? false,
  }: {
    inherit action mode key lua;
    options = {
      noremap = true;
      silent = true;
    };
  };
in {
  programs.nixvim = {
    plugins = {
      lsp = {
        enable = true;
        servers = {
          tsserver.enable = true;
          gopls = {
            enable = true;
            installLanguageServer = false;
          };
          rust-analyzer = {
            enable = true;
            # managed in projects
            installCargo = false;
            installRustc = false;
            settings = {
              cachePriming = {
                enable = true;
                numThreads = 0; # auto
              };
              check = {
                allTargets = true;
                command = "clippy";
              };
            };
          };
          pyright.enable = true;
          ruff-lsp.enable = true;
          nixd = {
            enable = true;
            # onAttach.function = "client.server_capabilities.documentFormattingProvider = false";
          };
        };
      };
    };
    keymaps = [
      (keymap {
        key = "gy";
        action = "vim.lsp.buf.type_definition";
        lua = true;
      })
      (keymap {
        key = "gi";
        action = "vim.lsp.buf.implementation";
        lua = true;
      })
      (keymap {
        key = "<leader>k";
        action = "vim.lsp.buf.hover";
        lua = true;
      })
      (keymap {
        key = "<leader>r";
        action = "vim.lsp.buf.rename";
        lua = true;
      })
      (keymap {
        key = "]d";
        action = "vim.diagnostic.goto_next";
        lua = true;
      })
      (keymap {
        key = "[d";
        action = "vim.diagnostic.goto_prev";
        lua = true;
      })
      (keymap {
        key = "<leader>a";
        action = "function() vim.lsp.buf.code_action({ source = { organizeImports = true } }) end";
        lua = true;
      })
      (keymap {
        mode = "i";
        key = "<C-h>";
        action = "vim.lsp.buf.signature_help";
        lua = true;
      })
    ];
  };
}
