function FixMe()
    local conf = require("telescope.config").values
    local pickers = require "telescope.pickers"
    local finders = require "telescope.finders"
    local make_entry = require "telescope.make_entry"

    local rg = {"rg", "--vimgrep", "--trim", "telescope"}

    local opts = {
        entry_maker = make_entry.gen_from_vimgrep({})
    }

    local picker = pickers.new(
        opts, {
                prompt_title = "Fix Me",
                finder = finders.new_oneshot_job(rg, opts),
                previewer = conf.grep_previewer(opts),
                sorter = conf.file_sorter(opts),
        })
    picker:find()
end

vim.api.nvim_create_user_command("FixMe", FixMe, {})
