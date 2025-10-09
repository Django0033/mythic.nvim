-- Chaos Factor state management
local M = {}

-- Chaos Factor: 1-9, default 5
local chaos_factor = 5

function M.get_chaos_factor()
    return chaos_factor
end

function M.set_chaos_factor(value)
    chaos_factor = math.max(1, math.min(9, value))
end

function M.adjust_chaos_factor(delta)
    M.set_chaos_factor(chaos_factor + delta)
end

return M
