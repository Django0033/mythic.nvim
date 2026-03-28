# mythic.nvim

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

A Neovim plugin to use the Mythic Game Master Emulator (GME) 2nd Edition inside Neovim. Designed as a companion for tabletop RPG game masters who want on-the-fly improvisation tools.

[Mythic Game Master Emulator 2e](https://www.drivethrurpg.com/en/product/422929/mythic-game-master-emulator-second-edition)

## What is Mythic GME?

Mythic is a game master emulator that allows you to run RPGs without a prepared scenario. It uses randomized tables and dice rolls to generate story elements, NPC actions, and scene outcomes on the fly. Perfect for one-shots, creative brainstorming, or when you need to improvise.

## Requirements

- Neovim 0.8+

## Installation

### Using Lazy

```lua
-- Lua
{ 'Django0033/mythic.nvim' }
```

### Using Packer

```lua
-- Lua
use 'Django0033/mythic.nvim'
```

### Using Plug

```vim
" Vimscript
Plug 'Django0033/mythic.nvim'
```

## Quick Start

1. Install the plugin
2. Restart Neovim
3. Run `:MythicChaos 5` to set initial Chaos Factor
4. Start generating!

## Output Display

All commands display results in two ways:

1. **Message area** - Print output at the bottom of Neovim
2. **Floating window** - Results also appear in a centered floating window

### Keyboard Shortcuts

| Key | Action |
|-----|--------|
| `y` | Copy result to clipboard and close |
| `q` | Close window |
| `Esc` | Close window |

When you press `y`, the result is copied to:
- The system clipboard (`+` register)
- Vim's default register (`"` register)

A notification "Copied to clipboard!" will appear.

### Visual Example

```
┌────────────────── Mythic GME ──────────────────┐
│                                                │
│  Exceptional Yes [8+2+2=12]                   │
│  ⚠ Random Event!                             │
│                                                │
│  [y] Copy to clipboard [q] Close            │
└────────────────────────────────────────────────┘
```

## Commands

| Command | Description |
|---------|-------------|
| `:MythicTables <table>` | Prints 2 random elements from a table |
| `:MythicChaos` | Shows current Chaos Factor |
| `:MythicChaos +` | Increases Chaos Factor by 1 |
| `:MythicChaos -` | Decreases Chaos Factor by 1 |
| `:MythicChaos <n>` | Sets Chaos Factor to n (1-9) |
| `:MythicFateCheck [odds]` | 2d10 roll vs odds (default: 50/50) |
| `:MythicFateChart [odds]` | 1d100 percentile alternative system |
| `:MythicSceneTest` | Tests if scene is Expected, Altered, or Interrupted |
| `:MythicEventFocus` | Generates a Random Event Focus |
| `:MythicSceneAdjustment` | Generates a Scene Adjustment |

## Chaos Factor

The Chaos Factor (CF) represents the level of randomness in your game:

| CF | Effect |
|----|--------|
| 1 | Very Predictable (-5 modifier) |
| 2-3 | Predictable |
| 4-6 | Normal (default: 5) |
| 7-8 | Unpredictable |
| 9 | Chaotic (+5 modifier) |

Higher CF means more random events and scene interruptions.

## Odds Reference

When using `:MythicFateCheck` or `:MythicFateChart`, you can specify odds:

| Odds | Modifier |
|------|----------|
| Impossible | -5 |
| Nearly Impossible | -4 |
| Very Unlikely | -2 |
| Unlikely | -1 |
| 50/50 | 0 |
| Likely | +1 |
| Very Likely | +2 |
| Nearly Certain | +4 |
| Certain | +5 |

## Available Tables

Use `:MythicTables <name>` to access these tables:

| Table | Description |
|-------|-------------|
| `Actions` | Action verbs (2 elements) |
| `Descriptors` | Descriptive words (2 elements) |
| `AdventureTone` | Adventure themes and moods |
| `AlienSpecies` | Alien species types |
| `AnimalActions` | Animal/creature behaviors |
| `ArmyDescriptors` | Army/military descriptors |
| `CavernDescriptors` | Cave/cavern attributes |
| `Characters` | Character types and traits |
| `CharacterActionsCombat` | Combat actions |
| `CharacterActionsGeneral` | General actions |
| `CharacterAppearance` | Physical appearance |
| `CharacterBackground` | Backstory elements |
| `CharacterConversations` | Conversation types |
| `CharacterDescriptors` | Character traits |
| `CharacterIdentity` | Identity/role |
| `CharacterMotivations` | NPC motivations |
| `CharacterPersonality` | Personality traits |
| `CharacterSkills` | Skill types |
| `CharacterTraitsFlaws` | Traits and flaws |
| `CityDescriptors` | City attributes |
| `CivilizationDescriptors` | Civilization types |
| `CreatureAbilities` | Creature abilities |
| `CreatureDescriptors` | Creature traits |
| `CrypticMessage` | Mysterious messages |
| `Curses` | Curse types |
| `DomicileDescriptors` | Home/dwelling descriptors |
| `DungeonDescriptors` | Dungeon attributes |
| `DungeonTraps` | Trap types |
| `ForestDescriptors` | Forest/woods attributes |
| `Gods` | Deity types |
| `Legends` | Legendary elements |
| `Locations` | Location descriptors |
| `MagicItemDescriptors` | Magic item traits |
| `MutationDescriptors` | Mutation types |
| `Names` | Name syllables |
| `NobleHouse` | Noble house attributes |
| `Objects` | Object/item types |
| `PlotTwists` | Plot twist ideas |
| `Powers` | Supernatural powers |
| `ScavengingResults` | Loot/scavenging results |
| `Smells` | Smell descriptors |
| `Sounds` | Sound descriptors |
| `SpellEffects` | Magic effect types |
| `StarshipDescriptors` | Sci-fi ship attributes |
| `TerrainDescriptors` | Terrain types |
| `UndeadDescriptors` | Undead creature traits |
| `VisionsDreams` | Dream/vision content |

## Examples

### Generating a Scene

```vim
:MythicTables Locations
:MythicTables Descriptors
:MythicAdventureTone
```

Output example: "Dark / Dangerous / Horror"

### Running a Fate Check

```vim
:MythicFateCheck Likely
```

Output example: "Yes [8+2+2=12]"

### Testing Scene Continuity

```vim
:MythicSceneTest
```

Output example: "Expected Scene [7 vs CF 5]"

### Handling a Random Event

```vim
:MythicEventFocus
:MythicSceneAdjustment
```

Output example: "Dice roll: 35 - NPC Action"

### Floating Window

When you run any command, a floating window appears with the result:

```
┌────────────────── Mythic GME ──────────────────┐
│                                                │
│  Exceptional Yes [8+2+2=12]                   │
│  ⚠ Random Event!                             │
│                                                │
│  [q] Close                                   │
└────────────────────────────────────────────────┘
```

Press `q` or `Esc` to close the window.

## License

MIT

## Acknowledgments

- **Tana Pigeon** - Creator of the Mythic Game Master Emulator, the system this plugin brings to Neovim
- **John Stephens** - For contributing the `MythicChaos`, `MythicFateCheck`, and `MythicSceneTest` commands
- **All contributors** - For helping improve this plugin
