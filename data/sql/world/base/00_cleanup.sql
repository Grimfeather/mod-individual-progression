/* Several unused BG NPCs have wrong classes in AC - fix to prevent console warning */
UPDATE `creature_template` SET `unit_class` = 2 WHERE `entry` IN (22742, 22791, 22796, 22792, 22627, 22532, 22774, 22534, 22529, 22537, 22790, 22791, 22637, 22599,
                                                                 32013, 22781, 31930, 32128, 31935, 31927, 31938, 32120, 37332, 32142, 31821, 37248, 37453, 37253,
                                                                 37245, 37256, 37443, 37472, 37341);
UPDATE `creature_template` SET `unit_class` = 1 WHERE `entry` IN (22632, 32055, 31921, 37376);
UPDATE `creature_template` SET `unit_class` = 8 WHERE `entry` IN (29273);

/* Delete unused Creature Addon data */
DELETE FROM `creature_addon` WHERE `guid` IN (133917, 133918, 133919, 133920, 133925);

-- battlemasters
DELETE FROM `game_event_creature` WHERE `guid` IN (207918, 207929, 207951, 208042, 208081, 208107, 208146, 208159, 208185, 208511, 208512); -- alliance
DELETE FROM `game_event_creature` WHERE `guid` IN (208207, 208240, 208251, 208355, 208368, 208394, 208407, 208509, 208510); -- horde

-- remove AzerothCore area triggers used by WotLK Scourge Invasion Event
DELETE FROM `areatrigger_involvedrelation` WHERE `id` IN (4092, 4094, 4095, 4096, 4098, 4099, 4100, 4101, 4103, 4104, 4105, 5151, 5152, 5153, 5154, 5158, 5159, 5160, 5161);

-- remove arena season event entries added by AC
DELETE FROM `creature_addon` WHERE `guid` IN (88155, 88156, 88158, 88159, 88160);
DELETE FROM `game_event_creature` WHERE `guid` IN 
(17676, 88155, 88156, 88158, 88159, 88160, 91798, 152022, 152023, 152026, 152027, 152028, 152029, 152030, 152031, 202335, 202336, 
208486, 208487, 208488, 208489, 208491, 208492, 208494, 208496, 208498, 208499, 208500, 208501, 208503, 208504, 208506, 208508);

DELETE FROM `creature`   WHERE `id`   IN (32405, 32832, 32834);
DELETE FROM `npc_vendor` WHERE `entry` IN (32405, 32832, 32834);
DELETE FROM `creature` WHERE `guid` = 88156 AND `id` IN (20278); -- Vixton Pinchwhistle


/* the following edits are temporary */

-- clean up mistake in zone_desolace
DELETE FROM `smart_scripts` WHERE `source_type` = 0 AND `entryorguid` = 1162505;

