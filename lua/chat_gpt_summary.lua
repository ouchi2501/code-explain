local api = vim.api
local http_request_with_curl = require("http_request_with_curl")

local function get_summary(selected_code, language, api_key, callback)
    local api_url = "https://api.openai.com/v1/chat/completions"

    local headers = {
        "Content-Type: application/json",
        "Authorization: Bearer " .. api_key,
    }

    local prompt = "You are a helpful assistant that summarizes code."
    if language == "Japanese" then
        prompt = "あなたはあらゆるプログラミング言語に精通したソフトウェアエンジニアです。渡されたプログラミングコードの内容を要約してください。日本語で要約した内容を答えてください。"
    elseif language == "English" then
        prompt = "You are a software engineer who is proficient in all programming languages. Please summarize the content of the programming code passed to you. Please give a summary in English."
    end

    local escaped_selected_code = vim.fn.escape(selected_code, '"')
    escaped_selected_code = string.gsub(escaped_selected_code, "\n", "\\n")

    local body = string.format('{"model": "gpt-3.5-turbo", "messages": [{"role": "system", "content": "%s"}, {"role": "user", "content": "Summarize this code:\\n%s"}], "max_tokens": 500, "n": 1, "stop": ["\\n"]}', prompt, escaped_selected_code)

    print("Request body:", body)

    local options = {
        "-X", "POST",
        "-H", headers[1],
        "-H", headers[2],
        "-d", body,
        api_url
    }

    http_request_with_curl(options, callback)
end

local function print_summary(language, api_key)
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
        print("API response:", vim.inspect(response))
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
            -- ウィンドウを右側に作成
            api.nvim_command("rightbelow vnew") -- 垂直分割の新しいウィンドウを右側に作成
            local new_bufnr = api.nvim_get_current_buf()
            api.nvim_buf_set_lines(new_bufnr, 0, -1, false, answerLines) -- 要約を新しいウィンドウに追加
        end)
    end

    get_summary(selected_code, language, api_key, handle_response)
end

return {
    print_summary = print_summary,
}
