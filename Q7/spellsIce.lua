-- This script demonstrates the potential of an ice spell with various functionalities:
-- 1. The area of effect (AoE) is defined as a 3x3 grid with the center having a higher value, indicating a stronger impact at the center.
-- 2. Functions are included to generate random positions within a specified range, allowing for dynamic and unpredictable spell effects.
-- 3. The spell can apply different damage values to targets based on the player's level and magic level, adding variability to the damage output.
-- 4. A function is added to execute random damage at specified positions, enhancing the spell's randomness and strategic use.
-- 5. If the spell hits a target, it can trigger an area damage effect around the target, increasing the spell's impact.
-- 6. Upon the target's death, the spell can produce additional damage in other areas, creating a chain reaction of effects.
local AREA_DAMAGE_1X1 = {
    { 1, 1, 1 },
    { 1, 3, 1 },
    { 1, 1, 1 }
}

-- Create a new instant spell
local spell = Spell("instant")

-- Initialize the combat object and set its parameters
local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_ICEDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_ICETORNADO)
combat:setArea(createCombatArea(AREA_DAMAGE_1X1))

-- Function to calculate the minimum and maximum damage based on player level and magic level
function onGetFormulaValues(player, level, maglevel)
    local min = (level / 1) + (maglevel * 2)
    local max = (level / 1) + (maglevel * 2)
    return -min, -max
end

-- Set the callback for the combat object to use the damage formula
combat:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")

-- Function to check if a position is within a specified range from a center position
local function isPositionInRange(centerPos, pos, range)
    local dx = math.abs(centerPos.x - pos.x)
    local dy = math.abs(centerPos.y - pos.y)
    return dx <= range and dy <= range
end

-- Function to generate random positions within a specified range around a center position
local function getRandomPositions(centerPos, range, count)
    local positions = {}
    while #positions < count do
        local xOffset = math.random(-range, range)
        local yOffset = math.random(-range, range)
        local pos = Position(centerPos.x + xOffset, centerPos.y + yOffset, centerPos.z)
        if isPositionInRange(centerPos, pos, range) then
            table.insert(positions, pos)
        end
    end
    return positions
end

-- Function to execute random damage at specified positions
local function executeRandomDamage(player, positions, index)
    local caster = Player(player)
    if not caster then
        return
    end

    local pos = positions[index]
    if pos then
        pos:sendMagicEffect(CONST_ME_ICEAREA)

        local targets = {}
        for x = 1, #AREA_DAMAGE_1X1 do
            for y = 1, #AREA_DAMAGE_1X1[x] do
                if AREA_DAMAGE_1X1[x][y] == 1 then
                    local targetPos = pos + Position(x - 2, y - 2, 0)
                    local target = Tile(targetPos):getTopCreature()
                    if target and (target:isPlayer() or target:isMonster()) then
                        table.insert(targets, target)
                    end
                end
            end
        end

        for _, target in ipairs(targets) do
            combat:execute(caster, Variant(target:getPosition()))
        end

        if index < #positions then
            addEvent(executeRandomDamage, 800, player, positions, index + 1)
        end
    end
end

-- Function to execute random tornado effects at specified positions
local function executeRandomTornado(player, positions, index)
    local caster = Player(player)
    if not caster then
        return
    end

    local pos = positions[index]
    if pos then
        pos:sendMagicEffect(CONST_ME_ICETORNADO)

        local targets = {}
        for x = 1, #AREA_DAMAGE_1X1 do
            for y = 1, #AREA_DAMAGE_1X1[x] do
                if AREA_DAMAGE_1X1[x][y] == 1 then
                    local targetPos = pos + Position(x - 2, y - 2, 0)
                    local target = Tile(targetPos):getTopCreature()
                    if target and (target:isPlayer() or target:isMonster()) then
                        table.insert(targets, target)
                    end
                end
            end
        end

        for _, target in ipairs(targets) do
            local min = 2
            local max = 5
            local damage = math.random(min, max) * 1.3  
            doTargetCombatHealth(caster, target, COMBAT_ICEDAMAGE, -damage, -damage, CONST_ME_NONE)
        end

        if index < #positions then
            addEvent(executeRandomTornado, 1600, player, positions, index + 1)
        end
    end
end

