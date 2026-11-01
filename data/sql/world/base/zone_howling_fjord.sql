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

-- quest: The Dead Rise! - fix Fengir's Clue
UPDATE `gameobject` SET `position_z` = 297.034 WHERE `guid` = 59521 AND `id` = 187022; -- Mound of Debris
