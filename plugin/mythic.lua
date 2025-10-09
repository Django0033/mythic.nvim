math.randomseed(os.time())

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
