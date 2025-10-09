-- Scene Testing
local dice = require('mythic.dice')
local state = require('mythic.state')

local M = {}

function M.test_scene()
    local roll = dice.d10()
    local cf = state.get_chaos_factor()

    local result
    if roll > cf then
        result = 'Expected Scene'
    elseif roll % 2 == 1 then  -- Odd: 1, 3, 5, 7, 9
        result = 'Altered Scene'
    else  -- Even: 2, 4, 6, 8
        result = 'Interrupt Scene'
    end

    return {
        result = result,
        roll = roll,
        chaos_factor = cf
    }
end

return M
