-- The current script has the following issues:
-- 1. The `releaseStorage` function does not check if the player object is valid before attempting to set the storage value.
-- 2. The `addEvent` function in `onLogout` passes the player object directly, which may cause issues if the player object is not valid when the event is executed.

-- The improved script addresses these issues by:
-- 1. Adding a check to ensure the player object is valid before setting the storage value.
-- 2. Passing the player ID to the `addEvent` function instead of the player object, ensuring the player object is retrieved fresh when the event is executed.

-- Improved `releaseStorage` function
local function releaseStorage(playerId)
    local player = Player(playerId)
    if player then
        local currentStorage = player:getStorageValue(1000)
        if currentStorage == -1 then
            player:setStorageValue(1000, playerId)
        elseif currentStorage ~= playerId then
            player:setStorageValue(1000, -1)
        end
    end
end

-- Improved `onLogout` function
function onLogout(player)
    if player:getStorageValue(1000) == 1 then
        -- A utility for this storageValue would be to assign a unique ID record to the storage.
        -- This storage record could then be used by other functions such as quest/SQM/refresh, etc.,
        -- as a conditional recognition of the player since the ID registered in the storage would be unique and its validation would be the same.

        -- Example usage:
        -- if player:getStorageValue(1000) == player:getId() then
        --     -- Proceed with the script you want to configure
        -- end

        addEvent(releaseStorage, 1000, player:getId())
    end
    return true
end