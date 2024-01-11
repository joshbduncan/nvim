-- OLD VERSION of FixMe that sent results to Telescope first...
-- Find dev comment tags and Markdown tasks using ripgrep.
-- All matches are sent to the quickfix list and opened in Telescope.
function FixMeTelescope()
    local conf = require("telescope.config").values
    local pickers = require "telescope.pickers"
    local finders = require "telescope.finders"
    local make_entry = require "telescope.make_entry"

    local tags = { "BUG", "HACK", "FIXME", "TODO", "\\[(\\s|x)\\]" }
    local comment_strings = "//|#|<!--|;|/\\*|-"
    local regex = "(" .. comment_strings .. ")\\s+(" .. table.concat(tags, "|") .. ")"

    local rg = { "rg", "--vimgrep", "--trim", regex }

    local opts = {
        entry_maker = make_entry.gen_from_vimgrep({}),

        attach_mappings = function(prompt_bufnr, map)
            map("i", "<C-r>", function(prompt_bufnr)
                print "You typed asdf"
            end)
            return true
        end,

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

vim.api.nvim_create_user_command("FixMeTelescope", FixMeTelescope, {})
