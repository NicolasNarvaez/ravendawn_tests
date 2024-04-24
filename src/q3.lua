-- Q3 - Fix or improve the name and the implementation of the below method

-- For this function, we updated the name to a more semantic one,  simplified the player instance acquisition 
-- and validated data before manipulation.

-- Removes a member from the party of a player.
function removePlayerPartyMember(playerId, memberName)
	player = Player(playerId)
	member = Player(memberName)
	-- We check everything is valid to avoid runtime errors
	if not player then
		print("WARN:removePlayerPartyMember:Missing player (id) : ", playerId)
		return
	end
	if not member then
		print("WARN:removePlayerPartyMember:Missing member (name): ", memberName)
		return
	end

	local party = player:getParty()
	if not party then
		print("WARN:removePlayerPartyMember: no party") -- log or propagate error depending on usage details
		return
	end

	for _, v in pairs(party:getMembers()) do
		if v == member then
			party:removeMember(member)
		end
	end
end