-- Function to execute random giant ice effects at specified positions
local function executeRandomGiantIce(player, positions, index)
    local caster = Player(player)
    if not caster then
        return
    end

    local pos = positions[index]
    if pos then
        pos:sendMagicEffect(CONST_ME_GIANTICE)

        local targets = {}
        for x = 1, #AREA_DAMAGE_1X1 do
            for y = 1, #AREA_DAMAGE_1X1[x] do
                if AREA_DAMAGE_1X1[x][y] == 1 then
                    local targetPos = pos + Position(x - 2, y - 2, 0)
                    local target = Tile(targetPos):getTopCreature()
                    if target and (target:isPlayer() or target:isMonster()) then
                        table.insert(targets, target)
                    end
                end
            end
        end

        for _, target in ipairs(targets) do
            local min = 340 // damage fixed
            local max = 610 // damage change 
            local damage = math.random(min, max) * 1.3  // extra damage
            doTargetCombatHealth(caster, target, COMBAT_ICEDAMAGE, -damage, -damage, CONST_ME_NONE)
        end

        if index < #positions then
            addEvent(executeRandomGiantIce, 2700, player, positions, index + 1)
        end
    end
end

-- Function to apply a giant ice effect on a creature's death
local function applyGiantIceEffect(creature)
    local pos = creature:getPosition()
    pos:sendMagicEffect(CONST_ME_GIANTICE)
    local targets = {}
    for x = 1, #AREA_DAMAGE_1X1 do
        for y = 1, #AREA_DAMAGE_1X1[x] do
            if AREA_DAMAGE_1X1[x][y] == 1 then
                local targetPos = pos + Position(x - 2, y - 2, 0)
                local target = Tile(targetPos):getTopCreature()
                if target and (target:isPlayer() or target:isMonster()) then
                    table.insert(targets, target)
                end
            end
        end
    end

    for _, target in ipairs(targets) do
        local min = 210
        local max = 490
        local damage = math.random(min, max) * 1.5
        doTargetCombatHealth(nil, target, COMBAT_ICEDAMAGE, -damage, -damage, CONST_ME_NONE)
    end
end

-- Callback function to apply the giant ice effect when a creature dies
function onDeath(creature, corpse, killer, mostDamage, unjustified, mostDamage_unjustified)
    applyGiantIceEffect(creature)
    return true
end

-- Function to cast the spell, executing random damage, tornado, and giant ice effects
function spell.onCastSpell(creature, var)
    local player = Player(creature)
    if not player then
        return false
    end

    local pos = player:getPosition()
    local duration = 5 * 1000 
    local interval = 1000
    local repeats = math.floor(duration / interval) 

    for i = 0, repeats - 1 do
        addEvent(function()
            local positions = getRandomPositions(pos, 3, 3)
            executeRandomDamage(player:getId(), positions, 1)
        end, i * interval)

        addEvent(function()
            local tornadoPositions = getRandomPositions(pos, 4, 4)
            executeRandomTornado(player:getId(), tornadoPositions, 1)
        end, i * 1000)

        addEvent(function()
            local gianticePositions = getRandomPositions(pos, 4, 4)
            executeRandomGiantIce(player:getId(), gianticePositions, 1)
        end, i * 1500)
    end

    return combat:execute(creature, var)
end

-- Register the spell with its properties
spell:group("attack", "focus")
spell:id(57)
spell:name("Ice Spiral")
spell:words("exevo abu")
spell:castSound(SOUND_EFFECT_TYPE_SPELL_ICE_WAVE)
spell:level(99)
spell:mana(860)
spell:isPremium(true)
spell:isSelfTarget(true)
spell:cooldown(50 * 1000) // cooldown retry spells again
spell:groupCooldown(4 * 1000, 20 * 1000) // free slot other spells
spell:needLearn(false)
spell:vocation("druid;true", "elder sorcerer;true")
spell:register()

-- Register the death callback to apply the giant ice effect on death
local deathCallback = CreatureEvent("onDeathIceEffect")
deathCallback:type("death")
deathCallback:register()


-- @@ ADD spells focus video

-- local AREA_DAMAGE_1X1 = {
--     { 1, 0, 1 },
--     { 0, 3, 0 },
--     { 1, 0, 1 }
-- }

