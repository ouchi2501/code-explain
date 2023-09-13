local M = {}

function M.setup(config)
    require("code-explain").setup(config)
end

function M.print_summary()
    require("code-explain").print_summary()
end

return M
