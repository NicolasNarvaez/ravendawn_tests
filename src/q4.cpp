// Q4 - Assume all method calls work fine. Fix the memory leak issue in below method

void Game::addItemToPlayer(const std::string& recipient, uint16_t itemId)
{
	Player* player = g_game.getPlayerByName(recipient);
	if (!player) {
		// Here we explicitely request memory, so the function execution scope is responsible of release
		player = new Player(nullptr); 
		if (!IOLoginData::loadPlayerByName(player, recipient)) {
			delete player; // here we werent able to load player data, thus we release borrowed memory.
			return;
		}
	}

	Item* item = Item::CreateItem(itemId);
	if (!item) {
		return;
	}

	g_game.internalAddItem(player->getInbox(), item, INDEX_WHEREEVER, FLAG_NOLIMIT);
	// In theory, the add item could fail, and we should release the created item memory, but the exposed interface 
	// could be self managed, so given we dont have enough implementation details, and the hypothesis is that 
	// the calls are error-free, we leave it as is.
	//
	// In the case CreateItem doesnt manages its own memory trough opaque state, we should do something like this
	// to release the requested item:
	/*
	 * auto res = g_game.internalAddItem(player->getInbox(), item, INDEX_WHEREEVER, FLAG_NOLIMIT);
	 * if (!res) {
	 *		delete item
	 * }
	 */

	if (player->isOffline()) {
		IOLoginData::savePlayer(player);
		// This pĺayer was loaded during this function, thus we release borrowed memory after persisting state.
		delete player; 
	}
}

