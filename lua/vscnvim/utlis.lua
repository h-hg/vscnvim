local M = {}

M.isHeadless = #vim.api.nvim_list_uis() == 0

return M