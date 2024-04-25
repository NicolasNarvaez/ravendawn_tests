-- Q5 - reproduction of sample video
--
-- For simplicity we register a talkaction script, through the xml or revscriptsys interface, this in turn will call
-- the function onSay, where we trigger the effect scheduling.
--
-- To render the magic effect we first create a combat sequence with only effects and no damage, from area
-- tables, and apply them to a player and its target (this case the player position) as an event, timing each
-- area frame with an interval to create the final animation.
-- This makes simple to draw general scripted effects but from a superfitial analisis its evident it probably has
-- many pitfalls: First, for every coordinate in the computed combat area a sendMagicEffect is executed,
-- depending on how the protocol is designed this probly means a request is made for each pixel of each frame, which
-- is very network inneficient, specially with many players, the ideal would be to decouple the animation from
-- the combat effects and play the animation on the client while the effect is propagated in relation to the
-- player position, thus only sending requests to inform of combat updates.
-- The other problem is that is difficult to make animations, we could improve this by adding a gif to animation
-- converter and design the animations with graphical tools, this converted could then optimize the animation
-- automatically, avoiding unnecesary updates and choosing ideal frame delay intervals.
--
-- Final Comment: I tried to make the animation equivalent to the sample, but there is an offset on the position of
-- the two distinct animations encoded in the "ice tornado", in the animation they happend at different positions.
-- Im not sure if this is due to TFS or OTClient settings, or a different implementation (sending the effect with
-- sendMagicEffect has the same pitfall). Thus I decided the make the effect area a bit bigger to compensate, but I
-- remain intrigued my the cause.
local combat = {}

