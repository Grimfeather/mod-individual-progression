/* smart scripts */
DELETE FROM `smart_scripts` WHERE `source_type` = 0 AND `entryorguid` IN (24014);
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`,
`event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `event_param6`,
`action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`,
`target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
--
(24014, 0,  7, 0, 4, 0, 100, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,                      'Necrolord - On Aggro - Say Line 0 (No Repeat)'),
(24014, 0,  8, 0, 0, 0, 100, 0, 2000, 2000, 3000, 3000, 0, 0, 11, 9613, 64, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0,     'Necrolord - In Combat - Cast Shadow Bolt'), -- https://www.youtube.com/watch?v=Xw8zg4OMR8M
(24014, 0,  9, 0, 0, 0, 100, 0, 0, 0, 25000, 35000, 0, 0, 11, 18267, 33, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0,        'Necrolord - In Combat - Cast Curse of Weakness'),
(24014, 0, 10, 0, 9, 0, 100, 0, 4000, 4000, 8000, 12000, 0, 0, 11, 17173, 65, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0,   'Necrolord - In Combat - Cast Drain Life');

-- give dead Crazed Northsea Slavers: UNIT_FLAG_IMMUNE and UNIT_FLAG_NON_ATTACKABLE
UPDATE `creature` SET `unit_flags` = 2147483650 WHERE `guid` IN
(131263, 131264, 131265, 131266, 131267, 131268, 131269, 131270, 131271, 131272, 131273, 131274, 131275, 131276, 131277, 131278, 131279, 131280, 131281);

-- quest: The Dead Rise! - fix Fengir's Clue
UPDATE `gameobject` SET `position_z` = 297.034 WHERE `guid` = 59521 AND `id` = 187022; -- Mound of Debris

-- fix loot table Iceshard Elemental, exceeded 100% chance
UPDATE `creature_loot_template` SET `Chance` = 65 WHERE `Item` = 36810 AND `Entry` = 24228;

-- quest: Dead Man's Debt - fix spawn of Black Conrad
SET @NPC_BLACK_CONRAD    := 24790;
SET @NPC_SPECTRAL_SAILOR := 24796;
SET @GO_DIRT_MOUND_ENTRY := 186944;
SET @GO_DIRT_MOUND_GUID  := 680001;

DELETE FROM `creature` WHERE `id` = @NPC_BLACK_CONRAD; -- remove npc placed by AC
UPDATE `creature_template` SET `faction` = 35 WHERE `entry` IN (@NPC_BLACK_CONRAD, @NPC_SPECTRAL_SAILOR); -- was 16, should be something else that's not hostile instead of 35, so they appear red instead of green
UPDATE `gameobject_template` SET `AIName` = 'SmartGameObjectAI' WHERE `entry` = @GO_DIRT_MOUND_ENTRY;

DELETE FROM `gameobject` WHERE `guid` = @GO_DIRT_MOUND_GUID AND `id` = @GO_DIRT_MOUND_ENTRY;
INSERT INTO `gameobject` (`guid`, `id`, `map`, `zoneId`, `areaId`, `spawnMask`, `phaseMask`, `position_x`, `position_y`, `position_z`, `orientation`,
`rotation0`, `rotation1`, `rotation2`, `rotation3`, `spawntimesecs`, `animprogress`, `state`, `ScriptName`, `VerifiedBuild`, `Comment`) VALUES
--
(@GO_DIRT_MOUND_GUID, @GO_DIRT_MOUND_ENTRY, 571, 0, 0, 1, 1, 689.488, -3373.89, 68.0065, 4.58879, 0, 0, 0.749427, -0.662087, 300, 100, 1, '', NULL, NULL);

DELETE FROM `smart_scripts` WHERE `source_type` = 0 AND `entryorguid` IN (@NPC_BLACK_CONRAD, @NPC_SPECTRAL_SAILOR);
DELETE FROM `smart_scripts` WHERE `source_type` = 1 AND `entryorguid` IN (@GO_DIRT_MOUND_ENTRY);
DELETE FROM `smart_scripts` WHERE `source_type` = 9 AND `entryorguid` IN (2479001, 2479601, 18694401);

INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`,
`event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `event_param6`,
`action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`,
`target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
--
(@GO_DIRT_MOUND_ENTRY, 1, 0, 0, 70, 0, 100, 0, 1, 0, 0, 0, 0, 0, 80, 18694401, 2, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,         'Dirt Mound - On Use - Run Script 18694401'),
--
(@NPC_BLACK_CONRAD, 0, 0, 0, 54, 0, 100, 0, 0, 0, 0, 0, 0, 0, 80, 2479001, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,             'Black Conrad\'s Ghost - On Just Summoned - Run Script 2479001'),
(@NPC_BLACK_CONRAD, 0, 1, 0, 6, 0, 100, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,                     'Black Conrad\'s Ghost - On Death - Say Text 1'),
(@NPC_BLACK_CONRAD, 0, 2, 0, 4, 0, 100, 0, 0, 0, 0, 0, 0, 0, 11, 51211, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,                'Black Conrad\'s Ghost - On Agro - Cast Blade Flurry'),
(@NPC_BLACK_CONRAD, 0, 3, 0, 9, 0, 100, 0, 0, 0, 10000, 15000, 0, 5, 11, 31022, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0,        'Black Conrad\'s Ghost - Within 0-5 Range - Cast Ghostly Strike'),
(@NPC_BLACK_CONRAD, 0, 4, 5, 7, 0, 100, 0, 0, 0, 0, 0, 0, 0, 47, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,                    'Black Conrad\'s Ghost - On Evade - Set Visible Off'),
(@NPC_BLACK_CONRAD, 0, 5, 0, 61, 0, 100, 0, 0, 0, 0, 0, 0, 0, 41, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,                   'Black Conrad\'s Ghost - On Evade - Despawn Self'),
--
(@NPC_SPECTRAL_SAILOR, 0, 0, 0, 54, 0, 100, 0, 0, 0, 0, 0, 0, 0, 80, 2479601, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,          'Spectral Sailor - On Just Summoned - Run Script 2479601'),
(@NPC_SPECTRAL_SAILOR, 0, 1, 2, 7, 0, 100, 0, 0, 0, 0, 0, 0, 0, 47, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,                 'Spectral Sailor - On Evade - Set Visible Off'),
(@NPC_SPECTRAL_SAILOR, 0, 2, 0, 61, 0, 100, 0, 0, 0, 0, 0, 0, 0, 41, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,                'Spectral Sailor - On Evade - Despawn Self'),
--
(2479001, 9, 0, 0, 0, 0, 100, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,                               'Script9 - Black Conrad\'s Ghost - Say Text 0'),
(2479001, 9, 1, 0, 0, 0, 100, 0, 7000, 7000, 0, 0, 0, 0, 1, 2, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,                         'Script9 - Black Conrad\'s Ghost - Say Text 2'),
(2479001, 9, 2, 0, 0, 0, 100, 0, 0, 0, 0, 0, 0, 0, 2, 16, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,                              'Script9 - Black Conrad\'s Ghost - Reset Faction'),
--
(2479601, 9, 0, 0, 0, 0, 50, 0, 5000, 5000, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,                          'Script9 - Spectral Sailor - Say Text 0'),
(2479601, 9, 1, 0, 0, 0, 100, 0, 0, 0, 0, 0, 0, 0, 2, 16, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,                              'Script9 - Spectral Sailor - Reset Faction'),
--
(18694401, 9, 0, 0, 0, 0, 100, 0, 0, 0, 0, 0, 0, 0, 12, @NPC_BLACK_CONRAD,    7, 60000, 1, 0, 0, 8, 0, 0, 0, 0, 688.965, -3378.28, 67.7668, 1.45666, 'Script9 - Dirt Mound - Summon Black Conrad'),
(18694401, 9, 1, 0, 0, 0, 100, 0, 0, 0, 0, 0, 0, 0, 12, @NPC_SPECTRAL_SAILOR, 7, 60000, 1, 0, 0, 8, 0, 0, 0, 0, 691.829, -3376.94, 67.9698, 1.45666, 'Script9 - Dirt Mound - Summon Black Conrad'),
(18694401, 9, 2, 0, 0, 0, 100, 0, 0, 0, 0, 0, 0, 0, 12, @NPC_SPECTRAL_SAILOR, 7, 60000, 1, 0, 0, 8, 0, 0, 0, 0, 686.696, -3376.46, 67.7311, 1.52735, 'Script9 - Dirt Mound - Summon Black Conrad');

