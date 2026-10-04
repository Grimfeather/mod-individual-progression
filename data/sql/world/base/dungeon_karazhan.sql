/* smart scripts */
UPDATE `creature_template` SET `AIName` = 'SmartAI' WHERE `entry` IN
(15547, 15548, 15551, 16173, 16174, 16176, 16177, 16389, 16406, 16408, 16409, 16410, 16411, 16412, 16415, 16424, 16425, 16459, 16460, 16468,
 16470, 16471, 16472, 16473, 16481, 16482, 16485, 16488, 16489, 16492, 16504, 16525, 16529, 16539, 16540, 16544, 16545, 16595, 16596);
 
DELETE FROM `smart_scripts` WHERE `source_type` = 0 AND `entryorguid` IN
(15547, 15548, 15551, 16173, 16174, 16176, 16177, 16389, 16406, 16408, 16409, 16410, 16411, 16412, 16415, 16424, 16425, 16459, 16460, 16468,
 16470, 16471, 16472, 16473, 16481, 16482, 16485, 16488, 16489, 16492, 16504, 16525, 16529, 16539, 16540, 16544, 16545, 16595, 16596);

INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`,
`event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `event_param6`,
`action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`,
`target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
--
(15547, 0, 0, 0, 0, 0, 100, 0, 1000, 10000, 12000, 25000, 0, 0, 11, 29320, 0, 0, 0, 0, 0, 28, 40, 0, 0, 0, 0, 0, 0, 0, 'Spectral Charger - In Combat - Cast Charge'),
(15547, 0, 1, 0, 31, 0, 100, 0, 29320, 0, 0, 0, 0, 0, 11, 29321, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,             'Spectral Charger - On Target Spellhit Charge - Cast Fear'),
(15547, 0, 2, 0, 11, 0, 100, 0, 0, 0, 0, 0, 0, 0, 11, 19817, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,                 'Spectral Charger - On Respawn - Cast Double Attack'), -- new! check aura!
(15548, 0, 0, 0, 0, 0, 100, 0, 6000, 18000, 10000, 20000, 0, 0, 11, 29577, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0,   'Spectral Stallion - In Combat - Cast Hoof Strike'),
(15548, 0, 1, 0, 0, 0, 100, 0, 6000, 18000, 6000, 18000, 0, 0, 11, 29323, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,    'Spectral Stallion - In Combat - Cast Absorb Vitality'),
--
(15551, 0, 0, 0, 4, 0, 30, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,                        'Spectral Stable Hand - On Aggro - Say Line 0'),
(15551, 0, 1, 0, 6, 0, 50, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,                        'Spectral Stable Hand - On Death - Say Line 1'),
(15551, 0, 2, 0, 1, 0, 60, 0, 0, 70000, 80000, 190000, 0, 0, 1, 2, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,           'Spectral Stable Hand - Out of Combat - Say Line 2'),
(15551, 0, 3, 0, 0, 0, 100, 0, 2000, 11000, 12000, 21000, 0, 0, 11, 18812, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0,   'Spectral Stable Hand - In Combat - Cast Knockdown'),
(15551, 0, 4, 0, 0, 0, 100, 0, 2000, 15000, 17000, 28000, 0, 0, 11, 6016, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0,    'Spectral Stable Hand - In Combat - Cast Pierce Armor'),
(15551, 0, 5, 0, 74, 0, 100, 0, 0, 0, 14000, 22000, 70, 40, 11, 29339, 0, 0, 0, 0, 0, 9, 15547, 0, 40, 1, 0, 0, 0, 0,  'Spectral Stable Hand - Spectral Charger below 70% hp - Cast Healing Touch'),
(15551, 0, 6, 0, 74, 0, 100, 0, 0, 0, 14000, 22000, 70, 40, 11, 29339, 0, 0, 0, 0, 0, 9, 15548, 0, 40, 1, 0, 0, 0, 0,  'Spectral Stable Hand - Spectral Stallion below 70% hp - Cast Healing Touch'),
(15551, 0, 7, 0, 0, 0, 100, 0, 0, 0, 21000, 38000, 0, 0, 11, 29340, 0, 0, 0, 0, 0, 9, 15547, 0, 40, 1, 0, 0, 0, 0,     'Spectral Stable Hand - In Combat - Cast Whip Rage'),
--
(16171, 0, 0, 0, 0, 0, 100, 0, 9000, 14000, 14000, 20000, 0, 0, 11, 29292, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,   'Coldmist Widow - In Combat - Cast Frost Mist'),
(16171, 0, 1, 0, 0, 0, 100, 0, 5000, 10000, 9000, 22000, 0, 0, 11, 29293, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,    'Coldmist Widow - In Combat - Cast Poison Bolt Volley'),
(16171, 0, 2, 0, 6, 0, 100, 512, 0, 0, 0, 0, 0, 0, 34, 100, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,                  'Coldmist Widow - On Death - Set Instance Data 100 to 1'),
(16173, 0, 0, 0, 0, 0, 100, 0, 5000, 10000, 7000, 11000, 0, 0, 11, 29298, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,    'Shadowbat - In Combat - Cast Dark Shriek'),
(16173, 0, 1, 0, 6, 0, 100, 512, 0, 0, 0, 0, 0, 0, 34, 100, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,                  'Shadowbat - On Death - Set Instance Data 100 to 1'),
(16174, 0, 0, 0, 0, 0, 100, 0, 4000, 7000, 7000, 10000, 0, 0, 11, 29300, 0, 0, 0, 0, 0, 5, 5, 0, 0, 0, 0, 0, 0, 0,     'Greater Shadowbat - In Combat - Cast Sonic Blast'),
(16174, 0, 1, 0, 0, 0, 100, 0, 7000, 11000, 11000, 16000, 0, 0, 11, 29303, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,   'Greater Shadowbat - In Combat - Cast Wing Beat'),
(16174, 0, 2, 0, 6, 0, 100, 512, 0, 0, 0, 0, 0, 0, 34, 100, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,                  'Greater Shadowbat - On Death - Set Instance Data 100 to 1'),
(16176, 0, 0, 0, 0, 0, 100, 0, 9000, 17000, 21000, 27000, 0, 0, 11, 29304, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,   'Shadowbeast - In Combat - Cast Howl of the Broken Hills'),
(16176, 0, 1, 0, 6, 0, 100, 512, 0, 0, 0, 0, 0, 0, 34, 100, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,                  'Shadowbeast - On Death - Set Instance Data 100 to 1'),
(16177, 0, 0, 0, 9, 0, 100, 0, 0, 0, 7000, 11000, 0, 5, 11, 29561, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0,           'Dreadbeast - Within 0-5 Range - Cast Cleave'),
(16177, 0, 1, 0, 6, 0, 100, 512, 0, 0, 0, 0, 0, 0, 34, 100, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,                  'Dreadbeast - On Death - Set Instance Data 100 to 1'),
(16389, 0, 0, 0, 4, 0, 30, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,                        'Spectral Apprentice - On Aggro - Say Line 0'),
(16389, 0, 1, 0, 6, 0, 50, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,                        'Spectral Apprentice - On Death - Say Line 1'),
(16389, 0, 2, 0, 9, 0, 100, 0, 0, 0, 4000, 11000, 0, 5, 11, 29618, 32, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0,          'Spectral Apprentice - Within 0-5 Range - Cast Burning Brand'),
(16406, 0, 0, 0, 4, 0, 30, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,                        'Phantom Attendant - On Aggro - Say Line 0'),
(16406, 0, 1, 0, 6, 0, 50, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,                        'Phantom Attendant - On Death - Say Line 1'),
(16406, 0, 2, 0, 74, 0, 100, 0, 9000, 20000, 30000, 35000, 50, 40, 11, 29587, 0, 0, 0, 0, 0, 7, 0,0,0,0,0,0,0,0,       'Phantom Attendant - Friendly below 50% Health - Cast Shadow Rejuvenation'),
(16406, 0, 3, 0, 105, 0, 100, 0, 0, 0, 22000, 32000, 0, 5, 11, 29586, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 0,        'Phantom Attendant - Victim Casting - Cast Kick'),
(16407, 0, 0, 0, 4, 0, 30, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,                        'Spectral Servant - On Aggro - Say Line 0'),
(16407, 0, 1, 0, 6, 0, 50, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,                        'Spectral Servant - On Death - Say Line 1'),
(16407, 0, 2, 0, 1, 0, 50, 0, 0, 80000, 80000, 200000, 0, 0, 1, 2, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,           'Spectral Servant - Out of Combat - Say Line 2'),
(16407, 0, 3, 0, 0, 0, 100, 0, 6000, 22000, 17000, 25000, 0, 0, 11, 29540, 0, 0, 0, 0, 0, 5, 10, 0, 0, 0, 0, 0, 0, 0,  'Spectral Servant - In Combat - Cast Curse of Past Burdens'),
(16407, 0, 4, 5, 8, 0, 100, 512, 29345, 0, 60000, 100000, 0, 0, 64, 1, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 0,       'Spectral Servant - On Spell Hit Weiter Search - Store Target'),
(16407, 0, 5, 0, 61, 0, 100, 512, 0, 0, 0, 0, 0, 0, 80, 1640700, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,             'Spectral Servant - On Spell Hit Weiter Search - Run Script'),
(16408, 0, 0, 0, 4, 0, 30, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,                        'Phantom Valet - On Aggro - Say Line 0'),
(16408, 0, 1, 0, 6, 0, 50, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,                        'Phantom Valet - On Death - Say Line 1'),
(16408, 0, 2, 0, 0, 1, 100, 0, 4000, 10000, 9000, 15000, 0, 0, 11, 29584, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,    'Phantom Valet - In Combat - Cast Demoralizing Shout'),
--
(16409, 0, 0, 0, 4, 0, 20, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,                        'Phantom Guest - On Aggro - Say Line 0'),
(16409, 0, 1, 0, 6, 0, 30, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,                        'Phantom Guest - On Death - Say Line 1'),
(16409, 0, 3, 4, 37, 0, 100, 512, 0, 0, 0, 0, 0, 0, 211, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,                  'Phantom Guest - On AI Init - No Event Phase Reset'),
(16409, 0, 4, 0, 61, 0, 100, 512, 0, 0, 0, 0, 0, 0, 31, 1, 5, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,                   'Phantom Guest - On AI Init - Set Random Phase Range'),
(16409, 0, 5, 0, 0, 1, 100, 1, 0, 0, 0, 0, 0, 0, 11, 29521, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,                  'Phantom Guest - In Combat - Cast Dance Vibe (Hunter)'),
(16409, 0, 6, 0, 0, 1, 100, 0, 0, 1000, 2000, 4000, 0, 0, 11, 29582, 64, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0,        'Phantom Guest - In Combat - Cast Throw (Hunter)'),
(16409, 0, 7, 0, 0, 1, 100, 0, 7000, 11000, 7000, 9000, 0, 0, 11, 29583, 64, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0,    'Phantom Guest - In Combat - Cast Impale (Hunter)'),
(16409, 0, 8, 0, 0, 2, 100, 0, 2000, 5000, 14000, 21000, 0, 0, 11, 29579, 0, 0, 0, 0, 0, 5, 30, 0, 0, 0, 0, 0, 0, 0,   'Phantom Guest - In Combat - Cast Throw Dynamite (Engineer)'),
(16409, 0, 9, 0, 9, 2, 100, 0, 0, 0, 8000, 17000, 0, 10, 11, 29513, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0,          'Phantom Guest - Within 0-10 Range - Cast Goblin Dragon Gun (Engineer)'),
(16409, 0, 10, 0, 0, 4, 100, 0, 6000, 25000, 10000, 25000, 0, 0, 11, 29930, 32, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 'Phantom Guest - In Combat - Cast Curse of Agony (Caster)'),
(16409, 0, 11, 0, 0, 4, 100, 0, 10000, 21000, 13000, 23000, 0, 0, 11, 29928, 32, 0, 0, 0, 0, 2, 0,0,0,0,0,0,0,0,       'Phantom Guest - In Combat - Cast Immolate (Caster)'),
(16409, 0, 12, 0, 0, 4, 100, 0, 0, 2000, 4000, 6000, 0, 0, 11, 29492, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0,        'Phantom Guest - In Combat - Cast Searing Pain (Caster)'),
(16409, 0, 13, 0, 74, 8, 100, 0, 2000, 9000, 9000, 13000, 50, 30, 11, 29580, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 0, 'Phantom Guest - Friendly below 50% Health - Cast Heal (Healer)'),
(16409, 0, 14, 0, 0, 8, 100, 0, 5000, 8000, 5000, 10000, 0, 0, 11, 29514, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,    'Phantom Guest - In Combat - Cast Holy Nova (Healer)'),
(16409, 0, 15, 0, 1, 0, 15, 0, 0, 70000, 70000, 150000, 0, 0, 1, 2, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,          'Phantom Guest - Out of Combat - Say Line 2'),
(16409, 0, 16, 0, 1, 0, 15, 0, 0, 70000, 70000, 150000, 0, 0, 1, 4, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,          'Phantom Guest - Out of Combat - Say Line 4'),
(16409, 0, 17, 0, 1, 0, 100, 512, 0, 20000, 20000, 40000, 0, 0, 11, 29345, 2, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,   'Phantom Guest - Out of Combat - Cast Waiter Search'),
--
(16410, 0, 0, 0, 4, 0, 30, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,                        'Spectral Retainer - On Aggro - Say Line 0'),
(16410, 0, 1, 0, 6, 0, 50, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,                        'Spectral Retainer - On Death - Say Line 1'),
(16410, 0, 2, 0, 0, 0, 100, 0, 6000, 18000, 6000, 15000, 0, 0, 11, 29578, 32, 0, 0, 0, 0, 5, 5, 0, 0, 0, 0, 0, 0, 0,   'Spectral Retainer - In Combat - Cast Rend'),
(16410, 0, 3, 0, 0, 0, 100, 0, 5000, 15000, 30000, 40000, 0, 0, 11, 29546, 32, 0, 0, 0, 0, 5, 25, 1, 0, 0, 0, 0, 0, 0, 'Spectral Retainer - In Combat - Cast Oath of Fealty'),
(16411, 0, 0, 0, 4, 0, 30, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,                        'Spectral Chef - On Aggro - Say Line 0'),
(16411, 0, 1, 0, 6, 0, 50, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,                        'Spectral Chef - On Death - Say Line 1'),
(16411, 0, 2, 0, 0, 0, 100, 0, 4000, 8000, 6000, 10000, 0, 0, 11, 29665, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0,     'Spectral Chef - In Combat - Cast Cleave'),
(16411, 0, 3, 0, 0, 0, 100, 0, 8000, 13000, 12000, 15000, 0, 0, 11, 29667, 32, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0,  'Spectral Chef - In Combat - Cast Hamstring'),
(16412, 0, 0, 0, 4, 0, 30, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,                        'Ghostly Baker - On Aggro - Say Line 0'),
(16412, 0, 1, 0, 6, 0, 50, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,                        'Ghostly Baker - On Death - Say Line 1'),
(16412, 0, 2, 0, 0, 0, 100, 0, 5000, 9000, 12000, 18000, 0, 0, 11, 29675, 32, 0, 0, 0, 0, 5, 30, 0, 0, 0, 0, 0, 0, 0,  'Ghostly Baker - In Combat - Cast Roast'),
(16412, 0, 3, 0, 0, 0, 100, 0, 4000, 8000, 7000, 12000, 0, 0, 11, 29676, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0,     'Ghostly Baker - In Combat - Cast Rolling Pin'),
(16415, 0, 1, 0, 0, 0, 100, 0, 11000, 20000, 21000, 30000, 0, 0, 11, 32441, 32, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 'Skeletal Waiter - In Combat - Cast Brittle Bones'),
(16415, 0, 2, 3, 8, 0, 100, 512, 29345, 0, 60000, 100000, 0, 0, 64, 1, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 0,       'Skeletal Waiter - On Spell Hit Weiter Search - Store Target'),
(16415, 0, 3, 0, 61, 0, 100, 512, 0, 0, 0, 0, 0, 0, 80, 1641500, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,             'Skeletal Waiter - On Spell Hit Weiter Search - Run Script'),
(16424, 0, 0, 0, 0, 0, 100, 0, 0, 0, 2000, 4000, 0, 0, 11, 29575, 64, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0,           'Spectral Sentry - In Combat - Cast Shoot'),
(16424, 0, 1, 0, 0, 0, 100, 0, 8000, 18000, 13000, 20000, 0, 0, 11, 29576, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0,   'Spectral Sentry - In Combat - Cast Multi-Shot'),
(16424, 0, 2, 0, 4, 0, 30, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,                        'Spectral Sentry - On Aggro - Say Line 0'),
(16424, 0, 3, 0, 6, 0, 30, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,                        'Spectral Sentry - On Death - Say Line 1'),
(16425, 0, 0, 0, 2, 0, 100, 0, 0, 75, 45000, 60000, 0, 0, 11, 29537, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,         'Phantom Guardsman - Between 0-75% Health - Cast Summon Phantom Hound'),
(16425, 0, 1, 0, 0, 0, 100, 0, 6000, 14000, 11000, 18000, 0, 0, 11, 29684, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0,   'Phantom Guardsman - In Combat - Cast Shield Slam'),
(16425, 0, 2, 0, 4, 0, 30, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,                        'Phantom Guardsman - On Aggro - Say Line 0'),
(16425, 0, 3, 0, 6, 0, 30, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,                        'Phantom Guardsman - On Just Died - Say Line 1'),
(16459, 0, 0, 0, 4, 0, 30, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,                        'Wanton Hostess - On Aggro - Say Line 1'),
(16459, 0, 1, 0, 6, 0, 50, 0, 0, 0, 0, 0, 0, 0, 1, 2, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,                        'Wanton Hostess - On Death - Say Line 2'),
(16459, 0, 2, 0, 1, 0, 50, 0, 0, 40000, 45000, 120000, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,           'Wanton Hostess - Out of Combat - Say Line 0'),
(16459, 0, 3, 0, 4, 0, 100, 0, 0, 0, 0, 0, 0, 0, 11, 29485, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,                  'Wanton Hostess - On Aggro - Cast Alluring Aura'),
(16459, 0, 4, 5, 2, 0, 100, 513, 0, 50, 0, 0, 0, 0, 28, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,                   'Wanton Hostess - Between 0-50% Health - Remove All Auras'),
(16459, 0, 5, 6, 61, 0, 100, 512, 0, 0, 0, 0, 0, 0, 11, 29472, 2, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,               'Wanton Hostess - Between 0-50% Health - Cast Wanton Hostess Transform'),
(16459, 0, 6, 7, 61, 0, 100, 512, 0, 0, 0, 0, 0, 0, 11, 29486, 2, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,               'Wanton Hostess - Between 0-50% Health - Cast Bewitching Aura'),
(16459, 0, 7, 0, 61, 0, 100, 512, 0, 0, 0, 0, 0, 0, 1, 3, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,                    'Wanton Hostess - On Transform - Say Line 3'),
(16459, 0, 8, 0, 0, 0, 100, 0, 5000, 8000, 7000, 10000, 0, 0, 11, 29477, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0,     'Wanton Hostess - In Combat - Cast Banshee Wail'),
(16459, 0, 9, 0, 0, 0, 100, 0, 5000, 10000, 12000, 15000, 0, 0, 11, 29505, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,   'Wanton Hostess - In Combat - Cast Banshee Shriek'), -- new!
(16460, 0, 0, 0, 4, 0, 30, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,                        'Night Mistress - On Aggro - Say Line 1'),
(16460, 0, 1, 0, 6, 0, 50, 0, 0, 0, 0, 0, 0, 0, 1, 2, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,                        'Night Mistress - On Death - Say Line 2'),
(16460, 0, 2, 0, 1, 0, 50, 0, 0, 40000, 45000, 120000, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,           'Night Mistress - Out of Combat - Say Line 0'),
(16460, 0, 3, 4, 2, 0, 100, 513, 0, 50, 0, 0, 0, 0, 11, 29488, 2, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,               'Night Mistress - Between 0-50% Health - Cast Night Mistress Transform'),
(16460, 0, 4, 5, 61, 0, 100, 512, 0, 0, 0, 0, 0, 0, 1, 3, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,                    'Night Mistress - On Transform - Say Line 3'),
(16460, 0, 5, 0, 61, 0, 100, 512, 0, 0, 0, 0, 0, 0, 22, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,                   'Night Mistress - Between 0-50% Health - Set Event Phase'),
(16460, 0, 6, 0, 0, 1, 100, 1, 500, 500, 0, 0, 0, 0, 11, 29491, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,              'Night Mistress - In Combat - Cast Impending Betrayal'),
(16460, 0, 7, 0, 0, 0, 100, 0, 0, 0, 2000, 3000, 0, 0, 11, 29487, 64, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0,           'Night Mistress - In Combat - Cast Shadow Bolt'),
(16460, 0, 8, 0, 0, 1, 100, 0, 12000, 15000, 11000, 17000, 0, 0, 11, 30358, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0,  'Night Mistress - In Combat - Cast Searing Pain'),
(16468, 0, 0, 0, 4, 0, 30, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,                        'Spectral Patron - On Aggro - Say Line 0'),
(16468, 0, 1, 0, 6, 0, 50, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,                        'Spectral Patron - On Death - Say Line 1'),
(16468, 0, 2, 0, 9, 0, 100, 0, 0, 0, 8000, 11000, 0, 5, 11, 29555, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0,           'Spectral Patron - Within 0-5 Range - Cast Left Hook'),
(16468, 0, 3, 0, 105, 0, 100, 0, 0, 0, 7000, 10000, 0, 5, 11, 29560, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 0,         'Spectral Patron - Victim Casting - Cast Kick'),
(16470, 0, 0, 0, 4, 0, 30, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,                        'Ghostly Philanthropist - On Aggro - Say Line 0'),
(16470, 0, 1, 0, 6, 0, 50, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,                        'Ghostly Philanthropist - On Death - Say Line 1'),
(16470, 0, 2, 0, 0, 0, 100, 0, 5000, 9000, 7000, 10000, 0, 0, 11, 29609, 256, 0, 0, 0, 0, 5, 25, 0, 0, 0, 0, 0, 0, 0,  'Ghostly Philanthropist - In Combat - Cast Ill Gift'),
(16470, 0, 3, 0, 0, 0, 100, 0, 7000, 12000, 21000, 30000, 0, 0, 11, 29612, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,   'Ghostly Philanthropist - In Combat - Cast Incite Rage'),
(16471, 0, 0, 0, 4, 0, 30, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,                        'Skeletal Usher - On Aggro - Say Line 0'),
(16471, 0, 1, 0, 6, 0, 50, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,                        'Skeletal Usher - On Death - Say Line 1'),
(16471, 0, 2, 0, 9, 0, 100, 0, 0, 0, 11000, 15000, 0, 20, 11, 29666, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0,         'Skeletal Usher - Within 0-20 Range - Cast Frost Shock'),
(16471, 0, 3, 0, 0, 0, 100, 0, 2000, 12000, 10000, 15000, 0, 0, 11, 29670, 0, 0, 0, 0, 0, 5, 15, 0, 0, 0, 0, 0, 0, 0,  'Skeletal Usher - In Combat - Cast Ice Tomb'),
(16471, 0, 5, 0, 0, 0, 100, 0, 9000, 14000, 16000, 21000, 0, 0, 11, 29661, 0, 0, 0, 0, 0, 17, 7, 40, 0, 0, 0, 0, 0, 0, 'Skeletal Usher - In Combat - Cast Magnetic Pull'),
(16472, 0, 0, 0, 4, 0, 30, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,                        'Phantom Stagehand - On Aggro - Say Line 0'),
(16472, 0, 1, 0, 6, 0, 50, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,                        'Phantom Stagehand - On Death - Say Line 1'),
(16472, 0, 2, 0, 1, 0, 100, 0, 0, 40000, 40000, 120000, 0, 0, 1, 2, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,          'Phantom Stagehand - Out of Combat - Say Line 2'),
(16472, 0, 3, 0, 9, 0, 100, 0, 0, 0, 4000, 6000, 5, 30, 11, 29677, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0,           'Phantom Stagehand - Within 5-30 Range - Cast Mallet Toss'),
(16472, 0, 4, 0, 0, 0, 100, 0, 3000, 9000, 9000, 18000, 0, 0, 11, 41580, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0,     'Phantom Stagehand - In Combat - Cast Net'),
(16472, 0, 5, 0, 9, 0, 100, 0, 0, 0, 12000, 22000, 0, 5, 11, 29673, 32, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0,         'Phantom Stagehand - Within 0-5 Range - Cast Sandbag'),
(16473, 0, 0, 0, 4, 0, 30, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,                        'Spectral Performer - On Aggro - Say Line 0'),
(16473, 0, 1, 0, 6, 0, 50, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,                        'Spectral Performer - On Death - Say Line 1'),
(16473, 0, 2, 0, 0, 0, 100, 0, 11000, 17000, 15000, 21000, 0, 0, 11, 29679, 32, 0, 0, 0, 0, 6, 20, 0,0,0,0,0,0,0,      'Spectral Performer - In Combat - Cast Bad Poetry'),
(16473, 0, 3, 0, 6, 0, 100, 0, 0, 0, 0, 0, 0, 0, 11, 29680, 2, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,                  'Spectral Performer - On Death - Cast Curtain Call'),
(16473, 0, 4, 0, 0, 0, 100, 0, 1000, 8000, 22000, 35000, 0, 0, 11, 29683, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,    'Spectral Performer - In Combat - Cast Spotlight'),
(16481, 0, 0, 0, 4, 0, 30, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,                        'Ghastly Haunt - On Aggro - Say Line 0'),
(16481, 0, 1, 0, 6, 0, 50, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,                        'Ghastly Haunt - On Death - Say Line 1'),
(16481, 0, 2, 0, 0, 0, 100, 0, 8000, 13000, 7000, 15000, 0, 0, 11, 29712, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0,    'Ghastly Haunt - In Combat - Cast Shadow Shock'),
(16481, 0, 3, 0, 9, 0, 100, 0, 0, 0, 11000, 17000, 0, 5, 11, 29716, 32, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0,         'Ghastly Haunt - Within 0-5 Range - Cast Ethereal Curse'),
(16482, 0, 0, 0, 4, 0, 30, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,                        'Trapped Soul - On Aggro - Say Line 0'),
(16482, 0, 1, 0, 6, 0, 50, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,                        'Trapped Soul - On Death - Say Line 1'),
(16482, 0, 2, 0, 0, 0, 100, 0, 1000, 3000, 60000, 60000, 0, 0, 11, 29718, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,    'Trapped Soul - In Combat - Cast Elemental Armor'),
(16482, 0, 3, 0, 16, 0, 100, 0, 0, 0, 10000, 13000, 0, 5, 11, 29717, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,         'Trapped Soul - Within 0-5 Range - Cast Cone of Cold'), -- test!
(16485, 0, 0, 0, 4, 0, 30, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,                        'Arcane Watchman - On Aggro - Say Line 0'),
(16485, 0, 1, 0, 6, 0, 50, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,                        'Arcane Watchman - On Death - Say Line 1'),
(16485, 0, 2, 0, 5, 0, 50, 0, 5000, 5000, 1, 0, 0, 0, 1, 2, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,                  'Arcane Watchman - On Kill - Say Line 2'),
(16485, 0, 3, 0, 9, 0, 100, 0, 0, 0, 9000, 12000, 0, 5, 11, 29765, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0,           'Arcane Watchman - Within 0-5 Range - Cast Crystal Strike'),
(16485, 0, 4, 0, 0, 0, 100, 0, 11000, 15000, 13000, 17000, 0, 0, 11, 29768, 0, 0, 0, 0, 0, 5, 30, 0, 0, 0, 0, 0, 0, 0, 'Arcane Watchman - In Combat - Cast Overload'),
(16485, 0, 5, 0, 11, 0, 100, 0, 0, 0, 0, 0, 0, 0, 11, 18950, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,                 'Arcane Watchman - On Respawn - Cast Stealth'), -- check aura!
(16488, 0, 0, 0, 25, 0, 100, 512, 0, 0, 0, 0, 0, 0, 42, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,                   'Arcane Anomaly - On Reset - Set HP Invincibility ON'),
(16488, 0, 1, 2, 4, 0, 100, 512, 0, 0, 0, 0, 0, 0, 11, 29880, 2, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,                'Arcane Anomaly - On Aggro - Cast Mana Shield'),
(16488, 0, 2, 0, 61, 0, 100, 512, 0, 0, 0, 0, 0, 0, 42, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,                   'Arcane Anomaly - On Aggro - Set HP Invincibility OFF'),
(16488, 0, 3, 0, 9, 0, 100, 0, 0, 0, 6000, 10000, 0, 40, 11, 29885, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,          'Arcane Anomaly - In Combat - Cast Arcane Volley'), -- test!
(16488, 0, 4, 0, 0, 0, 100, 0, 18000, 30000, 30000, 45000, 0, 0, 11, 29883, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,  'Arcane Anomaly - In Combat - Cast Blink'),
(16488, 0, 5, 0, 6, 0, 100, 512, 0, 0, 0, 0, 0, 0, 11, 29882, 2, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,                'Arcane Anomaly - On Death - Cast Loose Mana'), -- test!
(16489, 0, 0, 0, 106, 0, 100, 0, 0, 0, 30000, 45000, 0, 15, 11, 29900, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,       'Chaotic Sentience - Within 0-15 Range - Cast Unstable Magic'),
(16492, 0, 0, 0, 0, 0, 100, 0, 0, 3000, 9000, 13000, 0, 0, 11, 29881, 256, 0, 0, 0, 0, 5, 20, 0, 1, 0, 0, 0, 0, 0,     'Syphoner - Within 0-20 Range - Cast Drain Mana'),
(16504, 0, 0, 0, 4, 0, 30, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,                        'Arcane Protector - On Aggro - Say Line 0'),
(16504, 0, 1, 0, 6, 0, 50, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,                        'Arcane Protector - On Death - Say Line 1'),
(16504, 0, 2, 0, 5, 0, 50, 0, 5000, 5000, 1, 0, 0, 0, 1, 2, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,                  'Arcane Protector - On Kill - Say Line 2'),
(16504, 0, 3, 0, 0, 0, 100, 0, 22000, 32000, 31000, 47000, 0, 0, 11, 29840, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,  'Arcane Protector - In Combat - Cast Fist of Stone'),
(16504, 0, 4, 0, 0, 0, 100, 512, 4000, 7000, 20500, 20500, 0, 0, 88, 1650400, 1650402, 0, 0, 0, 0, 1, 0,0,0,0,0,0,0,0, 'Arcane Protector - In Combat - Run Script Range'),
(16504, 0, 5, 0, 0, 0, 100, 0, 3000, 8000, 15000, 19000, 0, 0, 11, 29857, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,    'Arcane Protector - In Combat - Cast Summon Astral Spark'),
--
(16525, 0, 0, 0, 1, 0, 100, 513, 0, 10000, 0, 0, 0, 0, 11, 29920, 2, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,            'Spell Shade - Out of Combat - Cast Phasing Invisibility'),
(16525, 0, 1, 0, 4, 0, 100, 512, 0, 0, 0, 0, 0, 0, 28, 29920, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,                'Spell Shade - On Aggro - Remove Phasing Invisibility'),
(16525, 0, 2, 0, 0, 0, 100, 512, 0, 1000, 3000, 3000, 0, 0, 88, 1652500, 1652502, 0, 0, 0, 0, 1, 0,0,0,0,0,0,0,0,      'Spell Shade - In Combat - Run Script'), -- check out scripts! needs to be random cast frostbolt/fireball (29926/29927)
--
(16526, 0, 0, 0, 0, 0, 100, 1, 180000, 180000, 0, 0, 0, 0, 11, 29922, 64, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,       'Sorcerous Shade - In Combat - Cast Fireball Volley'),
(16526, 0, 1, 0, 0, 0, 100, 512, 0, 1000, 3000, 5000, 0, 0, 88, 1652600, 1652602, 0, 0, 0, 0, 1, 0,0,0,0,0,0,0,0,      'Sorcerous Shade - In Combat - Run Script'), -- check out scripts! needs to be 29922/29923/29924
--
(16529, 0, 0, 0, 0, 0, 100, 0, 5000, 9000, 12000, 17000, 0, 0, 11, 29911, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,    'Magical Horror - In Combat - Cast Power Distortion'),
(16529, 0, 1, 0, 6, 0, 100, 0, 0, 0, 0, 0, 0, 0, 11, 37078, 2, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,                  'Magical Horror - In Combat - Cast Arcane Volley'), -- test!
--
(16539, 0, 0, 0, 0, 0, 100, 0, 0, 0, 3400, 4200, 0, 0, 11, 30180, 64, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0,           'Homunculus - In Combat - Cast Firebolt'),
(16540, 0, 0, 0, 4, 0, 30, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,                        'Shadow Pillager - On Aggro - Say Line 0'),
(16540, 0, 1, 0, 6, 0, 50, 0, 0, 0, 0, 0, 0, 0, 1, 2, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,                        'Shadow Pillager - On Death - Say Line 2'),
(16540, 0, 2, 0, 5, 0, 100, 0, 5000, 5000, 1, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,                 'Shadow Pillager - On Death - Say Line 1'),
(16540, 0, 3, 0, 0, 0, 100, 0, 1000, 2000, 2000, 2000, 0, 0, 11, 29492, 64, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0,     'Shadow Pillager - In Combat - Cast Searing Pain'), -- instead of shadow bolt
(16540, 0, 4, 0, 0, 0, 100, 0, 12000, 16000, 30000, 35000, 0, 0, 11, 29930, 32, 0, 0, 0, 0, 5, 30, 0,0,0,0,0,0,0,      'Shadow Pillager - In Combat - Cast Curse of Agony'),
(16540, 0, 5, 0, 0, 0, 100, 0, 7000, 11000, 17000, 21000, 0, 0, 11, 29928, 96, 0, 0, 0, 0, 5, 30, 0,0,0,0,0,0,0,       'Shadow Pillager - In Combat - Cast Immolate'),
(16544, 0, 0, 0, 4, 0, 30, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,                        'Ethereal Thief - On Aggro - Say Line 0'),
(16544, 0, 1, 0, 6, 0, 50, 0, 0, 0, 0, 0, 0, 0, 1, 2, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,                        'Ethereal Thief - On Death - Say Line 2'),
(16544, 0, 2, 0, 5, 0, 100, 0, 5000, 5000, 1, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,                 'Ethereal Thief - On Death - Say Line 1'),
(16544, 0, 3, 0, 9, 0, 100, 0, 0, 0, 7000, 11000, 0, 5, 11, 30014, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0,           'Ethereal Thief - Within 0-5 Range - Cast Cleave'),
(16544, 0, 4, 0, 0, 0, 100, 0, 9000, 12000, 15000, 18000, 0, 0, 11, 30013, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0,   'Ethereal Thief - In Combat - Cast Disarm'),
(16544, 0, 5, 0, 4, 0, 100, 0, 0, 0, 0, 0, 0, 0, 11, 29982, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,                  'Ethereal Thief - On Aggro - Cast Spatial Distortion'),
(16545, 0, 0, 0, 4, 0, 30, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,                        'Ethereal Spellfilcher - On Aggro - Say Line 0'),
(16545, 0, 1, 0, 6, 0, 50, 0, 0, 0, 0, 0, 0, 0, 1, 2, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,                        'Ethereal Spellfilcher - On Death - Say Line 2'),
(16545, 0, 2, 0, 5, 0, 100, 0, 5000, 5000, 1, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,                 'Ethereal Spellfilcher - On Death - Say Line 1'),
(16545, 0, 3, 0, 0, 0, 100, 0, 5000, 8000, 7000, 9000, 0, 0, 11, 37161, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,      'Ethereal Spellfilcher - In Combat - Cast Arcane Volley'),
(16545, 0, 4, 0, 0, 0, 100, 0, 7000, 9000, 10000, 16000, 0, 0, 11, 30036, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0,    'Ethereal Spellfilcher - In Combat - Cast Steal Magic'),
(16545, 0, 5, 0, 0, 0, 100, 0, 8000, 12000, 15000, 21000, 0, 0, 11, 30039, 32, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0,  'Ethereal Spellfilcher - In Combat - Cast Transference'), -- new!
(16545, 0, 6, 0, 4, 0, 100, 0, 0, 0, 0, 0, 0, 0, 11, 30007, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,                  'Ethereal Spellfilcher - On Aggro - Cast Spatial Distortion'),
--
(16595, 0, 0, 0, 9, 0, 100, 0, 0, 0, 10000, 20000, 0, 5, 11, 29935, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0,          'Fleshbeast - Within 0-5 Range - Cast Gaping Maw'),
(16595, 0, 1, 0, 0, 0, 100, 0, 10000, 20000, 10000, 20000, 0, 0, 11, 29939, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0,  'Fleshbeast - In Combat - Cast Infectious Poison'), -- test!
(16595, 0, 2, 0, 11, 0, 100, 0, 0, 0, 0, 0, 0, 0, 11, 3417, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,                  'Fleshbeast - On Respawn - Cast Thrash'), -- check auras!
(16596, 0, 0, 0, 9, 0, 100, 0, 0, 0, 6000, 18000, 0, 5, 11, 29935, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0,           'Greater Fleshbeast -  Within 0-5 Range - Cast Gaping Maw'),
(16596, 0, 1, 0, 0, 0, 100, 0, 6000, 18000, 6000, 18000, 0, 0, 11, 29939, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0,    'Greater Fleshbeast - In Combat - Cast Infectious Poison'),
(16596, 0, 2, 0, 11, 0, 100, 0, 0, 0, 0, 0, 0, 0, 11, 18950, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,                 'Greater Fleshbeast - On Respawn - Cast Invisibility and Stealth Detection'), -- check auras!
(17267, 0, 0, 0, 0, 0, 100, 0, 0, 0, 3400, 4800, 0, 0, 11, 30050, 64, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0,           'Fiendish Imp - In Combat - Cast Firebolt');

-- Spectral Stable Hand Healing Touch (29339) Requires Valid Target Nearby (not needed anymore? maybe look into this at some point)
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId` = 22 AND `SourceGroup` IN (6, 7) AND `ConditionTypeOrReference` = 29 AND `SourceEntry` = 15551;

