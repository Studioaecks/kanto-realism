return function(mod)
  -- Kanto Realism — adult, grounded foundation for a new Gen1Recomp experience.
  -- Not sexual. Pokemon are resources, people have vices, theft has consequences.

  local JAIL_DAYS = 7
  local stolenThisBattle = { player = false, opponent = false }
  local jailedTrainers = {} -- trainerId -> releaseDay

  -- Realistic items
  mod.content.items:register("CIGARETTE", {
    name = "Cigarette",
    price = 200,
    hold = false,
    description = "A cigarette. Temporary calm, long-term cost.",
  })
  mod.content.items:register("BEER", {
    name = "Beer",
    price = 350,
    hold = false,
    description = "Cheap beer. Lowers accuracy, raises recklessness.",
  })
  mod.content.items:register("PILLL", {
    name = "Street Pill",
    price = 800,
    hold = false,
    description = "Unregulated. Short boost, high risk.",
  })

  -- Dialogue overrides for grounded tone
  mod.content.text:override("_OakSpeech1", "Listen. These creatures aren't pets. People hunt them for meat, trade them, and steal them. You want to survive out there, learn the rules.")
  mod.content.text:override("_PalletTownSignText", "PALLET TOWN\nQuiet on the surface. Don't leave valuables unattended.")

  -- Flags
  local function setFlag(name, value)
    pcall(function() mod.world.flags:set(name, value) end)
  end
  local function getFlag(name)
    local ok, v = pcall(function() return mod.world.flags:get(name) end)
    return ok and v or false
  end

  -- Mid-battle theft tracking
  mod.events:on("battle.started", function(ev)
    stolenThisBattle.player = false
    stolenThisBattle.opponent = false
  end)

  -- Opponent can attempt to steal (simplified catch chance during trainer battles)
  mod.hooks:wrap("battle.menu_auxiliary", function(next, game, context)
    -- Placeholder for opponent AI steal attempt; real implementation would hook trainer AI
    return next(game, context)
  end)

  mod.events:on("pokemon.caught", function(ev)
    if not ev.battle then return end
    if ev.destination and ev.destination.side == "player" then
      stolenThisBattle.player = true
      mod.log:info("Player stole a Pokemon mid-battle")
    else
      stolenThisBattle.opponent = true
      mod.log:info("Opponent stole a Pokemon")
    end
  end)

  mod.events:on("battle.ended", function(ev)
    local playerWon = ev.winner == "player" or (ev.result and ev.result == "win")
    local playerLost = not playerWon

    if playerLost and stolenThisBattle.opponent then
      -- Permanent loss already handled by catch; confirm removal if needed
      mod.log:warn("Pokemon permanently lost after defeat")
      setFlag("LAST_LOSS_STOLEN", true)
    end

    if playerLost and stolenThisBattle.player then
      -- Wake in jail
      setFlag("IN_JAIL", true)
      setFlag("JAIL_RELEASE_DAY", (mod.world.time and mod.world.time.day or 0) + 1)
      pcall(function()
        mod.world:warp("PALLET_TOWN", 5, 5) -- stub jail warp; replace with real jail map
      end)
      mod.log:info("Sent to jail for theft")
    end

    if playerWon and stolenThisBattle.opponent then
      -- Opponent jailed for 7 days
      local tid = ev.trainerId or "unknown_trainer"
      jailedTrainers[tid] = (mod.world.time and mod.world.time.day or 0) + JAIL_DAYS
      setFlag("TRAINER_JAILED_" .. tid, true)
      mod.log:info("Opponent sent to jail for %d days", JAIL_DAYS)
    end
  end)

  -- Daily check for jail release
  mod.events:on("map.entered", function(ev)
    local day = mod.world.time and mod.world.time.day or 0
    for tid, release in pairs(jailedTrainers) do
      if day >= release then
        jailedTrainers[tid] = nil
        setFlag("TRAINER_JAILED_" .. tid, false)
        mod.log:info("Trainer %s released from jail", tid)
      end
    end
    if getFlag("IN_JAIL") then
      local release = getFlag("JAIL_RELEASE_DAY") or 0
      if day >= release then
        setFlag("IN_JAIL", false)
        mod.log:info("Released from jail")
      end
    end
  end)

  -- Prevent jailed trainers from battling (stub via before_battle)
  mod.hooks:wrap("trainer.before_battle", function(next, trainer, game)
    local tid = trainer and trainer.id or "unknown"
    if jailedTrainers[tid] or getFlag("TRAINER_JAILED_" .. tid) then
      mod.log:info("Trainer %s is in jail", tid)
      return false -- cancel battle
    end
    return next(trainer, game)
  end)

  -- Simple food/hunting flavor on wild encounters
  mod.events:on("battle.started", function(ev)
    if ev.kind == "wild" then
      mod.log:info("Wild encounter — some trainers hunt these for food")
    end
  end)

  mod.options:define({
    { key = "theft_enabled", label = "MID-BATTLE THEFT", type = "toggle", default = true },
    { key = "jail_days", label = "JAIL DAYS", type = "number", default = 7, min = 1, max = 30, step = 1 },
    { key = "permanent_loss", label = "PERMANENT LOSS ON DEFEAT", type = "toggle", default = true },
  })

  mod.log:info("Kanto Realism loaded. Foundation for a grounded total conversion.")
end
