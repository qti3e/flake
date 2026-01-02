{
  inputs,
  pkgs,
}:

# Standalone neovim package
inputs.nixvim.legacyPackages.${pkgs.system}.makeNixvimWithModule {
  inherit pkgs;
  module = {
    config = {
      # ensure base neovim is used from pkgs
      package = pkgs.neovim;

      clipboard.providers.wl-copy.enable = true;

      opts = {
        tabstop = 2;
        shiftwidth = 2;
        expandtab = true;
        mouse = "";
        number = true;
        undofile = true;
        relativenumber = true;
        scrolloff = 5;
        # otherwise the sudden appearance and disappearance of
        # signcolumn is annoying.
        signcolumn = "yes";

        foldenable = true;
        foldlevel = 99;
        foldlevelstart = 99;
        foldtext = "";
        foldcolumn = "0";
        foldmethod = "expr";
        foldexpr = "v:lua.vim.treesitter.foldexpr()";
        guicursor = "a:block,i-ci:ver25";

        termguicolors = true;
      };

      globals.mapleader = ",";

      keymaps = [
        {
          key = "<C-j>";
          action = "<Down>";
          mode = [ "c" ];
          options.desc = "Command-line history down";
        }
        {
          key = "<C-k>";
          action = "<Up>";
          mode = [ "c" ];
          options.desc = "Command-line history up";
        }

        {
          key = "<leader>tp";
          action.__raw = ''
            function()
              local S = require('nvim-autopairs').state
              S.disabled = not S.disabled
            end
          '';
          mode = [ "n" ];
          options.desc = "Toggle Autopairs";
        }
        {
          key = "!";
          action.__raw = "require('lsp_lines').toggle";
          mode = [ "n" ];
          options.desc = "Toggle LspLines";
        }

        {
          key = "<leader>j";
          action.__raw = "require('flash').treesitter";
          mode = [
            "v"
            "n"
          ];
          options.desc = "Flash treesitter";
        }
        {
          key = "<leader>R";
          action.__raw = "require('flash').treesitter_search";
          mode = [
            "v"
            "n"
          ];
          options.desc = "Flash treesitter search";
        }
        {
          key = "<leader>t";
          action = "<cmd>Telescope file_browser<CR>";
          mode = [ "n" ];
          options.desc = "Toggle file browser";
        }
        {
          key = "<leader>?";
          action = "<cmd>Telescope file_browser path=%:p:h select_buffer=true<CR>";
          mode = [ "n" ];
          options.desc = "Open file tree on the current file";
        }
        {
          key = "<leader>D";
          action = "<cmd>Telescope diagnostics<CR>";
          mode = [ "n" ];
          options.desc = "Telescope diagnostics";
        }
        {
          key = "<leader>d";
          action = "<cmd>Trouble diagnostics toggle<CR>";
          mode = [ "n" ];
          options.desc = "Toggle diagnostics";
        }
        {
          key = "<leader>s";
          action = "<cmd>Trouble symbols toggle<CR>";
          mode = [ "n" ];
          options.desc = "Toggle symbols";
        }
        {
          key = "K";
          action.__raw = "vim.lsp.buf.hover";
          mode = [ "n" ];
          options.desc = "Show hover actions";
        }

        {
          key = "go";
          action.__raw = "MiniDiff.toggle_overlay";
          mode = [ "n" ];
          options.desc = "Toggle git diff overlay";
        }
        {
          key = "gd";
          action = "<Esc>:Telescope lsp_definitions<CR>";
          mode = [ "n" ];
          options.desc = "Jump definition";
        }
        {
          key = "gD";
          # no telescope support
          action.__raw = "vim.lsp.buf.declaration";
          mode = [ "n" ];
          options.desc = "Jump declaration";
        }
        {
          key = "gi";
          action = "<Esc>:Telescope lsp_implementations<CR>";
          mode = [ "n" ];
          options.desc = "Jump to implementations";
        }
        {
          key = "gT";
          action = "<Esc>:Telescope lsp_type_definitions<CR>";
          mode = [ "n" ];
          options.desc = "Jump to type definition";
        }
        {
          key = "gr";
          action = "<Esc>:Telescope lsp_references<CR>";
          mode = [ "n" ];
          options.desc = "Show References";
        }
        {
          key = "ge";
          action.__raw = ''
            function()
              vim.diagnostic.goto_next({
                severity = vim.diagnostic.severity.ERROR;
              })
            end
          '';
          mode = [ "n" ];
          options.desc = "Next error diagnostic";
        }
        {
          key = "gn";
          action.__raw = "vim.diagnostic.goto_next";
          mode = [ "n" ];
          options.desc = "Next diagnostic";
        }
        {
          key = "gN";
          action.__raw = "vim.diagnostic.goto_prev";
          mode = [ "n" ];
          options.desc = "Prev diagnostic";
        }
        {
          key = "<leader>r";
          action.__raw = "vim.lsp.buf.rename";
          mode = [ "n" ];
          options.desc = "Lsp Symbol Rename";
        }
        {
          key = "<leader>f";
          action.__raw = "vim.lsp.buf.format";
          mode = [ "n" ];
          options.desc = "Lsp Format Buffer";
        }
        {
          key = "gt";
          action = "<Esc>:Telescope grep_string<CR>";
          mode = [ "v" ];
          options.desc = "Telescope grep current selection";
        }
        {
          key = "gt";
          action = "<Esc>:Telescope live_grep<CR>";
          mode = [ "n" ];
          options.desc = "Telescope live grep";
        }
        {
          key = "gb";
          action = "<Esc>:Telescope buffers<CR>";
          mode = [ "n" ];
          options.desc = "Show buffers";
        }
        {
          key = "gf";
          action = "<Esc>:Telescope find_files<CR>";
          mode = [ "n" ];
          options.desc = "Show files";
        }
        {
          key = "gS";
          action = "<Esc>:Telescope lsp_dynamic_workspace_symbols<CR>";
          mode = [ "n" ];
          options.desc = "Show workplace symbols";
        }
        {
          key = "gs";
          action = "<Esc>:Telescope lsp_document_symbols<CR>";
          mode = [ "n" ];
          options.desc = "Show document symbols";
        }
        {
          key = "<C-.>";
          action.__raw = ''require("actions-preview").code_actions'';
          mode = [
            "n"
            "v"
            "i"
          ];
          options.desc = "Show code actions";
        }
        {
          # Jump forward if completing a snippet (ie, function parameter placeholders)
          key = "<Tab>";
          action.__raw = ''
            function()
              if vim.snippet.active(1) then
                return '<cmd>lua vim.snippet.jump(1)<cr>'
              else
                return '<Tab>'
              end
            end
          '';
          mode = [
            "s"
            "i"
          ];
          options.expr = true;
        }
        {
          # Jump backwards if completing a snippet
          key = "<S-Tab>";
          action.__raw = ''
            function()
              if vim.snippet.jumpable("-1") then
                return '<cmd>lua vim.snippet.jump(-1)<cr>'
              else
                return '<Tab>'
              end
            end
          '';
          mode = [
            "s"
            "i"
          ];
          options.expr = true;
        }
        {
          key = "<leader>u";
          action.__raw = ''
            function()
              require("treesitter-context").go_to_context(vim.v.count1)
            end
          '';
          mode = [
            "n"
          ];
          options.desc = "Jump to upward context";
        }
      ];

      autoCmd = [
        {
          event = "TermOpen";
          command = "setlocal nonumber norelativenumber";
        }
      ];

      diagnostics = {
        severity_sort = true;
        float = {
          border = "rounded";
        };
        signs = {
          # severity.min.__raw = "vim.diagnostic.severity.WARN";
          text = {
            "__rawKey__vim.diagnostic.severity.ERROR" = "󰅙";
            "__rawKey__vim.diagnostic.severity.WARN" = "";
            "__rawKey__vim.diagnostic.severity.INFO" = "󰋼";
            "__rawKey__vim.diagnostic.severity.HINT" = "󰌵";
          };
        };
        underline = {
          severity.min.__raw = "vim.diagnostic.severity.ERROR";
        };
        jump = {
          severity.__raw = "vim.diagnostic.severity.ERROR";
        };
      };

      extraConfigLuaPre = ''
        vim.g.tlaplus_mappings_enable = false
        require("flatten").setup()
      '';

      extraConfigLua = ''
        require('crates').setup({
          completion = {
            crates = {
              enabled = true,
              max_results = 8,
              min_chars = 3
            },
            cmp = {
              enabled = true,
            },
          }
        })

        -- autopair configs
        local Rule = require('nvim-autopairs.rule')
        local npairs = require('nvim-autopairs')
        local cond = require('nvim-autopairs.conds')
        npairs.add_rule(Rule("|", "|", { "rust", "go", "lua" })
          :with_pair(cond.before_text("async"))
          :with_pair(cond.before_text("move"))
          :with_pair(cond.before_text("("))
          :with_pair(cond.before_text("="))
          :with_pair(cond.before_text(","))

          :with_move(cond.after_regex "|")
        )
        npairs.add_rule(Rule("<", ">", { "rust", "typescript" })
          :with_pair(cond.not_before_text(" "))
          :with_pair(cond.not_before_text("<"))
          :with_move(function(opts)
            if opts.char == ">" then
              return true
            end
            return false
          end))

        require'nvim-treesitter.configs'.setup {
          textobjects = {
            select = {
              enable = true,
              -- Automatically jump forward to textobj, similar to targets.vim
              lookahead = true,
              keymaps = {
                -- You can use the capture groups defined in textobjects.scm
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["ac"] = "@call.outer",
                ["ic"] = "@call.inner",
                ["al"] = "@loop.outer",
                ["il"] = "@loop.inner",
                ["ab"] = "@block.outer",
                ["ib"] = "@block.inner",
                ["ai"] = "@conditional.outer",
                ["ii"] = "@conditional.inner",
                ["aa"] = "@assignment.outer",
                ["ia"] = "@assignment.inner",
                -- upper case
                ["aC"] = "@comment.outer",
                ["iC"] = "@comment.inner",
                ["aP"] = "@parameter.outer",
                ["iP"] = "@parameter.inner",
                -- t for trait because Rust
                ["at"] = "@class.outer",
                ["it"] = "@class.inner",
                -- no inner
                ["aS"] = "@statement.outer",
              }
            },
            swap = {
              enable = true,
              swap_next = {
                ["<leader>mp"] = "@parameter.inner",
                ["<leader>mf"] = "@function.outer",
                ["<leader>mb"] = "@block.outer",
                ["<leader>mc"] = "@call.outer",
                ["<leader>ml"] = "@loop.outer",
                ["<leader>mi"] = "@conditional.outer",
                ["<leader>ms"] = "@statement.outer",
              },
              swap_previous = {
                ["<leader>mP"] = "@parameter.inner",
                ["<leader>mF"] = "@function.outer",
                ["<leader>mB"] = "@block.outer",
                ["<leader>mC"] = "@call.outer",
                ["<leader>mL"] = "@loop.outer",
                ["<leader>mI"] = "@conditional.outer",
                ["<leader>mS"] = "@statement.outer",
              },
            },
            move = {
              enable = true,
              set_jumps = true,
              goto_next = {
                ["]m"] = "@function.outer",
                ["]s"] = { query = { "@loop.outer", "@conditional.outer" } },
                ["]p"] = "@parameter.inner",
              },
              goto_previous = {
                ["[m"] = "@function.outer",
                ["[s"] = { query = { "@loop.outer", "@conditional.outer" } },
                ["[p"] = "@parameter.inner",
              }
            },
          },
        }
        -- Repeat movement with ; and ,
        -- ensure ; goes forward and , goes backward regardless of the last direction
        local ts_repeat_move = require "nvim-treesitter.textobjects.repeatable_move"
        vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next)
        vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous)

        require("actions-preview").setup()
        require('lsp_lines').toggle()

        vim.cmd([[
            hi Conceal guifg=#ff0000
        ]])

        local function virtual_text_document(params)
          local bufnr = params.buf
          local actual_path = params.match:sub(1)

          local clients = vim.lsp.get_clients({ name = "denols" })
          if #clients == 0 then
            return
          end

          local client = clients[1]
          local method = "deno/virtualTextDocument"
          local req_params = { textDocument = { uri = actual_path } }
          local response = client.request_sync(method, req_params, 2000, 0)
          if not response or type(response.result) ~= "string" then
            return
          end

          local lines = vim.split(response.result, "\n")
          vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
          vim.api.nvim_set_option_value("readonly", true, { buf = bufnr })
          vim.api.nvim_set_option_value("modified", false, { buf = bufnr })
          vim.api.nvim_set_option_value("modifiable", false, { buf = bufnr })
          vim.api.nvim_buf_set_name(bufnr, actual_path)
          vim.lsp.buf_attach_client(bufnr, client.id)

          local filetype = "typescript"
          if actual_path:sub(-3) == ".md" then
            filetype = "markdown"
          end
          vim.api.nvim_set_option_value("filetype", filetype, { buf = bufnr })
        end

        vim.api.nvim_create_autocmd({ "BufReadCmd" }, {
          pattern = { "deno:/*" },
          callback = virtual_text_document,
        })

        local function use_deno_tabsz(params)
          local bufnr = params.buf
          vim.g.rust_recommended_style = 0
          vim.api.nvim_set_option_value("expandtab", true, { buf = bufnr })
          vim.api.nvim_set_option_value("tabstop", 2, { buf = bufnr })
          vim.api.nvim_set_option_value("shiftwidth", 2, { buf = bufnr })
          vim.api.nvim_set_option_value("softtabstop", 2, { buf = bufnr })
          vim.api.nvim_set_option_value("textwidth", 80, { buf = bufnr })
        end

        _G.deno_tabsz = function()
          use_deno_tabsz({ buf = 0 })
        end

        vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
          pattern = { "/home/qti3e/Code/Deno/*" },
          callback = use_deno_tabsz,
        });

        -- https://github.com/neovim/neovim/issues/30985#issuecomment-2447329525
        for _, method in ipairs({ 'textDocument/diagnostic', 'workspace/diagnostic' }) do
            local default_diagnostic_handler = vim.lsp.handlers[method]
            vim.lsp.handlers[method] = function(err, result, context, config)
                if err ~= nil and err.code == -32802 then
                    return
                end
                return default_diagnostic_handler(err, result, context, config)
            end
        end
      '';

      # Use experimental lua loader with jit cache
      luaLoader.enable = true;
      performance.combinePlugins.enable = true;
      performance.combinePlugins.standalonePlugins = [
        "vimplugin-nvim-treesitter-textobjects"
      ];
      match.ExtraWhitespace = "\\s\\+$";

      extraPlugins =
        with pkgs.vimPlugins;
        [
          flatten-nvim
          actions-preview-nvim
          nvim-treesitter-parsers.tlaplus
        ]
        ++ [
          (pkgs.vimUtils.buildVimPlugin {
            name = "nvim-treesitter-textobjects";
            src = pkgs.fetchFromGitHub {
              owner = "nvim-treesitter";
              repo = "nvim-treesitter-textobjects";
              rev = "9937e5e356e5b227ec56d83d0a9d0a0f6bc9cad4";
              hash = "sha256-2i2HrJLJvx2HwPua/wcJpuF3nlvNf/VzNq2PlsbfHdM=";
            };
          })

          (pkgs.vimUtils.buildVimPlugin {
            name = "crates.nvim";
            src = pkgs.fetchFromGitHub {
              owner = "saecki";
              repo = "crates.nvim";
              rev = "6bf1b4ceb62f205c903590ccc62061aafc17024a";
              hash = "sha256-ijuz7abSLNTjgeIThtV+MV6SMBWgcAWcPK7yYpB9HeI=";
            };
          })

          # https://github.com/tlaplus-community/tlaplus-nvim-plugin
          (pkgs.vimUtils.buildVimPlugin {
            name = "tlaplus-nvim-plugin";
            src = pkgs.fetchFromGitHub {
              owner = "tlaplus-community";
              repo = "tlaplus-nvim-plugin";
              rev = "d066ba20ca95bde50ef55fa10f666a008fc71b09";
              hash = "sha256-6/JZTcQGtP/sfg2ySl+wfqfoOaEk4++KPD74kwPVX98=";
            };
          })

          # https://github.com/florentc/vim-tla
          (pkgs.vimUtils.buildVimPlugin {
            name = "vim-tla";
            src = pkgs.fetchFromGitHub {
              owner = "florentc";
              repo = "vim-tla";
              rev = "220145ef791ac8d64d2c319eb2940b59da17d6ca";
              hash = "sha256-YdXBzxB5yfpPJJ1wVRdl6i1rPDzgwrxB1Onlkixk4/c=";
            };
          })

          # https://github.com/arthurxavierx/vim-unicoder
          (pkgs.vimUtils.buildVimPlugin {
            name = "vim-tla";
            src = pkgs.fetchFromGitHub {
              owner = "arthurxavierx";
              repo = "vim-unicoder";
              rev = "a71fc3670f9337c56806fa9e8e97b7ea09fd5e39";
              hash = "sha256-Cyw+qZ3N7DvwVB6jSlWFxn6dHILj+wnmzrvdBFLvls0=";
            };
          })
        ];

      plugins = {
        neoscroll.enable = true;
        gitlinker.enable = true;
        web-devicons.enable = true;
        lsp-format.enable = true;
        treesitter.enable = true;
        lsp-lines.enable = true;
        commentary.enable = true;
        wakatime.enable = true;

        nvim-autopairs = {
          enable = true;
          settings = {
            check_ts = true;
          };
        };

        telescope = {
          enable = true;
          extensions.file-browser = {
            enable = true;
            settings = {
              hijack_netrw = true;
            };
          };
          settings = {
            layout_config.prompt_position = "top";
            mappings = {
              i = {
                "<C-j>".__raw = "require('telescope.actions').move_selection_next";
                "<C-k>".__raw = "require('telescope.actions').move_selection_previous";
              };
            };
          };
        };

        treesitter-context = {
          enable = true;
          settings = {
            separator = "⸻";
            max_lines = 10;
            trim_scope = "inner";
            min_window_height = 40;
          };
        };

        flash = {
          enable = true;
          settings = {
            continue = false;
            modes.search.enabled = true;
            jump = {
              autojump = false;
              history = false;
              jumplist = true;
              nohlsearch = true;
            };
            label = {
              after = true;
              # exclude hard to reach keys
              exclude = "z";
              min_pattern_length = 2;
              rainbow.enabled = false;
            };
          };
        };

        lsp = {
          enable = true;
          inlayHints = false;
          servers = {
            nil_ls = {
              enable = true;
              settings.formatting.command = [ "${pkgs.nixfmt-rfc-style}/bin/nixfmt" ];
            };
            lua_ls.enable = true;
            denols = {
              enable = true;
              package = null;
              # cmd = [
              #   "/home/qti3e/.cargo/bin/deno"
              #   "lsp"
              # ];
            };
            clangd.enable = true;
            zls.enable = true;
            gopls = {
              enable = true;
              settings = {
                workspaceFiles = [
                  "**/BUILD"
                  "**/WORKSPACE"
                  "**/*.{bzl,bazel}"
                ];
                directoryFilters = [
                  "-bazel-bin"
                  "-bazel-out"
                  "-bazel-testlogs"
                  "-bazel-mypkg"
                ];
              };
            };
            rust_analyzer = {
              enable = true;
              package = null;
              installCargo = false;
              installRustc = false;
              settings = {
                check.command = "clippy";
              };
            };
          };
        };

        fidget = {
          enable = true;
          progress = {
            display = {
              progressIcon = {
                pattern = "flip";
                period = 1;
              };
              overrides = {
                rust_analyzer = {
                  name = "rust analyzer";
                };
              };
            };
          };
          notification = {
            window = {
              winblend = 0;
              xPadding = 2;
            };
          };
        };

        trouble = {
          enable = true;
          settings.auto_close = true;
        };

        gitsigns = {
          enable = true;
          settings = {
            signcolumn = false;
            numhl = false;
            current_line_blame = false;
            current_line_blame_opts.delay = 0;
          };
        };

        blink-cmp = {
          enable = true;
          settings = {
            keymap = {
              "<C-space>" = [
                "show"
                "show_documentation"
                "hide_documentation"
              ];
              "<C-e>" = [ "hide" ];
              "<C-y>" = [ "select_and_accept" ];
              "<CR>" = [
                "select_and_accept"
                "fallback"
              ];
              "<Tab>" = [
                "select_next"
                "fallback"
              ];
              "<S-Tab>" = [
                "select_prev"
                "fallback"
              ];
              "<C-b>" = [
                "scroll_documentation_up"
                "fallback"
              ];
              "<C-f>" = [
                "scroll_documentation_down"
                "fallback"
              ];
            };
          };
        };

        mini = {
          enable = true;
          modules = {
            diff = {
              view = {
                style = "sign";
                signs = {
                  add = "▒";
                  change = "▒";
                  delete = "▒";
                };
                priority = 5;
              };
            };
            bracketed = { };
          };
        };
      };

      highlightOverride = {
        # Base UI
        Normal = {
          fg = "#ffffff";
          bg = "#000000";
        };
        NormalFloat = {
          fg = "#ffffff";
          bg = "#0a0a0a";
        };
        FloatBorder = {
          fg = "#444444";
          bg = "#0a0a0a";
        };
        CursorLine = {
          bg = "#111111";
        };
        CursorLineNr = {
          fg = "#ffffff";
          bold = true;
        };
        LineNr = {
          fg = "#444444";
        };
        Visual = {
          bg = "#333333";
        };
        Search = {
          fg = "#000000";
          bg = "#ffffff";
        };
        IncSearch = {
          fg = "#000000";
          bg = "#ffffff";
        };
        Pmenu = {
          fg = "#ffffff";
          bg = "#111111";
        };
        PmenuSel = {
          fg = "#000000";
          bg = "#ffffff";
        };
        StatusLine = {
          fg = "#ffffff";
          bg = "#111111";
        };
        StatusLineNC = {
          fg = "#666666";
          bg = "#0a0a0a";
        };
        VertSplit = {
          fg = "#222222";
        };
        SignColumn = {
          bg = "#000000";
        };

        # Syntax - all white
        Comment = {
          fg = "#666666";
          italic = false;
        };
        Constant = {
          fg = "#ffffff";
        };
        String = {
          fg = "#ffffff";
        };
        Identifier = {
          fg = "#ffffff";
        };
        Function = {
          fg = "#ffffff";
        };
        Statement = {
          fg = "#ffffff";
        };
        Operator = {
          fg = "#ffffff";
        };
        Keyword = {
          fg = "#ffffff";
        };
        Type = {
          fg = "#ffffff";
        };
        Special = {
          fg = "#ffffff";
        };
        PreProc = {
          fg = "#ffffff";
        };
        Delimiter = {
          fg = "#ffffff";
        };

        # Diagnostics
        DiagnosticError = {
          fg = "#ff6666";
        };
        DiagnosticWarn = {
          fg = "#ffcc66";
        };
        DiagnosticInfo = {
          fg = "#6699ff";
        };
        DiagnosticHint = {
          fg = "#666666";
        };

        # Git signs
        GitSignsAdd = {
          fg = "#666666";
        };
        GitSignsChange = {
          fg = "#666666";
        };
        GitSignsDelete = {
          fg = "#666666";
        };

        # LSP
        LspInlayHint = {
          fg = "#444444";
        };
      };

    };
  };
}
