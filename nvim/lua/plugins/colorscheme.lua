return {
  {
    "navarasu/onedark.nvim",
    config = function()
      require("onedark").setup({
        style = "cool", -- или 'dark', 'cool', 'deep', 'warm', 'warmer'
      })
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "onedark",
    },
  },
}
