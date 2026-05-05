local M = {}

M.setup = function(opts)
  local state = require("dashboard-github.state")
  state.user_laststatus = vim.opt.laststatus:get()
  state.ns = vim.api.nvim_create_namespace("activity_dashboard")
  for _, key in ipairs({
    "months_to_show",
    "username",
    "art",
    "shortcuts",
    "layout",
    "highlights",
  }) do
    if opts[key] then
      state[key] = opts[key]
    end
  end
end

function M.show()
  local ui = require("dashboard-github.ui")
  ui.art_and_shortcuts()
  ui.async_get_git_contributions({})
  local g = vim.api.nvim_create_augroup("dashboard-github", { clear = true })

  local state = require("dashboard-github.state")
  vim.api.nvim_create_autocmd("BufLeave", {
    buffer = state.buf,
    group = g,
    callback = function()
      vim.opt.laststatus = state.user_laststatus
    end,
  })
end
return M
