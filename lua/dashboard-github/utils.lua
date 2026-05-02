local M = { cache = "/tmp/dashboard-github-%s" }
local state = require("dashboard-github.state")

function M.getday_i(day, month, year)
  if year == nil then
    year = os.date("%Y") - 1
  end
  return tonumber(
    os.date(
      "%w",
      os.time({ year = tostring(year), month = month, day = day })
    )
  ) + 1
end

function M.get_week_of_past_year(date)
  local target_time = os.time(date)

  local now = os.time()
  local one_year_ago = now - 365 * 24 * 3600 -- 一年前的时间戳（不考虑闰年差异）

  if target_time < one_year_ago or target_time > now then
    return nil
  end

  local diff_days = math.floor((target_time - one_year_ago) / (24 * 3600))
  local week_number = math.floor(diff_days / 7) + 1 -- +1表示从第1周开始计数

  return week_number
end

function M.get_n_months_ago(n)
  local now = os.date("*t") -- 获取当前时间的表格式
  local year = now.year
  local month = now.month - n
  local day = now.day

  -- 计算年和月
  while month <= 0 do
    month = month + 12
    year = year - 1
  end

  -- 处理当月的天数（避免日期溢出，比如3月31日减1个月后应是2月28日或29日）
  local function days_in_month(y, m)
    local days = { 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 }
    -- 闰年检测
    if m == 2 then
      if (y % 400 == 0) or (y % 4 == 0 and y % 100 ~= 0) then
        return 29
      end
    end
    return days[m]
  end

  local max_day = days_in_month(year, month)
  if day > max_day then
    day = max_day
  end

  local t = os.time({
    year = year,
    month = month,
    day = day,
    hour = now.hour,
    min = now.min,
    sec = now.sec,
  })
  -- return os.date("%Y-%m-%d", t)
  return os.date("*t", t)
end

M.get_activity_hl = function(n)
  if n > 3 then
    return "0"
  elseif n > 2 then
    return "1"
  elseif n > 1 then
    return "2"
  else
    return "3"
  end
end

function M.operator_date(t, delta)
  local seconds_to_add = delta * 24 * 60 * 60
  local time = os.time(t)
  local new_time = time + seconds_to_add
  local new_date = os.date("*t", new_time)
  t.day = new_date.day
  t.month = new_date.month
  t.year = new_date.year
  return new_date.year
end

function M.render_heatmap(buf, lines)
  vim.bo[buf].modifiable = true
  local offset = vim.api.nvim_buf_line_count(buf)

  for row, segments in ipairs(lines) do
    row = offset + row
    local line = ""
    local highlights = {}
    local col = 0

    for _, seg in ipairs(segments) do
      local text = seg[1] or ""
      local hl = seg[2]

      local start_col = col
      line = line .. text
      col = col + #text

      if hl and hl ~= "" then
        table.insert(highlights, {
          group = hl,
          start_col = start_col,
          end_col = col,
        })
      end
    end

    vim.api.nvim_buf_set_lines(buf, row - 1, row - 1, false, { line })

    for _, h in ipairs(highlights) do
      vim.hl.range(
        buf,
        state.ns,
        h.group,
        { row - 1, h.start_col },
        { row - 1, h.end_col }
      )
    end
  end

  vim.bo[buf].modifiable = false
  vim.bo[buf].modified = false
end

-- test
M.gen_default_stats = function()
  return {
    ["1"] = { 0, 0, 1, 1, 0, 1, 3 },
    ["2"] = { 10, 4, 0, 0, 1, 2, 0 },
    ["3"] = { 1, 1, 2, 0, 1, 1, 0 },
    ["4"] = { 1, 0, 0, 0, 0, 0, 1 },
    ["5"] = { 1, 1, 1, 0, 0, 0, 0 },
    ["6"] = { 3, 0, 0, 0, 0, 0, 2 },
    ["7"] = { 3, 0, 0, 0, 0, 0, 2 },
    ["8"] = { 2, 0, 1, 0, 1, 1, 0 },
    ["9"] = { 0, 1, 1, 0, 1, 0, 1 },
    ["10"] = { 0, 0, 0, 0, 0, 0, 6 },
    ["11"] = { 0, 0, 0, 0, 2, 0, 2 },
    ["12"] = { 1, 0, 0, 0, 0, 0, 0 },
    ["13"] = { 2, 0, 2, 0, 0, 0, 2 },
    ["14"] = { 0, 1, 0, 0, 0, 0, 2 },
    ["15"] = { 0, 0, 0, 0, 0, 0, 0 },
    ["16"] = { 0, 0, 1, 0, 0, 0, 5 },
    ["17"] = { 0, 0, 0, 0, 0, 2, 6 },
    ["18"] = { 1, 0, 0, 0, 0, 0, 3 },
    ["19"] = { 4, 1, 1, 5, 0, 0, 3 },
    ["20"] = { 1, 0, 0, 0, 2, 0, 4 },
    ["21"] = { 3, 0, 0, 0, 0, 1, 0 },
    ["22"] = { 1, 0, 2, 1, 1, 0, 1 },
    ["23"] = { 4, 3, 5, 2, 0, 0, 1 },
    ["24"] = { 2, 0, 0, 0, 0, 0, 0 },
    ["25"] = { 1, 0, 0, 0, 0, 0, 0 },
    ["26"] = { 6, 3, 0, 0, 0, 0, 1 },
    ["27"] = { 1, 0, 0, 2, 0, 0, 1 },
    ["28"] = { 4, 1, 2, 2, 1, 0, 0 },
    ["29"] = { 0, 0, 0, 0, 0, 0, 4 },
    ["30"] = { 0, 0, 0, 3, 0, 0, 3 },
    ["31"] = { 4, 0, 0, 2, 2, 0, 0 },
    ["32"] = { 3, 4, 2, 0, 0, 0, 4 },
    ["33"] = { 1, 0, 0, 0, 0, 0, 1 },
    ["34"] = { 0, 0, 0, 0, 4, 0, 0 },
    ["35"] = { 0, 0, 0, 0, 0, 0, 4 },
    ["36"] = { 1, 0, 0, 0, 0, 7, 7 },
    ["37"] = { 1, 1, 0, 2, 2, 0, 4 },
    ["38"] = { 4, 9, 2, 10, 5, 5, 10 },
    ["39"] = { 8, 7, 4, 1, 3, 2, 9 },
    ["40"] = { 6, 0, 4, 9, 2, 1, 1 },
    ["41"] = { 0, 0, 1, 1, 0, 0, 2 },
    ["42"] = { 1, 2, 2, 0, 1, 3, 0 },
    ["43"] = { 1, 8, 0, 6, 5, 0, 0 },
    ["44"] = { 0, 0, 3, 0, 2, 0, 1 },
    ["45"] = { 5, 0, 1, 3, 2, 6, 8 },
    ["46"] = { 4, 1, 1, 0, 1, 0, 0 },
    ["47"] = { 0, 0, 0, 0, 0, 0, 0 },
    ["48"] = { 5, 0, 0, 0, 0, 0, 0 },
    ["49"] = { 5, 0, 0, 5, 2, 0, 0 },
    ["50"] = { 7, 1, 1, 0, 0, 0, 6 },
    ["51"] = { 8, 4, 1, 3, 2, 0, 9 },
    ["52"] = { 11, 0, 0, 3, 3, 0, 8 },
    ["53"] = { 3, 1, 5, 3, 0, 0 },
  }
end

return M
