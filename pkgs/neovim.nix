{ inputs, pkgs }:

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

        foldenable = true;
        foldlevel = 99;
        foldlevelstart = 99;
        foldtext = "";
        foldcolumn = "0";
        foldmethod = "expr";
        foldexpr = "v:lua.vim.treesitter.foldexpr()";
      };

      globals.mapleader = ",";

      keymaps = [
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
          # action = "<cmd>NvimTreeToggle<CR>";
          action = "<cmd>Telescope file_browser<CR>";
          mode = [ "n" ];
          options.desc = "Toggle file browser";
        }
        {
          key = "<leader>?";
          # action = "<cmd>NvimTreeFindFile<CR>";
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

      extraConfigLuaPre = ''
        vim.g.tlaplus_mappings_enable = true

        require("flatten").setup()

        local symbols = { Error = "󰅙", Info = "󰋼", Hint = "󰌵", Warn = "" }
        for name, icon in pairs(symbols) do
        	local hl = "DiagnosticSign" .. name
        	vim.fn.sign_define(hl, { text = icon, numhl = hl, texthl = hl })
        end

        vim.diagnostic.config {
          float = { border = "rounded" },
        }
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

        require("scrollbar").setup({
          handlers = {
            cursor = true,
            handle = false,
            diagnostic = true,
            gitsigns = true,
          },
          excluded_filetypes = {
            "NvimTree",
            "starter",
          },
          marks = {
            Cursor = { text = "█" },
            Error = { text = { symbols.Error } },
            Warn = { text = { symbols.Warn } },
            Info = { text = { symbols.Info } },
            Hint = { text = { symbols.Hint } },
          },
        })

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
        require("lsp-endhints").enable()

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

        vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
          pattern = { "/home/qti3e/Code/Deno/*" },
          callback = use_deno_tabsz,
        });
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
          nvim-scrollbar
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

          # https://github.com/andreasvc/vim-256noir
          (pkgs.vimUtils.buildVimPlugin {
            name = "256noir";
            src = pkgs.fetchFromGitHub {
              owner = "andreasvc";
              repo = "vim-256noir";
              rev = "e8668a18a4a90272c1cae87e655f8bddc5ac3665";
              hash = "sha256-HeS5nSnPk95YBaBEGIcEf6dfqQ3NvHHW0+u14tIZ9s4=";
            };
          })

          # https://github.com/chrisgrieser/nvim-lsp-endhints?tab=readme-ov-file
          (pkgs.vimUtils.buildVimPlugin {
            name = "lsp-endhints";
            src = pkgs.fetchFromGitHub {
              owner = "chrisgrieser";
              repo = "nvim-lsp-endhints";
              rev = "391ef40521b631a8a2fb7aef78db6967ead6b39d";
              hash = "sha256-dCySjZoCxcCkt8D1UVJF9wQheU8vgmDxkI0JeGURpnQ=";
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
        ];

      plugins = {
        wakatime.enable = true;
        neoscroll.enable = true;
        gitlinker.enable = true;
        web-devicons.enable = true;
        lsp-format.enable = true;
        treesitter.enable = true;
        lsp-lines.enable = true;
        nvim-autopairs.enable = true;
        nvim-colorizer.enable = true;
        commentary.enable = true;

        telescope = {
          enable = true;
          extensions.file-browser = {
            enable = true;
            settings = {
              hijack_netrw = true;
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
          inlayHints = true;
          servers = {
            nil_ls = {
              enable = true;
              settings.formatting.command = [ "${pkgs.nixfmt-rfc-style}/bin/nixfmt" ];
            };
            lua_ls.enable = true;
            denols.enable = true;
            clangd.enable = true;
            zls.enable = true;
            gopls.enable = true;
          };
        };

        rustaceanvim = {
          enable = true;
          settings = {
            tools.hover_actions.replace_builtin_hover = true;
            server.default_settings.rust_analyzer.check.command = "clippy";
            server.on_attach = "__lspOnAttach";
          };
        };

        fidget = {
          enable = true;
          integration = {
            nvim-tree = {
              enable = true;
            };
          };
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
            current_line_blame = true;
            current_line_blame_opts.delay = 0;
          };
        };

        cmp-nvim-lsp.enable = true;
        cmp-path.enable = true;
        cmp-buffer.enable = true;
        cmp-git.enable = true;
        cmp = {
          enable = true;
          autoEnableSources = false;
          settings = {
            sources = [
              { name = "nvim_lsp"; }
              { name = "path"; }
              { name = "buffer"; }
              { name = "git"; }
              { name = "crates"; }
            ];
            view = {
              entries = {
                name = "custom";
                selection_order = "near_cursor";
              };
            };
            formatting.__raw = ''
              {
                fields = { "kind", "abbr", "menu" },
                format = function(_, vim_item)
                  local icons = {
                    Text = '  ',
                    Method = '  ',
                    Function = '  ',
                    Constructor = '  ',
                    Field = '  ',
                    Variable = '  ',
                    Class = '  ',
                    Interface = '  ',
                    Module = '  ',
                    Property = '  ',
                    Unit = '  ',
                    Value = '  ',
                    Enum = '  ',
                    Keyword = '  ',
                    Snippet = '  ',
                    Color = '  ',
                    File = '  ',
                    Reference = '  ',
                    Folder = '  ',
                    EnumMember = '  ',
                    Constant = '  ',
                    Struct = '  ',
                    Event = '  ',
                    Operator = '  ',
                    TypeParameter = '  ',
                  }
                  local kind = vim_item.kind
                  vim_item.kind = (icons[kind] or "")
                  vim_item.menu = "   " .. (kind or "")
                  return vim_item
                end,
              }
            '';
            mapping = {
              "<C-Space>" = "cmp.mapping.complete()";
              "<C-d>" = "cmp.mapping.scroll_docs(-4)";
              "<C-e>" = "cmp.mapping.close()";
              "<C-f>" = "cmp.mapping.scroll_docs(4)";
              "<CR>" = "cmp.mapping.confirm({ select = true })";
              "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
              "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
            };
            snippet = {
              expand = ''
                function(args)
                  vim.snippet.expand(args.body)
                end
              '';
            };
            window.__raw = ''
              {
                completion = cmp.config.window.bordered(),
                documentation = cmp.config.window.bordered(),
              }
            '';
          };
        };

        lualine = {
          enable = true;
          settings = {
            globalstatus = true;
            componentSeparators = {
              left = "|";
              right = "|";
            };
            sectionSeparators = {
              left = "";
              right = "";
            };
            sections = {
              lualine_a = [
                {
                  name = "mode";
                  separator = {
                    left = "";
                  };
                  padding = {
                    left = 1;
                    right = 2;
                  };
                }
              ];
              lualine_b = [ "branch" ];
              lualine_c = [
                {
                  name = "filename";
                  path = 1;
                }
              ];
              lualine_x = [ "progress" ];
              lualine_y = [ "filetype" ];
              lualine_z = [
                {
                  name = "location";
                  separator = {
                    right = "";
                  };
                  padding = {
                    left = 2;
                    right = 1;
                  };
                }
              ];
            };
          };
        };

        mini = {
          enable = true;
          modules = {
            diff = { };
            bracketed = { };
          };
        };
      };

      colorschemes.nightfox = {
        enable = true;
      };
    };
  };
}
