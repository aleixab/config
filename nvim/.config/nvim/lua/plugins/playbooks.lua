return {
  {
    "folke/snacks.nvim",
    keys = {
      {
        "<leader>fP",
        function()
          Snacks.picker.pick({
            title = "Playbooks (tome)",
            finder = function()
              local home = vim.fn.expand("~")
              local files = vim.fn.systemlist("fd --type f --hidden --no-ignore --glob '.playbook.sh' " .. home)
              local items = {}
              for i, file in ipairs(files) do
                items[i] = { idx = i, score = 0, text = file, file = file }
              end
              return items
            end,
            format = "file",
            preview = "file",
            confirm = function(picker, item)
              picker:close()
              if item then
                vim.cmd.edit(item.file)
              end
            end,
          })
        end,
        desc = "Find Playbook (tome)",
      },
      {
        "<leader>sP",
        function()
          Snacks.picker.grep({
            title = "Search Playbooks (tome)",
            cwd = vim.fn.expand("~"),
            glob = ".playbook.sh",
            ignored = true,
            hidden = true,
          })
        end,
        desc = "Search Playbooks (tome)",
      },
    },
  },
}