-- Restore Enchanting formula drops to their pre-3.1 rates
UPDATE `creature_loot_template` SET `Chance` = 5 WHERE `Item` IN (22559, 22561, 22545, 22560);

-- make blackened urn unsellable and give as reward
UPDATE `item_template` SET `Quality` = 1, `SellPrice` = 0, `description` = 'Used to summon Nightbane in Karazhan' WHERE (`entry` = 24140);
UPDATE `quest_template` SET `StartItem` = 24140 WHERE `ID` = 9644;
UPDATE `quest_template_addon` SET `ProvidedItemCount` = 1 WHERE (`ID` = 9644);

-- fix worldserver error when Midnight kills a player, Midnight needs the text as well for Attumen to say the line
DELETE FROM `creature_text` WHERE `CreatureID` = 16151;
INSERT INTO `creature_text` (`CreatureID`, `GroupID`, `ID`, `Text`, `Type`, `Language`, `Probability`, `Emote`, `Duration`, `Sound`, `BroadcastTextId`, `TextRange`, `comment`) VALUES 
(16151, 0, 0, '%s calls for her master!', 16, 0, 100, 0, 0, 0, 13439, 0, 'midnight EMOTE_CALL_ATTUMEN'),
(16151, 1, 0, '%s rushes to her master\'s aid.', 16, 0, 100, 0, 0, 0, 13455, 0, 'midnight EMOTE_MOUNT_UP'),
(16151, 3, 0, 'Well done, Midnight!', 14, 0, 100, 0, 0, 9173, 15334, 0, 'attumen SAY_MIDNIGHT_KILL');