DELETE FROM `creature_text` WHERE `CreatureID` = @NPC_BLACK_CONRAD;
INSERT INTO `creature_text` (`CreatureID`, `GroupID`, `ID`, `Text`, `Type`, `Language`, `Probability`, `Emote`, `Duration`, `Sound`, `BroadcastTextId`, `TextRange`, `comment`) VALUES
--
(@NPC_BLACK_CONRAD, 0, 0, 'Yarrrr!  If it\'s me treasure yer lookin\' for... yer gonna have to fight for it!', 12, 0, 100, 1, 0, 0, 23833, 0, 'Black Conrad\'s Ghost'),
(@NPC_BLACK_CONRAD, 1, 0, 'Yarrrrr... dead again!', 12, 0, 100, 0, 0, 0, 23848, 0, 'Black Conrad\'s Ghost'),
(@NPC_BLACK_CONRAD, 2, 0, 'Looks like me boys need a hand!', 12, 0, 100, 0, 0, 0, 23844, 0, 'Black Conrad\'s Ghost');

-- fix Stairway to Mercy
SET @NPC_CAPTAIN_ELLIS  := 24910;
SET @NPC_SORLOF         := 24914;
SET @NPC_JUNIPER        := 24956;
SET @GUID_JUNIPER       := 624956;
SET @GO_STAIRWAY_MERCY  := 187117;

