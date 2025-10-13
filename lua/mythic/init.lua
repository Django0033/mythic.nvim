require('mythic.tables')
require('mythic.tables.action1')
require('mythic.tables.action2')
require('mythic.tables.descriptor1')
require('mythic.tables.descriptor2')
require('mythic.tables.adventure-tone')
require('mythic.tables.alien-species')
require('mythic.tables.animal-actions')
require('mythic.tables.army-descriptors')
require('mythic.tables.cavern-descriptors')
require('mythic.tables.characters')
require('mythic.tables.character-actions-combat')
require('mythic.tables.character-actions-general')
require('mythic.tables.character-appearance')
require('mythic.tables.character-background')
require('mythic.tables.character-conversations')
require('mythic.tables.character-descriptors')
require('mythic.tables.character-identity')
require('mythic.tables.character-motivations')
require('mythic.tables.character-personality')
require('mythic.tables.character-skills')
require('mythic.tables.character-traits-flaws')
require('mythic.tables.city-descriptors')
require('mythic.tables.civilization-descriptors')
require('mythic.tables.creature-abilities')
require('mythic.tables.creature-descriptors')
require('mythic.tables.cryptic-message')
require('mythic.tables.curses')
require('mythic.tables.domicile-descriptors')

M = {}

local function get_random_number(top_number)
    local random_number = math.random(1, top_number)

    return random_number
end

-- Gets a random element from a table
local function get_random_elemnt(tbl)
    -- Gets the table's size
    local size = #tbl

    if size == 0 then
        return nil
    end

    -- Sets random_index to a random number between 1 and the table size
    local random_index = get_random_number(size)

    -- Returns the element in the random_index from the table
    return tbl[random_index]
end

-- Prints 2 elements from tables
function M.print_table_elements(opts)
    local tbls_key = opts.fargs[1] -- Sets tbls_key to the arg passed by the user
    local tbl = TBLS[tbls_key] -- Sets tbl to the table in TBLS tbls_key
    local g_tbl = _G[opts.fargs[1]] -- _G is a table that lists global tables.

    if tbl then -- If tbl exists then
        print(get_random_elemnt(tbl[1]) .. ' / ' .. get_random_elemnt(tbl[2]))
    else
        local element1 = get_random_elemnt(g_tbl)
        local element2 = get_random_elemnt(g_tbl)

        print(element1 .. ' / ' .. element2)
    end
end

return M
