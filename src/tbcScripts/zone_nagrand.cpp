/*
 * This file is part of the AzerothCore Project. See AUTHORS file for Copyright information
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
 * more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program. If not, see <http://www.gnu.org/licenses/>.
 */

#include "CreatureScript.h"
#include "GameObjectScript.h"
#include "Player.h"
#include "ScriptedCreature.h"
#include "ScriptedEscortAI.h"
#include "SpellInfo.h"

// This script is for the escort quests "Totem of Kar'dash" (Alliance/Horde) in Nagrand.

enum QuestTexts
{
    SAY_MAG_START         = 0,
    SAY_MAG_MORE          = 1,
    SAY_MAG_FAREWELL      = 2,
    SAY_MAG_HEAL          = 3,
    SAY_MAG_LIGHTNING     = 4,
    SAY_MAG_TOTEM         = 5,
    SAY_MAG_SHOCK         = 6,

    SAY_KUR_START         = 0,
    SAY_KUR_LEAVE         = 1,
    SAY_KUR_SURROUNDED    = 2,
    SAY_KUR_TELAAR        = 3,
    SAY_KUR_FAREWELL      = 4,
    SAY_KUR_HEAL          = 5,
    SAY_KUR_LIGHTNING     = 6,
    SAY_KUR_TOTEM         = 7,
    SAY_KUR_SHOCK         = 8,

    SAY_PUTRIFIER_ESCAPE  = 0,
    SAY_PUTRIFIER_KILL    = 1,

    SAY_RAIDER_ESCAPE     = 0,
    SAY_RAIDER_KILL       = 1,

    SAY_BRUTE_OOC         = 0,
    SAY_BRUTE_ESCAPE      = 1,
    SAY_BRUTE_KILL        = 2
};

enum QuestSpells
{
    SPELL_HEALING_WAVE    = 12491,
    SPELL_FROST_SHOCK     = 12548,
    SPELL_EARTHBIND_TOTEM = 15786,
    SPELL_CHAIN_LIGHTNING = 16006
};

enum QuestNPCs
{
    NPC_MURK_PUTRIFIER    = 18202,
    NPC_MURK_RAIDER       = 18203,
    NPC_MURK_SCAVENGER    = 18207,
    NPC_MURK_BRUTE        = 18211
};

enum QuestID
{
    QUEST_TOTEM_KARDASH_H = 9868,
    QUEST_TOTEM_KARDASH_A = 9879
};

static float kurenaiAmbushA[]  = { -1520.6f, 8468.4f, -4.1f };
static float kurenaiAmbushB1[] = { -1419.67f, 8515.80f, 8.32922f };
static float kurenaiAmbushB2[] = { -1430.77f, 8524.27f, 13.5847f };
static float kurenaiAmbushB3[] = { -1416.78f, 8504.90f, 8.10577f };

static float magharAmbushA[] = { -1568.805786f, 8533.873047f, 1.958f };
static float magharAmbushB[] = { -1491.554321f, 8506.483398f, 1.248f };

class npc_maghar_captive_ipp : public CreatureScript
{
public:
    npc_maghar_captive_ipp() : CreatureScript("npc_maghar_captive_ipp") { }

    bool OnQuestAccept(Player* player, Creature* creature, Quest const* quest) override
    {
        if (quest->GetQuestId() == QUEST_TOTEM_KARDASH_H)
        {
            if (npc_maghar_captiveAI* EscortAI = dynamic_cast<npc_maghar_captiveAI*>(creature->AI()))
            {
                creature->SetStandState(UNIT_STAND_STATE_STAND);
                creature->SetFaction(FACTION_ESCORTEE_H_NEUTRAL_ACTIVE);
                creature->SetWalk(true);
                EscortAI->Start(true, player->GetGUID(), quest);
                creature->AI()->Talk(SAY_MAG_START);

                creature->SummonCreature(NPC_MURK_RAIDER, magharAmbushA[0] + 2.5f, magharAmbushA[1] - 2.5f, magharAmbushA[2], 0.0f, TEMPSUMMON_TIMED_DESPAWN_OUT_OF_COMBAT, 25000);
                creature->SummonCreature(NPC_MURK_PUTRIFIER, magharAmbushA[0] - 2.5f, magharAmbushA[1] + 2.5f, magharAmbushA[2], 0.0f, TEMPSUMMON_TIMED_DESPAWN_OUT_OF_COMBAT, 25000);
                creature->SummonCreature(NPC_MURK_BRUTE, magharAmbushA[0], magharAmbushA[1], magharAmbushA[2], 0.0f, TEMPSUMMON_TIMED_DESPAWN_OUT_OF_COMBAT, 25000);
            }
        }
        return true;
    }

