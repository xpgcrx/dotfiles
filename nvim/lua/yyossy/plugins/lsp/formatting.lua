return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local conform = require("conform")

    conform.setup({
      formatters_by_ft = {
        javascript = { "prettier" },
        typescript = { "prettier" },
        css = { "prettier" },
        html = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        lua = { "stylua" },
        python = { "ruff_format", "ruff_fix", "ruff_organize_imports" },
        xml = { "xmlformatter" },
      },
      format_on_save = function(bufnr)
        -- Disable autoformat on certain filetypes
        -- https://github.com/stevearc/conform.nvim/blob/master/doc/recipes.md#autoformat-with-extra-features
        local ignore_filetypes = {
          "java",
          "json",
          "yaml",
          "python",
          "typescript",
        }
        if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
          return
        end
        -- Disable with a global or buffer-local variable
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end
        -- Disable autoformat for files in a certain path
        local bufname = vim.api.nvim_buf_get_name(bufnr)
        if bufname:match("/node_modules/") then
          return
        end
        -- ...additional logic...
        return { timeout_ms = 500, lsp_format = "fallback" }
      end,
    })

    vim.keymap.set({ "n", "v" }, "<leader>mp", function()
      conform.format({
        lsp_fallback = true,
        async = false,
        timeout_ms = 1000,
      })
    end, { desc = "Format file or range (in visual mode)" })

    -- Toggle autoformat globally
    vim.keymap.set("n", "<leader>tf", function()
      vim.g.disable_autoformat = not vim.g.disable_autoformat
      local status = vim.g.disable_autoformat and "disabled" or "enabled"
      vim.notify("Autoformat " .. status, vim.log.levels.INFO)
    end, { desc = "Toggle autoformat globally" })

    -- Toggle autoformat for current buffer
    vim.keymap.set("n", "<leader>tF", function()
      vim.b.disable_autoformat = not vim.b.disable_autoformat
      local status = vim.b.disable_autoformat and "disabled" or "enabled"
      vim.notify("Autoformat " .. status .. " for current buffer", vim.log.levels.INFO)
    end, { desc = "Toggle autoformat for current buffer" })
  end,
}