-- undo SAI for Doomguard Commander - AC handles this correctly now
DELETE FROM `smart_scripts` WHERE `source_type` = 0 AND `entryorguid` = 12396;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`,
`event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `event_param6`,
`action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`,
`target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
--
(12396, 0, 0, 0, 0, 0, 100, 0, 5000, 8000, 18000, 24000, 0, 0, 11, 16005, 0, 0, 0, 0, 0, 5, 30, 0, 0, 0, 0, 0, 0, 0,    'Doomguard Commander - In Combat - Cast Rain of Fire'),
(12396, 0, 1, 0, 0, 0, 100, 0, 12000, 15000, 20000, 25000, 0, 0, 11, 16727, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,   'Doomguard Commander - In Combat - Cast War Stomp'),
(12396, 0, 2, 0, 0, 0, 100, 0, 2000, 4000, 25000, 32000, 0, 0, 11, 20812, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0,     'Doomguard Commander - In Combat - Cast Cripple'),
(12396, 0, 3, 0, 0, 0, 100, 0, 7000, 14000, 17000, 22000, 0, 0, 11, 15090, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0,    'Doomguard Commander - In Combat - Cast Dispel Magic'),
(12396, 0, 4, 0, 8, 0, 100, 1, 23019, 0, 0, 0, 0, 0, 80, 1239600, 2, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,             'Doomguard Commander - On Spellhit \'Crystal Prison Dummy DND\' - Run Script (No Repeat)');

-- rank 2 was rank 1 during TBC, undo mistake thinking it didn't exist durint TBC
UPDATE `trainer_spell` SET `ReqLevel` = 62 WHERE `TrainerId` = 7 AND `SpellId` = 34120;  -- Steady Shot (Rank 2), level 72 -> 62

-- undo forced phasing of Ysuria in Theramore
UPDATE `creature` SET `ScriptName` = '' WHERE `id` = 27703;

-- restore Midnight script, now properly overriding the script
UPDATE `creature_template` SET `ScriptName` = 'boss_midnight' WHERE `entry` = 16151;
UPDATE `creature_template` SET `ScriptName` = '' WHERE `entry` = 605;

-- restore AC's Ironhand Guardians
DELETE FROM `creature_template` WHERE `entry` IN (108982);
DELETE FROM `creature_template_model` WHERE `CreatureID` = 108982; -- 00_cleanup
UPDATE `creature_template` SET `ScriptName` = 'brd_ironhand_guardian' WHERE `entry` = 8982; -- 00_cleanup
DELETE FROM `smart_scripts` WHERE `source_type` = 0 AND `entryorguid` IN (108982); -- 00_cleanup

DELETE FROM `creature` WHERE `id` IN (8982, 108982); -- 00_cleanup
INSERT INTO `creature` (`guid`, `id`, `map`, `zoneId`, `areaId`, `spawnMask`, `phaseMask`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, 
`wander_distance`, `currentwaypoint`, `curhealth`, `curmana`, `MovementType`, `npcflag`, `unit_flags`, `dynamicflags`, `ScriptName`, `VerifiedBuild`, `CreateObject`, `Comment`) VALUES 
--
(47323, 8982, 230, 0, 0, 1, 1, 0, 1407.29, -587.299, -91.9711, 3.15905, 7200, 0, 0, 126, 0, 0, 0, 0, 0, '', 0, 0, NULL),
(47442, 8982, 230, 0, 0, 1, 1, 0, 1353.43, -587.317, -91.9711, 0.15708, 7200, 0, 0, 126, 0, 0, 0, 0, 0, '', 0, 0, NULL),
(47466, 8982, 230, 0, 0, 1, 1, 0, 1406.88, -632.438, -91.9711, 3.14159, 7200, 0, 0, 126, 0, 0, 0, 0, 0, '', 0, 0, NULL),
(47472, 8982, 230, 0, 0, 1, 1, 0, 1353.92, -632.75, -91.9711, 0.122173, 7200, 0, 0, 126, 0, 0, 0, 0, 0, '', 0, 0, NULL),
(47473, 8982, 230, 0, 0, 1, 1, 0, 1407.67, -677.718, -91.9711, 3.14159, 7200, 0, 0, 126, 0, 0, 0, 0, 0, '', 0, 0, NULL),
(47474, 8982, 230, 0, 0, 1, 1, 0, 1353.16, -677.38, -91.9711, 0, 7200, 0, 0, 126, 0, 0, 0, 0, 0, '', 0, 0, NULL);

-- remove AV conditons that aren't used anymore
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId` = 29 AND `ConditionTypeOrReference` = 29 AND `SourceEntry` IN 
(110982, 111603, 111604, 113089, 113097, 113316, 113087, 113096, 113317, 110987, 111600, 111602, 113081, 113099, 113397, 113080, 113098, 113396, 113358, 113359); -- 00_cleanup

