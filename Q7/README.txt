-- This script demonstrates the potential of an ice spell with various functionalities:
-- 1. The area of effect (AoE) is defined as a 3x3 grid with the center having a higher value, indicating a stronger impact at the center.
-- 2. Functions are included to generate random positions within a specified range, allowing for dynamic and unpredictable spell effects.
-- 3. The spell can apply different damage values to targets based on the player's level and magic level, adding variability to the damage output.
-- 4. A function is added to execute random damage at specified positions, enhancing the spell's randomness and strategic use.
-- 5. If the spell hits a target, it can trigger an area damage effect around the target, increasing the spell's impact.
-- 6. Upon the target's death, the spell can produce additional damage in other areas, creating a chain reaction of effects.

-- Installation:
-- To install this script, simply place it in the 'data/scripts' folder of your project.

-- Configuration:
-- The following parts of the script can be modified to suit your requirements:
-- 1. Damage Values: Modify the 'onGetFormulaValues' function to change the damage calculation based on player level and magic level.
-- 2. Area of Effect: Change the 'AREA_DAMAGE_1X1' table to adjust the area of effect for the spell.
-- 3. Spell Properties: Adjust the properties of the spell such as level required, mana cost, cooldown, etc., in the 'spell' object registration section.
-- 4. Effects: Modify the 'executeRandomDamage', 'executeRandomTornado', and 'executeRandomGiantIce' functions to change the visual effects and damage applied.
-- 5. Vocation: Change the 'spell:vocation' line to specify which vocations can use the spell.

-- Example of modifying damage values:
-- function onGetFormulaValues(player, level, maglevel)
--     local min = (level / 2) + (maglevel * 3)
--     local max = (level / 2) + (maglevel * 3)
--     return -min, -max
-- end

-- Example of modifying area of effect:
-- local AREA_DAMAGE_1X1 = {
--     { 0, 1, 0 },
--     { 1, 3, 1 },
--     { 0, 1, 0 }
-- }

-- Example of modifying spell properties:
-- spell:level(50)
-- spell:mana(500)
-- spell:cooldown(30 * 1000)
-- spell:groupCooldown(2 * 1000, 15 * 1000)

-- Example of modifying vocation:
-- spell:vocation("sorcerer;true", "druid;true")

-- This script is highly customizable and can be tailored to fit the specific needs of your game or project.
