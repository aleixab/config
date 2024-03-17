require("neotest").setup({
  adapters = {
    require("neotest-scala")({
        -- Can be a function to return dynamic value.
        -- For backwards compatibility, it also tries to read the vim-test scala config.
        -- Possibly values bloop|sbt.
        runner = "sbt",
        -- Test framework to use. Will use utest by default.
        -- Can be a function to return dynamic value.
        -- Possibly values utest|munit|scalatest.
        framework = "scalatest",
    })
  }
})

