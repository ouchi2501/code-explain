vim.cmd("luafile %") -- This line was added to reload init.lua. It's not needed in the actual configuration file.

vim.g.chat_gpt_summary_language = "English" -- or "Japanese"
vim.g.chat_gpt_summary_api_key = "your_api_key_here"

vim.api.nvim_set_keymap('n', '<leader>s', ':lua require("chat_gpt_summary").print_summary(vim.g.chat_gpt_summary_language, vim.g.chat_gpt_summary_api_key)<CR>', {noremap = true, silent = true})
