local tu = require "utils.telescope"
local icons = require "utils.icons"
local actions = require("telescope.actions")
return {

  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      { "crispgm/telescope-heading.nvim" },
      {
        "jvgrootveld/telescope-zoxide",
      },
      {
          "ajeetdsouza/zoxide"
      },
      { "FabianWirth/search.nvim" },
			{ "nvim-telescope/telescope-dap.nvim" },
      { "debugloop/telescope-undo.nvim" },
			{ 'nvim-telescope/telescope-fzf-native.nvim', build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' },
      {
        "olimorris/persisted.nvim",
        event = "BufReadPre",     -- Ensure the plugin loads only when a buffer has been loaded
        opts = {
          autostart = true,       -- Automatically start the plugin on load?

          -- Function to determine if a session should be saved
          ---@type fun(): boolean
          should_save = function()
            return true
          end,

          save_dir = vim.fn.expand(vim.fn.stdpath "data" .. "/sessions/"),       -- Directory where session files are saved

          follow_cwd = true,                                                     -- Change the session file to match any change in the cwd?
          use_git_branch = false,                                                -- Include the git branch in the session file name?
          autoload = false,                                                      -- Automatically load the session for the cwd on Neovim startup?

          -- Function to run when `autoload = true` but there is no session to load
          ---@type fun(): any
          on_autoload_no_session = function() end,

          allowed_dirs = {},       -- Table of dirs that the plugin will start and autoload from
          ignored_dirs = {},       -- Table of dirs that are ignored for starting and autoloading

          telescope = {
            icons = {         -- icons displayed in the Telescope picker
              selected = " ",
              dir = "  ",
              branch = " ",
            },
          },
        },
      },
    },
    opts = function(_, conf)
      local t = require "telescope"
      local builtin = require "telescope.builtin"

      local map = vim.keymap.set
      map("n", "<leader>cvt", function()
        t.extensions.vstask.tasks()
      end, { desc = "VSCode Tasks List" })

      map("n", "<leader>cvi", function()
        t.extensions.vstask.inputs()
      end, { desc = "VSCode Inputs" })

      map("n", "<leader>cvj", function()
        t.extensions.vstask.jobs()
      end, { desc = "VSCode Jobs List" })

      map("n", "<leader>cvh", function()
        t.extensions.vstask.history()
      end, { desc = "VSCode History" })

      map("n", "<leader>cvc", function()
        t.extensions.vstask.close()
      end, { desc = "VSCode Close Runner" })

      map("n", "<leader>cvr", function()
        t.extensions.vstask.run()
      end, { desc = "VSCode Run" })
      conf.defaults.color_devicons = true
      conf.defaults.set_env = { ["COLORTERM"] = "truecolor" }
      conf.defaults.prompt_prefix = icons.ui.Telescope .. " "
      conf.defaults.election_caret = icons.ui.Forward .. " "

      conf.defaults.mappings.i = {
				["<C-n>"] = actions.move_selection_next,
				["<C-p>"] = actions.move_selection_previous,
				["<C-c>"] = actions.close,
				["<C-j>"] = actions.cycle_history_next,
				["<C-k>"] = actions.cycle_history_prev,
				["<C-q>"] = function(...)
					actions.smart_send_to_qflist(...)
					actions.open_qflist(...)
				end,
				["<CR>"] = actions.select_default,
        ["<Esc>"] = actions.close,
      }
      conf.defaults.mappings.n = {
				["<C-n>"] = actions.move_selection_next,
				["<C-p>"] = actions.move_selection_previous,
				["<C-q>"] = function(...)
					actions.smart_send_to_qflist(...)
					actions.open_qflist(...)
				end,
			}
      conf.defaults.pickers = {
        find_files = {
          hidden = true,
          find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
        },
        live_grep = {
          --@usage don't include the filename in the search results
          only_sort_text = true,
        },
        grep_string = {
          only_sort_text = true,
        },
        buffers = {
          initial_mode = "normal",
          mappings = {
            i = {
              ["<C-d>"] = actions.delete_buffer,
            },
            n = {
              ["dd"] = actions.delete_buffer,
            },
          },
        },
        planets = {
          show_pluto = true,
          show_moon = true,
        },
        git_files = {
          hidden = true,
          show_untracked = true,
        },
        colorscheme = {
          enable_preview = true,
        },
      }
      local z_utils = require("telescope._extensions.zoxide.utils")
      conf.defaults.extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "smart_case",
        },
        zoxide = {
          prompt_title = "[ Zoxide List ]",
    
          -- Zoxide list command with score
          list_command = "zoxide query -ls",
          mappings = {
            default = {
              action = function(selection)
                vim.cmd.edit(selection.path)
              end,
              after_action = function(selection)
                print("Directory changed to " .. selection.path)
              end,
            },
            ["<C-s>"] = { action = z_utils.create_basic_command("split") },
            ["<C-v>"] = { action = z_utils.create_basic_command("vsplit") },
            ["<C-e>"] = { action = z_utils.create_basic_command("edit") },
            ["<C-b>"] = {
              keepinsert = true,
              action = function(selection)
                builtin.file_browser({ cwd = selection.path })
              end,
            },
            ["<C-f>"] = {
              keepinsert = true,
              action = function(selection)
                builtin.find_files({ cwd = selection.path })
              end,
            },
            ["<C-t>"] = {
              action = function(selection)
                vim.cmd.tcd(selection.path)
              end,
            },
          },
        },
        heading = {
          treesitter = true,
        },
        neoclip = {},
        undo = {},
      }
      -- or
      -- table.insert(conf.defaults.mappings.i, your table)
      require("search").setup {
        initial_tab = 1,
        append_tabs = {
          {
            name = "All Files",
            tele_func = builtin.find_files,
            tele_opts = { no_ignore = true, hidden = true },
          },
        },
        collections = {
          -- Here the "git" collection is defined. It follows the same configuraton layout as tabs.
          git = {
            initial_tab = 1,         -- Git branches
            tabs = {
              { name = "Branches", tele_func = builtin.git_branches },
              { name = "Commits",  tele_func = builtin.git_commits },
              { name = "Stashes",  tele_func = builtin.git_stash },
            },
          },
        },
      }

      tu.load_extension_after_telescope_is_loaded "dap"
      tu.load_extension_after_telescope_is_loaded "fzf"
      tu.load_extension_after_telescope_is_loaded "neoclip"
      tu.load_extension_after_telescope_is_loaded "vstask"
      tu.load_extension_after_telescope_is_loaded "undo"
      tu.load_extension_after_telescope_is_loaded "persisted"
      tu.load_extension_after_telescope_is_loaded "zoxide"
      require "configs.telescope"
      return conf
    end,
  },
  {
    "EthanJWright/vs-tasks.nvim",
    dependencies = {
      "nvim-lua/popup.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
  },
  {
    "AckslD/nvim-neoclip.lua",
    dependencies = {
      { "nvim-telescope/telescope.nvim" },
      { "kkharji/sqlite.lua",           module = "sqlite" },
    },
    config = function()
      require("neoclip").setup {
        history = 1000,
        enable_persistent_history = false,
        db_path = vim.fn.stdpath "data" .. "/databases/neoclip.sqlite3",
      }
    end,
  },
  {
    "rachartier/tiny-code-action.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-telescope/telescope.nvim" },
    },
    event = "LspAttach",
    config = function()
      require("tiny-code-action").setup {
        --- The backend to use, currently only "vim", "delta" and "difftastic" are supported
        backend = "vim",
        backend_opts = {
          delta = {
            -- Header from delta can be quite large.
            -- You can remove them by setting this to the number of lines to remove
            header_lines_to_remove = 4,

            -- The arguments to pass to delta
            -- If you have a custom configuration file, you can set the path to it like so:
            -- args = {
            --     "--config" .. os.getenv("HOME") .. "/.config/delta/config.yml",
            -- }
            args = {
              "--line-numbers",
            },
          },
          difftastic = {
            -- Header from delta can be quite large.
            -- You can remove them by setting this to the number of lines to remove
            header_lines_to_remove = 1,

            -- The arguments to pass to difftastic
            args = {
              "--color=always",
              "--display=inline",
              "--syntax-highlight=on",
            },
          },
        },
        telescope_opts = {
          layout_strategy = "vertical",
          layout_config = {
            width = 0.7,
            height = 0.9,
            preview_cutoff = 1,
            preview_height = function(_, _, max_lines)
              local h = math.floor(max_lines * 0.5)
              return math.max(h, 10)
            end,
          },
        },
        -- The icons to use for the code actions
        -- You can add your own icons, you just need to set the exact action's kind of the code action
        -- You can set the highlight like so: { link = "DiagnosticError" } or  like nvim_set_hl ({ fg ..., bg..., bold..., ...})
        signs = {
          quickfix = { "󰁨", { link = "DiagnosticInfo" } },
          others = { "?", { link = "DiagnosticWarning" } },
          refactor = { "", { link = "DiagnosticWarning" } },
          ["refactor.move"] = { "󰪹", { link = "DiagnosticInfo" } },
          ["refactor.extract"] = { "", { link = "DiagnosticError" } },
          ["source.organizeImports"] = { "", { link = "TelescopeResultVariable" } },
          ["source.fixAll"] = { "", { link = "TelescopeResultVariable" } },
          ["source"] = { "", { link = "DiagnosticError" } },
          ["rename"] = { "󰑕", { link = "DiagnosticWarning" } },
          ["codeAction"] = { "", { link = "DiagnosticError" } },
        },
      }
    end,
  },
}
