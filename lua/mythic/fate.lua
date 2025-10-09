-- Fate Check (2d10 resolution system) and Fate Chart (1d100 resolution system)
local dice = require('mythic.dice')
local state = require('mythic.state')

local M = {}

-- Unified odds configuration (from Fate Check Modifiers table)
-- Array preserves order for indexing; each entry contains level name and Fate Check modifier
local ODDS = {
    {level = 'Impossible',        modifier = -5},
    {level = 'Nearly Impossible', modifier = -4},
    {level = 'Very Unlikely',     modifier = -2},
    {level = 'Unlikely',          modifier = -1},
    {level = '50/50',             modifier =  0},
    {level = 'Likely',            modifier =  1},
    {level = 'Very Likely',       modifier =  2},
    {level = 'Nearly Certain',    modifier =  4},
    {level = 'Certain',           modifier =  5},
}

-- Fate Chart matrix [odds_index][chaos_factor] = {exceptional_yes, yes, exceptional_no}
-- nil for exceptional thresholds means no exceptional result possible (marked as "X" in rulebook)
local FATE_CHART = {
    -- Impossible
    {
        {nil, 1, 81}, {nil, 1, 81}, {nil, 1, 81}, {1, 5, 82}, {2, 10, 83},
        {3, 15, 84}, {5, 25, 86}, {7, 35, 88}, {10, 50, 91}
    },
    -- Nearly Impossible
    {
        {nil, 1, 81}, {nil, 1, 81}, {1, 5, 82}, {2, 10, 83}, {3, 15, 84},
        {5, 25, 86}, {7, 35, 88}, {10, 50, 91}, {13, 65, 94}
    },
    -- Very Unlikely
    {
        {nil, 1, 81}, {1, 5, 82}, {2, 10, 83}, {3, 15, 84}, {5, 25, 86},
        {7, 35, 88}, {10, 50, 91}, {13, 65, 94}, {15, 75, 96}
    },
    -- Unlikely
    {
        {1, 5, 82}, {2, 10, 83}, {3, 15, 84}, {5, 25, 86}, {7, 35, 88},
        {10, 50, 91}, {13, 65, 94}, {15, 75, 96}, {17, 85, 98}
    },
    -- 50/50
    {
        {2, 10, 83}, {3, 15, 84}, {5, 25, 86}, {7, 35, 88}, {10, 50, 91},
        {13, 65, 94}, {15, 75, 96}, {17, 85, 98}, {18, 90, 99}
    },
    -- Likely
    {
        {3, 15, 84}, {5, 25, 86}, {7, 35, 88}, {10, 50, 91}, {13, 65, 94},
        {15, 75, 96}, {17, 85, 98}, {18, 90, 99}, {19, 95, 100}
    },
    -- Very Likely
    {
        {5, 25, 86}, {7, 35, 88}, {10, 50, 91}, {13, 65, 94}, {15, 75, 96},
        {17, 85, 98}, {18, 90, 99}, {19, 95, 100}, {20, 99, nil}
    },
    -- Nearly Certain
    {
        {7, 35, 88}, {10, 50, 91}, {13, 65, 94}, {15, 75, 96}, {17, 85, 98},
        {18, 90, 99}, {19, 95, 100}, {20, 99, nil}, {20, 99, nil}
    },
    -- Certain
    {
        {10, 50, 91}, {13, 65, 94}, {15, 75, 96}, {17, 85, 98}, {18, 90, 99},
        {19, 95, 100}, {20, 99, nil}, {20, 99, nil}, {20, 99, nil}
    },
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

-- Helper: Find odds entry by level string, returns {index, entry} or {nil, error}
local function find_odds(odds_level)
    odds_level = odds_level or '50/50'
    for i, odds_entry in ipairs(ODDS) do
        if odds_entry.level == odds_level then
            return i, odds_entry
        end
    end
    return nil, 'Invalid odds: ' .. odds_level
end

function M.fate_check(odds_level)
    -- Find and validate odds
    local odds_index, odds_entry = find_odds(odds_level)
    if not odds_index then
        return nil, odds_entry  -- odds_entry contains error message
    end

    -- Roll 2d10
    local die1 = dice.d10()
    local die2 = dice.d10()
    local base_total = die1 + die2

    -- Get modifiers
    local cf = state.get_chaos_factor()
    local chaos_mod = CHAOS_MODIFIERS[cf]
    local total_modifier = odds_entry.modifier + chaos_mod

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

function M.fate_chart(odds_level)
    -- Find and validate odds
    local odds_index, odds_entry = find_odds(odds_level)
    if not odds_index then
        return nil, odds_entry  -- odds_entry contains error message
    end

    -- Roll 2d10 as percentile dice
    local die1 = dice.d10()  -- Tens digit
    local die2 = dice.d10()  -- Ones digit

    -- Convert to 1-100 range (treating 10 as 0 for tens place)
    local tens = (die1 == 10) and 0 or die1
    local roll = tens * 10 + die2  -- Results in 1-100

    -- Get Chaos Factor and lookup thresholds
    local cf = state.get_chaos_factor()
    local thresholds = FATE_CHART[odds_index][cf]
    local exceptional_yes_threshold = thresholds[1]  -- may be nil
    local yes_threshold = thresholds[2]
    local exceptional_no_threshold = thresholds[3]  -- may be nil

    -- Determine answer
    local answer, exceptional
    if exceptional_yes_threshold and roll <= exceptional_yes_threshold then
        answer, exceptional = 'Yes', true
    elseif roll <= yes_threshold then
        answer, exceptional = 'Yes', false
    elseif exceptional_no_threshold and roll >= exceptional_no_threshold then
        answer, exceptional = 'No', true
    else
        answer, exceptional = 'No', false
    end

    -- Check for Random Event (doubles where single digit <= CF)
    local random_event = dice.triggers_random_event(die1, die2, cf)

    return {
        answer = answer,
        exceptional = exceptional,
        random_event = random_event,
        roll = {
            die1 = die1,
            die2 = die2,
            percentile = roll,
            thresholds = {
                exceptional_yes = exceptional_yes_threshold,
                yes = yes_threshold,
                exceptional_no = exceptional_no_threshold
            }
        }
    }
end

return M
