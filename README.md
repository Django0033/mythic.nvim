# mythic.nvim
A small plugin to use Mythic GME 2 inside Neovim. This plugin is meant to be used as a companion for the Mythic Game Master Emulator by Tana Pigeon. If you want to know more about the rules, I'm leaving a link down here so you can grab a copy of the book. 

<https://www.drivethrurpg.com/en/product/422929/mythic-game-master-emulator-second-edition>

## Installation

### Using Lazy

| Branch | Code snippet                 |
|--------|:----------------------------:|
| Main   | { 'Django0033/mythic.nvim' } |


## Commands
- `MythicTables <table_name>`: Prints 2 elements from an specific table.

- `MythicChaos`: Prints the current Chaos Factor. You can use the `+` argument
to add 1 to the Chaos Factor or `-` to subtract 1. You can also pass a number as
an argument to set the Chaos Factor to that number.

- `MythicFateCheck`: Add the `?` argument to check the available odds arguments.
Prints a dice roll result adding the Chaos Factor modifier and a yes/no (or
exceptional yes/no) result. It also checks if there is a Random Event.

- `MythicFateChart`: A 1D100 percentile resolution system as an alternative to
  the Fate Check (2D10 system).

- `MythicSceneTest`: Rolls 1D10 and compares the result to current Chaos 
Factor to check if the scene will be as expected, altered or interrupted.

- `MythicEventFocus`: Rolls 1D100 and prints a result from the Random Event
  Focus table.

>>Special thanks to John Stephens for the `MythicChaos`, `MythicFateCheck`, and
>>`MythicSceneTest` commands. I really appreciate the help.

## TODO
- [ ] Add instructions to use the plugin in Vim
