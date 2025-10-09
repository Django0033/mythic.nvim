-- Fate Check (2d10 resolution system)
local dice = require('mythic.dice')
local state = require('mythic.state')

local M = {}

-- Odds modifiers (from Fate Check Modifiers table)
local ODDS_MODIFIERS = {
    ['Impossible'] = -5,
    ['Nearly Impossible'] = -4,
    ['Very Unlikely'] = -2,
    ['Unlikely'] = -1,
    ['50/50'] = 0,
    ['Likely'] = 1,
    ['Very Likely'] = 2,
    ['Nearly Certain'] = 4,
    ['Certain'] = 5,
}

-- Chaos Factor modifiers (from Fate Check Modifiers table)
local CHAOS_MODIFIERS = {
    [1] = -5,
    [2] = -4,
    [3] = -2,
    [4] = -1,
    [5] = 0,
    [6] = 1,
    [7] = 2,
    [8] = 4,
    [9] = 5,
}

function M.fate_check(odds)
    odds = odds or '50/50'

    -- Validate odds
    local odds_mod = ODDS_MODIFIERS[odds]
    if not odds_mod then
        return nil, 'Invalid odds: ' .. odds
    end

    -- Roll 2d10
    local die1 = dice.d10()
    local die2 = dice.d10()
    local base_total = die1 + die2

    -- Get modifiers
    local cf = state.get_chaos_factor()
    local chaos_mod = CHAOS_MODIFIERS[cf]
    local total_modifier = odds_mod + chaos_mod

    -- Final total
    local final = base_total + total_modifier

    -- Determine answer (bounded ranges for Exceptional)
    local answer, exceptional
    if final >= 18 and final <= 20 then
        answer, exceptional = 'Yes', true
    elseif final >= 11 then
        answer, exceptional = 'Yes', false
    elseif final >= 2 and final <= 4 then
        answer, exceptional = 'No', true
    else
        answer, exceptional = 'No', false
    end

    -- Check for Random Event
    local random_event = dice.triggers_random_event(die1, die2, cf)

    return {
        answer = answer,
        exceptional = exceptional,
        random_event = random_event,
        roll = {
            die1 = die1,
            die2 = die2,
            base = base_total,
            modifier = total_modifier,
            final = final
        }
    }
end

return M
