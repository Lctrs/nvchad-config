local ok, null_ls = pcall(require, "null-ls")
local u = require "null-ls.utils"

if not ok then
   return
end

local b = null_ls.builtins

local sources = {

   -- Docker
   b.diagnostics.hadolint,

   -- JS html css stuff
   b.formatting.prettierd.with {
      filetypes = { "html", "json", "markdown", "scss", "css", "javascript", "yaml" },
   },

   -- PHP
   b.formatting.phpcbf.with {
      command = "vendor/bin/phpcbf",
      args = { "-" },
      condition = function(utils)
         return utils.root_has_file "vendor/bin/phpcbf"
            or utils.root_has_file "phpcs.xml"
            or utils.root_has_file "phpcs.xml.dist"
      end,
   },
   b.formatting.phpcsfixer.with {
      command = "vendor/bin/php-cs-fixer",
      condition = function(utils)
         return utils.root_has_file "vendor/bin/php-cs-fixer"
            or utils.root_has_file ".php_cs"
            or utils.root_has_file ".php_cs.dist"
            or utils.root_has_file ".php-cs-fixer.php"
            or utils.root_has_file ".php-cs-fixer.dist.php"
      end,
   },
   b.diagnostics.phpstan.with {
      command = function()
         local utils = u.make_conditional_utils()

         if utils.root_has_file "vendor/bin/phpstan" then
            return "vendor/bin/phpstan"
         end

         return "bin/phpstan"
      end,
      extra_args = { "--memory-limit=-1" },
      condition = function(utils)
         return utils.root_has_file "vendor/bin/phpstan"
            or utils.root_has_file "bin/phpstan"
            or utils.root_has_file "phpstan.neon"
            or utils.root_has_file "phpstan.neon.dist"
      end,
   },
   b.diagnostics.psalm.with {
      command = "vendor/bin/psalm",
      extra_args = { "--threads=4" },
      condition = function(utils)
         return utils.root_has_file "vendor/bin/psalm"
            or utils.root_has_file "psalm.xml"
            or utils.root_has_file "psalm.xml.dist"
      end,
   },

   -- Python
   b.formatting.black,
   b.diagnostics.flake8,

   -- Rust
   b.formatting.rustfmt,

   -- Lua
   b.formatting.stylua,

   -- Shell
   b.formatting.shfmt,
   b.diagnostics.shellcheck,
}

local M = {}
M.setup = function(on_attach)
   null_ls.setup {
      debug = true,
      sources = sources,

      -- format on save
      on_attach = function(client)
         if client.resolved_capabilities.document_formatting then
            vim.cmd "autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()"
         end
      end,
   }
end

return M
