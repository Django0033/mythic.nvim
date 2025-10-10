local dice = require('mythic.dice')

local M = {}

local RANDOM_EVENT_FOCUS = {
    [5] = 'Remote Event',
    [10] = 'Ambiguous Event',
    [20] = 'New NPC',
    [40] = 'NPC Action',
    [45] = 'NPC Negative',
    [50] = 'NPC Positive',
    [55] = 'Move Towards a Thread',
    [65] = 'Move Away from a Thread',
    [70] = 'Close a Thread',
    [80] = 'PC Negative',
    [85] = 'PC Positive',
    [100] = 'Current Context',
}

function M.get_random_event_focus()
    local die1 = dice.d10()
    local die2 = dice.d10()
    local tens = (die1 == 10) and 0 or die1
    local roll = tens * 10 + die2  -- Results in 1-100
    local limits = vim.tbl_keys(RANDOM_EVENT_FOCUS) -- Creates a table with keys

    -- Sorts limits values from lower to higher
    table.sort(limits, function (a, b) return a < b end)

    for _, limit in ipairs(limits) do
        if roll <= limit then
            print('Dice roll: ' .. roll .. ' - ' .. RANDOM_EVENT_FOCUS[limit])
            return
        end
    end

    return nil
end

return M