    CreatureAI* GetAI(Creature* creature) const override
    {
        return new npc_maghar_captiveAI(creature);
    }

    struct npc_maghar_captiveAI : public npc_escortAI
    {
        npc_maghar_captiveAI(Creature* creature) : npc_escortAI(creature) { Reset(); }

        uint32 ChainLightningTimer;
        uint32 HealTimer;
        uint32 FrostShockTimer;

        void Reset() override
        {
            ChainLightningTimer = 1000;
            HealTimer = 0;
            FrostShockTimer = 6000;
        }

        void JustEngagedWith(Unit* /*who*/) override
        {
            DoCast(me, SPELL_EARTHBIND_TOTEM, false);

            if (rand() % 30)
                return;

            Talk(SAY_MAG_TOTEM);
        }

        void JustDied(Unit* /*killer*/) override
        {
            if (!HasEscortState(STATE_ESCORT_ESCORTING))
                return;

            if (Player* player = GetPlayerForEscort())
            {
                if (player->GetQuestStatus(QUEST_TOTEM_KARDASH_H) != QUEST_STATUS_COMPLETE)
                    player->FailQuest(QUEST_TOTEM_KARDASH_H);
            }
        }

        using CreatureAI::WaypointReached;
        void WaypointReached(uint32 waypointId) override
        {
            switch (waypointId)
            {
                case 5:
                {
                    Talk(SAY_MAG_MORE);
                    break;
                }
                case 6:
                {
                    if (Creature* temp = me->SummonCreature(NPC_MURK_PUTRIFIER, magharAmbushB[0], magharAmbushB[1], magharAmbushB[2], 0.0f, TEMPSUMMON_TIMED_DESPAWN_OUT_OF_COMBAT, 25000))
                        temp->AI()->Talk(SAY_PUTRIFIER_KILL);

                    me->SummonCreature(NPC_MURK_PUTRIFIER, magharAmbushB[0] - 2.5f, magharAmbushB[1] - 2.5f, magharAmbushB[2], 0.0f, TEMPSUMMON_TIMED_DESPAWN_OUT_OF_COMBAT, 25000);
                    me->SummonCreature(NPC_MURK_SCAVENGER, magharAmbushB[0] + 2.5f, magharAmbushB[1] + 2.5f, magharAmbushB[2], 0.0f, TEMPSUMMON_TIMED_DESPAWN_OUT_OF_COMBAT, 25000);
                    me->SummonCreature(NPC_MURK_SCAVENGER, magharAmbushB[0] + 2.5f, magharAmbushB[1] - 2.5f, magharAmbushB[2], 0.0f, TEMPSUMMON_TIMED_DESPAWN_OUT_OF_COMBAT, 25000);
                    break;
                }
                case 11:
                {
                    Talk(SAY_MAG_FAREWELL);

                    if (Player* player = GetPlayerForEscort())
                        player->GroupEventHappens(QUEST_TOTEM_KARDASH_H, me);

                    me->SetWalk(false);
                    break;
                }
            }
        }

        void JustSummoned(Creature* summoned) override
        {
            if (summoned->GetEntry() == NPC_MURK_BRUTE)
                summoned->AI()->Talk(SAY_BRUTE_ESCAPE);

            if (summoned->IsTotem())
                return;

            summoned->SetWalk(false);
            summoned->GetMotionMaster()->MovePoint(0, me->GetPositionX(), me->GetPositionY(), me->GetPositionZ());
            summoned->AI()->AttackStart(me);
        }

        void SpellHitTarget(Unit* /*target*/, SpellInfo const* spell) override
        {
            if (spell->Id == SPELL_CHAIN_LIGHTNING)
            {
                if (rand() % 30)
                    return;

                Talk(SAY_MAG_LIGHTNING);
            }

            if (spell->Id == SPELL_FROST_SHOCK)
            {
                if (rand() % 30)
                    return;

                Talk(SAY_MAG_SHOCK);
            }
        }

