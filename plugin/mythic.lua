math.randomseed(os.time() + vim.fn.getpid())

local function get_table_function_keys(leader, cmd, line)
    return {
        'Actions',
        'Descriptors',
        'AdventureTone',
    }
end

vim.api.nvim_create_user_command(
    'MythicTables',
    require('mythic').print_table_elements,
    {
        nargs = 1,
        complete = get_table_function_keys
    }
)
