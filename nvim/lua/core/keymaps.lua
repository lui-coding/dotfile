-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Swaps the current line with the line above or below
vim.keymap.set('n', '<A-j>', ':m+<CR>')
vim.keymap.set('n', '<A-k>', ':m-2<CR>')

vim.keymap.set('n', '<leader>e', function()
  local line = vim.fn.getline '.' -- 获取当前行文本
  local command = line:match '`(.-)`' -- 提取第一个 `` ` `` 包裹的内容
  if command then
    vim.cmd(command) -- 执行提取的命令
  else
    print 'No command found in backticks!'
  end
end, { noremap = true, silent = true })

vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Diagnostic keymaps
-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Use CTRL+<hjkl> to switch between windows
-- vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
-- vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
-- vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
-- vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

vim.keymap.set('n', '<leader>R', function()
  if vim.bo.filetype == 'java' then
    vim.cmd '!java-algs4 %'
  end
end, { desc = 'algs4 run ☕️' })

vim.keymap.set('n', '<leader>A', ':!java-algs4 %', { noremap = true, silent = false })
