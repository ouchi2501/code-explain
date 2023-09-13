# code-explain

This plugin sends selected text to the OpenAI API and retrieves a summary, which is then displayed in a new Neovim window.  
This allows you to easily create summaries of code or documentation.

## Prerequisites

- Neovim 0.5.0 or later
- `curl` command-line tool installed

## Installation

1. Add the following line to your `init.vim` or `init.lua` to install the plugin.

```vim
" For vim-plug
Plug 'ouchi2501/code-explain'
```

```lua
-- For packer.nvim
use 'ouchi2501/code-explain'
```

2. Open Neovim and run `:PlugInstall` or `:PackerInstall` to install the plugin.

3. Set your API key in `~/.config/nvim/lua/chat_gpt_summary.lua`.

```lua
local api_key = "your_api_key_here"
```

## Usage

1. In Neovim, select the text you want to summarize.
2. Run `:lua require('chat_gpt_summary').print_summary("en", "your_api_key")`, setting the language code and API key appropriately.
3. The summary will be displayed in a new window.

## Supported Languages

Currently, the following languages are supported:

- English (`en`)
- Japanese (`ja`)

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more information.
