local dice = require('mythic.dice')

local M = {}

local SCENE_ADJUSTMENT_TABLE = {
    [1] = 'Remove a Character',
    [2] = 'Add a Character',
    [3] = 'Reduce/Remove an Activity',
    [4] = 'Increase an Activity',
    [5] = 'Remove an Object',
    [6] = 'Add an Object',
    [10] = 'Make 2 Adjustments',
}

function M.get_scene_adjustment()
    local roll = dice.d10()
    local limits = vim.tbl_keys(SCENE_ADJUSTMENT_TABLE) -- Creates a table with keys

    -- Sorts limits values from lower to higher
    table.sort(limits, function (a, b) return a < b end)

    for _, limit in ipairs(limits) do
        if roll <= limit then
            print('Dice roll: ' .. roll .. ' - ' .. SCENE_ADJUSTMENT_TABLE[limit])
            return
        end
    end

    return nil
end

return M
