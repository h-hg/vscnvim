local init_path = debug.getinfo(1, "S").source:sub(2)
local base_dir = init_path:match("(.*[/\\])"):sub(1, -2)

if not vim.tbl_contains(vim.opt.rtp:get(), base_dir) then
  vim.opt.rtp:append(base_dir)
end

local vscnvim = require('vscnvim'):init()
vscnvim.plugin.init()

-- define your neovim plugin settings
local pluginConfigs = require('plugins.config')
vscnvim.plugin.init({})
vscnvim.plugin.load(pluginConfigs)

-- define your neovim option
local option = require('options')
option:init()

-- define your keymap
local keymap = require('keymap')
keymap:init()
