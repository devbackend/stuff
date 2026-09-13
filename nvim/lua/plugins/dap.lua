return {
  {
    "mfussenegger/nvim-dap",
    optional = true,
    config = function()
      local dap = require("dap")
      dap.adapters.go = {
        type = "server",
        port = "${port}",
        executable = {
          command = vim.fn.expand("~/go/bin/dlv"),
          args = { "dap", "-l", "127.0.0.1:${port}", "--log", "--log-output=dap" },
        },
      }
      dap.configurations.go = {
        {
          type = "go",
          name = "Debug package",
          request = "launch",
          program = "${fileDirname}",
        },
        {
          type = "go",
          name = "Debug test",
          request = "launch",
          mode = "test",
          program = "${fileDirname}",
        },
        {
          type = "go",
          name = "Attach remote",
          mode = "remote",
          request = "attach",
          port = 2345,
          host = "127.0.0.1",
        },
      }
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    optional = true,
    opts = {
      layouts = {
        {
          elements = {
            { id = "scopes", size = 0.4 },
            { id = "breakpoints", size = 0.2 },
            { id = "stacks", size = 0.2 },
            { id = "watches", size = 0.2 },
          },
          size = 40,
          position = "left",
        },
        {
          elements = {
            { id = "console", size = 0.7 },
            { id = "repl", size = 0.3 },
          },
          size = 15,
          position = "bottom",
        },
      },
    },
  },
}
