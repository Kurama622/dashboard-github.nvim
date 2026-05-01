local M = { cache = "/tmp/dashboard-github-%s" }
local state = require("dashboard-github.state")
local utils = require("dashboard-github.utils")

-- ⣿⣷⣾⡿⢿⣼⢻⡟⣧⠿⣶⠻⠟⣴⣸⣆⣰⠏⠛⣤⢸⡆⣄⠙⣠⠰⠉⢠⠘⣀⢀⡀⠈⠁⠀
local config = {
	art = {

		"⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣠⣤⣤⣶⣶⣦⣤⣄⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ ",
		"⠀⠀⠀⠀⠀⠀⢀⣤⣾⣿⣿⣿⣿⠿⠿⠿⠿⣿⣿⣿⣿⣶⣤⡀⠀⠀⠀⠀⠀⠀ ",
		"⠀⠀⠀⠀⣠⣾⣿⣿⡿⠛⠉⠀⠀⠀⠀⠀⠀⠀⠀⠉⠛⢿⣿⣿⣶⡀⠀⠀⠀⠀ ",
		"⠀⠀⠀⣴⣿⣿⠟⠁⠀⠀⠀⣴⣾⣿⣶⡄⠀⠀⠀⠀⠀⠀⠈⠻⣿⣿⣦⠀⠀⠀ ",
		"⠀⠀⣼⣿⣿⠋⠀⠀⠀⠀⠀⠙⠛⢻⣿⣿⡀⠀⠀⠀⠀⠀⠀⠀⠙⣿⣿⣧⠀⠀ ",
		"⠀⢸⣿⣿⠃⠀⠀⠀⠀⠀⠀⠀⠀⢀⣿⣿⣷⠀⠀⠀⠀⠀⠀⠀⠀⠸⣿⣿⡇⠀ ",
		"⠀⣿⣿⡿⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⣿⣿⣿⣇⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⠀ ",
		"⠀⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⢠⣿⣿⡟⢹⣿⣿⡆⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⠀ ",
		"⠀⣿⣿⣷⠀⠀⠀⠀⠀⠀⣰⣿⣿⠏⠀⠀⢻⣿⣿⡄⠀⠀⠀⠀⠀⠀⣿⣿⡿⠀ ",
		"⠀⢸⣿⣿⡆⠀⠀⠀⠀⣴⣿⡿⠃⠀⠀⠀⠈⢿⣿⣷⡀⣠⣄⠀⠀⣰⣿⣿⠇⠀ ",
		"⠀⠀⢻⣿⣿⣄⠀⠀⢾⣿⠟⠁⠀⠀⠀⠀⠀⠈⢿⣿⣿⡿⠋⠀⣰⣿⣿⡟⠀⠀ ",
		"⠀⠀⠀⠻⣿⣿⣷⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠁⠀⣠⣾⣿⣿⠏⠀⠀⠀ ",
		"⠀⠀⠀⠀⠈⠻⣿⣿⣷⣤⣄⡀⠀⠀⠀⠀⠀⠀⢀⣠⣴⣾⣿⣿⠟⠁⠀⠀⠀⠀ ",
		"⠀⠀⠀⠀⠀⠀⠈⠛⠿⣿⣿⣿⣿⣿⣶⣶⣿⣿⣿⣿⣿⠿⠋⠁⠀⠀⠀⠀⠀⠀ ",
		"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠉⠛⠛⠿⠿⠛⠛⠉⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ ",
	},

	shortcuts = {
		{ key = "f", desc = "Find Files", action = "<cmd>FzfLua files<CR>" },
		{ key = "r", desc = "Recent Files", action = "<cmd>FzfLua oldfiles<CR>" },
		{ key = "n", desc = "New File", action = "<cmd>enew <CR>i" },
		{ key = "d", desc = "Open Neovim Config", action = "<cmd>FzfLua files cwd=~/.config/nvim<CR>" },
		{ key = "/", desc = "Live Grep", action = "<cmd>FzfLua live_grep<CR>" },
		{
			key = "u",
			desc = "Update Plugins",
			action = "<cmd>Lazy update<CR>",
		},
		{ key = "q", desc = "Quit", action = "<cmd>qa<CR>" },
	},

	highlights = {
		art = "DashboardArt",
		key = "DashboardKey",
		desc = "DashboardDesc",
		date = "DashboardDate",
		footer = "DashboardFooter",
	},

	layout = {
		gap = 9,
		date_gap = 4,
		plugin_info_gap = 4,
		shortcuts_top_offset = 1,
		plugin_info_offset = 1,
	},
}

