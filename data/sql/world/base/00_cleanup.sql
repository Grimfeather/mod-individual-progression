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
