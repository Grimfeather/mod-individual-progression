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

// #include "AreaDefines.h"
// #include "CombatAI.h"
#include "CreatureScript.h"
// #include "PassiveAI.h"
#include "Player.h"
#include "ScriptedCreature.h"
// #include "ScriptedEscortAI.h"
// #include "ScriptedFollowerAI.h"
// #include "ScriptedGossip.h"
// #include "SmartAI.h"
#include "SpellAuras.h"
#include "SpellInfo.h"
// #include "SpellScript.h"
// #include "SpellScriptLoader.h"
// #include "WaypointMgr.h"


/*######
## npc_imprisoned_beryl_sorcerer
######*/
enum ImprisionedBerylSorcerer
{
    SPELL_NEURAL_NEEDLE                 = 45634,
    SPELL_COSMETIC_ENSLAVE_CHAINS_SELF  = 45631,

    NPC_IMPRISONED_BERYL_SORCERER   = 25478,

    SAY_IMPRISIONED_BERYL_1         = 0,
    SAY_IMPRISIONED_BERYL_2         = 1,
    SAY_IMPRISIONED_BERYL_3         = 2,
    SAY_IMPRISIONED_BERYL_4         = 3,
    SAY_IMPRISIONED_BERYL_5         = 4,
    SAY_IMPRISIONED_BERYL_6         = 5,
    SAY_IMPRISIONED_BERYL_7         = 6
};

class npc_imprisoned_beryl_sorcerer_ipp : public CreatureScript
{
public:
    npc_imprisoned_beryl_sorcerer_ipp() : CreatureScript("npc_imprisoned_beryl_sorcerer") { }

    struct npc_imprisoned_beryl_sorcererAI : public ScriptedAI
    {
        npc_imprisoned_beryl_sorcererAI(Creature* creature) : ScriptedAI(creature) { }

        uint32 rebuff;

        void Reset() override
        {
            if (me->GetReactState() != REACT_PASSIVE)
                me->SetReactState(REACT_PASSIVE);

            rebuff = 0;

            // xinef: correct visuals
            me->UpdatePosition(me->GetPositionX(), me->GetPositionY(), 150.517f, me->GetOrientation(), true);
            me->SetStandState(UNIT_STAND_STATE_SIT_MEDIUM_CHAIR);
        }

        void UpdateAI(uint32 diff) override
        {
            UpdateVictim();

            if (rebuff <= diff)
            {
                if (!me->HasAura(SPELL_COSMETIC_ENSLAVE_CHAINS_SELF))
                {
                    DoCast(me, SPELL_COSMETIC_ENSLAVE_CHAINS_SELF);
                }
                rebuff = 180000;
            }
            else
                rebuff -= diff;

            DoMeleeAttackIfReady();
        }

        void JustEngagedWith(Unit* /*who*/) override
        {
        }

        void SpellHit(Unit* unit, SpellInfo const* spell) override
        {
            if (spell->Id == SPELL_NEURAL_NEEDLE && unit->IsPlayer())
            {
                if (Player* player = unit->ToPlayer())
                {
                    GotStinged(player->GetGUID());
                }
            }
        }

        void GotStinged(ObjectGuid casterGUID)
        {
            if (Player* caster = ObjectAccessor::GetPlayer(*me, casterGUID))
            {
                uint32 step = caster->GetAuraCount(SPELL_NEURAL_NEEDLE) + 1;
                switch (step)
                {
                    case 1:
                        Talk(SAY_IMPRISIONED_BERYL_1);
                        break;
                    case 2:
                        Talk(SAY_IMPRISIONED_BERYL_2, caster);
                        break;
                    case 3:
                        Talk(SAY_IMPRISIONED_BERYL_3);
                        break;
                    case 4:
                        Talk(SAY_IMPRISIONED_BERYL_4);
                        break;
                    case 5:
                        Talk(SAY_IMPRISIONED_BERYL_5);
                        caster->KilledMonsterCredit(NPC_IMPRISONED_BERYL_SORCERER);
                        break;
                    case 6:
                        Talk(SAY_IMPRISIONED_BERYL_6, caster);
                        break;
                    case 7:
                        Talk(SAY_IMPRISIONED_BERYL_7);
                        break;
                }
            }
        }
    };

    CreatureAI* GetAI(Creature* creature) const override
    {
        return new npc_imprisoned_beryl_sorcererAI(creature);
    }
};

void AddSC_ipp_zone_borean_tundra()
{
    new npc_imprisoned_beryl_sorcerer_ipp();
}
