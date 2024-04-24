
-- Q2 - Fix or improve the implementation of the below method

-- This method is supposed to print names of all guilds that have less than memberCount max members.
-- We do everything in the query to simplify.
function printSmallGuildNames(memberCount)
	local selectGuildQuery = [[
		WITH selection AS (
			SELECT g.name, COUNT(gm.player_id) as memberCount
			FROM `guilds` g
			JOIN `guild_membership` gm ON (g.id = gm.guild_id)
			GROUP BY g.name
			HAVING memberCount < %d
		)
		SELECT GROUP_CONCAT(name SEPARATOR ', ') as names FROM selection;
		]]
	local resultId = db.storeQuery(string.format(selectGuildQuery, memberCount))
	print("guild names: ", result.getString(resultId, 'names'))

	-- in the case we used the selection subquery directly, we would need to iterate the results records,
	-- concatenating into a message string or printing them directly. I preferred to do it on the query to decrease
	-- complexity.

	-- local guild_names = ''
	-- repeat
		-- print("guild name: ", result.getString(resultId, 'name')) -- printing directly
		-- guild_names = guild_names .. ', ' .. result.getString(resultId, 'name') -- aggregating message
	-- until not result.next(resultId)
	-- print('guild_names: ', guild_names)
end

