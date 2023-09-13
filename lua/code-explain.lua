local M = {}

function M.setup(config)
    require("chat_gpt_summary").setup(config)
end

function M.print_summary()
    require("chat_gpt_summary").print_summary()
end

return M
