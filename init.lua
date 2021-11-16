vim.g.did_load_filetypes = 1

-- This is where your custom modules and plugins go.
-- See the wiki for a guide on how to extend NvChad

local hooks = require "core.hooks"

-- NOTE: To use this, make a copy with `cp example_init.lua init.lua`

--------------------------------------------------------------------

-- To modify packaged plugin configs, use the overrides functionality
-- if the override does not exist in the plugin config, make or request a PR,
-- or you can override the whole plugin config with 'chadrc' -> M.plugins.default_plugin_config_replace{}
-- this will run your config instead of the NvChad config for the given plugin

-- hooks.override("lsp", "publish_diagnostics", function(current)
--   current.virtual_text = false;
--   return current;
-- end)

-- To add new mappings, use the "setup_mappings" hook,
-- you can set one or many mappings
-- example below:

-- hooks.add("setup_mappings", function(map)
--    map("n", "<leader>cc", "gg0vG$d", opt) -- example to delete the buffer
--    .... many more mappings ....
-- end)

-- To add new plugins, use the "install_plugin" hook,
-- NOTE: we heavily suggest using Packer's lazy loading (with the 'event' field)
-- see: https://github.com/wbthomason/packer.nvim
-- examples below:

-- hooks.add("install_plugins", function(use)
--    use {
--       "max397574/better-escape.nvim",
--       event = "InsertEnter",
--    }
-- end)

hooks.add("install_plugins", function(use)
   use {
      "windwp/nvim-ts-autotag",
      after = "nvim-treesitter",
      -- event = "InsertEnter",
      config = function()
         require("nvim-ts-autotag").setup()
      end,
   }

   use {
      "williamboman/nvim-lsp-installer",
      config = function()
         local lsp_installer = require "nvim-lsp-installer"

         lsp_installer.on_server_ready(function(server)
            local opts = {}

            server:setup(opts)
            vim.cmd [[ do User LspAttachBuffers ]]
         end)
      end,
   }

   use {
      "jose-elias-alvarez/null-ls.nvim",
      after = "nvim-lspconfig",
      config = function()
         require("custom.plugins.null-ls").setup()
      end,
   }

   use {
      "weilbith/nvim-code-action-menu",
      cmd = "CodeActionMenu",
   }

   use {
      "nvim-telescope/telescope-project.nvim",
      after = "telescope.nvim",
      module = "telescope",
      config = function()
         require("telescope").load_extension "project"
      end,
   }

   --   use {
   --      "kosayoda/nvim-lightbulb",
   --      event = { "CursorHold *", "CursorHoldI *" },
   --      config = function()
   --         vim.cmd [[
   --           autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb({
   --             \ sign = {
   --             \   enabled = false,
   --             \ },
   --             \ float = {
   --             \   enabled = true,
   --             \   winopts = {
   --             \     winblend = 60,
   --             \   }
   --             \ },
   --          \ })
   --        ]]
   --      end,
   --   }

   use "nathom/filetype.nvim"
end)

hooks.add("setup_mappings", function(map)
   map("n", "<C-p>", ":lua require'telescope'.extensions.project.project{}<CR>", { noremap = true, silent = true })
end)

-- alternatively, put this in a sub-folder like "lua/custom/plugins/mkdir"
-- then source it with

-- require "custom.plugins.mkdir"
