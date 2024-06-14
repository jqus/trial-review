-- This script defines a spell that allows a player to dash in their current direction.
-- Version protopipe funcionality before add sprite effects news in use command
-- Define the spell action for the command "!dash"
local slideSpell = TalkAction("!dash")

-- Define the magic effects for each direction
local DIRECTION_EFFECTS = {
    [0] = CONST_ME_MAGIC_GREEN,   -- North
    [1] = CONST_ME_MAGIC_GREEN,   -- East
    [2] = CONST_ME_MAGIC_GREEN,   -- South
    [3] = CONST_ME_MAGIC_GREEN    -- West
}

-- Set the maximum distance the player can dash
local MAX_DISTANCE = 6

-- Function to check if a position is walkable
local function isWalkable(pos, creature, proj)
    local tile = Tile(pos)
    if not tile then
        return false
    end

    local ground = tile:getGround()
    if not ground or ground:hasProperty(CONST_PROP_BLOCKSOLID) or ground:hasProperty(CONST_PROP_IMMOVABLEBLOCKSOLID) then
        return false
    end

    local items = tile:getItems()
    for _, item in ipairs(items) do
        if item:hasProperty(CONST_PROP_BLOCKSOLID) or item:hasProperty(CONST_PROP_BLOCKPATH) or item:hasProperty(CONST_PROP_IMMOVABLEBLOCKSOLID) then
            return false
        end
        if proj and item:hasProperty(CONST_PROP_BLOCKPROJECTILE) then
            return false
        end
    end

    local creatures = tile:getCreatures()
    for _, foundCreature in ipairs(creatures) do
        if foundCreature == creature then
            goto continue
        end
        
        if foundCreature:isPlayer() or (foundCreature:isMonster() and not foundCreature:isSummon()) then
            return false
        end

        -- Check if the creature is a summon
        if proj and foundCreature:isMonster() then
            local creatureType = foundCreature:getType()
            if creatureType and creatureType:isSummon() then
                return false
            end
        end

        if proj and foundCreature:isNpc() then
            return false
        end

        ::continue::
    end

    if creature and tile:hasFlag(TILESTATE_PROTECTIONZONE) then
        return false
    end

    return true
end

-- Function to slide the player in the given direction for a certain distance
local function slidePlayer(player, direction, distance)
    local pos = player:getPosition()
    local dirOffset = {
        [0] = {x = 0, y = -1},  -- North
        [1] = {x = 1, y = 0},   -- East
        [2] = {x = 0, y = 1},   -- South
        [3] = {x = -1, y = 0}   -- West
    }

    for i = 1, distance do
        local newPos = Position(pos.x + dirOffset[direction].x, pos.y + dirOffset[direction].y, pos.z)
        if not isWalkable(newPos, player, false) then
            break
        end

        addEvent(function()
            if isWalkable(newPos, player, false) then
                player:teleportTo(newPos, true)
                newPos:sendMagicEffect(DIRECTION_EFFECTS[direction])
            end
        end, i * 100)

        pos = newPos
    end
end

-- Function to handle the spell when the player says the command
function slideSpell.onSay(player, words, param)
    local direction = player:getDirection()
    slidePlayer(player, direction, MAX_DISTANCE)
    return true
end

-- Register the spell action
slideSpell:groupType("normal")
slideSpell:register()