M.line_w = function(line)
	local w = 0

	for _, cell in ipairs(line) do
		if cell[1] ~= "_pad_" then
			w = w + vim.api.nvim_strwidth(cell[1])
		end
	end

	return w
end

M.separator = function(char, w, hl)
	return { { string.rep(char or "─", w), hl or "linenr" } }
end

M.border = function(lines, hl)
	hl = hl or "linenr"

	local maxw = 0
	local line_widths = {}

	for _, line in ipairs(lines) do
		local linew = M.line_w(line)

		if maxw < linew then
			maxw = linew
		end

		table.insert(line_widths, linew)
	end

	state.maxw = maxw + 4

	state.pad = string.rep(" ", (vim.o.columns - state.maxw) / 2)
	for i, _ in ipairs(lines) do
		table.insert(lines[i], 1, { state.pad .. "│ ", hl })
		local rpad = string.rep(" ", maxw - line_widths[i])
		table.insert(lines[i], { rpad .. " │", hl })
	end

	maxw = maxw + 2

	local horiz_chars = string.rep("─", maxw)

	table.insert(lines, 1, { { state.pad .. "┌" .. horiz_chars .. "┐", hl } })
	table.insert(lines, { { state.pad .. "└" .. horiz_chars .. "┘", hl } })
end

M.hpad = function(line, w)
	local pad_w = w - M.line_w(line)

	for i, v in ipairs(line) do
		if v[1] == "_pad_" then
			line[i][1] = string.rep(" ", pad_w)
		end
	end

	return line
end

M.activity_heatmap = function(data)
	local months = { "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" }
	local days_in_months = { 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 }
	local days = { "Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat" }

	local four_colors = { "Red", "Green", "Blue", "Yellow" }
	local monthshl = vim.list_extend(vim.list_extend(four_colors, four_colors), four_colors)

	local time = utils.get_n_months_ago(state.months_to_show)
	local month_offset = time.month

	time.day = 1
	if time.day ~= days_in_months[time.month] then
		month_offset = time.month + 1
		if month_offset == 13 then
			month_offset = 1
			time.year = time.year + 1
		end
		time.month = month_offset
	end

	local week = utils.get_week_of_past_year(
		os.date("*t", os.time({ year = time.year, month = time.month, day = time.day, hour = 0, min = 0, sec = 0 }))
	)

	local squares_len = state.months_to_show * 4

	local lines = {
		{ { "   ", "exgreen" }, { "  " } },
		{},
	}

	for i = 1, state.months_to_show do
		local idx = (i + month_offset - 1) % 12 == 0 and 12 or (i + month_offset - 1) % 12
		local hl = "ex" .. monthshl[idx]
		table.insert(lines[1], { "  " .. months[idx] .. "  ", hl })
		table.insert(lines[1], { i == state.months_to_show and "" or "  " })
	end

	local hrline = M.separator("─", squares_len * 2 + (state.months_to_show - 1 + 5), "exlightgrey")
	table.insert(lines[2], hrline[1])

	for day = 1, 7 do -- 7 weakdays
		local line = { { days[day], "exlightgrey" }, { " │ ", "linenr" } }
		table.insert(lines, line)
	end

	for i = 1, state.months_to_show do
		local month_i = (i + month_offset - 1) % 12 == 0 and 12 or (i + month_offset - 1) % 12
		local start_day = utils.getday_i(1, month_i, time.year)

		if start_day ~= 1 and i == 1 then
			for n = 1, start_day - 1 do
				table.insert(lines[n + 2], { "  " })
			end
		end

		for n = 1, days_in_months[month_i] do
			local day = utils.getday_i(n, month_i, time.year)

			local activity_week = data[tostring(week)]
			local activity = activity_week and activity_week[day] or -1
			local hl = "Dashboard" .. monthshl[month_i] .. utils.get_activity_hl(activity)
			hl = activity <= 0 and "Linenr" or hl
			local str = activity == -1 and "  " or "󱓻 "

			if day == 7 then
				week = week + 1
			end
			utils.opeator_date(time, 1)
			table.insert(lines[day + 2], { str, hl })
		end
	end

	M.border(lines)

	local header = {
		{ state.pad .. "   Activity" },
		{ "_pad_" },
		{ "  Less " },
	}

	local hlgroups = { "linenr", "dashboardgreen3", "dashboardgreen2", "dashboardgreen1", "dashboardgreen0" }

	for _, v in ipairs(hlgroups) do
		table.insert(header, { "󱓻 ", v })
	end

	table.insert(header, { " More" })
	table.insert(lines, 1, M.hpad(header, (vim.o.columns + state.maxw) / 2))

	return lines
