return {
  {
    "Civitasv/cmake-tools.nvim",
    ft = { "c", "cpp", "cmake" },
    dependencies = { "nvim-lua/plenary.nvim", "akinsho/toggleterm.nvim" },
    opts = {
      cmake_command = "cmake",
      ctest_command = "ctest",
      cmake_use_preset = true,
      cmake_regenerate_on_save = true,
      cmake_generate_options = { "-DCMAKE_EXPORT_COMPILE_COMMANDS=1" },
      cmake_build_directory = "build/${variant:buildType}",
      cmake_compile_commands_options = {
        action = "soft_link",
        target = vim.uv.cwd,
      },
      cmake_dap_configuration = {
        name = "CMake target",
        type = "codelldb",
        request = "launch",
        stopOnEntry = false,
        runInTerminal = true,
      },
      cmake_executor = {
        name = "quickfix",
        default_opts = {
          quickfix = {
            show = "only_on_error",
            position = "belowright",
            size = 12,
            auto_close_when_success = true,
          },
        },
      },
      cmake_runner = {
        name = "terminal",
        default_opts = {
          terminal = {
            split_direction = "horizontal",
            split_size = 12,
            start_insert = false,
            focus = false,
            do_not_add_newline = false,
          },
        },
      },
    },
    keys = {
      { "<leader>mg", "<cmd>CMakeGenerate<CR>", desc = "CMake configure/generate" },
      { "<leader>mb", "<cmd>CMakeBuild<CR>", desc = "CMake build" },
      { "<leader>mt", "<cmd>CMakeSelectBuildTarget<CR>", desc = "Select build target" },
      { "<leader>mr", "<cmd>CMakeRun<CR>", desc = "Run CMake target" },
      { "<leader>md", "<cmd>CMakeDebug<CR>", desc = "Debug CMake target" },
      { "<leader>mc", "<cmd>CMakeClean<CR>", desc = "Clean CMake build" },
      { "<leader>mv", "<cmd>CMakeSelectBuildType<CR>", desc = "Select build type" },
      { "<leader>bk", "<cmd>make<CR>", desc = "Run make" },
    },
  },
  {
    "mfussenegger/nvim-dap",
    config = function()
      local dap = require("dap")
      local adapter = vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/adapter/codelldb"
      dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        executable = {
          command = adapter,
          args = { "--port", "${port}" },
        },
      }
      dap.configurations.cpp = {
        {
          name = "Launch executable",
          type = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.input("Executable: ", vim.uv.cwd() .. "/build/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
          runInTerminal = true,
        },
        {
          name = "Attach to process",
          type = "codelldb",
          request = "attach",
          pid = require("dap.utils").pick_process,
          cwd = "${workspaceFolder}",
        },
      }
      dap.configurations.c = dap.configurations.cpp
    end,
    keys = {
      { "<F5>", function() require("dap").continue() end, desc = "Debug continue/start" },
      { "<F10>", function() require("dap").step_over() end, desc = "Step over" },
      { "<F11>", function() require("dap").step_into() end, desc = "Step into" },
      { "<F12>", function() require("dap").step_out() end, desc = "Step out" },
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle breakpoint" },
      { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, desc = "Conditional breakpoint" },
      { "<leader>dl", function() require("dap").run_last() end, desc = "Run last debug session" },
      { "<leader>dr", function() require("dap").repl.open() end, desc = "Debug REPL" },
      { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate debugger" },
      { "<leader>du", function() require("dapui").toggle() end, desc = "Toggle debug UI" },
    },
    dependencies = {
      {
        "rcarriga/nvim-dap-ui",
        dependencies = { "nvim-neotest/nvim-nio" },
        opts = {},
        config = function(_, opts)
          local dap = require("dap")
          local dapui = require("dapui")
          dapui.setup(opts)
          dap.listeners.before.attach.dapui_config = function() dapui.open() end
          dap.listeners.before.launch.dapui_config = function() dapui.open() end
          dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
          dap.listeners.before.event_exited.dapui_config = function() dapui.close() end
        end,
      },
      {
        "theHamsta/nvim-dap-virtual-text",
        opts = { commented = true },
      },
    },
  },
  {
    "nvim-neotest/neotest",
    cmd = "Neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-neotest/nvim-nio",
      "nvim-treesitter/nvim-treesitter",
      "mfussenegger/nvim-dap",
      "orjangj/neotest-ctest",
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-ctest").setup({
            dap_adapter = "codelldb",
            frameworks = { "gtest" },
          }),
        },
        output = { open_on_run = true },
        quickfix = { open = false },
        status = { virtual_text = true, signs = true },
      })
    end,
    keys = {
      { "<leader>tn", function() require("neotest").run.run() end, desc = "Run nearest test" },
      { "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run test file" },
      { "<leader>ta", function() require("neotest").run.run(vim.uv.cwd()) end, desc = "Run all tests" },
      { "<leader>td", function() require("neotest").run.run({ strategy = "dap" }) end, desc = "Debug nearest test" },
      { "<leader>ts", function() require("neotest").summary.toggle() end, desc = "Test summary" },
      { "<leader>to", function() require("neotest").output.open({ enter = true }) end, desc = "Test output" },
      { "<leader>tO", function() require("neotest").output_panel.toggle() end, desc = "Test output panel" },
      { "<leader>tx", function() require("neotest").run.stop() end, desc = "Stop test" },
    },
  },
}
