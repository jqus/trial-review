// Note on code behavior and improvements:
// 1) The code previously had a memory leak issue due to a loop accumulation when using this function.
// 2) A new variable 'isPlayerMemoryVerify' has been introduced to manage memory allocation when the command is triggered, ensuring proper flow.
// 3) Memory is freed conditionally based on whether the execution of the function is successful or not.
// 4) Additional enhancements and details have been added to improve code readability and maintainability.

void Game::addItemToPlayer(const std::string& recipient, uint16_t itemId)
{
    Player* player = g_game.getPlayerByName(recipient);
    bool isPlayerMemoryVerify = false; // Flag to check if the player was temporarily created

    if (!player) {
        player = new Player(nullptr);
        if (!IOLoginData::loadPlayerByName(player, recipient)) {
            player->sendCancelMessage("An error occurred while sending the items."); // Notify player this send item fails
            delete player; // Free memory if player loading fails
            return;
        }
        isPlayerMemoryVerify = true; // Mark that this player was temporarily created
    }

    Item* item = Item::CreateItem(itemId);
    if (!item) {
        if (isPlayerMemoryVerify) {
            delete player; // Free the player if item creation fails and the player was temporary
        }
        return;
    }

    g_game.internalAddItem(player->getInbox(), item, INDEX_WHEREEVER, FLAG_NOLIMIT);
    g_game.addMagicEffect(player->getPosition(), CONST_ME_GREEN_RINGS); // Upon completion, the function will notify with an effect indicating that its flow was correct

    if (player->isOffline()) {
        player->sendCancelMessage("Player is offline, please try again later.");
        IOLoginData::savePlayer(player);
    }
    
    std::string itemName = item->getName(); // Get the name of the item
    std::string truesends = "Item sent: " + itemName; // Prepare the message with the item name
    player->sendFYIBox(truesends); // Send the message to the player

    // This function handles the creation and flow of item creation, ensuring memory is freed and prepared for the next call.
    if (isPlayerMemoryVerify) {
        delete player; // Free the player if it was temporarily created
    }
    
}
