-- Keymaps for better default experience
--  common options
local keymapOpts = { noremap = true, silent = true}

-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- set s key to Window moving.
vim.keymap.set('n', 's', '<NOP>')
-- set s+hjkl move to other window
vim.keymap.set('n', 'sj', '<C-w>j')
vim.keymap.set('n', 'sk', '<C-w>k')
vim.keymap.set('n', 'sl', '<C-w>l')
vim.keymap.set('n', 'sh', '<C-w>h')
-- set s+nptT move tab
vim.keymap.set('n', 'sn', 'gt')
vim.keymap.set('n', 'sp', 'gT')
vim.keymap.set('n', 'st', ':<C-u>tabnew<CR>')

-- change buffer size
vim.keymap.set('n', '<Space>h', '<C-w><', keymapOpts)
vim.keymap.set('n', '<Space>l', '<C-w>>', keymapOpts)
vim.keymap.set('n', '<Space>j', '<C-w>-', keymapOpts)
vim.keymap.set('n', '<Space>k', '<C-w>+', keymapOpts)

-- F3でハイライト表示を切り替え
vim.keymap.set('n', '<F3>', ':<C-u>set nohlsearch!<CR>', keymapOpts)
