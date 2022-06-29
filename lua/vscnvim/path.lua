
local M = {}

M.sep = vim.loop.os_uname().version:match 'Windows' and '\\' or '/'

---Join path segments that were passed as input
---@return string
function M.joins(...)
  return table.concat({ ... }, M.sep)
end

function M.isDir(path)
  local stat = vim.loop.fs_stat(path)
  return stat and stat.type == 'directory' or false
end

function M.isFile(path)
  -- todo
end

M.paths = {}

-- store the original stdpath
M.stdpath_ = vim.fn.stdpath

function M.stdpath(what)
  if what == 'cache' then
    return M.paths.cache
  elseif what == 'config' then
    return M.paths.config
  elseif what == 'data' then
    return M.paths.data
  else
    return M.stdpath_(what)
  end
end

function M:init()
    -- init self.paths
    local cachePath = os.getenv 'VSCNVIM_CACHE_DIR'
    local configPath = os.getenv 'VSCNVIM_CONFIG_DIR'
    local dataPath = os.getenv 'VSCNVIM_DATA_DIR'

    self.stdpath_ = vim.fn.stdpath

    self.paths.cache = cachePath ~= nil and cachePath or self.stdpath_('cache')
    self.paths.config = configPath ~= nil and configPath self.stdpath_('config')
    self.paths.data = dataPath ~= nil and dataPath self.stdpath_('data')

    -- set stdpath
    vim.fn.stdpath = self.stdpath_
    -- vim.fn.stdpath = function(what)
    --   if what == 'cache' then
    --     return self.stdpath('cache')
    --   end
    --   return self.stdpath_(what)
    -- end
    
    vim.opt.rtp:remove(self.joins(self.stdpath_('data'), 'site'))
    vim.opt.rtp:remove(self.joins(self.stdpath_('data'), 'site', 'after'))
    vim.opt.rtp:prepend(self.joins(self.stdpath('data'), 'site'))
    vim.opt.rtp:append(self.joins(self.stdpath('data'), 'site', 'after'))
  
    vim.opt.rtp:remove(self.stdpath_('config'))
    vim.opt.rtp:remove(self.joins(self.stdpath_('config'), 'after'))
    vim.opt.rtp:prepend(self.stdpath('config'))
    vim.opt.rtp:append(self.joins(self.stdpath('config'), 'after'))
    -- TODO: we need something like this: vim.opt.packpath = vim.opt.rtp
    vim.cmd [[let &packpath = &runtimepath]]

    -- mkdir
    vim.fn.mkdir(self.joins(self.stdpath('data'), 'site', 'after'), 'p')
    vim.fn.mkdir(self.joins(self.stdpath('config'), 'after'), 'p')
    vim.fn.mkdir(self.stdpath('cache'), 'p')

    return self
end

return M