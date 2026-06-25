{
  inputs,
  pkgs,
}:

# Standalone neovim package
inputs.nixvim.legacyPackages.${pkgs.stdenv.hostPlatform.system}.makeNixvimWithModule {
  inherit pkgs;
  module = {
    config = {
      version.enableNixpkgsReleaseCheck = false;

      # ensure base neovim is used from pkgs
      package = pkgs.neovim;

      clipboard.providers.wl-copy.enable = true;

      opts = {
        exrc = true; # Load .nvim.lua from project directories
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

      diagnostic.settings = {
        severity_sort = true;
        float = {
          border = "rounded";
        };
        signs = {
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
        -- neoconf must be set up before lspconfig
        require("neoconf").setup()
      '';

      extraConfigLua = ''
        require('crates').setup({
          completion = {
            crates = {
              enabled = true,
              max_results = 8,
              min_chars = 3
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

        require("actions-preview").setup()
        require('lsp_lines').toggle()

        -- :Mono command to switch to monochrome theme
        vim.api.nvim_create_user_command('Mono', function()
          local hl = vim.api.nvim_set_hl
          -- Base UI
          hl(0, 'Normal', { fg = '#ffffff', bg = '#000000' })
          hl(0, 'NormalFloat', { fg = '#ffffff', bg = '#0a0a0a' })
          hl(0, 'FloatBorder', { fg = '#444444', bg = '#0a0a0a' })
          hl(0, 'CursorLine', { bg = '#111111' })
          hl(0, 'CursorLineNr', { fg = '#ffffff', bold = true })
          hl(0, 'LineNr', { fg = '#444444' })
          hl(0, 'Visual', { bg = '#333333' })
          hl(0, 'Search', { fg = '#000000', bg = '#ffffff' })
          hl(0, 'IncSearch', { fg = '#000000', bg = '#ffffff' })
          hl(0, 'Pmenu', { fg = '#ffffff', bg = '#111111' })
          hl(0, 'PmenuSel', { fg = '#000000', bg = '#ffffff' })
          hl(0, 'StatusLine', { fg = '#ffffff', bg = '#111111' })
          hl(0, 'StatusLineNC', { fg = '#666666', bg = '#0a0a0a' })
          hl(0, 'VertSplit', { fg = '#222222' })
          hl(0, 'SignColumn', { bg = '#000000' })
          -- Classic syntax groups
          hl(0, 'Comment', { fg = '#666666', italic = false })
          hl(0, 'Constant', { fg = '#ffffff' })
          hl(0, 'String', { fg = '#ffffff' })
          hl(0, 'Character', { fg = '#ffffff' })
          hl(0, 'Number', { fg = '#ffffff' })
          hl(0, 'Boolean', { fg = '#ffffff' })
          hl(0, 'Float', { fg = '#ffffff' })
          hl(0, 'Identifier', { fg = '#ffffff' })
          hl(0, 'Function', { fg = '#ffffff' })
          hl(0, 'Statement', { fg = '#ffffff' })
          hl(0, 'Conditional', { fg = '#ffffff' })
          hl(0, 'Repeat', { fg = '#ffffff' })
          hl(0, 'Label', { fg = '#ffffff' })
          hl(0, 'Operator', { fg = '#ffffff' })
          hl(0, 'Keyword', { fg = '#ffffff' })
          hl(0, 'Exception', { fg = '#ffffff' })
          hl(0, 'PreProc', { fg = '#ffffff' })
          hl(0, 'Include', { fg = '#ffffff' })
          hl(0, 'Define', { fg = '#ffffff' })
          hl(0, 'Macro', { fg = '#ffffff' })
          hl(0, 'PreCondit', { fg = '#ffffff' })
          hl(0, 'Type', { fg = '#ffffff' })
          hl(0, 'StorageClass', { fg = '#ffffff' })
          hl(0, 'Structure', { fg = '#ffffff' })
          hl(0, 'Typedef', { fg = '#ffffff' })
          hl(0, 'Special', { fg = '#ffffff' })
          hl(0, 'SpecialChar', { fg = '#ffffff' })
          hl(0, 'Tag', { fg = '#ffffff' })
          hl(0, 'Delimiter', { fg = '#ffffff' })
          hl(0, 'SpecialComment', { fg = '#666666' })
          hl(0, 'Debug', { fg = '#ffffff' })
          -- Treesitter groups
          hl(0, '@variable', { fg = '#ffffff' })
          hl(0, '@variable.builtin', { fg = '#ffffff' })
          hl(0, '@variable.parameter', { fg = '#ffffff' })
          hl(0, '@variable.member', { fg = '#ffffff' })
          hl(0, '@constant', { fg = '#ffffff' })
          hl(0, '@constant.builtin', { fg = '#ffffff' })
          hl(0, '@constant.macro', { fg = '#ffffff' })
          hl(0, '@module', { fg = '#ffffff' })
          hl(0, '@label', { fg = '#ffffff' })
          hl(0, '@string', { fg = '#ffffff' })
          hl(0, '@string.escape', { fg = '#ffffff' })
          hl(0, '@string.special', { fg = '#ffffff' })
          hl(0, '@character', { fg = '#ffffff' })
          hl(0, '@character.special', { fg = '#ffffff' })
          hl(0, '@boolean', { fg = '#ffffff' })
          hl(0, '@number', { fg = '#ffffff' })
          hl(0, '@number.float', { fg = '#ffffff' })
          hl(0, '@type', { fg = '#ffffff' })
          hl(0, '@type.builtin', { fg = '#ffffff' })
          hl(0, '@type.definition', { fg = '#ffffff' })
          hl(0, '@type.qualifier', { fg = '#ffffff' })
          hl(0, '@attribute', { fg = '#ffffff' })
          hl(0, '@property', { fg = '#ffffff' })
          hl(0, '@function', { fg = '#ffffff' })
          hl(0, '@function.builtin', { fg = '#ffffff' })
          hl(0, '@function.macro', { fg = '#ffffff' })
          hl(0, '@function.method', { fg = '#ffffff' })
          hl(0, '@constructor', { fg = '#ffffff' })
          hl(0, '@operator', { fg = '#ffffff' })
          hl(0, '@keyword', { fg = '#ffffff' })
          hl(0, '@keyword.function', { fg = '#ffffff' })
          hl(0, '@keyword.operator', { fg = '#ffffff' })
          hl(0, '@keyword.import', { fg = '#ffffff' })
          hl(0, '@keyword.storage', { fg = '#ffffff' })
          hl(0, '@keyword.repeat', { fg = '#ffffff' })
          hl(0, '@keyword.return', { fg = '#ffffff' })
          hl(0, '@keyword.debug', { fg = '#ffffff' })
          hl(0, '@keyword.exception', { fg = '#ffffff' })
          hl(0, '@keyword.conditional', { fg = '#ffffff' })
          hl(0, '@keyword.directive', { fg = '#ffffff' })
          hl(0, '@punctuation', { fg = '#ffffff' })
          hl(0, '@punctuation.delimiter', { fg = '#ffffff' })
          hl(0, '@punctuation.bracket', { fg = '#ffffff' })
          hl(0, '@punctuation.special', { fg = '#ffffff' })
          hl(0, '@comment', { fg = '#666666', italic = false })
          hl(0, '@tag', { fg = '#ffffff' })
          hl(0, '@tag.attribute', { fg = '#ffffff' })
          hl(0, '@tag.delimiter', { fg = '#ffffff' })
          -- Diagnostics
          hl(0, 'DiagnosticError', { fg = '#ff6666' })
          hl(0, 'DiagnosticWarn', { fg = '#ffcc66' })
          hl(0, 'DiagnosticInfo', { fg = '#6699ff' })
          hl(0, 'DiagnosticHint', { fg = '#666666' })
          -- Git signs
          hl(0, 'GitSignsAdd', { fg = '#666666' })
          hl(0, 'GitSignsChange', { fg = '#666666' })
          hl(0, 'GitSignsDelete', { fg = '#666666' })
          -- LSP
          hl(0, 'LspInlayHint', { fg = '#444444' })
          hl(0, '@lsp.type.class', { fg = '#ffffff' })
          hl(0, '@lsp.type.decorator', { fg = '#ffffff' })
          hl(0, '@lsp.type.enum', { fg = '#ffffff' })
          hl(0, '@lsp.type.enumMember', { fg = '#ffffff' })
          hl(0, '@lsp.type.function', { fg = '#ffffff' })
          hl(0, '@lsp.type.interface', { fg = '#ffffff' })
          hl(0, '@lsp.type.macro', { fg = '#ffffff' })
          hl(0, '@lsp.type.method', { fg = '#ffffff' })
          hl(0, '@lsp.type.namespace', { fg = '#ffffff' })
          hl(0, '@lsp.type.parameter', { fg = '#ffffff' })
          hl(0, '@lsp.type.property', { fg = '#ffffff' })
          hl(0, '@lsp.type.struct', { fg = '#ffffff' })
          hl(0, '@lsp.type.type', { fg = '#ffffff' })
          hl(0, '@lsp.type.typeParameter', { fg = '#ffffff' })
          hl(0, '@lsp.type.variable', { fg = '#ffffff' })
        end, {})

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

      # Default colorscheme
      colorschemes.catppuccin = {
        enable = true;
        settings = {
          flavour = "mocha";
          show_end_of_buffer = false;
          integrations = {
            mini.enabled = true;
            lsp_trouble = true;
            treesitter = true;
            gitsigns = true;
            fidget = true;
          };
        };
      };

      # Use experimental lua loader with jit cache
      luaLoader.enable = true;
      performance.combinePlugins.enable = true;
      performance.combinePlugins.standalonePlugins = [ ];
      match.ExtraWhitespace = "\\s\\+$";

      extraPlugins =
        with pkgs.vimPlugins;
        [
          # Additional colorschemes (switch with :colorscheme <name>)
          tokyonight-nvim
          gruvbox-nvim
          kanagawa-nvim
          rose-pine
          nord-nvim
          onedark-nvim
          nightfox-nvim
          everforest
          dracula-nvim

          # Utility plugins
          flatten-nvim
          actions-preview-nvim
          nvim-treesitter-parsers.tlaplus
          neoconf-nvim
        ]
        ++ [
          (pkgs.vimUtils.buildVimPlugin {
            name = "crates.nvim";
            doCheck = false; # null-ls module removed
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
        treesitter-textobjects = {
          enable = true;
          settings = {

            select = {
              enable = true;
              lookahead = true;
              keymaps = {
                "af" = "@function.outer";
                "if" = "@function.inner";
                "ac" = "@call.outer";
                "ic" = "@call.inner";
                "as" = "@statement.outer";
                "aa" = "@assignment.outer";
                "ia" = "@assignment.inner";
                "ab" = "@block.outer";
                "ib" = "@block.inner";
                "ai" = "@conditional.outer";
                "ii" = "@conditional.inner";
                "al" = "@loop.outer";
                "il" = "@loop.inner";
                "ap" = "@parameter.outer";
                "ip" = "@parameter.inner";
                "at" = "@class.outer";
                "it" = "@class.inner";
              };
            };
            swap = {
              enable = true;
              swapNext = {
                "Mf" = "@function.outer";
                "Mc" = "@call.outer";
                "Ms" = "@statement.outer";
                "Ma" = "@assignment.outer";
                "Mb" = "@block.outer";
                "Mi" = "@conditional.outer";
                "Ml" = "@loop.outer";
                "Mp" = "@parameter.inner";
                "Mt" = "@class.outer";
              };
              swapPrevious = {
                "MF" = "@function.outer";
                "MC" = "@call.outer";
                "MS" = "@statement.outer";
                "MA" = "@assignment.outer";
                "MB" = "@block.outer";
                "MI" = "@conditional.outer";
                "ML" = "@loop.outer";
                "MP" = "@parameter.inner";
                "MT" = "@class.outer";
              };
            };
            move = {
              enable = true;
              setJumps = true;
              gotoNextStart = {
                "]f" = "@function.outer";
                "]c" = "@call.outer";
                "]s" = "@statement.outer";
                "]a" = "@assignment.outer";
                "]b" = "@block.outer";
                "]i" = "@conditional.outer";
                "]l" = "@loop.outer";
                "]p" = "@parameter.inner";
                "]t" = "@class.outer";
              };
              gotoPreviousStart = {
                "[f" = "@function.outer";
                "[c" = "@call.outer";
                "[s" = "@statement.outer";
                "[a" = "@assignment.outer";
                "[b" = "@block.outer";
                "[i" = "@conditional.outer";
                "[l" = "@loop.outer";
                "[p" = "@parameter.inner";
                "[t" = "@class.outer";
              };
            };
          };
        };
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
            min_window_height = 0;
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
              settings.formatting.command = [ "${pkgs.nixfmt}/bin/nixfmt" ];
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
          settings = {
            progress = {
              display = {
                progress_icon = {
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
                x_padding = 2;
              };
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

    };
  };
}
