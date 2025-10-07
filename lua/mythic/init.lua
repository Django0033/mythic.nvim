require('mythic.tables')

M = {}

-- Gets a random element from a table
local function get_random_elemnt(tbl)
    -- Gets the table's size
    local size = #tbl

    if size == 0 then
        return nil
    end

    -- Sets random_index to a random number between 1 and the table size
    local random_index = math.random(1, size)

    -- Returns the element in the random_index from the table
    return tbl[random_index]
end

-- Prints 2 elements from tables
function M.print_table_elements(opts)
    -- Sets tbls_key to the arg passed by the user
    local tbls_key = opts.fargs[1]
    -- Sets tbl to the table in TBLS tbls_key
    local tbl = TBLS[tbls_key]

    if tbl then -- If tbl exists then
        print(get_random_elemnt(tbl[1]) .. ' / ' .. get_random_elemnt(tbl[2]))
    else
        -- Sets available_table to a string with TBLS keys separated by ','
        local available_table = table.concat(vim.tbl_keys(TBLS), ', ')
        -- Sets error_msg
        local error_msg = string.format(
            'Error: Unknown table. Available tables: %s',
            available_table
        )
        -- Sends error_msg to notifications and logs the error.
        vim.notify(error_msg, vim.log.levels.ERROR)
    end
end

return M
