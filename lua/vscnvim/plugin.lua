local path = require('vscnvim.path')
local utils = require('vscnvim.utlis')

local M = {}

function M.init(options)
  options = options or {}
  -- donwload packer.nvim
  local install_path =  path.joins(path.stdpath('data'), 'site', 'pack', 'packer', 'start', 'packer.nvim')
  if not path.isDir(install_path) then
    vim.fn.system { 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path }
    vim.cmd 'packadd packer.nvim'
  end

  local packer = require('packer')
  local opts = vim.tbl_extend('force', options, {
    package_root = path.joins(path.stdpath('data'), 'site', 'pack'),
    install_path = path.joins(path.stdpath('data'), 'site', 'pack', 'packer', 'start', 'packer.nvim'),
    snapshot_path = path.joins(path.stdpath('cache'), 'snapshots'),
    compile_path = path.joins(path.stdpath('config'), 'plugin', 'packer_compiled.lua'),
  })
  if opts.display == nil then
    opts.display = {
      open_fn = function()
        return require('packer.util').float { border = 'rounded' }
      end,
    }
  end
  if utils.isHeadless then
    opts.display = nil
  end
  packer.init(opts)
end

function M.load(configs)
  require('packer').startup(function(use)
    for _, config in pairs(configs) do
      use(config)
    end
  end)
end

return M