        void UpdateAI(uint32 diff) override
        {
            npc_escortAI::UpdateAI(diff);

            if (!UpdateVictim())
                return;

            if (me->HasUnitState(UNIT_STATE_CASTING))
                return;

            if (ChainLightningTimer <= diff)
            {
                DoCastVictim(SPELL_CHAIN_LIGHTNING);
                ChainLightningTimer = urand(7000, 14000);
            }
            else
                ChainLightningTimer -= diff;

            if (HealthBelowPct(40))
            {
                if (HealTimer <= diff)
                {
                    DoCast(me, SPELL_HEALING_WAVE);
                    HealTimer = 5000;

                    if (rand() % 30)
                        return;

                    Talk(SAY_MAG_HEAL);
                }
                else
                    HealTimer -= diff;
            }

            if (FrostShockTimer <= diff)
            {
                DoCastVictim(SPELL_FROST_SHOCK);
                FrostShockTimer = urand(7500, 15000);
            }
            else
                FrostShockTimer -= diff;

            DoMeleeAttackIfReady();
        }
    };
};

class npc_kurenai_captive_ipp : public CreatureScript
{
public:
    npc_kurenai_captive_ipp() : CreatureScript("npc_kurenai_captive_ipp") { }

    bool OnQuestAccept(Player* player, Creature* creature, Quest const* quest) override
    {
        if (quest->GetQuestId() == QUEST_TOTEM_KARDASH_A)
        {
            if (npc_kurenai_captiveAI* EscortAI = dynamic_cast<npc_kurenai_captiveAI*>(creature->AI()))
            {
                creature->SetStandState(UNIT_STAND_STATE_STAND);
                creature->SetFaction(FACTION_ESCORTEE_H_NEUTRAL_ACTIVE);
                creature->SetWalk(true);
                EscortAI->Start(true, player->GetGUID(), quest);
                creature->AI()->Talk(SAY_KUR_START);

                creature->SummonCreature(NPC_MURK_RAIDER, kurenaiAmbushA[0] + 2.5f, kurenaiAmbushA[1] - 2.5f, kurenaiAmbushA[2], 0.0f, TEMPSUMMON_TIMED_DESPAWN_OUT_OF_COMBAT, 50000);
                creature->SummonCreature(NPC_MURK_BRUTE, kurenaiAmbushA[0] - 2.5f, kurenaiAmbushA[1] + 2.5f, kurenaiAmbushA[2], 0.0f, TEMPSUMMON_TIMED_DESPAWN_OUT_OF_COMBAT, 50000);
                creature->SummonCreature(NPC_MURK_SCAVENGER, kurenaiAmbushA[0], kurenaiAmbushA[1], kurenaiAmbushA[2], 0.0f, TEMPSUMMON_TIMED_DESPAWN_OUT_OF_COMBAT, 50000);
            }
        }
        return true;
    }

    CreatureAI* GetAI(Creature* creature) const override
    {
        return new npc_kurenai_captiveAI(creature);
    }

    struct npc_kurenai_captiveAI : public npc_escortAI
    {
        npc_kurenai_captiveAI(Creature* creature) : npc_escortAI(creature) { }

        uint32 ChainLightningTimer;
        uint32 HealTimer;
        uint32 FrostShockTimer;

        void Reset() override
        {
            ChainLightningTimer = 1000;
            HealTimer = 0;
            FrostShockTimer = 6000;
        }

        void JustEngagedWith(Unit* /*who*/) override
        {
            DoCast(me, SPELL_EARTHBIND_TOTEM, false);

            if (rand() % 30)
                return;

            Talk(SAY_KUR_TOTEM);
        }

        void JustDied(Unit* /*killer*/) override
        {
            if (!HasEscortState(STATE_ESCORT_ESCORTING))
                return;

            if (Player* player = GetPlayerForEscort())
            {
                if (player->GetQuestStatus(QUEST_TOTEM_KARDASH_A) != QUEST_STATUS_COMPLETE)
                    player->FailQuest(QUEST_TOTEM_KARDASH_A);
            }
        }

