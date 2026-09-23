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
#include "Player.h"
#include "ScriptedCreature.h"
#include "ScriptedEscortAI.h"
#include "ScriptedGossip.h"
#include "SpellInfo.h"

enum Caravan
{
    QUEST_BODYGUARD_FOR_HIRE            = 5821,
    QUEST_GIZELTON_CARAVAN              = 5943,

    EVENT_RESUME_PATH                   = 1,
    EVENT_WAIT_FOR_ASSIST               = 2,
    EVENT_RESTART_ESCORT                = 3,
    EVENT_CHECK_FOLLOWERS               = 4,

    NPC_CORK_GIZELTON                   = 11625,
    NPC_RIGGER_GIZELTON                 = 11626,
    NPC_CARAVAN_KODO                    = 11564,
    NPC_VENDOR_TRON                     = 12245,
    NPC_SUPER_SELLER                    = 12246,

    SAY_CARAVAN_LEAVE                   = 0,
    SAY_CARAVAN_HIRE                    = 1,

    SAY_CORK_PROTECT                    = 2,
    SAY_CORK_MISTER                     = 3,
    SAY_CORK_FIRED                      = 4,
    SAY_CORK_SMEED                      = 5,

    SAY_RIGGER_HUNGRY                   = 2,
    SAY_RIGGER_PAYING                   = 3,
    SAY_RIGGER_TALLER                   = 4,
    SAY_RIGGER_SMEED                    = 5,

    MAX_CARAVAN_SUMMONS                 = 3,

    // Ambush
    NPC_KOLKAR_WAYLAYER                 = 12976,
    NPC_KOLKAR_AMBUSHER                 = 12977,
    NPC_LESSER_INFERNAL                 = 4676,
    NPC_DOOMWARDER                      = 4677,
    NPC_NETHER                          = 4684,
};

constexpr Milliseconds TIME_SHOP_STOP   = 600s;
constexpr Milliseconds TIME_HIRE_STOP   = 240s;
constexpr Milliseconds TIME_SHORT_BREAK = 7s;

class npc_cork_gizelton_ipp : public CreatureScript
{
private:
    void ImmuneFlagSet(Creature* creature, bool remove, uint32 faction)
    {
        if (!creature)
            return;

        creature->SetFaction(faction);

        // If the AI is escort AI, set the faction for all summons as well
        if (auto* ai = dynamic_cast<npc_cork_gizelton_ipp::npc_cork_gizeltonAI*>(creature->AI()))
        {
            for (uint8 i = 0; i < MAX_CARAVAN_SUMMONS; ++i)
            {
                if (Creature* summon = ObjectAccessor::GetCreature(*creature, ai->summons[i]))
                    summon->SetFaction(faction);
            }
        }
    }
public:
    npc_cork_gizelton_ipp() : CreatureScript("npc_cork_gizelton_ipp") { }

    bool OnQuestAccept(Player* player, Creature* creature, Quest const* quest) override
    {
        if (quest->GetQuestId() == QUEST_BODYGUARD_FOR_HIRE || quest->GetQuestId() == QUEST_GIZELTON_CARAVAN)
        {
            creature->AI()->SetGUID(player->GetGUID());
            creature->SetWalk(true);

            ImmuneFlagSet(creature, true, player->GetFaction());
        }

        return true;
    }

    CreatureAI* GetAI(Creature* creature) const override
    {
        return new npc_cork_gizeltonAI(creature);
    }

    struct npc_cork_gizeltonAI : public npc_escortAI
    {
        npc_cork_gizeltonAI(Creature* creature) : npc_escortAI(creature) { }

        EventMap events;
        ObjectGuid summons[MAX_CARAVAN_SUMMONS];
        bool headNorth;

        ObjectGuid _playerGUID;
        uint32 _faction;
        bool _wasInCombat{false};

        void Initialize()
        {
            _faction      = 35;
            _wasInCombat  = false;
            headNorth     = true;

            me->setActive(true);
            me->SetWalk(false);

            events.ScheduleEvent(EVENT_RESTART_ESCORT, 0ms);
        }

        void JustRespawned() override
        {
            npc_escortAI::JustRespawned();
            Initialize();
        }

        void InitializeAI() override
        {
            npc_escortAI::InitializeAI();
            Initialize();
        }

