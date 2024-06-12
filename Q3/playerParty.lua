-- Improved function to remove a player from a party with better error handling and code readability.
-- This function `removePlayerFromParty` is designed to manage the removal of a player from a party in a game.
-- Improvements include:
-- 1. Enhanced error handling: The function now checks for the existence of both the player and the member to be removed, and provides appropriate feedback.
-- 2. Code readability: The function is structured with clear separation of concerns, making it easier to understand and maintain.
-- 3. User feedback: Sends messages directly to the player to inform them of the status of their request, improving user experience.

function removePlayerFromParty(playerId, memberName)
    -- Retrieve the player object using playerId, check if the player exists
    local player = Player(playerId)
    if not player then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Player not found")
        return
    end

    -- Retrieve the party object from the player, check if the player is in a party
    local party = player:getParty()
    if not party then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Player is not in a party")
        return
    end

    -- Retrieve the member object to remove from the party using memberName, check if the member exists
    local memberToRemove = Player(memberName)
    if not memberToRemove then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Member to remove not found")
        return
    end

    -- Iterate through the party members to find and remove the specified member
    for _, member in pairs(party:getMembers()) do
        if member == memberToRemove then
            party:removeMember(memberToRemove)
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Member removed from party")
            return
        end
    end

    -- If the member was not found in the party, print a message notify
    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Member not found in party")
end