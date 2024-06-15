-- This script defines a slide spell action for a game, allowing players to slide in a specified direction.
-- The script includes several utility functions and security checks to ensure proper functionality and prevent abuse.

-- Utility and Functions:
-- 1. `isWalkable`: This function checks if a position is walkable by verifying the properties of the ground, items, and creatures at the position.
-- 2. `DIRECTION_EFFECTS`: A table that stores the magic effects for each direction (North, East, South, West).
-- 3. `MAX_DISTANCE`: A constant that defines the maximum distance a player can slide.

-- Security Features:
-- 1. The `isWalkable` function ensures that the player cannot slide into positions that are blocked by solid objects, immovable objects, or other creatures.
-- 2. The function also checks for projectile-blocking properties if the slide involves projectiles.

-- Possible Uses:
-- 1. In War: The slide spell can be used strategically to quickly move out of danger, dodge attacks, or reposition for a better tactical advantage.
-- 2. When Hunting Creatures: Players can use the slide spell to evade attacks from creatures, close the distance to a target, or escape from a dangerous situation.

-- Additional Features:
-- 1. Removing the Item: A function can be added to remove an item from the player's inventory when the slide spell is used.
-- 2. Resource Cost: The slide spell can be configured to consume a specific resource (e.g., mana, stamina) when used.
-- 3. Diagonal Dash: The script can be extended to allow diagonal dashes, providing more movement options for players.


-- Define the action for the slide spell
local slideSpell = Action()

-- Table to store the magic effects for each direction
local DIRECTION_EFFECTS = {
    [0] = 260,   -- North
    [1] = 260,   -- East
    [2] = 260,   -- South
    [3] = 260    -- West
}

-- Maximum distance the player can slide
local MAX_DISTANCE = 4

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
        
        if foundCreature:isPlayer() or foundCreature:isNpc() or foundCreature:isMonster() then
            return false
        end

        if proj and foundCreature:isMonster() then
            local creatureType = foundCreature:getType()
            if creatureType and creatureType:isNpc() then
                return false
            end
        end

        if proj then
            return false
        end

        ::continue::
    end

    if creature and tile:hasFlag(TILESTATE_PROTECTIONZONE) then
        return false
    end

    return true
end

-- Function to slide the player in a given direction for a certain distance
local function slidePlayer(player, direction, distance)
    local pos = player:getPosition()
    local dirOffset = {
        [0] = {x = 0, y = -1},   -- North
        [1] = {x = 1, y = 0},    -- East
        [2] = {x = 0, y = 1},    -- South
        [3] = {x = -1, y = 0}    -- West
    }

    for i = 1, distance do
        local newPos = Position(pos.x + dirOffset[direction].x, pos.y + dirOffset[direction].y, pos.z)
        if not isWalkable(newPos, player, false) then
            player:sendTextMessage(MESSAGE_STATUS, "An obstacle is blocking your path.")
            break
        end

        addEvent(function()
            if isWalkable(newPos, player, false) then
                player:teleportTo(newPos, true)
                newPos:sendMagicEffect(DIRECTION_EFFECTS[direction])
            end
        end, i * 13)

        pos = newPos
    end
end

-- Function to handle the use of the slide spell
function slideSpell.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    local direction = player:getDirection()
    slidePlayer(player, direction, MAX_DISTANCE)
    return true
end

-- Register the slide spell with its ID
slideSpell:id(3051) 
slideSpell:register()