        void JustDied(Unit* killer) override
        {
            RemoveSummons();
            npc_escortAI::JustDied(killer);
        }

        void EnterEvadeMode(EvadeReason why) override
        {
            SummonsFollow();
            npc_escortAI::EnterEvadeMode(why);
        }

        void CheckPlayer()
        {
            if (_playerGUID)
                if (Player* player = ObjectAccessor::GetPlayer(*me, _playerGUID))
                    if (me->IsWithinDist(player, 60.0f))
                        return;

            _playerGUID.Clear();
            _faction = 35;
            ImmuneFlagSet(false, _faction);
        }

        void SetGUID(ObjectGuid const& playerGUID, int32 faction) override
        {
            _playerGUID = playerGUID;
            _faction = faction;
            SetEscortPaused(false);

            if (Creature* active = !headNorth ? me : ObjectAccessor::GetCreature(*me, summons[0]))
                active->RemoveNpcFlag(UNIT_NPC_FLAG_QUESTGIVER);

            events.CancelEvent(EVENT_WAIT_FOR_ASSIST);
        }

        void SetData(uint32 field, uint32 data) override
        {
            if (field == 1 && data == 1)
                if (Player* player = me->SelectNearestPlayer(50.0f))
                    SetGUID(player->GetGUID(), player->GetFaction());
        }

        bool CheckCaravan()
        {
            for (uint8 i = 0; i < MAX_CARAVAN_SUMMONS; ++i)
            {
                if (!summons[i])
                {
                    SummonHelpers();
                    return false;
                }

                Creature* summon = ObjectAccessor::GetCreature(*me, summons[i]);
                if (!summon || me->GetDistance2d(summon) > 25.0f)
                {
                    SummonHelpers();
                    return false;
                }
            }
            return true;
        }

        void RemoveSummons()
        {
            for (uint8 i = 0; i < MAX_CARAVAN_SUMMONS; ++i)
            {
                if (Creature* summon = ObjectAccessor::GetCreature(*me, summons[i]))
                    summon->DespawnOrUnsummon();

                summons[i].Clear();
            }
        }

        void SummonHelpers()
        {
            RemoveSummons();
            me->RemoveNpcFlag(UNIT_NPC_FLAG_QUESTGIVER);

            if (Creature* cr = me->SummonCreature(NPC_RIGGER_GIZELTON, *me))
            {
                cr->RemoveNpcFlag(UNIT_NPC_FLAG_QUESTGIVER);
                summons[0] = cr->GetGUID();
            }
            if (Creature* cr = me->SummonCreature(NPC_CARAVAN_KODO, *me))
            {
                summons[1] = cr->GetGUID();
            }
            if (Creature* cr = me->SummonCreature(NPC_CARAVAN_KODO, *me))
            {
                summons[2] = cr->GetGUID();
            }

            SummonsFollow();
        }

        void SummonedCreatureDies(Creature* creature, Unit*) override
        {
            if (creature->GetGUID() == summons[0])
                summons[0].Clear();
            else if (creature->GetGUID() == summons[1])
                summons[1].Clear();
            else if (creature->GetGUID() == summons[2])
                summons[2].Clear();
        }

        void SummonedCreatureDespawn(Creature* creature) override
        {
            if (creature->GetGUID() == summons[0])
                summons[0].Clear();
            else if (creature->GetGUID() == summons[1])
                summons[1].Clear();
            else if (creature->GetGUID() == summons[2])
                summons[2].Clear();
        }

        void SummonsFollow()
        {
            float dist = 1.0f;
            for (uint8 i = 0; i < MAX_CARAVAN_SUMMONS; ++i)
                if (Creature* summon = ObjectAccessor::GetCreature(*me, summons[i]))
                {
                    summon->GetMotionMaster()->Clear(false);
                    summon->StopMoving();
                    summon->GetMotionMaster()->MoveFollow(me, dist, M_PI, MOTION_SLOT_ACTIVE);
                    dist += (i == 1 ? 9.5f : 3.0f);
                }
        }

        void RelocateSummons()
        {
            for (uint8 i = 0; i < MAX_CARAVAN_SUMMONS; ++i)
                if (Creature* summon = ObjectAccessor::GetCreature(*me, summons[i]))
                    summon->SetHomePosition(me->GetPositionX(), me->GetPositionY(), me->GetPositionZ(), me->GetOrientation());
        }

