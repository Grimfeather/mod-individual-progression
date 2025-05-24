/*  Rockfist was removed from Phalanx's drop table in TBC - placing it back */
DELETE FROM `creature_loot_template` WHERE `Entry` = 9502 AND `Item` = 11743;
INSERT INTO `creature_loot_template` (Entry, Item, Reference, Chance, QuestRequired, LootMode, GroupId, MinCount, MaxCount, Comment) VALUES
(9502, 11743, 0, 0, 0, 1, 1, 1, 1, 'Phalanx - Rockfist');


/* Ring of Law bosses missing smart AI */

UPDATE `creature_template` SET `AIName` = 'SmartAI' WHERE `entry` IN (9027, 9028, 9029, 9030, 9031, 9032);

DELETE FROM `smart_scripts` WHERE `entryorguid` IN (9027, 9028, 9029, 9030, 9031, 9032);
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `event_param6`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES 
(9027, 0, 0, 0, 2, 0, 100, 1, 0, 30, 0, 0, 0, 0, 11, 21049, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,                   'Gorosh the Dervish - Between 0-30% Health - Cast Bloodlust (No Repeat)'),
(9027, 0, 1, 0, 0, 0, 100, 0, 7000, 11000, 9000, 15000, 0, 0, 11, 15708, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0,      'Gorosh the Dervish - In Combat - Cast Mortal Strike'),
(9027, 0, 2, 0, 0, 0, 100, 0, 5000, 9000, 8000, 10000, 0, 0, 11, 13736, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,       'Gorosh the Dervish - In Combat - Cast Whirlwind'),
--
(9028, 0, 0, 0, 0, 0, 100, 0, 4850, 18250, 4850, 18250, 0, 0, 11, 40504, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0,      'Grizzle - In Combat - Cast Cleave'),
(9028, 0, 1, 0, 0, 0, 100, 0, 15000, 18000, 135000, 138000, 0, 0, 11, 8269, 32, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,  'Grizzle - In Combat - Cast Enrage'),
(9028, 0, 2, 0, 0, 0, 100, 0, 10000, 13000, 11000, 14000, 0, 0, 11, 6524, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,     'Grizzle - In Combat - Cast Ground Tremor'),
--
(9029, 0, 0, 0, 0, 0, 100, 0, 8000, 15000, 20000, 30000, 0, 0, 11, 7121, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,      'Eviscerator - In Combat - Cast Anti-Magic Shield'),
(9029, 0, 1, 0, 0, 0, 100, 0, 5000, 7000, 15000, 17000, 0, 0, 11, 15245, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,      'Eviscerator - In Combat - Cast Shadow Bolt Volley'),
(9029, 0, 2, 0, 0, 0, 100, 0, 3000, 9000, 12000, 19000, 0, 0, 11, 14331, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0,      'Eviscerator - In Combat - Cast Vicious Rend'),
--
(9030, 0, 0, 0, 0, 0, 100, 0, 500, 500, 2000, 3000, 0, 0, 11, 15254, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0,          'Ok\'thor the Breaker - In Combat - Cast Arcane Bolt'),
(9030, 0, 1, 0, 0, 1, 100, 0, 1000, 3200, 2800, 5200, 0, 0, 11, 15453, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,        'Ok\'thor the Breaker - In combat - Cast Arcane Explosion'),
(9030, 0, 2, 0, 0, 0, 100, 0, 3000, 9000, 15000, 25000, 0, 0, 11, 13323, 0, 0, 0, 0, 0, 6, 30, 0, 0, 0, 0, 0, 0, 0,     'Ok\'thor the Breaker - In Combat - Cast Polymorph'),
(9030, 0, 3, 0, 0, 0, 100, 0, 13000, 15000, 20000, 35000, 0, 0, 11, 13747, 32, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0,   'Ok\'thor the Breaker - In Combat - Cast Slow'),
--
(9031, 0, 0, 0, 0, 0, 100, 0, 5000, 15000, 16000, 20000, 0, 0, 11, 8994, 32, 0, 0, 0, 0, 6, 30, 0, 0, 8994, 0, 0, 0, 0, 'Anub\'shiah - In Combat - Cast Banish'),
(9031, 0, 1, 0, 0, 0, 100, 0, 6000, 8000, 7000, 15000, 0, 0, 11, 15470, 289, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0,     'Anub\'shiah - In Combat - Cast Curse of Tongues'),
(9031, 0, 2, 0, 0, 0, 100, 0, 6000, 8000, 7000, 15000, 0, 0, 11, 11980, 33, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0,      'Anub\'shiah - In Combat - Cast Curse of Weakness'),
(9031, 0, 3, 0, 23, 0, 100, 0, 13787, 0, 10000, 10000, 0, 0, 11, 13787, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,       'Anub\'shiah - On aura missing - Cast Demon Armor'),
(9031, 0, 4, 0, 0, 0, 100, 0, 1000, 7000, 18000, 24000, 0, 0, 11, 15471, 0, 0, 0, 0, 0, 5, 15, 0, 0, 0, 0, 0, 0, 0,     'Anub\'shiah - In Combat - Cast Enveloping Web'),
(9031, 0, 5, 0, 0, 0, 100, 0, 0, 1000, 3000, 4500, 0, 0, 11, 12739, 64, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0,          'Anub\'shiah - In Combat - Cast Shadow Bolt'),
--
(9032, 0, 0, 0, 0, 0, 100, 0, 2000, 12000, 13000, 20000, 0, 0, 11, 15474, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,     'Hedrum the Creeper - In Combat - Cast Web Explosion'),
(9032, 0, 1, 0, 0, 0, 100, 0, 4000, 12000, 0, 0, 0, 0, 11, 15475, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,             'Hedrum the Creeper - In Combat - Cast Baneful Poison');


