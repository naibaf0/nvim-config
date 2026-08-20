-- AI assistant: CodeCompanion
--
-- LAZY STRATEGY:
-- - codecompanion: YES (cmd/keys) - AI features only when invoked
--
-- INTEGRATIONS:
-- - nvim-cmp: Completion source for editor context, slash commands, tools
-- - telescope: Action palette provider
-- - treesitter: Required for markdown prompts in prompt library
-- - plenary: Required dependency
--
-- ADAPTERS:
-- - opencode (ACP): Default - requires opencode CLI installed and configured
-- - mistral: HTTP adapter - requires MISTRAL_API_KEY env var
-- - ollama: Local models - requires ollama installed and running

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
                interactions = {
                    -- Chat buffer interaction (uses ACP adapter)
                    chat = {
                        adapter = {
                            name = "opencode",
                            model = "",  -- TODO: Fill in your preferred model
                        },
                    },
                    -- Inline code interaction (uses HTTP adapter as fallback)
                    inline = {
                        adapter = "mistral",
                    },
                    -- Command generation
                    cmd = {
                        adapter = "mistral",
                    },
                },
                --}}}---------------------------------------------------------------------------------------------------

                ----- Adapters {{{--------------------------------------------------------------------------------------
                adapters = {
                    ----- ACP Adapters {{{------------------------------------------------------------------------------
                    -- OpenCode (ACP) - Default
                    -- Requires: opencode CLI installed and configured
                    -- Install: https://opencode.ai/docs/#install
                    -- Configure: https://opencode.ai/docs/#configure
                    -- Model can also be set in ~/.config/opencode/config.json
                    acp = {
                        opencode = function()
                            return require("codecompanion.adapters").extend("opencode", {
                                defaults = {
                                    session_config_options = {
                                        model = "",  -- TODO: Fill in your preferred model
                                    },
                                },
                            })
                        end,
                    },
                    --}}}-----------------------------------------------------------------------------------------------

                    ----- HTTP Adapters {{{-----------------------------------------------------------------------------
                    http = {
                        -- Mistral
                        -- Requires: MISTRAL_API_KEY env var
                        mistral = function()
                            return require("codecompanion.adapters").extend("mistral", {
                                schema = {
                                    model = {
                                        default = "mistral-large-latest",
                                    },
                                },
                            })
                        end,

                        -- Ollama (local)
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
                    },
                    --}}}-----------------------------------------------------------------------------------------------
                },
                --}}}---------------------------------------------------------------------------------------------------

                ----- Display {{{---------------------------------------------------------------------------------------
                display = {
                    action_palette = {
                        provider = "telescope",  -- Uses your existing telescope setup
                    },
                    chat = {
                        show_token_count = true,
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
