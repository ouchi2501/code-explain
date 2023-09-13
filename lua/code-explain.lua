local M = {}

function M.setup(config)
    require("code-explain.chat_gpt_summary").setup(config)
end

function M.print_summary()
    require("code-explain.chat_gpt_summary").print_summary()
end

return M
