function JSXRunnerOld()
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
  
  vim.api.nvim_create_user_command("JSXRunnerOld", JSXRunnerOld, {})