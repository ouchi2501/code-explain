vim.cmd("luafile %") -- この行はinit.luaを再読み込みするために追加されました。実際の設定ファイルでは必要ありません。

vim.g.chat_gpt_summary_language = "English" -- または "Japanese"
vim.g.chat_gpt_summary_api_key = "your_api_key_here"

vim.api.nvim_set_keymap('n', '<leader>s', ':lua require("chat_gpt_summary").print_summary(vim.g.chat_gpt_summary_language, vim.g.chat_gpt_summary_api_key)<CR>', {noremap = true, silent = true})
