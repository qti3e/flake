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
        foldenable = false;
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
          key = "<C-b>g";
          action = "<cmd>BufferLinePick<CR>";
          mode = [ "n" ];
          options.desc = "BufferLine Pick";
        }
        {
          key = "<C-b>p";
          action = "<cmd>BufferLineTogglePin<CR>";
          mode = [ "n" ];
          options.desc = "BufferLine Toggle Pin";
        }

        {
          key = "<C-b>mh";
          action = "<cmd>BufferLineMovePrev<CR>";
          mode = [ "n" ];
          options.desc = "BufferLine Move Prev";
        }
        {
          key = "<C-b>ml";
          action = "<cmd>BufferLineMoveNext<CR>";
          mode = [ "n" ];
          options.desc = "BufferLine Move Next";
        }

        # Go to previous/next
        {
          key = "<C-b>h";
          action = "<cmd>BufferLineCyclePrev<CR>";
          mode = [ "n" ];
          options.desc = "BufferLine Cycle Prev";
        }
        {
          key = "<C-b>l";
          action = "<cmd>BufferLineCycleNext<CR>";
          mode = [ "n" ];
          options.desc = "BufferLine Cycle Next";
        }

        # Go to buffer by position
        {
          key = "<C-b>1";
          action = "<cmd>BufferLineGoToBuffer 1<CR>";
          mode = [ "n" ];
          options.desc = "BufferLine Goto 1";
        }
        {
          key = "<C-b>2";
          action = "<cmd>BufferLineGoToBuffer 2<CR>";
          mode = [ "n" ];
          options.desc = "BufferLine Goto 2";
        }
        {
          key = "<C-b>3";
          action = "<cmd>BufferLineGoToBuffer 3<CR>";
          mode = [ "n" ];
          options.desc = "BufferLine Goto 3";
        }
        {
          key = "<C-b>4";
          action = "<cmd>BufferLineGoToBuffer 4<CR>";
          mode = [ "n" ];
          options.desc = "BufferLine Goto 4";
        }
        {
          key = "<C-b>5";
          action = "<cmd>BufferLineGoToBuffer 5<CR>";
          mode = [ "n" ];
          options.desc = "BufferLine Goto 5";
        }
        {
          key = "<C-b>6";
          action = "<cmd>BufferLineGoToBuffer 6<CR>";
          mode = [ "n" ];
          options.desc = "BufferLine Goto 6";
        }
        {
          key = "<C-b>7";
          action = "<cmd>BufferLineGoToBuffer 7<CR>";
          mode = [ "n" ];
          options.desc = "BufferLine Goto 7";
        }
        {
          key = "<C-b>8";
          action = "<cmd>BufferLineGoToBuffer 8<CR>";
          mode = [ "n" ];
          options.desc = "BufferLine Goto 8";
        }
        {
          key = "<C-b>9";
          action = "<cmd>BufferLineGoToBuffer 9<CR>";
          mode = [ "n" ];
          options.desc = "BufferLine Goto 9";
        }

        # To close buffers:
        {
          key = "<C-b>qa";
          action = "<cmd>BufferLineCloseOthers<CR>";
          mode = [ "n" ];
          options.desc = "BufferLine Close Others";
        }
        {
          key = "<C-b>qh";
          action = "<cmd>BufferLineCloseLeft<CR>";
          mode = [ "n" ];
          options.desc = "BufferLine Close Left";
        }
        {
          key = "<C-b>ql";
          action = "<cmd>BufferLineCloseRight<CR>";
          mode = [ "n" ];
          options.desc = "BufferLine Close Right";
        }

        {
          # Toggle nvim tree
          key = "t";
          action = "<cmd>NvimTreeToggle<CR>";
          mode = [ "n" ];
          options.desc = "Toggle file tree";
        }
        {
          # Toggle trouble window with all current lsp errors
          key = "T";
          action = "<cmd>Trouble diagnostics toggle<CR>";
          mode = [ "n" ];
          options.desc = "Toggle diagnostics";
        }
        {
          # Show hover actions
          key = "K";
          action.__raw = "vim.lsp.buf.hover";
          mode = [ "n" ];
          options.desc = "Show hover actions";
        }
        {
          # Toggle git diff overlay
          key = "go";
          action.__raw = "MiniDiff.toggle_overlay";
          mode = [ "n" ];
          options.desc = "Toggle git diff overlay";
        }
        {
          # Jump definition
          key = "gd";
          action.__raw = "vim.lsp.buf.definition";
          mode = [ "n" ];
          options.desc = "Jump definition";
        }
        {
          # Jump declaration
          key = "gD";
          action.__raw = "vim.lsp.buf.declaration";
          mode = [ "n" ];
          options.desc = "Jump declaration";
        }
        {
          # Jump implementation
          key = "gi";
          action.__raw = "vim.lsp.buf.implementation";
          mode = [ "n" ];
          options.desc = "Jump implementation";
        }
        {
          # References
          key = "gr";
          action.__raw = "vim.lsp.buf.references";
          mode = [ "n" ];
          options.desc = "Show References";
        }
        {
          # Next diagnostic
          key = "gn";
          action.__raw = "vim.diagnostic.goto_next";
          mode = [ "n" ];
          options.desc = "Next diagnostic";
        }
        {
          # Previous diagnostic
          key = "gN";
          action.__raw = "vim.diagnostic.goto_prev";
          mode = [ "n" ];
          options.desc = "Prev diagnostic";
        }
        {
          # Rename
          key = "<leader>r";
          action.__raw = "vim.lsp.buf.rename";
          mode = [ "n" ];
          options.desc = "Lsp Symbol Rename";
        }
        {
          # Format
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
          # Show buffers
          key = "gb";
          action = "<Esc>:Telescope buffers<CR>";
          mode = [ "n" ];
          options.desc = "Show buffers";
        }
        {
          # Show files
          key = "gf";
          action = "<Esc>:Telescope find_files<CR>";
          mode = [ "n" ];
          options.desc = "Show files";
        }
        {
          # Show symbols
          key = "gs";
          action = "<Esc>:Telescope lsp_dynamic_workspace_symbols<CR>";
          mode = [ "n" ];
          options.desc = "Show workplace symbols";
        }
        {
          # Show document symbols
          key = "gS";
          action = "<Esc>:Telescope lsp_document_symbols<CR>";
          mode = [ "n" ];
          options.desc = "Show document symbols";
        }
        {
          # Show code actions
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
          # Ctrl-S save and escape
          key = "<C-s>";
          action = "<Esc>:w!<CR>";
          mode = [
            "n"
            "v"
            "i"
          ];
          options.desc = "Save";
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
        vim.wo.relativenumber = true

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
      '';

      # Use experimental lua loader with jit cache
      luaLoader.enable = true;
      performance.combinePlugins.enable = true;

      extraPlugins =
        with pkgs.vimPlugins;
        [
          flatten-nvim
          nvim-scrollbar
          actions-preview-nvim
          vimsence
          nvim-treesitter-parsers.tlaplus
        ]
        ++ [
          # https://github.com/karoliskoncevicius/distilled-vim
          (pkgs.vimUtils.buildVimPlugin {
            name = "distilled-vim";
            src = pkgs.fetchFromGitHub {
              owner = "karoliskoncevicius";
              repo = "distilled-vim";
              rev = "a3d366af10b3ac477af2c9225c57ec630b416381";
              hash = "sha256-TzzKYSRUfalysp+yXbWw8JZ/A5ErcwVqCAaCsGhlXaA=";
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
              min_pattern_length = 0;
              rainbow.enabled = false;
            };
          };
        };

        wakatime = {
          enable = true;
        };

        neoscroll = {
          enable = true;
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

        web-devicons.enable = true;

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

        lsp-format.enable = true;
        treesitter.enable = true;
        trouble = {
          enable = true;
          settings.auto_close = true;
        };
        lsp-lines.enable = true;
        gitsigns = {
          enable = true;
          settings = {
            signcolumn = false;
            current_line_blame = true;
            current_line_blame_opts.delay = 0;
          };
        };
        nvim-colorizer.enable = true;
        nvim-autopairs.enable = true;
        commentary.enable = true;

        cmp-nvim-lsp.enable = true;
        cmp-path.enable = true;
        cmp-buffer.enable = true;
        cmp-git.enable = true;
        crates-nvim.enable = true;
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

        telescope.enable = true;

        nvim-tree = {
          enable = true;
          renderer.addTrailing = true;
          renderer.highlightOpenedFiles = "all";
          updateFocusedFile = {
            enable = false;
            updateRoot = true;
          };
          diagnostics = {
            enable = true;
            showOnDirs = true;
            icons = {
              hint = {
                __raw = "symbols.Hint";
              };
              info = {
                __raw = "symbols.Info";
              };
              warning = {
                __raw = "symbols.Warn";
              };
              error = {
                __raw = "symbols.Error";
              };
            };
          };
        };

        bufferline = {
          enable = true;
          settings.options = {
            separatorStyle = "thin";
            offsets = [
              {
                filetype = "NvimTree";
                text = "__ Tree __";
                separator = "│";
              }
            ];
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
            starter = {
              evaluate_single = true;
              header.__raw = ''
                function()
                  local hour = tonumber(vim.fn.strftime('%H'))
                  local part_id = math.floor((hour + 4) / 8) + 1
                  local day_part = ({ 'evening', 'morning', 'afternoon', 'evening' })[part_id]
                  local username = vim.loop.os_get_passwd()['username'] or 'USERNAME'
                  return ([[
                       ▄▄▄▄▄▄▄▄▄▄▄  ▄         ▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄
                      ▐░░░░░░░░░░░▌▐░▌       ▐░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌
                      ▐░█▀▀▀▀▀▀▀█░▌▐░▌       ▐░▌▐░█▀▀▀▀▀▀▀▀▀  ▀▀▀▀█░█▀▀▀▀
                      ▐░▌       ▐░▌▐░▌       ▐░▌▐░▌               ▐░▌
                      ▐░█▄▄▄▄▄▄▄█░▌▐░▌       ▐░▌▐░█▄▄▄▄▄▄▄▄▄      ▐░▌
                      ▐░░░░░░░░░░░▌▐░▌       ▐░▌▐░░░░░░░░░░░▌     ▐░▌
                      ▐░█▀▀▀▀█░█▀▀ ▐░▌       ▐░▌ ▀▀▀▀▀▀▀▀▀█░▌     ▐░▌
                      ▐░▌     ▐░▌  ▐░▌       ▐░▌          ▐░▌     ▐░▌
                      ▐░▌      ▐░▌ ▐░█▄▄▄▄▄▄▄█░▌ ▄▄▄▄▄▄▄▄▄█░▌     ▐░▌
                      ▐░▌       ▐░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌     ▐░▌
                       ▀         ▀  ▀▀▀▀▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀▀▀▀▀       ▀

                                           ▄▄       ▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄
                                          ▐░░▌     ▐░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌
                                          ▐░▌░▌   ▐░▐░▌▐░█▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀▀▀
                                          ▐░▌▐░▌ ▐░▌▐░▌▐░▌       ▐░▌▐░▌       ▐░▌▐░▌
                                          ▐░▌ ▐░▐░▌ ▐░▌▐░▌       ▐░▌▐░█▄▄▄▄▄▄▄█░▌▐░█▄▄▄▄▄▄▄▄▄
                                          ▐░▌  ▐░▌  ▐░▌▐░▌       ▐░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌
                                          ▐░▌   ▀   ▐░▌▐░▌       ▐░▌▐░█▀▀▀▀█░█▀▀ ▐░█▀▀▀▀▀▀▀▀▀
                                          ▐░▌       ▐░▌▐░▌       ▐░▌▐░▌     ▐░▌  ▐░▌
                                          ▐░▌       ▐░▌▐░█▄▄▄▄▄▄▄█░▌▐░▌      ▐░▌ ▐░█▄▄▄▄▄▄▄▄▄
                                          ▐░▌       ▐░▌▐░░░░░░░░░░░▌▐░▌       ▐░▌▐░░░░░░░░░░░▌
                                           ▀         ▀  ▀▀▀▀▀▀▀▀▀▀▀  ▀         ▀  ▀▀▀▀▀▀▀▀▀▀▀




                ~ Good %s, %s]]):format(day_part, username)
                end
              '';
              items.__raw = ''
                {
                  require("mini.starter").sections.recent_files(9, true),
                  { name = 'New',  action = 'enew',           section = 'Editor actions' },
                  { name = 'Tree', action = 'NvimTreeToggle', section = 'Editor actions' },
                  { name = 'Quit', action = 'qall',           section = 'Editor actions' },
                }
              '';

              content_hooks.__raw = ''
                (function()
                  local starter = require('mini.starter')
                  return {
                    starter.gen_hook.adding_bullet(),
                    starter.gen_hook.indexing("all", { "Editor actions" }),
                    starter.gen_hook.padding(2, 1),
                  }
                end)()
              '';
            };
          };
        };
      };

      highlight = {
        # Highlight and remove extra white spaces
        ExtraWhitespace.bg = "#fa4d56";

        # Mini.diff color fixes
        MiniDiffSignAdd.fg = "#42be65";
        MiniDiffSignChange.fg = "#fddc69";
        MiniDiffSignDelete.fg = "#fa4d56";
        MiniDiffOverAdd.bg = "#044317";
        MiniDiffOverChange.bg = "#8e6a00";
        MiniDiffOverDelete.bg = "#750e13";
        MiniDiffOverContext.bg = "#262626";
      };
      match.ExtraWhitespace = "\\s\\+$";

      # colorscheme = "256_noir";

      colorschemes.catppuccin = {
        enable = true;
        settings = {
          transparent_background = true;
          color_overrides.all = {
            rosewater = "#ffd7d9";
            flamingo = "#ffb3b8";
            pink = "#ff7eb6";
            mauve = "#d4bbff";
            red = "#fa4d56";
            maroon = "#ff8389";
            peach = "#ff832b";
            yellow = "#fddc69";
            green = "#42be65";
            teal = "#3ddbd9";
            sky = "#82cfff";
            sapphire = "#78a9ff";
            blue = "#4589ff";
            lavender = "#be95ff";
            text = "#f4f4f4";
            subtext1 = "#e0e0e0";
            subtext0 = "#c6c6c6";
            overlay2 = "#a8a8a8";
            overlay1 = "#8d8d8d";
            overlay0 = "#6f6f6f";
            surface2 = "#525252";
            surface1 = "#393939";
            surface0 = "#262626";
            base = "#161616";
            mantle = "#0b0b0b";
            crust = "#000000";
          };
          show_end_of_buffer = false;
          integrations = {
            NormalNvim = true;
            mini.enabled = true;
            nvimtree = true;
            lsp_trouble = true;
            symbols_outline = true;
            treesitter = true;
            gitsigns = true;
            fidget = true;
            cmp = true;
          };
        };
      };
    };
  };
}
