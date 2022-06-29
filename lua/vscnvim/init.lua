local M = {}

M.path = require('vscnvim.path')
M.config = require('vscnvim.config')
M.plugin = require('vscnvim.plugin')

function M:init()
  self.path:init()
  return self
end

return M