/*  Fix Dark Coffer event */

SET @GUID         :=640001;
SET @cover        :=164819;
SET @Portrait     :=164825;
SET @Assemblage   :=8905;
SET @ReliCoffer   :=174564;
SET @ReliCoffer2  :=174563;
SET @ReliCoffer3  :=174562;
SET @ReliCoffer4  :=174561;
SET @ReliCoffer5  :=174560;
SET @ReliCoffer6  :=174559;
SET @ReliCoffer7  :=174554;
SET @ReliCoffer8  :=174555;
SET @ReliCoffer9  :=174556;
SET @ReliCoffer10 :=174557;
SET @ReliCoffer11 :=174566;
SET @ReliCoffer12 :=174558;
SET @DOOM         :=9476;
SET @Secret       :=174553; 
SET @Dark         :=174565;

DELETE FROM `gameobject` WHERE `guid` IN (@GUID);
INSERT INTO `gameobject` (`guid`,`id`,`map`,`spawnMask`,`phaseMask`,`position_x`,`position_y`,`position_z`,`orientation`,`rotation0`,`rotation1`,`rotation2`,`rotation3`,`spawntimesecs`,`animprogress`,`state`) VALUES
(@GUID,165554,230,1,1, 802.907, -356.401, -48.9423,0,0,0,-0.382683, 0.92388, 7200, 100, 1);

UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry` IN (@Assemblage, @DOOM);
UPDATE `gameobject_template` SET `AIName`='SmartGameObjectAI' WHERE `entry` IN (@cover, @Dark, @ReliCoffer, @ReliCoffer2, @ReliCoffer3, @ReliCoffer4, @ReliCoffer5, @ReliCoffer6, @ReliCoffer7, @ReliCoffer8, @ReliCoffer9, @ReliCoffer10, @ReliCoffer11, @ReliCoffer12, @Secret);

DELETE FROM `smart_scripts` WHERE `entryorguid`=@Assemblage AND `source_type`=0;
DELETE FROM `smart_scripts` WHERE `entryorguid`=-46610 AND `source_type`=0;
DELETE FROM `smart_scripts` WHERE `entryorguid`=@Assemblage*100 AND `source_type`=9;
DELETE FROM `smart_scripts` WHERE `entryorguid`=@Assemblage*100+1 AND `source_type`=9;
DELETE FROM `smart_scripts` WHERE `entryorguid`=@DOOM AND `source_type`=0;
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (@cover, @Dark, @Secret, @ReliCoffer, @ReliCoffer2, @ReliCoffer3, @ReliCoffer4, @ReliCoffer5, @ReliCoffer6, @ReliCoffer7, @ReliCoffer8, @ReliCoffer9, @ReliCoffer10, @ReliCoffer11, @ReliCoffer12) AND `source_type`=1;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(@cover, 1, 0, 0, 64, 0, 100, 0, 0, 0, 0, 0, 106, 16, 0, 0, 0, 0, 0, 20, @Portrait, 5, 0, 0, 0, 0, 0, 'Cover - On gossip hello - Remove flags'),
(@ReliCoffer, 1, 0, 1, 70, 0, 100, 0, 2, 0, 0, 0, 45, 0, 1, 0, 0, 0, 0, 11, @Assemblage, 30, 0, 0, 0, 0, 0, 'ReliCoffer - On State 2 - Set data'), 
(@ReliCoffer, 1, 1, 0, 61, 0, 100, 0, 0, 0, 0, 0, 106, 16, 0, 0, 0, 0, 0, 20, 160836, 10, 0, 0, 0, 0, 0, 'ReliCoffer - On State 2 - Remove flags'), 
(@ReliCoffer2, 1, 0, 1, 70, 0, 100, 0, 2, 0, 0, 0, 45, 0, 1, 0, 0, 0, 0, 11, @Assemblage, 30, 0, 0, 0, 0, 0, 'ReliCoffer - On State 2  - Set data'),
(@ReliCoffer2, 1, 1, 0, 61, 0, 100, 0, 0, 0, 0, 0, 106, 16, 0, 0, 0, 0, 0, 20, 160836, 10, 0, 0, 0, 0, 0, 'ReliCoffer - On State 2 - Remove flags'), 
(@ReliCoffer3, 1, 0, 1, 70, 0, 100, 0, 2, 0, 0, 0, 45, 0, 1, 0, 0, 0, 0, 11, @Assemblage, 30, 0, 0, 0, 0, 0, 'ReliCoffer - On State 2  - Set data'),
(@ReliCoffer3, 1, 1, 0, 61, 0, 100, 0, 0, 0, 0, 0, 106, 16, 0, 0, 0, 0, 0, 20, 160836, 10, 0, 0, 0, 0, 0, 'ReliCoffer - On State 2 - Remove flags'), 
(@ReliCoffer4, 1, 0, 1, 70, 0, 100, 0, 2, 0, 0, 0, 45, 0, 1, 0, 0, 0, 0, 11, @Assemblage, 30, 0, 0, 0, 0, 0, 'ReliCoffer - On State 2  - Set data'),
(@ReliCoffer4, 1, 1, 0, 61, 0, 100, 0, 0, 0, 0, 0, 106, 16, 0, 0, 0, 0, 0, 20, 160836, 10, 0, 0, 0, 0, 0, 'ReliCoffer - On State 2 - Remove flags'), 
(@ReliCoffer5, 1, 0, 1, 70, 0, 100, 0, 2, 0, 0, 0, 45, 0, 1, 0, 0, 0, 0, 11, @Assemblage, 30, 0, 0, 0, 0, 0, 'ReliCoffer - On State 2  - Set data'),
(@ReliCoffer5, 1, 1, 0, 61, 0, 100, 0, 0, 0, 0, 0, 106, 16, 0, 0, 0, 0, 0, 20, 160836, 10, 0, 0, 0, 0, 0, 'ReliCoffer - On State 2 - Remove flags'), 
(@ReliCoffer6, 1, 0, 1, 70, 0, 100, 0, 2, 0, 0, 0, 45, 0, 1, 0, 0, 0, 0, 11, @Assemblage, 30, 0, 0, 0, 0, 0, 'ReliCoffer - On State 2  - Set data'),
(@ReliCoffer6, 1, 1, 0, 61, 0, 100, 0, 0, 0, 0, 0, 106, 16, 0, 0, 0, 0, 0, 20, 160836, 10, 0, 0, 0, 0, 0, 'ReliCoffer - On State 2 - Remove flags'), 
(@ReliCoffer7, 1, 0, 1, 70, 0, 100, 0, 2, 0, 0, 0, 45, 0, 1, 0, 0, 0, 0, 11, @Assemblage, 30, 0, 0, 0, 0, 0, 'ReliCoffer - On State 2  - Set data'),
(@ReliCoffer7, 1, 1, 0, 61, 0, 100, 0, 0, 0, 0, 0, 106, 16, 0, 0, 0, 0, 0, 20, 160836, 10, 0, 0, 0, 0, 0, 'ReliCoffer - On State 2 - Remove flags'), 
(@ReliCoffer8, 1, 0, 1, 70, 0, 100, 0, 2, 0, 0, 0, 45, 0, 1, 0, 0, 0, 0, 11, @Assemblage, 30, 0, 0, 0, 0, 0, 'ReliCoffer - On State 2  - Set data'),
(@ReliCoffer8, 1, 1, 0, 61, 0, 100, 0, 0, 0, 0, 0, 106, 16, 0, 0, 0, 0, 0, 20, 160836, 10, 0, 0, 0, 0, 0, 'ReliCoffer - On State 2 - Remove flags'), 
(@ReliCoffer9, 1, 0, 1, 70, 0, 100, 0, 2, 0, 0, 0, 45, 0, 1, 0, 0, 0, 0, 11, @Assemblage, 30, 0, 0, 0, 0, 0, 'ReliCoffer - On State 2  - Set data'),
(@ReliCoffer9, 1, 1, 0, 61, 0, 100, 0, 0, 0, 0, 0, 106, 16, 0, 0, 0, 0, 0, 20, 160836, 10, 0, 0, 0, 0, 0, 'ReliCoffer - On State 2 - Remove flags'), 
(@ReliCoffer10, 1, 0, 1, 70, 0, 100, 0, 2, 0, 0, 0, 45, 0, 1, 0, 0, 0, 0, 11, @Assemblage, 30, 0, 0, 0, 0, 0, 'ReliCoffer - On State 2  - Set data'),
(@ReliCoffer10, 1, 1, 0, 61, 0, 100, 0, 0, 0, 0, 0, 106, 16, 0, 0, 0, 0, 0, 20, 160836, 10, 0, 0, 0, 0, 0, 'ReliCoffer - On State 2 - Remove flags'), 
(@ReliCoffer11, 1, 0, 1, 70, 0, 100, 0, 2, 0, 0, 0, 45, 0, 1, 0, 0, 0, 0, 11, @Assemblage, 30, 0, 0, 0, 0, 0, 'ReliCoffer - On State 2  - Set data'),
(@ReliCoffer11, 1, 1, 0, 61, 0, 100, 0, 0, 0, 0, 0, 106, 16, 0, 0, 0, 0, 0, 20, 160836, 10, 0, 0, 0, 0, 0, 'ReliCoffer - On State 2 - Remove flags'), 
(@ReliCoffer12, 1, 0, 1, 70, 0, 100, 0, 2, 0, 0, 0, 45, 0, 1, 0, 0, 0, 0, 11, @Assemblage, 30, 0, 0, 0, 0, 0, 'ReliCoffer - On State 2  - Set data'),
(@ReliCoffer12, 1, 1, 0, 61, 0, 100, 0, 0, 0, 0, 0, 106, 16, 0, 0, 0, 0, 0, 20, 160836, 10, 0, 0, 0, 0, 0, 'ReliCoffer - On State 2 - Remove flags'), 
(@Assemblage, 0, 0, 0, 38, 0, 100, 0, 0, 1, 0, 0, 63, 1, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Assemblage - On data set - Increment Counter 1'), -- the counter nbr 1 is incremented here
(@Assemblage, 0, 1, 2, 11, 0, 100, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Assemblage - On Respawn - Set passif'),
(@Assemblage, 0, 2, 3, 61, 0, 100, 0, 0, 0, 0, 0, 18, 33554432, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Assemblage - On Respawn - Add unit_flag'),
(@Assemblage, 0, 3, 0, 61, 0, 100, 0, 0, 0, 0, 0, 22, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Assemblage - On Respawn - SET PHASE EVENT 0'),
(@Assemblage, 0, 4, 0, 77, 0, 100, 1, 1, 12, 0, 0, 80, @Assemblage*100, 2, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Assemblage - On counter1=12 - Actionlist'),  -- event triggred when the counter 1= 12
(@Assemblage*100, 9, 0, 0, 0, 0, 100, 0, 0, 0, 0, 0, 19, 33554432, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Assemblage - Actionlist - Remmove unit flag'),
(@Assemblage*100, 9, 1, 0, 0, 0, 100, 0, 0, 0, 0, 0, 8, 2, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Assemblage - Actionlist - react agressif'),
(@Assemblage*100, 9, 2, 0, 0, 0, 100, 0, 0, 0, 0, 0, 22, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Assemblage - Actionlist - SET PHASE EVENT 0'),
(@Assemblage, 0, 5, 0, 0, 0, 100, 0, 4000, 4000, 8000, 8000, 11, 15621, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 'Assemblage - IC - Cast'),
(@Secret, 1, 0, 0, 70, 0, 100, 0, 2, 0, 0, 0, 106, 16, 0, 0, 0, 0, 0, 20, 161495, 10, 0, 0, 0, 0, 0, 'Secret - On State 2  - Remove flags'),
(@Dark, 1, 0, 0, 70, 0, 100, 0, 2, 0, 0, 0, 106, 16, 0, 0, 0, 0, 0, 20, 160845, 10, 0, 0, 0, 0, 0, '@Dark - On State 2  - Remove flags'),
(-46610, 0, 0, 0, 38, 0, 100, 0, 0, 1, 0, 0, 63, 1, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Assemblage - On data set - Increment Counter1'), -- the counter nbr 1 is incremented here
(-46610, 0, 1, 2, 11, 0, 100, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Assemblage - On Respawn - Set passif'),
(-46610, 0, 2, 0, 61, 0, 100, 0, 0, 0, 0, 0, 18, 33554432, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Assemblage - On Respawn - Add unit_flag'),
(-46610, 0, 4, 0, 77, 0, 100, 1, 1, 12, 0, 0, 80, @Assemblage*100+1, 2, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Assemblage - On counter1=12 - Actionlist'), -- event triggred when the counter 1= 12
(@Assemblage*100+1, 9, 0, 0, 0, 0, 100, 0, 0, 0, 0, 0, 19, 33554432, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Assemblage - Actionlist - Remmove unit flag'),
(@Assemblage*100+1, 9, 1, 0, 0, 0, 100, 0, 0, 0, 0, 0, 8, 2, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Assemblage - Actionlist - react agressif'),
(@Assemblage*100+1, 9, 2, 0, 0, 0, 100, 0, 0, 0, 0, 0, 12, @DOOM, 7, 0, 0, 0, 0, 8, 0, 0, 0, 813.737915, -347.550354, -50.578030, 0.670515, 'Assemblage - Actionlist - Summon'),
(@Assemblage*100+1, 9, 3, 0, 0, 0, 100, 0, 0, 0, 0, 0, 22, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Assemblage - Actionlist - SET PHASE EVENT 0'),
(-46610, 0, 5, 0, 0, 0, 100, 0, 4000, 4000, 8000, 8000, 11, 15621, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 'Assemblage - IC - Cast'),
(@DOOM, 0, 0, 0, 0, 0, 100, 0, 4000, 4000, 8000, 8000, 11, 11971, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 'DOOM - IC - Cast'),
(@DOOM, 0, 1, 0, 0, 0, 100, 0, 10000, 10000, 14000, 14000, 11, 15504, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'DOOM - IC - Cast'),
(@DOOM, 0, 2, 0, 6, 0, 100, 0, 0, 0, 0, 0, 9, 0, 0, 0, 0, 0, 0, 20, 174553, 70, 0, 0, 0, 0, 0, 'DOOM - On death - Activate gob'),
(@DOOM, 0, 3, 0, 4, 0, 100, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'DOOM - On aggro - Talk');

DELETE FROM `creature_text` WHERE `CreatureID` IN (@DOOM);   
INSERT INTO `creature_text` (`CreatureID`,`groupid`,`id`,`text`,`type`,`language`,`probability`,`emote`,`duration`,`sound`,`comment`, `BroadcastTextID`) VALUES
(@DOOM,0,0,"What are you doing?  Intruders!!",14,0,100,0,0,0,'Watchman Doomgrip', 4962);
