local M = {}

M.setup = function(opts)
	local state = require("dashboard-github.state")
	state.ns = vim.api.nvim_create_namespace("activity_dashboard")
	for _, key in ipairs({ "months_to_show", "username" }) do
		if opts[key] then
			state[key] = opts[key]
		end
	end
end
function M.show()
	local ui = require("dashboard-github.ui")
	ui.art_and_shortcuts()
	ui.async_get_git_contributions({})
end
return M
