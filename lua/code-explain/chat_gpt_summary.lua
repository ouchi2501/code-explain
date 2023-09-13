local api = vim.api
local http_request_with_curl = require("code-explain.http_request_with_curl")

local config = {
    token = '',
    language = 'English'
}

local function setup(user_config)
    config = vim.tbl_extend('force', config, user_config)
end

local function get_summary(selected_code, language, api_key, callback)
    local api_url = "https://api.openai.com/v1/chat/completions"

    local headers = {
        "Content-Type: application/json",
        "Authorization: Bearer " .. api_key,
    }

    local prompt = "You are a helpful assistant that summarizes code."
    if language == "Japanese" then
        prompt = "あなたはあらゆるプログラミング言語に精通したソフトウェアエンジニアです。渡されたプログラミングコードの内容を要約してください。日本語で要約した内容を答えてください。コードの内容をある程度は詳細に答えてください。要約するときは短すぎないようにすること"
    elseif language == "English" then
        prompt = "You are a software engineer who is proficient in all programming languages. Please summarize the content of the programming code passed to you. Please give a summary in English. Please answer the code in some detail. Avoid being too short when summarizing"
    end

    local escaped_selected_code = vim.fn.escape(selected_code, '"')
    escaped_selected_code = string.gsub(escaped_selected_code, "\n", "\\n")

    local body = string.format('{"model": "gpt-3.5-turbo", "messages": [{"role": "system", "content": "%s"}, {"role": "user", "content": "Summarize this code:\\n%s"}], "max_tokens": 1500, "n": 1, "stop": ["\\n"]}', prompt, escaped_selected_code)

    local options = {
        "-X", "POST",
        "-H", headers[1],
        "-H", headers[2],
        "-d", body,
        api_url
    }

    http_request_with_curl(options, callback)
end

local function print_summary()
    local start_pos = vim.fn.getpos("'<")
    local end_pos = vim.fn.getpos("'>")
    local bufnr = api.nvim_get_current_buf()
    local lines = api.nvim_buf_get_lines(bufnr, start_pos[2] - 1, end_pos[2], false)
    if #lines > 0 then
        lines[1] = lines[1]:sub(start_pos[3])
        lines[#lines] = lines[#lines]:sub(1, end_pos[3])
    end
    local selected_code = table.concat(lines, '\n')

    local function handle_response(response)
        local start_index = string.find(response, "\"content\": \"")
        if start_index == nil then
            -- json doesn't contain the answer because something went wrong
            error(response)
        end
        local end_index = string.find(response, '"\n', start_index + 8)
        local answer = string.sub(response, start_index + 12, end_index - 1)

        local function unescape(text)
            text = string.gsub(text, '\\n', '\n')
            text = string.gsub(text, [[\']], [[']])
            text = string.gsub(text, [[\"]], [["]])
            text = string.gsub(text, [[\t]], [[	]])
            return text
        end

        local escaped = unescape(answer)

        local answerLines = {}
        for str in string.gmatch(escaped, "([^\n]+)") do
            table.insert(answerLines, str)
        end
        vim.schedule(function()
            -- split window to the right with 1/3 width of the screen
            vim.cmd("rightbelow vnew")
            vim.cmd("vertical resize " .. math.floor(vim.o.columns * 1/3))
            local new_bufnr = api.nvim_get_current_buf()
            api.nvim_buf_set_lines(new_bufnr, 0, -1, false, answerLines)

            -- Close the window when pressing 'q'
            vim.api.nvim_buf_set_keymap(new_bufnr, 'n', 'q', '<cmd>bd! <CR>', {noremap = true, silent = true})
        end)

    end

    local language = config.language
    local api_key = config.token
    get_summary(selected_code, language, api_key, handle_response)
end

return {
    setup = setup,
    print_summary = print_summary,
}
