-- AI assistant: CodeCompanion
--
-- LAZY STRATEGY:
-- - codecompanion: YES (cmd/keys) - AI features only when invoked
--
-- INTEGRATIONS:
-- - nvim-cmp: Completion source for editor context, slash commands, tools
-- - telescope: Action palette provider (optional)
-- - treesitter: Required for markdown prompts in prompt library
-- - plenary: Required dependency
--
-- PROVIDERS (free options):
-- - ollama: Local models (requires ollama installed)
-- - copilot: If you have GitHub Copilot subscription (reuses auth)

return {
    ----- CodeCompanion {{{-----------------------------------------------------------------------------------------
    {
        "olimorris/codecompanion.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
        cmd = {
            "CodeCompanion",
            "CodeCompanionChat",
            "CodeCompanionActions",
            "CodeCompanionCmd",
        },
        keys = {
            { "<C-a>", "<cmd>CodeCompanionActions<cr>", mode = { "n", "v" }, desc = "CodeCompanion Actions" },
            { "<leader>a", "<cmd>CodeCompanionChat Toggle<cr>", mode = { "n", "v" }, desc = "Toggle CodeCompanion Chat" },
            { "ga", "<cmd>CodeCompanionChat Add<cr>", mode = "v", desc = "Add selection to CodeCompanion" },
        },
        config = function()
            require("codecompanion").setup({
                ----- Interactions {{{----------------------------------------------------------------------------------
                -- Configure which adapter to use for each interaction type
                interactions = {
                    -- Chat buffer interaction
                    chat = {
                        adapter = "ollama",  -- Change to your preferred adapter
                        -- Or specify adapter with model:
                        -- adapter = {
                        --     name = "ollama",
                        --     model = "llama3.2",
                        -- },
                    },
                    -- Inline code interaction
                    inline = {
                        adapter = "ollama",
                    },
                    -- Command generation
                    cmd = {
                        adapter = "ollama",
                    },
                },
                --}}}---------------------------------------------------------------------------------------------------

                ----- Adapters {{{--------------------------------------------------------------------------------------
                adapters = {
                    -- Ollama (local, free)
                    -- Requires: ollama installed and running (https://ollama.ai)
                    -- Run: ollama pull llama3.2 (or your preferred model)
                    ollama = function()
                        return require("codecompanion.adapters").extend("ollama", {
                            schema = {
                                model = {
                                    default = "llama3.2",
                                },
                            },
                        })
                    end,

                    -- Anthropic (requires ANTHROPIC_API_KEY env var)
                    -- anthropic = function()
                    --     return require("codecompanion.adapters").extend("anthropic", {
                    --         schema = {
                    --             model = {
                    --                 default = "claude-sonnet-4-20250514",
                    --             },
                    --         },
                    --     })
                    -- end,

                    -- OpenAI (requires OPENAI_API_KEY env var)
                    -- openai = function()
                    --     return require("codecompanion.adapters").extend("openai", {
                    --         schema = {
                    --             model = {
                    --                 default = "gpt-4o",
                    --             },
                    --         },
                    --     })
                    -- end,
                },
                --}}}---------------------------------------------------------------------------------------------------

                ----- Display {{{---------------------------------------------------------------------------------------
                display = {
                    action_palette = {
                        provider = "telescope",  -- Uses your existing telescope setup
                        -- provider = "default",  -- Use vim.ui.select instead
                    },
                    chat = {
                        -- Show token count in chat buffer
                        show_token_count = true,
                        -- Render markdown in chat (integrates with render-markdown.nvim if installed)
                        render_headers = true,
                    },
                    diff = {
                        provider = "default",
                    },
                },
                --}}}---------------------------------------------------------------------------------------------------

                ----- Strategies {{{------------------------------------------------------------------------------------
                strategies = {
                    chat = {
                        roles = {
                            llm = function(adapter)
                                return "  " .. adapter.formatted_name
                            end,
                            user = "  User",
                        },
                        keymaps = {
                            send = {
                                modes = { n = "<CR>", i = "<C-s>" },
                            },
                            close = {
                                modes = { n = "q", i = "<C-c>" },
                            },
                        },
                    },
                    inline = {
                        keymaps = {
                            accept_change = {
                                modes = { n = "ga" },
                                description = "Accept the suggested change",
                            },
                            reject_change = {
                                modes = { n = "gr" },
                                description = "Reject the suggested change",
                            },
                        },
                    },
                },
                --}}}---------------------------------------------------------------------------------------------------

                ----- Options {{{---------------------------------------------------------------------------------------
                opts = {
                    -- Set to "DEBUG" or "TRACE" for troubleshooting
                    log_level = "ERROR",
                },
                --}}}---------------------------------------------------------------------------------------------------
            })

            -- Expand 'cc' into 'CodeCompanion' in the command line
            vim.cmd([[cab cc CodeCompanion]])
        end,
    },
    --}}}-----------------------------------------------------------------------------------------------------------
}