        void ImmuneFlagSet(bool remove, uint32 faction)
        {
            for (uint8 i = 0; i < MAX_CARAVAN_SUMMONS; ++i)
            {
                if (Creature* summon = ObjectAccessor::GetCreature(*me, summons[i]))
                    summon->SetFaction(faction);
            }

            me->SetFaction(faction);
        }

        using CreatureAI::WaypointReached;
        void WaypointReached(uint32 waypointId) override
        {
            RelocateSummons();
            switch (waypointId)
            {
                // Finished north path
                case 52:
                    me->SummonCreature(NPC_VENDOR_TRON, -694.61f, 1460.7f, 90.794f, 2.4f, TEMPSUMMON_TIMED_DESPAWN, 600000 + 15 * IN_MILLISECONDS);
                    SetEscortPaused(true);
                    events.ScheduleEvent(EVENT_RESUME_PATH, TIME_SHOP_STOP);
                    CheckCaravan();
                    break;
                // Finished south path
                case 193:
                    me->SummonCreature(NPC_SUPER_SELLER, -1927.48f, 2418.02f, 60.77f, 5.67f, TEMPSUMMON_TIMED_DESPAWN, 600000 + 15 * IN_MILLISECONDS);
                    
                    SetEscortPaused(true);
                    events.ScheduleEvent(EVENT_RESUME_PATH, TIME_SHOP_STOP);
                    CheckCaravan();
                    break;
                // North -> South - hire
                case 77:
                    SetEscortPaused(true);
                    me->SetNpcFlag(UNIT_NPC_FLAG_QUESTGIVER);
                    Talk(SAY_CARAVAN_HIRE);
                    events.ScheduleEvent(EVENT_WAIT_FOR_ASSIST, TIME_HIRE_STOP);
                    break;
                // South -> North - hire
                case 208:
                    SetEscortPaused(true);
                    if (Creature* rigger = ObjectAccessor::GetCreature(*me, summons[0]))
                    {
                        rigger->SetNpcFlag(UNIT_NPC_FLAG_QUESTGIVER);
                        rigger->AI()->Talk(SAY_CARAVAN_HIRE);
                    }
                    events.ScheduleEvent(EVENT_WAIT_FOR_ASSIST, TIME_HIRE_STOP);
                    break;
                // North -> South - complete
                case 103:
                    SetEscortPaused(true);
                    Talk(SAY_CORK_SMEED);

                    if (Player* player = ObjectAccessor::FindPlayer(_playerGUID))
                    {
                        if (CheckCaravan())
                            player->GroupEventHappens(QUEST_BODYGUARD_FOR_HIRE, player);
                        else
                            player->FailQuest(QUEST_BODYGUARD_FOR_HIRE);
                    }

                    me->SetWalk(false);
                    _playerGUID.Clear();
                    CheckPlayer();
                    events.ScheduleEvent(EVENT_WAIT_FOR_ASSIST, TIME_SHORT_BREAK);
                    break;
                // South -> North - complete
                case 235:
                    SetEscortPaused(true);
                    if (Creature* rigger = ObjectAccessor::GetCreature(*me, summons[0]))
                        rigger->AI()->Talk(SAY_RIGGER_SMEED);

                    if (Player* player = ObjectAccessor::FindPlayer(_playerGUID))
                    {
                        if (CheckCaravan())
                            player->GroupEventHappens(QUEST_GIZELTON_CARAVAN, player);
                        else
                            player->FailQuest(QUEST_GIZELTON_CARAVAN);
                    }

                    me->SetWalk(false);
                    _playerGUID.Clear();
                    CheckPlayer();
                    events.ScheduleEvent(EVENT_WAIT_FOR_ASSIST, TIME_SHORT_BREAK);
                    break;
                // North -> South - spawn attackers
                case 83:
                case 93: 
                case 100:                   
                    {
                        if (waypointId == 83)
                            Talk(SAY_CORK_PROTECT);
                        else if (waypointId == 93)
                            Talk(SAY_CORK_MISTER);
                        else /* 100 */
                            Talk(SAY_CORK_FIRED);

                        if (!_playerGUID)
                            return;

                        if (Player* player = ObjectAccessor::FindPlayer(_playerGUID))
                            _faction = player->GetFaction();

                        ImmuneFlagSet(true, _faction);

                        Creature* cr = nullptr;
                        for (uint8 i = 0; i < 4; ++i)
                        {
                            float o = (i * M_PI / 2) + (M_PI / 4);
                            float x = me->GetPositionX() + cos(o) * 15.0f;
                            float y = me->GetPositionY() + std::sin(o) * 15.0f;
                            if ((cr = me->SummonCreature((i % 2 == 0 ? NPC_KOLKAR_WAYLAYER : NPC_KOLKAR_AMBUSHER),
                                                         x, y, me->GetMap()->GetHeight(x, y, MAX_HEIGHT), 0.0f, TEMPSUMMON_TIMED_DESPAWN_OUT_OF_COMBAT, 30000)))
                                cr->AI()->AttackStart(me);
                        }
                        if (cr)
                        {
                            AttackStart(cr);
                            me->CallForHelp(30.0f);
                        }
                        break;
                    }
                // South -> North - spawn attackers
                case 221:
                case 228:
                case 233:
                    {
                        if (Creature* rigger = ObjectAccessor::GetCreature(*me, summons[0]))
                        {
                            if (waypointId == 221)
                                rigger->AI()->Talk(SAY_RIGGER_HUNGRY);
                            else if (waypointId == 228)
                                rigger->AI()->Talk(SAY_RIGGER_PAYING);
                            else /* 233 */
                                rigger->AI()->Talk(SAY_RIGGER_TALLER);
                        }

                        if (!_playerGUID)
                            return;

                        if (Player* player = ObjectAccessor::FindPlayer(_playerGUID))
                            _faction = player->GetFaction();

                        ImmuneFlagSet(true, _faction);

                        Creature* cr = nullptr;
                        for (uint8 i = 0; i < 3; ++i)
                        {
                            float o = i * 2 * M_PI / 3;
                            float x = me->GetPositionX() + cos(o) * 10.0f;
                            float y = me->GetPositionY() + std::sin(o) * 10.0f;
                            uint32 entry = NPC_LESSER_INFERNAL;
                            if (i)
                                entry = i == 1 ? NPC_DOOMWARDER : NPC_NETHER;

                            if ((cr = me->SummonCreature(entry, x, y, me->GetMap()->GetHeight(x, y, MAX_HEIGHT), 0.0f, TEMPSUMMON_TIMED_DESPAWN_OUT_OF_COMBAT, 30000)))
                                cr->AI()->AttackStart(me);
                        }
                        if (cr)
                        {
                            AttackStart(cr);
                            me->CallForHelp(30.0f);
                        }
                        break;
                    }
                case 282:
                    events.ScheduleEvent(EVENT_RESTART_ESCORT, 1s);
                    break;
            }
        }