-- local AREA_CIRCLE6X6 = {
--     {0, 0, 0, 1, 1, 1, 0, 0, 0},
--     {0, 0, 1, 1, 1, 1, 1, 0, 0},
--     {0, 1, 1, 1, 1, 1, 1, 1, 0},
--     {1, 1, 1, 1, 1, 1, 1, 1, 1},
--     {1, 1, 1, 1, 3, 1, 1, 1, 1},
--     {1, 1, 1, 1, 1, 1, 1, 1, 1},
--     {0, 1, 1, 1, 1, 1, 1, 1, 0},
--     {0, 0, 1, 1, 1, 1, 1, 0, 0},
--     {0, 0, 0, 1, 1, 1, 0, 0, 0}
-- }

-- Create a new instant spell
-- local spell = Spell("instant")

-- Initialize the combat object and set its parameters
-- local combat = Combat()
-- combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_ICEDAMAGE)
-- combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_ICETORNADO)
-- combat:setArea(createCombatArea(AREA_DAMAGE_1X1))

-- Function to calculate the minimum and maximum damage based on player level and magic level
-- function onGetFormulaValues(player, level, maglevel)
--     local min = (level / 1) + (maglevel * 2)
--     local max = (level / 1) + (maglevel * 2)
--     return -min, -max
-- end

-- Set the callback for the combat object to use the damage formula
-- combat:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")

-- Function to check if a position is within a specified range from a center position
-- local function isPositionInRange(centerPos, pos, range)
--     local dx = math.abs(centerPos.x - pos.x)
--     local dy = math.abs(centerPos.y - pos.y)
--     return dx <= range and dy <= range
-- end

-- Function to generate random positions within a specified range around a center position
-- local function getRandomPositions(centerPos, range, count)
--     local positions = {}
--     while #positions < count do
--         local xOffset = math.random(-range, range)
--         local yOffset = math.random(-range, range)
--         local pos = Position(centerPos.x + xOffset, centerPos.y + yOffset, centerPos.z)
--         if isPositionInRange(centerPos, pos, range) then
--             table.insert(positions, pos)
--         end
--     end
--     return positions
-- end

-- Function to execute random tornado effects at specified positions
-- local function executeRandomTornado(player, positions, index)
--     local caster = Player(player)
--     if not caster then
--         return
--     end

--     local pos = positions[index]
--     if pos then
--         pos:sendMagicEffect(CONST_ME_ICETORNADO)

--         local targets = {}
--         for x = 1, #AREA_CIRCLE6X6 do
--             for y = 1, #AREA_CIRCLE6X6[x] do
--                 if AREA_CIRCLE6X6[x][y] == 1 then
--                     local targetPos = pos + Position(x - 5, y - 5, 0)
--                     local target = Tile(targetPos):getTopCreature()
--                     if target and (target:isPlayer() or target:isMonster()) then
--                         table.insert(targets, target)
--                     end
--                 end
--             end
--         end

--         for _, target in ipairs(targets) do
--             local min = 2
--             local max = 5
--             local damage = math.random(min, max) * 1.3  
--             doTargetCombatHealth(caster, target, COMBAT_ICEDAMAGE, -damage, -damage, CONST_ME_NONE)
--         end

--         if index < #positions then
--             addEvent(executeRandomTornado, 50, player, positions, index + 1)
--         end
--     end
-- end

-- Function to cast the spell, executing random tornado effects
-- function spell.onCastSpell(creature, var)
--     local player = Player(creature)
--     if not player then
--         return false
--     end

--     local pos = player:getPosition()
--     local duration = 5 * 1000 
--     local interval = 50
--     local repeats = math.floor(duration / interval) 

--     for i = 0, repeats - 1 do
--         addEvent(function()
--             local tornadoPositions = getRandomPositions(pos, 3, 1)
--             executeRandomTornado(player:getId(), tornadoPositions, 1)
--         end, i * interval)
--     end

--     return combat:execute(creature, var)
-- end

-- Register the spell with its properties
-- spell:group("attack", "focus")
-- spell:id(57)
-- spell:name("Ice Spiral")
-- spell:words("exevo abu")
-- spell:castSound(SOUND_EFFECT_TYPE_SPELL_ICE_WAVE)
-- spell:level(99)
-- spell:mana(860)
-- spell:isPremium(true)
-- spell:isSelfTarget(true)
-- spell:cooldown(50 * 1000) 
-- spell:groupCooldown(4 * 1000, 20 * 1000)
-- spell:needLearn(false)
-- spell:vocation("sorcerer;true", "master sorcerer;true")
-- spell:register()
