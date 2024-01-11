-- Find dev comment tags and Markdown tasks using ripgrep.
-- All matches are sent to the quickfix list and opened in Telescope.
function FixMe()
    if (vim.fn.executable("rg") == 0)
    then
        print("Executable rg (ripgrep) not found. Install and rerun.")
        return
    end

    local tags = { "BUG", "HACK", "FIXME", "TODO", "\\[\\s\\]", "\\[x\\]" }
    local comment_strings = { "/*", "\\#", "<!--", ";", "-" }
    local regex = "'(" .. table.concat(comment_strings, "\\|") .. ")\\s+(" .. table.concat(tags, "\\|") .. ")'"

    vim.o.grepprg = "rg --vimgrep --trim"
    vim.cmd("silent grep! " .. regex)
    vim.cmd("Telescope quickfix")
end

vim.api.nvim_create_user_command("FixMe", FixMe, {})
