
-- This method is supposed to print names of all guilds that have less than memberCount max members
-- Current code explanation:
-- The function constructs a SQL query to select guild names where the max_members is less than the provided memberCount.
-- It then executes the query and retrieves the guild name from the result set, printing it out.
-- However, the current code only retrieves and prints the first guild name and does not handle cases where the query fails.

-- Revised version:
-- The revised function will handle the result set properly, iterating through all guild names and printing each one.
-- It will also handle the case where no results are found, ensuring the function does not get stuck on failure.
-- Additionally, the print statements will be replaced with player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "") for better user feedback.

function printSmallGuildNames(player, memberCount)
    -- This method should send the names of all guilds that have less than memberCount max members to the player
    local selectGuildQuery = "SELECT name FROM guilds WHERE max_members < %d;"
    local resultId = db.storeQuery(string.format(selectGuildQuery, memberCount))
    
    if resultId then
        repeat
            local guildName = result.getString(resultId, "name")
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, guildName)
        until not result.next(resultId)
        
        result.free(resultId)
    else
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "No guilds found with less than " .. memberCount .. " members.")
    end
end
