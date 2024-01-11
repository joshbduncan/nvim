-- run adobe extendscript files from neovim
function JSXRunner()
  -- app lookup table
  local app_lut = {
    illustrator = "Adobe\\ Illustrator",
    photoshop = "Adobe\\ Photoshop\\ 2024",
  }

  -- execute the current buffer code in target app
  local execute_in_target = function(target_str)
    os.execute(string.format("open -a %s %s", app_lut[target_str], F))
  end

  -- allow user to select the executing adobe app when a target isn't specified in the code
  local telescope_picker = function()
    local actions = require "telescope.actions"
    local action_state = require "telescope.actions.state"
    local pickers = require "telescope.pickers"
    local finders = require "telescope.finders"
    local conf = require("telescope.config").values

    local opts = require("telescope.themes").get_dropdown {}
    local picker = pickers.new(opts, {
      prompt_title = "Execute Script Where?",
      finder = finders.new_table {
        results = { "illustrator", "photoshop", }
      },
      sorter = conf.generic_sorter(opts),
      attach_mappings = function(prompt_bufnr, map)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          execute_in_target(selection[1])
        end)
        return true
      end,
    })

    return picker
  end

  -- check to see if a target is specified in the code
  local check_for_target = function(buf_num)
    buf_num = buf_num or 0

    -- search specified/current buffer for target
    local line_num = 0
    vim.api.nvim_buf_call(buf_num, function()
      line_num = vim.fn.search("\\(\\/\\/@\\|#\\)target", "n") - 1
    end)

    if (line_num > -1)
    then
      local content = vim.api.nvim_buf_get_lines(buf_num, line_num, line_num + 1, false)
      execute_in_target(string.match(content[1], "%s*%p*%a+%s(%a+)"))
    else
      telescope_picker():find()
    end
  end

  -- ensure the current buffer is save, and if not save as a temporary file
  local ensure_or_create_path = function()
    local f = vim.fn.expand("%:p")
    if (f == "")
    then
      f = string.format("/tmp/jsx_runner_%s.jsx", os.time())
      vim.api.nvim_command(string.format("write! %s", f))
    end
    return f
  end

  -- endure the current buffer is saved to disk
  F = ensure_or_create_path()
  if (vim.bo.filetype ~= "javascriptreact")
  then
    print("Error: Not an ExtendScript file.")
    return
  end
  check_for_target()
end

-- setup the nvim auto command
vim.api.nvim_create_user_command("JSXRunner", JSXRunner, {})
