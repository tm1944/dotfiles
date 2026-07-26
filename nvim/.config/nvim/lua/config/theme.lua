local M = {}

local mode_file = vim.fn.expand("~/.config/theme-mode")
local watcher

local function read_mode()
  local file = io.open(mode_file, "r")
  if not file then
    return "light"
  end
  local mode = (file:read("*l") or "light"):gsub("%s+", "")
  file:close()
  return mode == "dark" and "dark" or "light"
end

local function flavour_for(mode)
  return mode == "dark" and "mocha" or "latte"
end

local function pink_for(mode)
  -- Catppuccin palette pinks
  return mode == "dark" and "#f5c2e7" or "#ea76cb"
end

function M.current()
  return read_mode()
end

function M.apply()
  local mode = read_mode()
  local flavour = flavour_for(mode)
  local ok_catppuccin, catppuccin = pcall(require, "catppuccin")
  if not ok_catppuccin then
    return mode
  end

  catppuccin.setup({
    flavour = flavour,
    background = { light = "latte", dark = "mocha" },
    transparent_background = false,
    term_colors = true,
    integrations = {
      cmp = true,
      gitsigns = true,
      mason = true,
      neotest = true,
      neotree = true,
      telescope = true,
      treesitter = true,
      which_key = true,
      dap = true,
      dap_ui = true,
      native_lsp = {
        enabled = true,
        underlines = {
          errors = { "undercurl" },
          hints = { "undercurl" },
          warnings = { "undercurl" },
          information = { "undercurl" },
        },
      },
    },
    custom_highlights = function(colors)
      return {
        LineNr = { fg = colors.pink, bold = true },
        CursorLineNr = { fg = colors.maroon, bold = true },
        Visual = { bg = colors.pink, fg = colors.base },
      }
    end,
  })

  vim.o.background = mode
  vim.cmd.colorscheme("catppuccin-" .. flavour)

  pcall(function()
    require("smear_cursor").setup({ cursor_color = pink_for(mode) })
  end)

  pcall(function()
    require("lualine").setup({
      options = {
        -- Flavour-specific theme names (there is no plain "catppuccin").
        theme = "catppuccin-" .. flavour,
        globalstatus = true,
        component_separators = "|",
        section_separators = "",
      },
      sections = {
        lualine_c = { { "filename", path = 1 }, "lsp_status" },
        lualine_x = { "diagnostics", "encoding", "fileformat", "filetype" },
      },
    })
  end)

  return mode
end

function M.toggle()
  local next_mode = read_mode() == "dark" and "light" or "dark"
  -- Shared CLI resets the tmux Catppuccin palette and notifies Neovim sockets.
  vim.fn.system({ "theme", next_mode })
  M.apply()
  vim.notify("theme: " .. next_mode, vim.log.levels.INFO)
end

function M.watch()
  if watcher or not vim.uv then
    return
  end
  if vim.fn.filereadable(mode_file) == 0 then
    vim.fn.writefile({ "light" }, mode_file)
  end
  watcher = vim.uv.new_fs_event()
  if not watcher then
    return
  end
  watcher:start(mode_file, {}, vim.schedule_wrap(function()
    M.apply()
  end))
end

return M
