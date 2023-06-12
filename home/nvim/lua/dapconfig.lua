require('dap-python').setup()
require("dapui").setup()

-- keybindings
vim.keymap.set('n', '<F8>', ":lua require('dap').step_over()<cr>")
vim.keymap.set('n', '<F9>', ":lua require('dap').continue()<cr>")
vim.keymap.set('n', '<F7>', ":lua require('dap').step_into()<cr>")
vim.keymap.set('n', '<Shift><F9>', ":lua require('dap').step_out()<cr>")
vim.keymap.set('n', '<leader>b', ":lua require('dap').toggle_breakpoint()<cr>")

local dap, dapui = require("dap"), require("dapui")
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

