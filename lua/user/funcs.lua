function JSXRunner()
  local f = vim.fn.expand("%:p")
  if (f == "")
  then
    f = string.format("/tmp/jsx_runner_%s.jsx", os.time())
    vim.api.nvim_command(string.format("write! %s", f))
  end
  if (vim.bo.filetype ~= "javascriptreact")
  then
    print("Error: Not an ExtendScript file.")
    return
  end
  os.execute(string.format("open -a Adobe\\ Illustrator %s", f))
end

vim.api.nvim_create_user_command("JSXRunner", JSXRunner, {})

function FixMe()
  local conf = require("telescope.config").values
  local pickers = require "telescope.pickers"
  local finders = require "telescope.finders"
  local make_entry = require "telescope.make_entry"

  local tags={"BUG", "HACK", "FIXME", "TODO", "\\[(\\s|x)\\]"}
  local comment_strings="//|#|<!--|;|/\\*|-\\s"
  local regex = "(" .. comment_strings .. ")\\s*(" .. table.concat(tags, "|") .. ")"

  print(regex)

  local rg = {"rg", "--vimgrep", "--trim", regex}

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