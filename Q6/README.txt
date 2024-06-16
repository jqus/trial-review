/*
In the version 1.4 folder, the compiled version along with its necessary files for execution has been added. 
The config.lua.dist file needs to be configured by renaming it to config.lua and setting it up with the required data such as MYSQL connection and IP if necessary.
*/
/*
Uses and Features of @dash.lua:

1. **Slide Spell Action**: The script defines a slide spell action for a game, allowing players to slide in a specified direction.

2. **Utility Functions**:
   - `isWalkable`: Checks if a position is walkable by verifying the properties of the ground, items, and creatures at the position.
   - `DIRECTION_EFFECTS`: A table that stores the magic effects for each direction (North, East, South, West).
   - `MAX_DISTANCE`: A constant that defines the maximum distance a player can slide.

3. **Security Features**:
   - The `isWalkable` function ensures that the player cannot slide into positions that are blocked by solid objects, immovable objects, or other creatures.
   - The function also checks for projectile-blocking properties if the slide involves projectiles.

4. **Possible Uses**:
   - **In War**: The slide spell can be used strategically to quickly move out of danger, dodge attacks, or reposition for a better tactical advantage.
   - **When Hunting Creatures**: Players can use the slide spell to evade attacks from creatures, close the distance to a target, or escape from a dangerous situation.

5. **Additional Features**:
   - **Removing the Item**: A function can be added to remove an item from the player's inventory when the slide spell is used.
   - **Resource Cost**: The slide spell can be configured to consume a specific resource (e.g., mana, stamina) when used.
   - **Diagonal Dash**: The script can be extended to allow diagonal dashes, providing more movement options for players.
*/


// This script has variants that can be removed or conditioned, such as passing through familiars, creatures, and NPCs. 
// It also includes protection in safe zones to prevent traps in depots.