-- this simulates the given animation various features: the center repeating whirlwinds, the little ones
-- moving around, and the graceful final fade out with the innermost whirlwinds and little ones on the front C:
local area = {
	-- useful template of center whirlwinds
	-- {
		-- {0, 0, 0, 0, 0, 0, 0, 0, 0},
		-- {0, 0, 1, 0, 1, 0, 1, 0, 0},
		-- {0, 0, 1, 0, 1, 0, 1, 0, 0},
		-- {0, 0, 1, 0, 1, 0, 1, 0, 0},
		-- {1, 1, 1, 1, 2, 1, 1, 1, 1},
		-- {0, 0, 1, 0, 1, 0, 1, 0, 0},
		-- {0, 0, 1, 0, 1, 0, 1, 0, 0},
		-- {0, 0, 1, 0, 1, 0, 1, 0, 0},
		-- {0, 0, 0, 0, 0, 0, 0, 0, 0},
	-- },
	{
		{0, 0, 0, 0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0, 0, 0, 0},
		{0, 0, 1, 0, 0, 0, 0, 0, 0},
		{0, 1, 0, 0, 0, 0, 0, 0, 0},
		{1, 0, 0, 0, 2, 0, 0, 0, 1},
		{0, 1, 0, 0, 0, 0, 0, 0, 0},
		{0, 0, 1, 0, 0, 0, 0, 0, 0},
		{0, 0, 0, 1, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 1, 0, 0, 0, 0},
	},
	{
		{0, 0, 0, 0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0, 1, 0, 0},
		{0, 0, 0, 0, 0, 0, 0, 1, 0},
		{0, 0, 0, 0, 2, 0, 0, 0, 1},
		{0, 0, 1, 1, 1, 1, 1, 1, 0},
		{0, 0, 0, 0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0, 0, 0, 0},
	},
	{
		{0, 0, 0, 0, 0, 0, 0, 0, 0},
		{0, 0, 1, 0, 0, 0, 1, 0, 0},
		{0, 0, 1, 0, 0, 0, 1, 0, 0},
		{0, 0, 1, 0, 0, 0, 1, 0, 0},
		{1, 1, 1, 1, 2, 1, 1, 1, 1},
		{0, 0, 1, 1, 0, 1, 1, 0, 0},
		{0, 0, 1, 1, 1, 1, 1, 0, 0},
		{0, 0, 1, 1, 1, 1, 1, 0, 0},
		{0, 0, 0, 0, 0, 0, 0, 0, 0},
	},
	{
		{0, 0, 0, 0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 1, 0, 0, 0},
		{0, 0, 0, 0, 0, 1, 0, 0, 0},
		{0, 0, 0, 0, 2, 0, 0, 0, 0},
		{0, 0, 0, 1, 0, 0, 0, 0, 0},
		{0, 0, 0, 1, 0, 1, 0, 0, 0},
		{0, 0, 0, 1, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0, 0, 0, 0},
	},
	{
		{0, 0, 0, 0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0, 0, 1, 0},
		{0, 0, 0, 0, 2, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 1, 0, 1, 0},
		{0, 0, 0, 1, 0, 1, 0, 0, 0},
		{0, 0, 0, 1, 0, 1, 0, 0, 0},
		{0, 0, 0, 0, 0, 0, 0, 0, 0},
	},
	{
		{0, 0, 0, 0, 0, 0, 0, 0, 0},
		{0, 0, 1, 0, 1, 1, 0, 0, 0},
		{0, 0, 1, 0, 1, 1, 1, 0, 0},
		{0, 0, 1, 0, 1, 1, 1, 1, 0},
		{1, 1, 1, 1, 2, 1, 1, 1, 1},
		{0, 0, 1, 0, 1, 1, 1, 1, 0},
		{0, 0, 1, 0, 1, 1, 1, 1, 0},
		{0, 0, 1, 0, 1, 0, 1, 0, 0},
		{0, 0, 0, 0, 0, 0, 0, 0, 0},
	},
	{
		{0, 0, 0, 0, 0, 0, 0, 0, 0},
		{0, 0, 0, 1, 0, 1, 0, 0, 0},
		{0, 0, 0, 1, 0, 1, 0, 1, 0},
		{0, 0, 0, 1, 0, 1, 0, 1, 0},
		{0, 0, 0, 0, 2, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 1, 0, 0, 0},
		{0, 0, 0, 0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 1, 0, 0, 0},
		{0, 0, 0, 0, 0, 0, 0, 0, 0},
	},
	{
		{0, 0, 0, 0, 0, 0, 0, 0, 0},
		{0, 0, 0, 1, 0, 1, 0, 0, 0},
		{0, 0, 0, 1, 0, 0, 0, 0, 0},
		{0, 1, 0, 1, 0, 1, 0, 0, 0},
		{0, 0, 0, 0, 2, 0, 0, 0, 0},
		{0, 1, 0, 0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0, 0, 0, 0},
	},
	{
		{0, 0, 0, 0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 1, 0, 1, 0, 0},
		{0, 0, 1, 0, 1, 0, 1, 0, 0},
		{0, 1, 1, 0, 1, 0, 1, 0, 0},
		{1, 1, 1, 1, 2, 1, 1, 1, 1},
		{0, 1, 1, 1, 1, 0, 1, 0, 0},
		{0, 0, 1, 1, 1, 0, 1, 0, 0},
		{0, 0, 0, 1, 1, 0, 1, 0, 0},
		{0, 0, 0, 0, 0, 0, 0, 0, 0},
	},
	{
		{0, 0, 0, 0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 1, 0, 0, 0},
		{0, 0, 0, 1, 0, 1, 0, 1, 0},
		{0, 0, 0, 0, 0, 1, 0, 1, 0},
		{0, 0, 0, 0, 2, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 1, 0, 1, 0},
		{0, 0, 0, 0, 0, 1, 0, 0, 0},
		{0, 0, 0, 0, 0, 1, 0, 0, 0},
		{0, 0, 0, 0, 0, 0, 0, 0, 0},
	},
	{
		{0, 0, 0, 0, 0, 0, 0, 0, 0},
		{0, 0, 0, 1, 0, 1, 0, 0, 0},
		{0, 0, 0, 1, 0, 1, 0, 1, 0},
		{0, 0, 0, 1, 0, 1, 0, 1, 0},
		{0, 0, 0, 0, 2, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 1, 0, 0, 0},
		{0, 0, 0, 0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 1, 0, 0, 0},
		{0, 0, 0, 0, 0, 0, 0, 0, 0},
	},
	{
		{0, 0, 0, 0, 0, 0, 0, 0, 0},
		{0, 0, 1, 0, 1, 0, 1, 0, 0},
		{0, 0, 1, 0, 1, 1, 1, 0, 0},
		{0, 0, 1, 0, 1, 0, 1, 0, 0},
		{1, 1, 1, 1, 2, 1, 1, 1, 1},
		{0, 0, 1, 1, 1, 1, 1, 0, 0},
		{0, 0, 1, 1, 1, 1, 1, 0, 0},
		{0, 0, 0, 1, 1, 1, 0, 0, 0},
		{0, 0, 0, 0, 1, 0, 0, 0, 0},
	},
	{
		{0, 0, 0, 0, 0, 0, 0, 0, 0},
		{0, 0, 0, 1, 0, 0, 0, 0, 0},
		{0, 1, 0, 1, 0, 1, 0, 0, 0},
		{0, 1, 0, 1, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 2, 0, 0, 0, 0},
		{0, 1, 0, 1, 0, 0, 0, 0, 0},
		{0, 0, 0, 1, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 1, 0, 0, 0},
		{0, 0, 0, 0, 0, 0, 0, 0, 0},
	},
	{
		{0, 0, 0, 0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 2, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0, 0, 0, 0},
	},
	{
		{0, 0, 0, 0, 1, 0, 0, 0, 0},
		{0, 0, 0, 1, 1, 1, 0, 0, 0},
		{0, 0, 1, 0, 1, 0, 1, 0, 0},
		{0, 0, 0, 0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 2, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0, 0, 0, 0},
		{0, 0, 1, 0, 0, 0, 1, 0, 0},
		{0, 0, 0, 0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0, 0, 0, 0},
	},
}

-- We convert the area data into a combat sequence
for i = 1, #area do
	combat[i] = Combat()
	-- we only want to show an effect
	combat[i]:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_ICETORNADO)
end

for x, _ in ipairs(area) do
	combat[x]:setArea(createCombatArea(area[x]))
end

-- Helper to execute a combat as an event
function executeCombat(playerId, combat, target)
	player = Player(playerId)
	if not player or not player:isPlayer() then
		return false
	end

	combat:execute(player, target)
end

-- Plays an animation as a combat sequence with only effects on the target, this in turn works using sendMagicEffect.
function playSpellAnim(playerId, target, anim_settings)
	local initialDelay = anim_settings.initialDelay
	local framesDelta = anim_settings.framesDelta
	local combat = anim_settings.combat

	local player = Player(playerId)
	if not player then
		print("WARN:castSpellEffect: player doesnt exists")
		return
	end

	for i = 1, #combat do
		addEvent(executeCombat, framesDelta * (i-1) + initialDelay, player:getId(), combat[i], target)
	end

	return true
end

-- This describes out animation to the executor, we send it as the third arg (anim_settings)
local iceTornadoAnimation = {
	combat = combat,
	initialDelay = 0,
	framesDelta = 300,
}

-- This will be called when player says "frigo"
function onSay(player, words, param)
	local player_position = player:getPosition()
	playSpellAnim(player:getId(), Variant(player_position), iceTornadoAnimation)
	return true
end

-- example of talkaction xml registry (on data/talkactions/talkactions.xml)
-- <talkaction words="frigo" script="frigo.lua" />

