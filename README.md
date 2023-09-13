# code-explain

This plugin sends selected text to the OpenAI API and retrieves a summary, which is then displayed in a new Neovim window.  
This allows you to easily create summaries of code or documentation.

## Prerequisites

- Neovim 0.5.0 or later
- `curl` command-line tool installed

## Installation

1. Add the following line to your `init.vim` or `init.lua` to install the plugin.

```lua
-- For packer.nvim
use 'ouchi2501/code-explain'
```

2. Open Neovim and run or `:PackerInstall` to install the plugin.

3. Set your API key and Language.

```lua
require("code-explain").setup({token = 'your_api_key',language = 'English'}) -- or Japanese
```
4. Set your keymap.

```lua
vim.api.nvim_set_keymap('v', '<leader>a', ':lua require("code-explain").print_summary()<CR>', {noremap = true, silent = true})
```

## Usage

To use the `code-explain` plugin, follow these steps:

1. In Neovim, enter Visual mode by pressing `v`, `V`, or `<C-v>`.
2. Select the text you want to send to the API.
3. Press `<leader>s` to send the selected text to the API. The result will be displayed in a new window.

Note: If you want to use a different key mapping, replace `<leader>s` in the `init.vim` configuration with your preferred key combination.
If you have any issues or need further assistance, feel free to ask.


## Supported Languages

Currently, the following languages are supported:

- English (`en`)
- Japanese (`ja`)

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more information.
