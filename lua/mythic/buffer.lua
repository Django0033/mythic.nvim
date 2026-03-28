local M = {}
local config = {
	width = 50,
	height = 10,
	border = "rounded",
	title = "Mythic GME",
	title_pos = "center",
}

local buf = nil
local win = nil
local is_open = false

local function create_buffer()
	if buf and vim.api.nvim_buf_is_valid(buf) then
		return buf
	end
	buf = vim.api.nvim_create_buf(false, true)
	return buf
end

local function calculate_position()
	local lines = vim.opt.lines:get()
	local columns = vim.opt.columns:get()

	local row = math.floor((lines - config.height) / 2) - 1
	local col = math.floor((columns - config.width) / 2) - 1

	return {
		relative = "editor",
		width = config.width,
		height = config.height,
		row = row,
		col = col,
	}
end

function M.show(content)
	local b = create_buffer()

	local lines = vim.split(content, "\n", { plain = true })
	table.insert(lines, "")
	table.insert(lines, "[y] Copy to clipboard [q] Close")

	vim.api.nvim_buf_set_lines(b, 0, -1, false, lines)

	if is_open and win and vim.api.nvim_win_is_valid(win) then
		vim.api.nvim_win_close(win, true)
	end

	local opts = calculate_position()
	opts.border = config.border
	opts.title = config.title
	opts.title_pos = config.title_pos

	win = vim.api.nvim_open_win(b, true, opts)
	is_open = true

	vim.bo[b].modifiable = false
	vim.bo[b].readonly = true

	vim.keymap.set("n", "q", function()
		M.close()
	end, { buffer = b, nowait = true })

	vim.keymap.set("n", "<Esc>", function()
		M.close()
	end, { buffer = b, nowait = true })

	vim.keymap.set("n", "y", function()
		local lines = vim.api.nvim_buf_get_lines(b, 0, -1, false)
		local content_to_copy = ""

		for _, line in ipairs(lines) do
			if line ~= "" and not line:match("%[q%]") then
				content_to_copy = content_to_copy .. line .. "\n"
			end
		end
		content_to_copy = content_to_copy:gsub("\n$", "")

		vim.fn.setreg("+", content_to_copy)
		vim.fn.setreg('"', content_to_copy)

		vim.notify("Copied to clipboard!", vim.log.levels.INFO)
		M.close()
	end, { buffer = b, nowait = true })
end

function M.close()
	if win and vim.api.nvim_win_is_valid(win) then
		vim.api.nvim_win_close(win, true)
		win = nil
	end
	is_open = false
end

function M.toggle()
	if is_open then
		M.close()
	else
		vim.notify("No content to display. Run a Mythic command first.", vim.log.levels.WARN)
	end
end

return M
