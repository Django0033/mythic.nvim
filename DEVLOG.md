# mythic.nvim Development Log

## Project Overview

**mythic.nvim** is a Neovim plugin to use the Mythic Game Master Emulator (GME) 2e system inside Neovim. It's designed as a companion for the Mythic Game Master Emulator by Tana Pigeon.

[Mythic Game Master Emulator 2e](https://www.drivethrurpg.com/en/product/422929/mythic-game-master-emulator-second-edition)

---

## Project Structure

```
mythic.nvim/
├── lua/mythic/
│   ├── init.lua              # Entry point, loads tables and main function
│   ├── dice.lua              # Dice rolling utilities (d10, doubles)
│   ├── state.lua             # Chaos Factor state management (1-9)
│   ├── fate.lua              # Fate Check (2d10) and Fate Chart (1d100) resolution
│   ├── scene.lua             # Scene Test vs Chaos Factor
│   ├── random-event-focus.lua # Random Event Focus table
│   ├── scene-adjustment.lua  # Scene Adjustment table
│   └── tables/               # ~45+ data tables for random generation
│       ├── action1.lua, action2.lua
│       ├── descriptor1.lua, descriptor2.lua
│       ├── characters.lua, locations.lua, objects.lua
│       ├── creature-descriptors.lua, creature-abilities.lua
│       ├── names.lua
│       ├── gods.lua, legends.lua
│       └── ... (many more)
└── plugin/mythic.lua         # User command registration
```

---

## Current Features

### Commands

| Command | Description |
|---------|-------------|
| `MythicTables <table>` | Prints 2 elements from a table with index (e.g., Locations -> 15 Abandoned / 42 Dangerous) |
| `MythicChaos [+/-/n]` | Display/adjust Chaos Factor |
| `MythicFateCheck [odds]` | 2d10 roll + modifiers vs odds |
| `MythicFateChart [odds]` | 1d100 percentile alternative system |
| `MythicSceneTest` | Test if scene is Expected, Altered, or Interrupted |
| `MythicEventFocus` | Generate Random Event Focus |
| `MythicSceneAdjustment` | Generate Scene Adjustment |

### Odds Levels

- Impossible (-5)
- Nearly Impossible (-4)
- Very Unlikely (-2)
- Unlikely (-1)
- 50/50 (0)
- Likely (+1)
- Very Likely (+2)
- Nearly Certain (+4)
- Certain (+5)

### Core Systems

1. **Dice System** (`dice.lua`): d10 rolling, double detection, random event triggers
2. **Chaos Factor** (`state.lua`): Manages values 1-9, affects all rolls
3. **Fate Check** (`fate.lua`): 2d10 resolution with modifiers and Chaos Factor
4. **Fate Chart** (`fate.lua`): 1d100 percentile resolution system
5. **Scene Test** (`scene.lua`): Determines scene outcome based on Chaos Factor

### Data Tables (45+)

- Actions (Action1, Action2)
- Descriptors (Descriptor1, Descriptor2)
- Characters (various attributes)
- Creatures (descriptors, abilities)
- Locations, Cities, Dungeons, Forests, Caverns
- Objects, Magic Items
- Gods, Legends
- And many more...

---

## Architecture Notes

### State Management
- Chaos Factor is stored in memory during session (default: 5)
- Range: 1-9, clamped automatically

### Random Number Generation
- Seeded with `os.time() + vim.fn.getpid()` in `plugin/mythic.lua`

### Table Structure
- Tables are global Lua tables (e.g., `Action1`, `Characters`)
- Some tables are paired (Action1+Action2, Descriptor1+Descriptor2)
- Tables are loaded via `require` in `init.lua`

---

## Future Possibilities

Ordered by dependency - each feature builds upon previous ones.

### Phase 1: Core Generators (Low Complexity)

#### 1. Complete Name Generator
- **Depends on**: Existing tables (names.lua)
- **Complexity**: Low
- **Estimated Lines**: 30-50

Combines syllables from `names.lua` with optional prefixes/suffixes to generate complete fantasy names.

```lua
-- Concept
local function generate_name(style)
    -- style: "fantasy", "sci-fi", "alien", etc.
    local prefix = get_random_elemnt(name_prefixes[style])
    local syllable1 = get_random_elemnt(Names)
    local syllable2 = get_random_elemnt(Names)
    local suffix = get_random_elemnt(name_suffixes[style])
    return prefix .. syllable1 .. syllable2 .. suffix
end
```

---

#### 2. Encounter Generator
- **Depends on**: Feature 1 (Name Generator)
- **Complexity**: Low
- **Estimated Lines**: 40-50

Generates a complete encounter by combining:
- Creature descriptor
- Creature ability
- Animal/creature action
- Optional name (from Feature 1)

```lua
function M.generate_encounter()
    local descriptor = get_random_elemnt(CreatureDescriptors)
    local ability = get_random_elemnt(CreatureAbilities)
    local action = get_random_elemnt(AnimalActions)
    local name = generate_name("creature")  -- Feature 1

    return {
        name = name,
        descriptor = descriptor,
        ability = ability,
        action = action
    }
end
```

---

#### 3. Complete Character Generator
- **Depends on**: Feature 1 + 2
- **Complexity**: Low
- **Estimated Lines**: 50-70

Generates a full NPC/PC with:
- Name (from Feature 1)
- Appearance
- Background
- Personality
- Motivation
- Identity
- Skills
- Optional: combat actions (from Feature 2)

```lua
function M.generate_character()
    return {
        name = generate_name(),           -- Feature 1
        appearance = get_random_elemnt(CharacterAppearance),
        background = get_random_elemnt(CharacterBackground),
        personality = get_random_elemnt(CharacterPersonality),
        motivation = get_random_elemnt(CharacterMotivations),
        identity = get_random_elemnt(CharacterIdentity),
        skill = get_random_elemnt(CharacterSkills),
        combat_action = get_random_elemnt(CharacterActionsCombat)
    }
end
```

---

#### 4. Scene Generator
- **Depends on**: Feature 3 (Character Generator)
- **Complexity**: Low
- **Estimated Lines**: 40-50

Generates a complete scene with:
- Location descriptor
- Location type
- Optional: characters present (from Feature 3)

```lua
function M.generate_scene(include_characters)
    local scene = {
        location = get_random_elemnt(Locations),
        descriptor1 = get_random_elemnt(Descriptor1),
        descriptor2 = get_random_elemnt(Descriptor2),
        tone = get_random_elemnt(AdventureTone)
    }

    if include_characters then
        scene.characters = {
            generate_character(),  -- Feature 3
            generate_character()
        }
    end

    return scene
end
```

---

### Phase 2: UI and State (Medium Complexity)

#### 5. Roll History
- **Depends on**: Any roll command
- **Complexity**: Medium
- **Estimated Lines**: 50-70

Stores last N rolls in memory with timestamps.

```lua
local History = {
    max_size = 50,
    rolls = {}
}

function M.record_roll(roll_type, result)
    table.insert(History.rolls, {
        type = roll_type,
        result = result,
        timestamp = os.time()
    })

    if #History.rolls > History.max_size then
        table.remove(History.rolls, 1)
    end
end

function M.get_history()
    return History.rolls
end
```

---

#### 6. Dedicated Buffer (Floating Window)
- **Depends on**: Feature 5 (History)
- **Complexity**: Medium
- **Estimated Lines**: 80-120
- **Status**: ✅ IMPLEMENTED

Displays results in a formatted floating window with:
- Current Chaos Factor
- Recent rolls
- Generated content history

**Implemented Features:**
- Floating window centered on screen
- Title: "Mythic GME"
- Rounded border
- Keyboard shortcuts:
  - `y`: Copy result to clipboard and close
  - `<CR>` / `<Enter>`: Copy to clipboard, paste in buffer, and close
  - `q`: Close window
  - `Esc`: Close window
  - Copy to both `+` (system clipboard) and `"` (Vim default) registers
- Paste using Vim's native `p` command (cursor moves correctly)
- Confirmation notification on copy/paste
- Bug fix: Buffer deletion and recreation to prevent "not modifiable" error on reuse

**Technical Notes:**
```lua
-- Keymap for paste functionality (<CR> and <Enter>)
vim.keymap.set("n", "<CR>", function()
    if not user_buf or not vim.api.nvim_buf_is_valid(user_buf) then
        vim.notify("No valid buffer to paste into", vim.log.levels.WARN)
        M.close()
        return
    end

    local flines = vim.api.nvim_buf_get_lines(b, 0, -1, false)
    local content = ""
    for _, line in ipairs(flines) do
        if line ~= "" and not line:match("%[y%]") and not line:match("%[CR%]") and not line:match("%[%]") then
            content = content .. line .. "\n"
        end
    end
    content = content:gsub("\n$", "")

    vim.fn.setreg("+", content)

    vim.fn.win_execute(user_win, 'normal! "+p')
    
    vim.notify("Pasted!", vim.log.levels.INFO)
    M.close()
end, { buffer = b, nowait = true })
```

**File:** `lua/mythic/buffer.lua` (158 lines)

---

#### 7. Thread/Plot Tracking
- **Depends on**: Feature 6 (Buffer)
- **Complexity**: High
- **Estimated Lines**: 100-150

Manages story threads and plots:
- Create new threads
- Link threads to events
- Track thread status (open, closed, resolved)

```lua
local Threads = {
    active = {},
    closed = {}
}

function M.create_thread(name, description)
    local thread = {
        id = #Threads.active + 1,
        name = name,
        description = description,
        events = {},
        status = "open",
        created = os.time()
    }
    table.insert(Threads.active, thread)
    return thread
end

function M.add_event_to_thread(thread_id, event)
    -- Link random events to threads
end

function M.close_thread(thread_id)
    -- Move from active to closed
end
```

---

#### 8. Interrupt System
- **Depends on**: Feature 4 (Scene) + Feature 7 (Threads)
- **Complexity**: High
- **Estimated Lines**: 100-150

Predefined responses for interrupted scenes:
- Random event triggers interrupt
- System suggests resolution based on active threads

```lua
local INTERRUPT_PRESETS = {
    "Ambush",
    "Natural Disaster",
    "Betrayal",
    "Supply Loss",
    "Weather Change",
    "Enemy Reinforcements",
    -- ... more presets
}

function M.handle_interrupt(scene, active_threads)
    local interrupt = get_random_elemnt(INTERRUPT_PRESETS)

    -- Suggest resolution based on threads
    local related_thread = find_related_thread(interrupt, active_threads)

    return {
        interrupt = interrupt,
        suggested_resolution = generate_resolution(interrupt, related_thread)
    }
end
```

---

### Phase 3: Persistence and Export (Medium-High Complexity)

#### 9. State Persistence
- **Depends on**: Feature 7 + 8
- **Complexity**: Medium
- **Estimated Lines**: 40-60

Saves Chaos Factor and session state between Neovim sessions using vim options.

```lua
function M.save_state()
    local data = {
        chaos_factor = state.get_chaos_factor(),
        threads = Threads,
        -- other state
    }
    vim.fn.mkdir(vim.fn.stdpath("data") .. "/mythic", "p")
    vim.fn.writefile(
        vim.fn.stdpath("data") .. "/mythic/state.json",
        vim.fn.json_encode(data)
    )
end

function M.load_state()
    local path = vim.fn.stdpath("data") .. "/mythic/state.json"
    if vim.fn.filereadable(path) == 1 then
        local data = vim.fn.json_decode(vim.fn.readfile(path))
        -- restore state
    end
end
```

---

#### 10. Session Export/Import
- **Depends on**: Feature 9 (Persistence)
- **Complexity**: High
- **Estimated Lines**: 80-100

Export and import complete game sessions.

```lua
function M.export_session(path)
    local session = {
        chaos_factor = state.get_chaos_factor(),
        threads = Threads,
        history = History,
        scenes = GeneratedScenes,
        timestamp = os.time()
    }
    vim.fn.writefile(path, vim.fn.json_encode(session))
end

function M.import_session(path)
    local session = vim.fn.json_decode(vim.fn.readfile(path))
    -- restore all state
end
```

---

### Phase 4: Utilities and Advanced UI

#### 11. Help Command
- **Depends on**: Existing documentation
- **Complexity**: Medium
- **Estimated Lines**: 40-50

Displays available odds, commands, and usage.

```vim
:MythicHelp
```

Shows:
- All available odds levels
- All commands with descriptions
- Quick reference for Chaos Factor effects

---

#### 12. Advanced UI
- **Depends on**: All previous features
- **Complexity**: Very High
- **Estimated Lines**: 150-250

Full interactive UI with:
- Floating windows for all generators
- Syntax highlighting for results
- Interactive menus for selecting options
- Keybindings for quick access

---

## Development Priority Recommendation

1. **Start with Features 1-4**: These build the core generation system
2. **Add Feature 5**: History is useful immediately
3. **Feature 11 (Help)**: Can be done in parallel, low dependency
4. **Feature 6 (Buffer)**: ✅ COMPLETED - Floating window with copy
5. **Features 7-8**: Add UI and story tracking
6. **Features 9-10**: Add persistence
7. **Feature 12**: Final polish

---

## Technical Considerations

### Performance
- Tables are loaded once at startup
- Random selection is O(1) with table indexing
- History can grow unbounded - consider max size

### Extensibility
- New tables can be added easily
- Generator functions should be modular
- Consider a registry pattern for generators

### Testing
- No test framework currently in place
- Consider adding tests for dice, fate, and generators

---

## Contributing

Contributions are welcome! Please ensure:
- Code follows existing Lua style
- New tables follow naming conventions
- Commands are registered in `plugin/mythic.lua`
- Update documentation accordingly

---

*Last Updated: 2026*
