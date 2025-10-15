math.randomseed(os.time() + vim.fn.getpid())

local function get_odds_completion()
    return {
        'Impossible',
        'Nearly Impossible',
        'Very Unlikely',
        'Unlikely',
        '50/50',
        'Likely',
        'Very Likely',
        'Nearly Certain',
        'Certain'
    }
end

local function get_table_keys(leader, cmd, line)
    return {
        'Actions',
        'Descriptors',
        'AdventureTone',
        'AlienEspecies',
        'AnimalActions',
        'ArmyDescriptors',
        'CavernDescriptors',
        'Characters',
        'CharacterActionsCombat',
        'CharacterActionsGeneral',
        'CharacterAppearance',
        'CharacterBackground',
        'CharacterConversations',
        'CharacterDescriptors',
        'CharacterIdentity',
        'CharacterMotivations',
        'CharacterPersonality',
        'CharacterSkills',
        'CharacterTraitsFlaws',
        'CityDescriptors',
        'CivilizationDescriptors',
        'CreatureAbilities',
        'CreatureDescriptors',
        'CrypticMessage',
        'Curses',
        'DomicileDescriptors',
        'DungeonDescriptors',
        'DungeonTraps',
        'ForestDescriptors',
        'Gods',
        'Legends',
        'Locations',
        'MagicItemDescriptors',
        'MutationDescriptors',
        'Names',
        'NobleHouse',
    }
end

vim.api.nvim_create_user_command(
    'MythicTables',
    require('mythic').print_table_elements,
    {
        nargs = 1,
        complete = get_table_keys
    }
)

vim.api.nvim_create_user_command(
    'MythicEventFocus',
    require('mythic.random-event-focus').get_random_event_focus,
    {
        nargs = 0,
    }
)

-- MythicChaos command
vim.api.nvim_create_user_command('MythicChaos', function(opts)
    local state = require('mythic.state')
    local arg = opts.fargs[1]

    if not arg then
        print('Chaos Factor: ' .. state.get_chaos_factor())
    elseif arg == '+' then
        state.adjust_chaos_factor(1)
        print('Chaos Factor: ' .. state.get_chaos_factor())
    elseif arg == '-' then
        state.adjust_chaos_factor(-1)
        print('Chaos Factor: ' .. state.get_chaos_factor())
    else
        local value = tonumber(arg)
        if value then
            state.set_chaos_factor(value)
            print('Chaos Factor: ' .. state.get_chaos_factor())
        else
            vim.notify('Invalid argument. Use +, -, or a number.', vim.log.levels.ERROR)
        end
    end
end, { nargs = '?' })

-- MythicFateCheck command
vim.api.nvim_create_user_command('MythicFateCheck', function(opts)
    local fate = require('mythic.fate')
    local odds = opts.fargs[1] or '50/50'

    local result, err = fate.fate_check(odds)
    if not result then
        vim.notify(err, vim.log.levels.ERROR)
        return
    end

    -- Format output
    local output = result.exceptional and ('Exceptional ' .. result.answer) or result.answer
    output = output .. string.format(' [%d+%d%+d=%d]',
        result.roll.die1, result.roll.die2, result.roll.modifier, result.roll.final)

    if result.random_event then
        output = output .. ' ⚠ Random Event!'
    end

    print(output)
end, {
    nargs = '?',
    complete = get_odds_completion
})

-- MythicFateChart command
vim.api.nvim_create_user_command('MythicFateChart', function(opts)
    local fate = require('mythic.fate')
    local odds = opts.fargs[1] or '50/50'

    local result, err = fate.fate_chart(odds)
    if not result then
        vim.notify(err, vim.log.levels.ERROR)
        return
    end

    -- Format output
    local output = result.exceptional and ('Exceptional ' .. result.answer) or result.answer
    output = output .. string.format(' [d100=%d (%d,%d)]',
        result.roll.percentile, result.roll.die1, result.roll.die2)

    if result.random_event then
        output = output .. ' ⚠ Random Event!'
    end

    print(output)
end, {
    nargs = '?',
    complete = get_odds_completion
})

-- MythicSceneTest command
vim.api.nvim_create_user_command('MythicSceneTest', function()
    local scene = require('mythic.scene')
    local result = scene.test_scene()

    print(string.format('%s [%d vs CF %d]', result.result, result.roll, result.chaos_factor))
end, { nargs = 0 })
