return {
  months_to_show = 7,

  -- ⣿⣷⣾⡿⢿⣼⢻⡟⣧⠿⣶⠻⠟⣴⣸⣆⣰⠏⠛⣤⢸⡆⣄⠙⣠⠰⠉⢠⠘⣀⢀⡀⠈⠁⠀
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
    {
      key = "d",
      desc = "Open Neovim Config",
      action = "<cmd>FzfLua files cwd=~/.config/nvim<CR>",
    },
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
    date_gap = 5,
    plugin_info_gap = 5,
    shortcuts_top_offset = 1,
    plugin_info_offset = 1,
  },

  --- @private Unconfigurable
  maxw = 0,
  ns = nil,
  move_range = {},
}
