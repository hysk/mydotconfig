-- common options
local keymapOpts = { noremap = true, silent = true }

-- キーマップのラップ関数
local function my_map(mode, lhs, rhs, option, desc)
	vim.keymap.set(mode, lhs, rhs, vim.tbl_extend("force", option, { desc = desc }))
end

-- 汎用キーを事前に無効化
my_map("n", "s", "<NOP>", keymapOpts, "")
my_map({ "n", "v" }, "<Space>", "<Nop>", keymapOpts, "")

-- バッファ移動
my_map("n", "sj", "<C-w>j", keymapOpts, "Move to window below")
my_map("n", "sk", "<C-w>k", keymapOpts, "Move to window above")
my_map("n", "sl", "<C-w>l", keymapOpts, "Move to window right")
my_map("n", "sh", "<C-w>h", keymapOpts, "Move to window left")
my_map("n", "sH", "<C-w>t", keymapOpts, "Move to top window")

-- タブ移動
my_map("n", "sn", "gt", keymapOpts, "Move to next tab")
my_map("n", "sp", "gT", keymapOpts, "Move to previous tab")
my_map("n", "st", ":<C-u>tabnew<CR>", keymapOpts, "New tab")

-- バッファいサイズ変更
my_map("n", "<Space>h", "<C-w><", keymapOpts, "Change buffer size")
my_map("n", "<Space>l", "<C-w>>", keymapOpts, "Change buffer size")
my_map("n", "<Space>j", "<C-w>-", keymapOpts, "Change buffer size")
my_map("n", "<Space>k", "<C-w>+", keymapOpts, "Change buffer size")

-- F3でハイライト表示を切り替え
my_map("n", "<F3>", ":<C-u>set nohlsearch!<CR>", keymapOpts, "Toggle search highlight")

-- F8: init.luaの編集
my_map("n", "<F8>", ":e ~/.config/nvim/init.lua<CR>", keymapOpts, "Edit init.lua")
