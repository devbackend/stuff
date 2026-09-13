return {
  "lewis6991/gitsigns.nvim",
  opts = {
    current_line_blame = false, -- выключен по умолчанию
    current_line_blame_opts = {
      virt_text = true,
      virt_text_pos = "eol",
      delay = 200,
    },
    current_line_blame_formatter = " <author>, <author_time:%y-%m-%d> • <summary>",
  },
  keys = {
    { "<leader>gb", ":Gitsigns toggle_current_line_blame<CR>", desc = "Toggle Git Blame" },
    { "<leader>gB", ":Gitsigns blame_line full=true<CR>", desc = "Git Blame Full" },
  },
}