        using CreatureAI::WaypointReached;
        void WaypointReached(uint32 waypointId) override
        {
            switch (waypointId)
            {
                case 2:
                {
                    Talk(SAY_KUR_LEAVE);
                    break;
                }
                case 8:
                {
                    Talk(SAY_KUR_SURROUNDED);
                    break;
                }
                case 9:
                {
                    if (Creature* cr = me->SummonCreature(NPC_MURK_BRUTE, kurenaiAmbushB1[0], kurenaiAmbushB1[1], kurenaiAmbushB1[2], 0.0f, TEMPSUMMON_TIMED_DESPAWN_OUT_OF_COMBAT, 25000))
                        cr->AI()->Talk(SAY_BRUTE_KILL);

                    me->SummonCreature(NPC_MURK_BRUTE, kurenaiAmbushB1[0], kurenaiAmbushB1[1], kurenaiAmbushB1[2], 0.0f, TEMPSUMMON_TIMED_DESPAWN_OUT_OF_COMBAT, 25000);
                    me->SummonCreature(NPC_MURK_PUTRIFIER, kurenaiAmbushB2[0], kurenaiAmbushB2[1], kurenaiAmbushB2[2], 0.0f, TEMPSUMMON_TIMED_DESPAWN_OUT_OF_COMBAT, 25000);
                    me->SummonCreature(NPC_MURK_PUTRIFIER, kurenaiAmbushB3[0], kurenaiAmbushB3[1], kurenaiAmbushB3[2], 0.0f, TEMPSUMMON_TIMED_DESPAWN_OUT_OF_COMBAT, 25000);
                    break;
                }
                case 10:
                {
                    Talk(SAY_KUR_TELAAR);
                    break;
                }
                case 13:
                {
                    Talk(SAY_KUR_FAREWELL);

                    if (Player* player = GetPlayerForEscort())
                        player->GroupEventHappens(QUEST_TOTEM_KARDASH_A, me);

                    me->SetWalk(false);
                    break;
                }
            }
        }

        void JustSummoned(Creature* summoned) override
        {
            if (summoned->GetEntry() == NPC_MURK_BRUTE)
                summoned->AI()->Talk(SAY_BRUTE_ESCAPE);

            if (summoned->IsTotem())
                return;

            summoned->SetWalk(false);
            summoned->GetMotionMaster()->MovePoint(0, me->GetPositionX(), me->GetPositionY(), me->GetPositionZ());
            summoned->AI()->AttackStart(me);
        }

        void SpellHitTarget(Unit* /*target*/, SpellInfo const* spell) override
        {
            if (spell->Id == SPELL_CHAIN_LIGHTNING)
            {
                if (rand() % 30)
                    return;

                Talk(SAY_KUR_LIGHTNING);
            }

            if (spell->Id == SPELL_FROST_SHOCK)
            {
                if (rand() % 30)
                    return;

                Talk(SAY_KUR_SHOCK);
            }
        }

        void UpdateAI(uint32 diff) override
        {
            npc_escortAI::UpdateAI(diff);

            if (!UpdateVictim())
                return;

            if (me->HasUnitState(UNIT_STATE_CASTING))
                return;

            if (ChainLightningTimer <= diff)
            {
                DoCastVictim(SPELL_CHAIN_LIGHTNING);
                ChainLightningTimer = urand(7000, 14000);
            }
            else
                ChainLightningTimer -= diff;

            if (HealthBelowPct(40))
            {
                if (HealTimer <= diff)
                {
                    DoCast(me, SPELL_HEALING_WAVE);
                    HealTimer = 5000;

                    if (rand() % 30)
                        return;

                    Talk(SAY_KUR_HEAL);
                }
                else
                    HealTimer -= diff;
            }

            if (FrostShockTimer <= diff)
            {
                DoCastVictim(SPELL_FROST_SHOCK);
                FrostShockTimer = urand(7500, 15000);
            }
            else
                FrostShockTimer -= diff;

            DoMeleeAttackIfReady();
        }
    };
};

void AddSC_ipp_zone_nagrand()
{
    new npc_maghar_captive_ipp();
    new npc_kurenai_captive_ipp();
}