        void UpdateEscortAI(uint32 diff) override
        {
            events.Update(diff);
            switch (events.ExecuteEvent())
            {
            case EVENT_RESUME_PATH:
                SetEscortPaused(false);
                if (Creature* talker = headNorth ? me : ObjectAccessor::GetCreature(*me, summons[0]))
                    talker->AI()->Talk(SAY_CARAVAN_LEAVE);

                headNorth = !headNorth;
                break;
            case EVENT_WAIT_FOR_ASSIST:
                SetEscortPaused(false);
                if (Creature* active = !headNorth ? me : ObjectAccessor::GetCreature(*me, summons[0]))
                    active->RemoveNpcFlag(UNIT_NPC_FLAG_QUESTGIVER);
                break;
            case EVENT_RESTART_ESCORT:
                if (!IsEscorted())
                {
                    CheckCaravan();
                    SetDespawnAtEnd(false);
                    Start(true, ObjectGuid::Empty, 0, false, false, true);
                }
                break;
            case EVENT_CHECK_FOLLOWERS:
            {
                bool anyInCombat = false;
                Creature* lastVictimSrc = nullptr;
                for (uint8 i = 0; i < MAX_CARAVAN_SUMMONS; ++i)
                {
                    if (Creature* summon = ObjectAccessor::GetCreature(*me, summons[i]))
                    {
                        if (summon->IsInCombat())
                        {
                            anyInCombat = true;
                            if (Unit* victim = summon->GetVictim())
                                lastVictimSrc = summon;
                        }
                    }
                }

                if (!anyInCombat)
                {
                    SummonsFollow();
                    SetEscortPaused(false);
                }
                else
                {
                    // Assist followers
                    if (lastVictimSrc && lastVictimSrc->GetVictim())
                    {
                        Unit* victim = lastVictimSrc->GetVictim();
                        if (victim && !victim->IsFriendlyTo(me))
                        {
                            AttackStart(victim);
                            me->CallForHelp(30.0f);
                        }
                    }

                    events.ScheduleEvent(EVENT_CHECK_FOLLOWERS, 1s);
                }
            }
            break;
            }

            // Combat transition handling (only on state changes).
            bool currentlyInCombat = me->IsInCombat();

            // If followers are attacked while leader is OOC, assist them and pause the escort
            if (IsEscorted() && !currentlyInCombat && !_wasInCombat)
            {
                bool anyInCombat = false;
                Creature* lastVictimSrc = nullptr;
                for (uint8 i = 0; i < MAX_CARAVAN_SUMMONS; ++i)
                {
                    if (Creature* summon = ObjectAccessor::GetCreature(*me, summons[i]))
                    {
                        if (summon->IsInCombat())
                        {
                            anyInCombat = true;
                            if (Unit* v = summon->GetVictim())
                                lastVictimSrc = summon;
                        }
                    }
                }

                if (anyInCombat)
                {
                    // Assist followers and pause the escort, schedule checks
                    if (lastVictimSrc && lastVictimSrc->GetVictim())
                    {
                        Unit* victim = lastVictimSrc->GetVictim();
                        if (victim && !victim->IsFriendlyTo(me))
                        {
                            AttackStart(victim);
                            me->CallForHelp(30.0f);
                        }
                    }

                    SetEscortPaused(true);
                    events.ScheduleEvent(EVENT_CHECK_FOLLOWERS, 1s);
                }
            }

            // If leader enters combat, order nearby summons to assist
            if (currentlyInCombat && !_wasInCombat)
            {
                UpdateVictim();
                if (Unit* victim = me->GetVictim())
                {
                    constexpr float ASSIST_DISTANCE = 12.0f;
                    for (uint8 i = 0; i < MAX_CARAVAN_SUMMONS; ++i)
                    {
                        if (Creature* summon = ObjectAccessor::GetCreature(*me, summons[i]))
                        {
                            if (!summon->IsAlive())
                                continue;

                            // only ask summons already close to the victim to engage to avoid pulling formation
                            if (!summon->IsInCombat() && summon->IsWithinDistInMap(victim, ASSIST_DISTANCE))
                                summon->AI()->AttackStart(victim);
                        }
                    }
                }
            }
            else if (!currentlyInCombat && _wasInCombat)
            {
                // If any follower is still in combat, assist them and pause the escort until they finish.
                bool anyInCombat = false;
                Creature* lastVictimSrc = nullptr;

                for (uint8 i = 0; i < MAX_CARAVAN_SUMMONS; ++i)
                {
                    if (Creature* summon = ObjectAccessor::GetCreature(*me, summons[i]))
                    {
                        if (summon->IsInCombat())
                        {
                            anyInCombat = true;
                            if (Unit* v = summon->GetVictim())
                                lastVictimSrc = summon;
                        }
                    }
                }

                if (!anyInCombat)
                    SummonsFollow();
                else
                {
                    // Assist followers
                    if (lastVictimSrc && lastVictimSrc->GetVictim())
                    {
                        Unit* victim = lastVictimSrc->GetVictim();
                        if (victim && !victim->IsFriendlyTo(me))
                        {
                            AttackStart(victim);
                            me->CallForHelp(30.0f);
                        }
                    }

                    // Pause escort to avoid leader moving away from engaged followers.
                    SetEscortPaused(true);
                    events.ScheduleEvent(EVENT_CHECK_FOLLOWERS, 1s);
                }
            }

            // remember state for next tick
            _wasInCombat = currentlyInCombat;

            if (!UpdateVictim())
                return;

            DoMeleeAttackIfReady();
        }
    };
};

void AddSC_ipp_zone_desolace()
{
    new npc_cork_gizelton_ipp();
}
