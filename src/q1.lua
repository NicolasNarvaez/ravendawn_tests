-- Q1 - Fix or improve the implementation of the below methods
--
-- The problem described here relates to the general issue of altering user data beyond the lifetime of its ram storage
-- if this is really needed we can query the database directly, but in most of the cases (when we need to reset state
-- back to an original value on close()) we can do the same mutation on the start of the session (onLogin).
--
-- Given there are no details on the purpose of this flag, we cant tell exactly what to do, but most probably is
-- reseting a value after logout, thus I would reset it on the login script (solution included in q1.onLogin.lua),
-- if the event needs to be triggered at a specific time, then I would use the more careful procedure implemented
-- here with a time interval = current - target time .
--
-- releaseStorage now cleans the storage value if user is online, otherwise queries the db directly.

-- Util to update player storage entry directly when offline
local function updateStorageOffline(player_guid, key, value)
	local result = db.storeQuery("SELECT `name` FROM `players` WHERE `id` = " .. player_guid)
	if not result then
		-- player doesn't exists it should warn or log depending on implementation details
		print("WARN: updateStorageOffline: player doesnt exists")
		return
	end

	if value == -1 then
		db.query("DELETE FROM `player_storage` WHERE `key` = " .. key .. " AND `player_id` = " .. player_guid)
	else
		db.query("UPDATE `player_storage` SET `value` = " .. value .. " WHERE `key` = " .. key .. " AND `player_id` = " .. player_guid)
	end
end

-- This function clears a user storage entry independent of login state:
-- uses storage API if the user is online, and fallbacks to a delete query otherwise
local function releaseStorage(player_id, player_guid, key)
	local player = Player(player_id)
	if player then
		player:setStorageValue(key, -1)
	else
		updateStorageOffline(player_guid, key, -1)
	end
end

function onLogout(player)
	-- I leaved this here from the original script
	local playerId = player:getId()
	if nextUseStaminaTime[playerId] then
		nextUseStaminaTime[playerId] = nil
	end

	-- This would only be adequate if we really need to make this change while the user is offline, like on
	-- special events, etc. Normally we would toggle it on onLogin (solution included in q1.onLogin.lua)
	if player:getStorageValue(1000) == 1 then
		-- We use getId() instead of sending the player userdata directly due to this being unsecure and prone to bugs
		-- , the lua binding middleware (c++::luaAddEvent()) replaces it by getId, so we do this directly to avoid the
		-- warning.
		addEvent(releaseStorage, 1000, player:getId(), player:getGuid(), 1000)
	end

	return true
end

