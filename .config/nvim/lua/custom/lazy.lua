require("lazy").setup(
    {
        { import = "custom.plugins" },
        { import = "custom.plugins.lsp" },
        { import = "custom.plugins.linters" },
    },
    {
        checker = {
            enabled = true,
            notify = false
        },
        change_detection = {
            enable = true,
            notify = false
        }
    }
)
