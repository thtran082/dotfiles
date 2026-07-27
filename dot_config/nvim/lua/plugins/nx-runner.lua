-- In-editor NX command runner.
--
-- A thin, self-contained wrapper over the `nx` CLI (no third-party plugin):
--   * a Telescope picker for projects -> targets,
--   * direct keymaps for the common loop against the current file's project,
--   * workspace-level affected / graph / generate.
-- Commands run in a snacks terminal split (snacks ships with LazyVim).
--
-- Keymaps live under the `<leader>nx` group to stay clear of the existing
-- ngswitcher (`<leader>nu/ni/no/np`) and package-info (`<leader>ns`) maps.

local M = {}

-- Locate the NX workspace root (nearest ancestor containing nx.json).
function M.root()
  local start = vim.fn.expand("%:p:h")
  if start == "" then
    start = vim.fn.getcwd()
  end
  local found = vim.fs.find("nx.json", { upward = true, path = start })[1]
  return found and vim.fs.dirname(found) or vim.fn.getcwd()
end

-- Prefer the workspace-local nx binary, then npx, then a global nx.
function M.bin(root)
  local local_bin = root .. "/node_modules/.bin/nx"
  if vim.fn.executable(local_bin) == 1 then
    return { local_bin }
  end
  if vim.fn.executable("nx") == 1 then
    return { "nx" }
  end
  return { "npx", "nx" }
end

-- Run an nx subcommand (table of args) in a terminal split rooted at the workspace.
function M.run(args)
  local root = M.root()
  local cmd = M.bin(root)
  vim.list_extend(cmd, args)
  if Snacks and Snacks.terminal then
    Snacks.terminal(cmd, { cwd = root, win = { position = "bottom" } })
  else
    vim.cmd("botright split | terminal " .. table.concat(cmd, " "))
  end
end

-- All projects in the workspace (one per line from `nx show projects`).
function M.projects()
  local root = M.root()
  local cmd = M.bin(root)
  vim.list_extend(cmd, { "show", "projects" })
  local out = vim.fn.systemlist(cmd)
  if vim.v.shell_error ~= 0 then
    vim.notify("nx show projects failed:\n" .. table.concat(out, "\n"), vim.log.levels.ERROR)
    return {}
  end
  return vim.tbl_filter(function(line)
    return line ~= ""
  end, out)
end

-- Target names defined on a project (`nx show project <p> --json`).
function M.targets(project)
  local root = M.root()
  local cmd = M.bin(root)
  vim.list_extend(cmd, { "show", "project", project, "--json" })
  local out = table.concat(vim.fn.systemlist(cmd), "\n")
  local ok, decoded = pcall(vim.json.decode, out)
  if not ok or type(decoded) ~= "table" or type(decoded.targets) ~= "table" then
    return {}
  end
  local names = vim.tbl_keys(decoded.targets)
  table.sort(names)
  return names
end

-- Project owning the current file: nearest ancestor project.json's "name".
function M.current_project()
  local start = vim.fn.expand("%:p:h")
  if start == "" then
    return nil
  end
  local found = vim.fs.find("project.json", { upward = true, path = start })[1]
  if not found then
    return nil
  end
  local ok, decoded = pcall(vim.json.decode, table.concat(vim.fn.readfile(found), "\n"))
  if ok and type(decoded) == "table" and decoded.name then
    return decoded.name
  end
  -- Fall back to the directory name of the project root.
  return vim.fs.basename(vim.fs.dirname(found))
end

-- Minimal Telescope single-select picker.
local function pick(title, items, on_choice)
  if vim.tbl_isempty(items) then
    vim.notify("nx: nothing to pick for " .. title, vim.log.levels.WARN)
    return
  end
  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf = require("telescope.config").values
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")
  pickers
    .new({}, {
      prompt_title = title,
      finder = finders.new_table({ results = items }),
      sorter = conf.generic_sorter({}),
      attach_mappings = function(bufnr)
        actions.select_default:replace(function()
          local entry = action_state.get_selected_entry()
          actions.close(bufnr)
          if entry then
            on_choice(entry[1])
          end
        end)
        return true
      end,
    })
    :find()
end

-- Pick a project, then one of its targets, then run it.
function M.pick_and_run()
  pick("NX Projects", M.projects(), function(project)
    pick("NX Targets: " .. project, M.targets(project), function(target)
      M.run({ "run", project .. ":" .. target })
    end)
  end)
end

-- Run <target> against the current file's project (no picker).
function M.run_current(target)
  local project = M.current_project()
  if not project then
    vim.notify("nx: could not resolve a project for the current file", vim.log.levels.WARN)
    return
  end
  M.run({ "run", project .. ":" .. target })
end

function M.affected()
  vim.ui.input({ prompt = "nx affected target: ", default = "test" }, function(target)
    if target and target ~= "" then
      M.run({ "affected", "-t", target })
    end
  end)
end

function M.generate()
  vim.ui.input({ prompt = "nx generate: ", default = "@nx/angular:component " }, function(spec)
    if spec and spec ~= "" then
      M.run(vim.list_extend({ "generate" }, vim.split(spec, "%s+")))
    end
  end)
end

return {
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      { "<leader>nx", "", desc = "+nx" },
      { "<leader>nxp", M.pick_and_run, desc = "NX projects/targets picker" },
      {
        "<leader>nxs",
        function()
          M.run_current("serve")
        end,
        desc = "NX serve (current project)",
      },
      {
        "<leader>nxb",
        function()
          M.run_current("build")
        end,
        desc = "NX build (current project)",
      },
      {
        "<leader>nxt",
        function()
          M.run_current("test")
        end,
        desc = "NX test (current project)",
      },
      {
        "<leader>nxl",
        function()
          M.run_current("lint")
        end,
        desc = "NX lint (current project)",
      },
      { "<leader>nxa", M.affected, desc = "NX affected" },
      {
        "<leader>nxg",
        function()
          M.run({ "graph" })
        end,
        desc = "NX graph",
      },
      { "<leader>nxG", M.generate, desc = "NX generate" },
    },
  },
}
