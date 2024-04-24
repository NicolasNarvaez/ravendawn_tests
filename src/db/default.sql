-- This is a convenient DB snipets collection put together using DBeaver while testing the scripts.

-- Account
INSERT INTO `accounts`(`id`, `name`, `password`, `type`, `premdays`, `lastday`, `email`, `creation`) 
VALUES 
(1,'boulder','82b384ce62e22ad7baf5959c3cdcc048a18f5703',5,100,0,'',0);

DELETE FROM `players`;
SELECT * FROM `players`;
INSERT INTO `players`(`id`, `name`, `group_id`, `account_id`, `level`, `vocation`, `health`, `healthmax`, `experience`, `lookbody`, `lookfeet`, `lookhead`, `looklegs`, `looktype`, `lookaddons`, `maglevel`
	, `mana`, `manamax`, `manaspent`, `soul`, `town_id`, `posx`, `posy`, `posz`, `conditions`, `cap`, `sex`, `lastlogin`, `lastip`, `save`, `skull`, `skulltime`, `lastlogout`, `blessings`, `onlinetime`
	, `deletion`, `balance`, `offlinetraining_time`, `offlinetraining_skill`, `stamina`, `skill_fist`, `skill_fist_tries`, `skill_club`, `skill_club_tries`, `skill_sword`, `skill_sword_tries`
	, `skill_axe`, `skill_axe_tries`, `skill_dist`, `skill_dist_tries`, `skill_shielding`, `skill_shielding_tries`, `skill_fishing`, `skill_fishing_tries`) 
VALUES 
(1,'BOULDER',3,1,2,1,1000,1000,100,114,0,116,114,140,3,20,1000,1000,100,100,1,95,117,7,'',1000,0,0,0,1,0,0,0,0,0,0,0,43200,-1,2520,10,0,10,0,10,0,10,0,10,0,10,0,10,0),
(2,'boulder0',3,1,2,1,1000,1000,100,114,0,116,114,140,3,20,1000,1000,100,100,1,95,117,7,'',1000,0,0,0,1,0,0,0,0,0,0,0,43200,-1,2520,10,0,10,0,10,0,10,0,10,0,10,0,10,0),
(3,'boulder1',3,1,2,1,1000,1000,100,114,0,116,114,140,3,20,1000,1000,100,100,1,95,117,7,'',1000,0,0,0,1,0,0,0,0,0,0,0,43200,-1,2520,10,0,10,0,10,0,10,0,10,0,10,0,10,0),
(4,'boulder2',3,1,2,1,1000,1000,100,114,0,116,114,140,3,20,1000,1000,100,100,1,95,117,7,'',1000,0,0,0,1,0,0,0,0,0,0,0,43200,-1,2520,10,0,10,0,10,0,10,0,10,0,10,0,10,0),
(5,'boulder3',3,1,2,1,1000,1000,100,114,0,116,114,140,3,20,1000,1000,100,100,1,95,117,7,'',1000,0,0,0,1,0,0,0,0,0,0,0,43200,-1,2520,10,0,10,0,10,0,10,0,10,0,10,0,10,0),
(6,'boulder4',3,1,2,1,1000,1000,100,114,0,116,114,140,3,20,1000,1000,100,100,1,95,117,7,'',1000,0,0,0,1,0,0,0,0,0,0,0,43200,-1,2520,10,0,10,0,10,0,10,0,10,0,10,0,10,0),
(7,'boulder5',3,1,2,1,1000,1000,100,114,0,116,114,140,3,20,1000,1000,100,100,1,95,117,7,'',1000,0,0,0,1,0,0,0,0,0,0,0,43200,-1,2520,10,0,10,0,10,0,10,0,10,0,10,0,10,0),
(8,'boulder6',3,1,2,1,1000,1000,100,114,0,116,114,140,3,20,1000,1000,100,100,1,95,117,7,'',1000,0,0,0,1,0,0,0,0,0,0,0,43200,-1,2520,10,0,10,0,10,0,10,0,10,0,10,0,10,0),
(9,'boulder7',3,1,2,1,1000,1000,100,114,0,116,114,140,3,20,1000,1000,100,100,1,95,117,7,'',1000,0,0,0,1,0,0,0,0,0,0,0,43200,-1,2520,10,0,10,0,10,0,10,0,10,0,10,0,10,0),
(10,'boulder8',3,1,2,1,1000,1000,100,114,0,116,114,140,3,20,1000,1000,100,100,1,95,117,7,'',1000,0,0,0,1,0,0,0,0,0,0,0,43200,-1,2520,10,0,10,0,10,0,10,0,10,0,10,0,10,0),
(11,'boulder9',3,1,2,1,1000,1000,100,114,0,116,114,140,3,20,1000,1000,100,100,1,95,117,7,'',1000,0,0,0,1,0,0,0,0,0,0,0,43200,-1,2520,10,0,10,0,10,0,10,0,10,0,10,0,10,0),
(12,'boulder10',3,1,2,1,1000,1000,100,114,0,116,114,140,3,20,1000,1000,100,100,1,95,117,7,'',1000,0,0,0,1,0,0,0,0,0,0,0,43200,-1,2520,10,0,10,0,10,0,10,0,10,0,10,0,10,0)
;

DELETE FROM `guilds`;
SELECT * FROM `guilds`;
INSERT INTO `guilds`(`id`, `name`, `ownerid`, `creationdata`, `motd`) 
VALUES 
(1, 'guild_BOULDER', 1, 0, 'nice climate in scotland'),
(2, 'guild_0', 2, 0, ''),
(3, 'guild_1', 3, 0, ''),
(4, 'guild_2', 4, 0, ''),
(5, 'guild_3', 5, 0, '')
;

-- known id ranks
DELETE FROM `guild_ranks`;
SELECT * FROM `guild_ranks`;
INSERT INTO `guild_ranks`(`id`, `guild_id`, `name`, `level`)
VALUES
(1, 1, 'the Leader', 3),(2, 1, 'a Vice-Leader', 2),(3, 1, 'a Member', 1),
(4, 2, 'the Leader', 3),(5, 2, 'a Vice-Leader', 2),(6, 2, 'a Member', 1),
(7, 3, 'the Leader', 3),(8, 3, 'a Vice-Leader', 2),(9, 3, 'a Member', 1),
(10, 4, 'the Leader', 3),(11, 4, 'a Vice-Leader', 2),(12, 4, 'a Member', 1),
(13, 5, 'the Leader', 3),(14, 5, 'a Vice-Leader', 2),(15, 5, 'a Member', 1)
;

DELETE FROM `guild_membership`;
SELECT * FROM `guild_membership`;
INSERT INTO `guild_membership`(`player_id`, `guild_id`, `rank_id`, `nick`) 
VALUES 
(1, 1, 1, 'BOULDER'),
(2, 2, 4, 'boulder_0'),
(3, 3, 7, 'boulder_1'),
(4, 4, 10, 'boulder_2'),
(5, 5, 13, 'boulder_3'),
-- not owning
(6, 1, 3, 'boulder_4'),
(7, 2, 6, 'boulder_5'),
(8, 3, 9, 'boulder_6'),
(9, 4, 12, 'boulder_7'),
(10, 1, 3, 'boulder_8'),
(11, 1, 3, 'boulder_9'),
(12, 2, 6, 'boulder_10')
;

-- First guilds query experiment 
SELECT g.name, COUNT(gm.player_id) as memberCount
FROM `guilds` g
JOIN `guild_membership` gm ON (g.id = gm.guild_id)
GROUP BY g.name
HAVING memberCount >= 3;
