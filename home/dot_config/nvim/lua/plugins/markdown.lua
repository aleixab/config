-- lang.markdown extra: keep render-markdown, marksman and formatting (<leader>cf),
-- but no markdownlint diagnostics while writing
return {
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      opts.linters_by_ft = opts.linters_by_ft or {}
      opts.linters_by_ft.markdown = {}
    end,
  },
}
