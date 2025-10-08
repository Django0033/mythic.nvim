-- Dice rolling utilities
local M = {}

function M.d10()
    return math.random(1, 10)
end

-- Check if two dice form a double (11, 22, 33, ..., 99, 100)
function M.is_double(die1, die2)
    return die1 == die2
end

-- Check if double triggers Random Event (single digit <= chaos_factor)
function M.triggers_random_event(die1, die2, chaos_factor)
    if M.is_double(die1, die2) then
        return die1 <= chaos_factor
    end
    return false
end

return M
