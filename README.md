# Kanto Realism

**An adult, grounded total-conversion foundation for Gen1Recomp.**

Not sexual. Pokemon are resources that people hunt, trade, and steal. Vices exist. Theft has permanent consequences. This is the starting framework for a realistic Kanto experience.

![Badge](https://img.shields.io/badge/Gen1Recomp-Total%20Conversion-orange)

## Core Systems Implemented

- **Mid-battle theft tracking** — Detects when a Pokemon is caught during battle (player or opponent).
- **Permanent loss** — If the opponent steals one of your Pokemon and you lose, it is gone.
- **Jail for the thief** — Lose after you steal → wake in jail. Win after they try to steal yours → opponent jailed for 7 in-game days and unavailable.
- **Realistic items** — Cigarette, Beer, Street Pill registered with prices and descriptions.
- **Grounded dialogue overrides** — Oak’s speech and Pallet Town sign rewritten for tone.
- **Jail flags & daily release** — Trainers and player can be marked jailed; released after the configured days.
- **Trainer battle block** — Jailed trainers refuse battle via `trainer.before_battle`.

## Additional Realism Ideas (Ready for Expansion)

- Hunting encounters that drop meat/food items instead of pure capture.
- Alcohol/drug status effects (accuracy down, temporary stat changes, addiction flags).
- Police/NPC patrols that react to theft flags.
- Black-market traders who buy stolen Pokemon.
- Permanent party slots lost on death/theft.
- Economic pressure (rent, food costs, bribes).

## Installation

1. Import the mod zip in Gen1Recomp (**MODS → Import mod .zip**).
2. Enable **Kanto Realism**.
3. Start a new save for the cleanest experience (dialogue and flags are early-game oriented).

## Options

- **MID-BATTLE THEFT** — Master toggle
- **JAIL DAYS** — Length of trainer lockout (default 7)
- **PERMANENT LOSS ON DEFEAT** — Whether stolen Pokemon are removed on loss

## Extending to a Full New Game

This is a **foundation**, not a finished cart. Gen1Recomp’s Tutorial 12 (Mini Total Conversion) and Tutorial 07 (New Map) show how to:

- Register entirely new maps with `maps:register` and connections
- Add original NPCs, scripts, and quests
- Change starters, encounters, and progression
- Package as a sealed custom cart with Cartkit

Replace the stub jail warp and expand the theft AI, item effects, and dialogue tables as you build.

## Credits

Built on the Gen1Recomp mod API (events, hooks, registries, flags). Inspired by the desire for a grounded, consequence-heavy Pokemon experience.

Use responsibly. No Nintendo assets included.