end

function M.draw(data)
	local buf = vim.api.nvim_get_current_buf()

	utils.render_heatmap(buf, M.activity_heatmap(data))
end

function M.load_git_contributions_from_cache()
	local cache_file = M.cache:format(state.username)

	local file = io.open(cache_file, "r")
	local content = nil
	local s = nil
	if file then
		content = file:read("*all")
		file:close()
	else
		vim.print("read faild: " .. cache_file)
	end
	s, content = pcall(vim.json.decode, content)
	if not s then
		vim.print(s)
		return nil
	end
	return content
end

local function cache_git_contributions(str)
	local cache_file = M.cache:format(state.username)

	local file = io.open(cache_file, "w")
	if file then
		file:write(str)
		file:close()
	else
		print("write failed: " .. cache_file)
	end
end

local function check_file_valid(file_path, max_time_diff)
	local stat = vim.uv.fs_stat(file_path)
	if stat then
		local mtime = stat.mtime.sec
		return os.difftime(os.time(), mtime) < max_time_diff
	else
		return false
	end
end

function M.async_get_git_contributions(opts)
	if opts.fake_contributions ~= nil then
		local contributions = opts.fake_contributions()
		pcall(M.draw, contributions)
	else
		local cache_file = M.cache:format(state.username)
		local enable_load_cache = false
		if cache_file then
			enable_load_cache = check_file_valid(cache_file, 24 * 60 * 60)
		end

		if enable_load_cache then
			local contributions = M.load_git_contributions_from_cache()
			pcall(M.draw, contributions)
		else
			local cmd =
				[[curl -s -H "Authorization: bearer $GITHUB_TOKEN" -X POST -d '{"query":"query {user(login: \"%s\") {contributionsCollection {contributionCalendar {weeks {contributionDays {contributionCount}}}}}}"}' https://api.github.com/graphql | \
jq -c 'reduce (.data.user.contributionsCollection.contributionCalendar.weeks | to_entries[]) as $week ({}; .[$week.key + 1 | tostring] = [$week.value.contributionDays[].contributionCount])']]
			if opts.non_official_api_cmd then
				cmd = opts.non_official_api_cmd
			end
			vim.fn.jobstart(string.format(cmd, state.username), {
				on_stdout = function(_, data, _)
					vim.schedule(function()
						local str = ""
						for _, line in ipairs(data) do
							str = str .. line
						end
						if str == "" or str == " " or str == "\n" then
							return
						end
						local contributions = vim.json.decode(str)
						cache_git_contributions(str)
						pcall(M.draw, contributions)
					end)
				end,
			})
		end
	end
