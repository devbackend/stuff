return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      gopls = {
        settings = {
          gopls = {
            codelenses = {
              generate = true,
              test = true,
              tidy = true,
            },
            hints = {
              assignVariableTypes = false,
              compositeLiteralFields = false,
              compositeLiteralTypes = false,
              constantValues = true,
              functionTypeParameters = true,
              parameterNames = true,
              rangeVariableTypes = false,
            },
            analyses = {
              nilness = true,
              unusedparams = true,
              unusedwrite = true,
              ST1000 = false,
            },
            usePlaceholders = true,
            completeUnimported = true,
            staticcheck = true,
            semanticTokens = true,
          },
        },
      },
    },
    setup = {
      gopls = function(_, opts)
        -- workaround for gopls not supporting semanticTokensProvider
        -- https://github.com/golang/go/issues/54531#issuecomment-1464982242
        Snacks.util.lsp.on({ name = "gopls" }, function(_, client)
          if not client.server_capabilities.semanticTokensProvider then
            local semantic = client.config.capabilities.textDocument.semanticTokens
            client.server_capabilities.semanticTokensProvider = {
              full = true,
              legend = {
                tokenTypes = semantic.tokenTypes,
                tokenModifiers = semantic.tokenModifiers,
              },
              range = true,
            }
          end
        end)
        -- end workaround
      end,
    },
  },
}
