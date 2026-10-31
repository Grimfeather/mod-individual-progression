-- quest `Abduction` (11590) not being rewarded for all party members
UPDATE `creature_template` SET `AIName` = 'SmartAI' WHERE `entry` = 25262;

DELETE FROM `smart_scripts` WHERE `source_type` = 0 AND `entryorguid` = 25262;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`,
`event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `event_param6`,
`action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`,
`target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
--
(25262, 0, 0, 0, 20, 0, 100, 0, 11590, 0, 0, 0, 0, 0, 11, 45739, 0, 0, 0, 0, 0, 16, 0, 0, 0, 0, 0, 0, 0, 0, 'Librarian Donathan - On Quest Rewarded - Cast Spell Abduction: Quest Complete (Force Cast)');

-- quest `Monitoring the Rift, reward invoker party
UPDATE `smart_scripts` SET `target_type` = 16 WHERE `source_type` = 0 AND `id` = 0 AND `entryorguid` = 25308;

-- quest `The Art of Persuasion`, use IP script instead
UPDATE `creature` SET `ScriptName` = 'npc_imprisoned_beryl_sorcerer_ipp' WHERE `guid` = 108032 AND `id` = 25478;
