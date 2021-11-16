local M = {}

M.setup_lsp = function(attach, capabilities)
   local lsp_installer = require "nvim-lsp-installer"
   local List = require "plenary.collections.py_list"

   lsp_installer.on_server_ready(function(server)
      local opts = {
         on_attach = attach,
         capabilities = capabilities,
         flags = {
            debounce_text_changes = 150,
         },
         settings = {},
      }

      if server.name == "rust_analyzer" then
         opts.settings = {
            ["rust-analyzer"] = {
               experimental = {
                  procAttrMacros = true,
               },
            },
         }
      end

      if List({ "phpactor", "rust_analyzer" }):contains(server.name) then
         opts.on_attach = function(client, bufnr)
            local function buf_set_keymap(...)
               vim.api.nvim_buf_set_keymap(...)
            end

            -- Run nvchad's attach
            attach(client, bufnr)

            -- Use nvim-code-action-menu for code actions
            buf_set_keymap(bufnr, "n", "<leader>ca", "lua vim.lsp.buf.range_code_action()<CR>", { noremap = true, silent = true })
            buf_set_keymap(bufnr, "v", "<leader>ca", "lua vim.lsp.buf.range_code_action()<CR>", { noremap = true, silent = true })
         end
      end

      server:setup(opts)
      vim.cmd [[ do User LspAttachBuffers ]]
   end)
end

return M