DELETE FROM `creature` WHERE `guid` = @GUID_JUNIPER;
INSERT INTO `creature` (`guid`, `id`, `map`, `zoneId`, `areaId`, `spawnMask`, `phaseMask`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`,
`wander_distance`, `currentwaypoint`, `curhealth`, `curmana`, `MovementType`, `npcflag`, `unit_flags`, `dynamicflags`, `ScriptName`, `VerifiedBuild`, `CreateObject`, `Comment`) VALUES
--
(@GUID_JUNIPER, 24956, 571, 0, 0, 1, 1, 0, 105.78, -3689.83, 2.10135, 2.20969, 300, 0, 0, 61160, 0, 0, 0, 0, 0, '', NULL, 0, NULL);

UPDATE creature_template SET `AIName` = 'SmartAI' WHERE `entry` = @NPC_JUNIPER;
DELETE FROM `gameobject` WHERE `guid` = 100055 AND `id` = @GO_STAIRWAY_MERCY; -- remove GO added by AC
DELETE FROM `smart_scripts` WHERE `source_type` = 0 AND `entryorguid` IN (@NPC_CAPTAIN_ELLIS, -(@GUID_JUNIPER));
DELETE FROM `smart_scripts` WHERE `source_type` = 9 AND `entryorguid` IN (2491001, 2491002, 2495601);

INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`,
`event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `event_param6`,
`action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`,
`target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
--
(@NPC_CAPTAIN_ELLIS, 0, 0, 0, 103, 0, 100, 0, 0, @NPC_SORLOF, 1, 80, 5000, 0, 80, 2491001, 0, 0, 0, 0, 0, 1, 0,0,0,0,0,0,0,0,      'Captain Ellis - On Near Sorlof - Run Script 2491001'),
(-(@GUID_JUNIPER), 0, 0, 0, 103, 0, 100, 0, 0, @NPC_CAPTAIN_ELLIS, 1, 50, 5000, 0, 80, 2495601, 0, 0, 0, 0, 0, 1, 0,0,0,0,0,0,0,0, 'Juniper - On Near Captain Ellis - Run Script 2495601'),
(-(@GUID_JUNIPER), 0, 1, 2, 11, 0, 100, 0, 0, 0, 0, 0, 0, 0, 48, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,                      'Juniper - On Respawn - Set Active'),
(-(@GUID_JUNIPER), 0, 2, 3, 61, 0, 100, 0, 0, 0, 0, 0, 0, 0, 47, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,                      'Juniper - On Respawn - Set Visible OFF'),
(-(@GUID_JUNIPER), 0, 3, 0, 61, 0, 100, 0, 0, 0, 0, 0, 0, 0, 2, 35, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,                      'Juniper - On Respawn - Set Faction Friendly'),
--
(2491001, 9, 0, 0, 0, 0, 100, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,                                 'Script9 - Captain Ellis - Say Text 0'),
(2491001, 9, 1, 0, 0, 0, 100, 0, 90000, 90000, 0, 0, 0, 0, 47, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,                        'Script9 - Captain Ellis - Wait for Ship to disappear'),
(2495601, 9, 0, 0, 0, 0, 100, 0,0,0,0,0,0,0, 50, @GO_STAIRWAY_MERCY, 60, 0,0,0,0, 8, 0,0,0,0, 97.52, -3684.33, 2.944, -2.0246,     'Script9 - Juniper - Summon Stairway to Mercy'),
(2495601, 9, 1, 0, 0, 0, 100, 0, 90000, 90000, 0, 0, 0, 0, 47, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,                        'Script9 - Juniper - Wait for Ship to disappear');

-- quest: Mimicking Nature's Call, fix missing text (https://www.youtube.com/watch?v=bbLvn4TiMwg)
DELETE FROM `smart_scripts` WHERE `source_type` = 0 AND `entryorguid` = 24173;
DELETE FROM `smart_scripts` WHERE `source_type` = 9 AND `entryorguid` = 2417300;

INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`,
`event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `event_param6`,
`action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`,
`target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
--
(24173, 0, 0, 0, 11, 0, 100, 0, 0, 0, 0, 0, 0, 0, 18, 256, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,                   'Frostgore - On Respawn - Set Flags Immune To Players'),
(24173, 0, 1, 0, 11, 0, 100, 0, 0, 0, 0, 0, 0, 0, 232, 241731, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,               'Frostgore - On Respawn - Start Path 241731'),
(24173, 0, 2, 0, 108, 0, 100, 0, 5, 241731, 0, 0, 0, 0, 80, 2417300, 2, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,         'Frostgore - On Point 5 of Path 241731 Reached - Run Script'),
(24173, 0, 3, 0, 9, 0, 100, 0, 0, 0, 9000, 15000, 0, 10, 11, 52058, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,          'Frostgore - Within 0-10 Range - Cast Ground Slam'),
(24173, 0, 4, 5, 7, 0, 100, 0, 0, 0, 0, 0, 0, 0, 47, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,                      'Frostgore - On Evade - Set Visible OFF'),
(24173, 0, 5, 0, 61, 0, 100, 0, 0, 0, 0, 0, 0, 0, 41, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,                     'Frostgore - On Evade - Despawn'),
--
(2417300, 9, 0, 0, 0, 0, 100, 0, 0, 0, 0, 0, 0, 0, 66, 0, 0, 0, 0, 0, 0, 21, 40, 0, 0, 0, 0, 0, 0, 0,                  'Script9 - Frostgore - Set Orientation Closest Player'),
(2417300, 9, 1, 0, 0, 0, 100, 0, 800, 800, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,                 'Script9 - Frostgore - Say Text 0'),
(2417300, 9, 2, 0, 0, 0, 100, 0, 3600, 3600, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,               'Script9 - Frostgore - Say Text 1'),
(2417300, 9, 3, 0, 0, 0, 100, 0, 3600, 3600, 0, 0, 0, 0, 19, 256, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,            'Script9 - Frostgore - Remove Flags Immune To Players'),
(2417300, 9, 4, 0, 0, 0, 100, 0, 0, 0, 0, 0, 0, 0, 49, 0, 0, 0, 0, 0, 0, 21, 40, 0, 0, 0, 0, 0, 0, 0,                  'Script9 - Frostgore - Start Attacking');