-- remove pvp progression requirements to show pvp gear. added rank requirements back
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId` = 23 AND `ConditionTypeOrReference` = 8 AND `Comment` = "Vanilla PvP Ranked Gear (IPP)";

-- BRD Detention Block: older versions of dungeon_blackrock_depths.sql replaced the patrols that AC 2026_09_24_09 sets up
-- (positions, paths 459170..910840 instead of guid * 100, formations); put AC's version back
UPDATE `creature` SET `position_x` = 505.312, `position_y` = -124.581, `position_z` = -62.091, `orientation` = 3.3517, `currentwaypoint` = 0, `VerifiedBuild` = 69110 WHERE `guid` = 47825 AND `id` = 8890;
UPDATE `creature` SET `position_x` = 424.321, `position_y` = -79.389, `position_z` = -64.193, `orientation` = 2.8469, `currentwaypoint` = 0, `VerifiedBuild` = 69110 WHERE `guid` = 91084 AND `id` = 8890;
UPDATE `creature` SET `position_x` = 524.359, `position_y` = -73.163, `position_z` = -62.163, `orientation` = 5.3016, `currentwaypoint` = 0, `VerifiedBuild` = 69110 WHERE `guid` = 47832 AND `id` = 8921;
UPDATE `creature` SET `position_x` = 502.454, `position_y` = -73.061, `position_z` = -63.079, `orientation` = 1.3006, `currentwaypoint` = 0, `VerifiedBuild` = 69110 WHERE `guid` = 45917 AND `id` = 8921;
UPDATE `creature` SET `position_x` = 485.841, `position_y` = -104.503, `position_z` = -62.635, `orientation` = 3.8515, `currentwaypoint` = 0, `VerifiedBuild` = 69110 WHERE `guid` = 45924 AND `id` = 8921;
UPDATE `creature` SET `position_x` = 422.511, `position_y` = -79.066, `position_z` = -63.935, `orientation` = 2.8346, `currentwaypoint` = 0, `VerifiedBuild` = 69110 WHERE `guid` = 90688 AND `id` = 8921;
UPDATE `creature` SET `position_x` = 410.003, `position_y` = -183.575, `position_z` = -63.584, `orientation` = 3.8935, `currentwaypoint` = 0, `VerifiedBuild` = 69110 WHERE `guid` = 90855 AND `id` = 8921;

DELETE FROM `creature_addon` WHERE `guid` IN (45917, 45924, 47825, 47832, 90688, 90855, 91084);
INSERT INTO `creature_addon` (`guid`, `path_id`, `mount`, `bytes1`, `bytes2`, `emote`, `visibilityDistanceType`, `auras`) VALUES
(45917, 4591700, 0, 0, 1, 0, 0, '8279'),
(45924, 4592400, 0, 0, 1, 0, 0, '8279'),
(47825, 4782500, 0, 0, 1, 0, 0, NULL),
(47832, 4783200, 0, 0, 1, 0, 0, '8279'),
(90688, 9068800, 0, 0, 1, 0, 0, '8279'),
(90855, 9085500, 0, 0, 1, 0, 0, '8279'),
(91084, 9108400, 0, 0, 1, 0, 0, NULL);

DELETE FROM `creature_formations` WHERE `leaderGUID` IN (45917, 45924, 47825, 47832, 90688, 90855, 91084);
DELETE FROM `creature_formations` WHERE `memberGUID` IN (45915, 45916, 45917, 45924, 45925, 45926, 47825, 47826, 47827, 47830, 47831, 47832, 90686, 90687, 90688, 90855, 90856, 90857, 91084, 91085, 91086);
INSERT INTO `creature_formations` (`leaderGUID`, `memberGUID`, `dist`, `angle`, `groupAI`, `point_1`, `point_2`) VALUES
(45917, 45917, 0, 0, 515, 0, 0),
(45917, 45915, 2, 90, 515, 0, 0),
(45917, 45916, 2, 180, 515, 0, 0),
(45924, 45924, 0, 0, 515, 0, 0),
(45924, 45925, 6, 180, 515, 0, 0),
(45924, 45926, 4, 180, 515, 0, 0),
(47825, 47825, 0, 0, 515, 0, 0),
(47825, 47826, 2, 90, 515, 0, 0),
(47825, 47827, 2, 180, 515, 0, 0),
(47832, 47832, 0, 0, 515, 0, 0),
(47832, 47830, 2, 90, 515, 0, 0),
(47832, 47831, 2, 180, 515, 0, 0),
(90688, 90688, 0, 0, 515, 0, 0),
(90688, 90686, 2, 90, 515, 0, 0),
(90688, 90687, 2, 180, 515, 0, 0),
(90855, 90855, 0, 0, 515, 0, 0),
(90855, 90856, 2, 90, 515, 0, 0),
(90855, 90857, 2, 180, 515, 0, 0),
(91084, 91084, 0, 0, 515, 0, 0),
(91084, 91085, 2, 90, 515, 0, 0),
(91084, 91086, 2, 180, 515, 0, 0);

-- Serpent Statue: older versions of zone_desolace.sql replaced the summon of Lord Kragaru that AC 2026_09_12_02
-- moves onto the statue; put AC's version back
DELETE FROM `smart_scripts` WHERE (`source_type` = 1 AND `entryorguid` IN (177673, 177705)) OR (`source_type` = 9 AND `entryorguid` = 17767300);
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`,
`event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `event_param6`,
`action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`,
`target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
--
(177673, 1, 0, 1, 70, 0, 100, 0, 2, 0, 0, 0, 0, 0, 80, 17767300, 2, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Serpent Statue - On Loot State Changed (Activated) - Call Timed Actionlist'),
(177673, 1, 1, 0, 61, 0, 100, 0, 0, 0, 0, 0, 0, 0, 241, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Serpent Statue - On Link - Summon Gameobject Group 0 \'Naga Beam\''),
(17767300, 9, 0, 0, 0, 0, 100, 0, 3500, 3500, 0, 0, 0, 0, 12, 12369, 1, 180000, 0, 0, 0, 8, 0, 0, 0, 0, 252.57, 2963.7, 1.72356, 1.29154, 'Serpent Statue - On Script - Summon Creature \'Lord Kragaru\'');
