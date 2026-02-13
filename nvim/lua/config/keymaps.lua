-- Keymaps are automatically loaded on the VeryLazy event

-- Go: run current project
vim.keymap.set("n", "<leader>rr", function()
  vim.cmd("split | terminal go run .")
end, { desc = "Go: run project" })

-- Go: run current file
vim.keymap.set("n", "<leader>rf", function()
  vim.cmd("split | terminal go run " .. vim.fn.expand("%"))
end, { desc = "Go: run current file" })
