-- GNU GENERAL PUBLIC LICENSE Version 3 License (GPL-3.0)
--
-- Copyright (c) 2022 nvzone

-- All credits to https://github.com/nvzone/typr for making this!

local api = vim.api

return function(ns)
  local mix = require("dashboard-github.color").mix
  local get_hl = require("dashboard-github.color").get_hl
  local lighten = require("dashboard-github.color").change_hex_lightness
  local bg

  if vim.g.base46_cache then
    local colors = dofile(vim.g.base46_cache .. "colors")
    bg = colors.black
  else
    bg = get_hl("Normal").bg
  end

  local transparent = not bg

  if not transparent then
    bg = lighten(bg, 2)
    api.nvim_set_hl(ns, "DashboardBorder", { fg = bg, bg = bg })
    api.nvim_set_hl(ns, "DashboardNormal", { bg = bg })
  else
    bg = "#000000"
  end

  local exred = get_hl("ExRed").fg
  api.nvim_set_hl(ns, "DashboardRed", { bg = mix(exred, bg, 80), fg = exred })
  api.nvim_set_hl(ns, "DashboardRed0", { fg = mix(exred, bg, 10) })
  api.nvim_set_hl(ns, "DashboardRed1", { fg = mix(exred, bg, 40) })
  api.nvim_set_hl(ns, "DashboardRed2", { fg = mix(exred, bg, 60) })
  api.nvim_set_hl(ns, "DashboardRed3", { fg = mix(exred, bg, 80) })

  local exgreen = get_hl("ExGreen").fg
  api.nvim_set_hl(
    ns,
    "DashboardGreen",
    { bg = mix(exgreen, bg, 80), fg = exgreen }
  )
  api.nvim_set_hl(ns, "DashboardGreen0", { fg = mix(exgreen, bg, 10) })
  api.nvim_set_hl(ns, "DashboardGreen1", { fg = mix(exgreen, bg, 40) })
  api.nvim_set_hl(ns, "DashboardGreen2", { fg = mix(exgreen, bg, 60) })
  api.nvim_set_hl(ns, "DashboardGreen3", { fg = mix(exgreen, bg, 80) })

  local exblue = get_hl("ExBlue").fg
  api.nvim_set_hl(
    ns,
    "DashboardBlue",
    { bg = mix(exblue, bg, 80), fg = exblue }
  )
  api.nvim_set_hl(ns, "DashboardBlue0", { fg = mix(exblue, bg, 10) })
  api.nvim_set_hl(ns, "DashboardBlue1", { fg = mix(exblue, bg, 40) })
  api.nvim_set_hl(ns, "DashboardBlue2", { fg = mix(exblue, bg, 60) })
  api.nvim_set_hl(ns, "DashboardBlue3", { fg = mix(exblue, bg, 80) })

  local exyellow = get_hl("ExYellow").fg
  api.nvim_set_hl(
    ns,
    "DashboardYellow",
    { bg = mix(exyellow, bg, 80), fg = exyellow }
  )
  api.nvim_set_hl(ns, "DashboardYellow0", { fg = mix(exyellow, bg, 10) })
  api.nvim_set_hl(ns, "DashboardYellow1", { fg = mix(exyellow, bg, 40) })
  api.nvim_set_hl(ns, "DashboardYellow2", { fg = mix(exyellow, bg, 60) })
  api.nvim_set_hl(ns, "DashboardYellow3", { fg = mix(exyellow, bg, 80) })

  local x = vim.o.bg == "dark" and 1 or -1

  local commentfg = get_hl("Conceal").fg

  if transparent then
    api.nvim_set_hl(ns, "DashboardGrey", { bg = lighten(commentfg, -22) })
  else
    api.nvim_set_hl(
      ns,
      "DashboardGrey",
      { bg = lighten(bg, 6 * x), fg = lighten(commentfg, 10 * x) }
    )
  end
  vim.api.nvim_set_hl(ns, "DashboardArt", { link = "DashboardRed0" })
  vim.api.nvim_set_hl(
    ns,
    "DashboardKey",
    { link = "DashboardGreen1", bold = true }
  )
  vim.api.nvim_set_hl(ns, "DashboardDesc", { link = "DashboardBlue1" })
  vim.api.nvim_set_hl(ns, "DashboardDate", { link = "DashboardYellow0" })
  vim.api.nvim_set_hl(ns, "DashboardFooter", { link = "Conceal" })
end
