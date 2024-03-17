

require("nvim-tree").setup({

   update_focused_file = {
     enable = true,
     update_cwd = true,
   },
   renderer = {
     group_empty = true,
     root_folder_modifier = ":t",
  -- These icons are visible when you install web-devicons
     icons = {
       glyphs = {
         default = "",
         symlink = "",
         folder = {
           arrow_open = "",
           arrow_closed = "",
           default = "",
           open = "",
           empty = "",
           empty_open = "",
           symlink = "",
           symlink_open = "",
         },
         git = {
           unstaged = "",
           staged = "S",
           unmerged = "",
           renamed = "➜",
           untracked = "U",
           deleted = "",
           ignored = "◌",
         },
       },
     },
   },
   diagnostics = {
     enable = true,
     show_on_dirs = true,
     icons = {
       hint = "",
       info = "",
       warning = "",
       error = "",
     },
   },
 
})