end

local function get_datetime()
	local datetime = os.date("*t")
	local weekdays = { "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday" }
	local months = { "jan", "feb", "mar", "apr", "may", "jun", "jul", "aug", "sep", "oct", "nov", "dec" }

	local weekday = weekdays[datetime.wday]
	local year = datetime.year
	local month = months[datetime.month]
	local day = datetime.day
	local hour = string.format("%02d", datetime.hour)
	local min = string.format("%02d", datetime.min)

	return string.format("%s %04d %s %02d %s:%s", weekday, year, month, day, hour, min)
end

local function calculate_positions()
	local screen_width = vim.o.columns

	config.layout.top_offset = math.floor((vim.o.lines - math.max(#config.art, #config.shortcuts) - 14) / 2)
	config.layout.date_top_offset = math.floor((#config.art - #config.shortcuts) / 2)

	local art_display_width = 0
	for _, line in ipairs(config.art) do
		art_display_width = math.max(art_display_width, vim.fn.strdisplaywidth(line))
	end

	local max_right_display_width = 0

	for _, line in ipairs(config.shortcuts) do
		max_right_display_width =
			math.max(max_right_display_width, vim.fn.strdisplaywidth(line.desc) + vim.fn.strdisplaywidth(line.key) + 4)
	end

	config.layout.datetime_str = get_datetime()

	max_right_display_width = math.max(max_right_display_width, vim.fn.strdisplaywidth(config.layout.datetime_str))
	local total_display_width = art_display_width + config.layout.gap + max_right_display_width

	local start_pos = math.max(1, math.floor((screen_width - total_display_width) / 2))

	return {
		art_left_margin = start_pos,
		right_section_left = start_pos + art_display_width + config.layout.gap,
	}
end

local function create_dashboard_buffer()
	local buf = vim.api.nvim_get_current_buf()

	local opts = {
		["bufhidden"] = "wipe",
		["colorcolumn"] = "",
		["foldcolumn"] = "0",
		["matchpairs"] = "",
		["buflisted"] = false,
		["cursorcolumn"] = false,
		["cursorline"] = false,
		["list"] = false,
		["number"] = false,
		["relativenumber"] = false,
		["spell"] = false,
		["swapfile"] = false,
		["readonly"] = false,
		["filetype"] = "dashboard",
		["wrap"] = false,
		["signcolumn"] = "no",
	}
	for opt, val in pairs(opts) do
		vim.opt_local[opt] = val
	end

	return buf
end

local function render(buf)
	local lines = {}
	local highlights_to_apply = {}

	local pos = calculate_positions()

	for _ = 1, config.layout.top_offset do
		table.insert(lines, "")
	end

	local art_lines = #config.art
	local date_line_idx = config.layout.top_offset + config.layout.date_top_offset
	local shortcuts_start_idx = date_line_idx + config.layout.shortcuts_top_offset + 1
	local plugin_info_line_idx = shortcuts_start_idx + config.layout.plugin_info_offset + #config.shortcuts

	local total_lines = math.max(
		config.layout.top_offset + art_lines,
		shortcuts_start_idx + #config.shortcuts,
		plugin_info_line_idx + 1
	)

	for _ = #lines + 1, total_lines do
		table.insert(lines, "")
	end

	for i, art_line in ipairs(config.art) do
		local line_idx = config.layout.top_offset + i
		if line_idx <= #lines then
			local new_line = string.rep(" ", pos.art_left_margin - 1) .. art_line
			lines[line_idx] = new_line

			local art_byte_start = pos.art_left_margin - 1
			local art_byte_end = art_byte_start + #art_line

			table.insert(highlights_to_apply, {
				line = line_idx - 1,
				col_start = art_byte_start,
				col_end = art_byte_end,
				hl_group = config.highlights.art,
			})
		end
	end

	if date_line_idx <= #lines then
		local current_line = lines[date_line_idx] or ""
		local needed_spaces = math.max(config.layout.date_gap, pos.right_section_left - 1 - #current_line)
		local new_line = current_line .. string.rep(" ", needed_spaces) .. config.layout.datetime_str
		lines[date_line_idx] = new_line

		local date_byte_start = #current_line + needed_spaces
		local date_byte_end = date_byte_start + #config.layout.datetime_str

		table.insert(highlights_to_apply, {
			line = date_line_idx - 1,
			col_start = date_byte_start,
			col_end = date_byte_end,
			hl_group = config.highlights.date,
		})
	end

	local cursor = {}

	local shortcuts = config.shortcuts
	for i, shortcut in ipairs(shortcuts) do
		local row_idx = shortcuts_start_idx + i - 1
		if row_idx <= #lines then
			local shortcut_text = string.format("[%s]  %s", shortcut.key, shortcut.desc)

			local current_line = lines[row_idx] or ""
			local needed_spaces = math.max(config.layout.gap, pos.right_section_left - 1 - #current_line)
			local new_line = current_line .. string.rep(" ", needed_spaces) .. shortcut_text
			if i == 1 then
				cursor[1] = row_idx
				cursor[2] = #new_line - #shortcut_text + 5
			end
			lines[row_idx] = new_line

			local shortcut_byte_start = #current_line + needed_spaces

			table.insert(highlights_to_apply, {
				line = row_idx - 1,
				col_start = shortcut_byte_start + 1,
				col_end = shortcut_byte_start + 2,
				hl_group = config.highlights.key,
			})

			table.insert(highlights_to_apply, {
				line = row_idx - 1,
				col_start = shortcut_byte_start + 3,
				col_end = shortcut_byte_start + #shortcut_text,
				hl_group = config.highlights.desc,
			})
		end
	end

	local stats = require("lazy").stats()

	local plugin_info_str =
		string.format("load %d/%d plugins in %.2fms", stats.loaded or 0, stats.count or 0, stats.startuptime)

	if plugin_info_line_idx <= #lines then
		local current_line = lines[plugin_info_line_idx] or ""
		local needed_spaces = math.max(config.layout.plugin_info_gap, pos.right_section_left - 1 - #current_line)
		local new_line = current_line .. string.rep(" ", needed_spaces) .. plugin_info_str
		lines[plugin_info_line_idx] = new_line

		local plugin_byte_start = #current_line + needed_spaces
		local plugin_byte_end = plugin_byte_start + #plugin_info_str

		table.insert(highlights_to_apply, {
			line = plugin_info_line_idx - 1,
			col_start = plugin_byte_start,
			col_end = plugin_byte_end,
			hl_group = config.highlights.footer,
		})
	end
	vim.bo[buf].modifiable = true
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	vim.api.nvim_buf_set_lines(0, -1, -1, false, { "", "" })
	vim.bo[buf].modifiable = false
	vim.api.nvim_win_set_cursor(0, cursor)

	local ns_id = vim.api.nvim_create_namespace("dashboard")
	for _, hl in ipairs(highlights_to_apply) do
		vim.hl.range(buf, ns_id, hl.hl_group, { hl.line, hl.col_start }, { hl.line, hl.col_end })
	end
end

local function setup_keymaps(buf)
	local opts = { noremap = true, silent = true, buffer = buf }

	for _, key in ipairs({ "h", "l", "v", "V", "j", "k" }) do
		vim.keymap.set("n", key, "<Nop>", { buffer = buf })
	end
	for _, shortcut in ipairs(config.shortcuts) do
		vim.keymap.set("n", shortcut.key, shortcut.action, opts)
	end
end

function M.art_and_shortcuts()
	local buf = create_dashboard_buffer()
	render(buf)
	setup_keymaps(buf)
end

return M
