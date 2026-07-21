/*
 * Restores Alterac Valley turn-in quest.
 * WITHOUT editing core BattlegroundAV.cpp.
 */

#include "IndividualProgression.h"
#include "av_quests.h"
#include "Battleground.h"
#include "Creature.h"
#include "GossipDef.h"
#include "Map.h"
#include "Player.h"
#include "ScriptedGossip.h"
#include "ScriptMgr.h"
#include <unordered_map>

namespace
{
    std::unordered_map<uint32, AVQuestState> avState;

    uint32 ScrapsThreshold(uint8 tier)
    {
        switch (tier)
        {
        case 1:  return sConfigMgr->GetOption<uint32>("IndividualProgression.AV.ScrapsSeasoned", 25);
        case 2:  return sConfigMgr->GetOption<uint32>("IndividualProgression.AV.ScrapsVeteran", 50);
        default: return sConfigMgr->GetOption<uint32>("IndividualProgression.AV.ScrapsChampion", 75);
        }
    }

    uint32 BossPointsRequired()
    {
        return sConfigMgr->GetOption<uint32>("IndividualProgression.AV.BossPointsRequired", 200);
    }

    bool UpgradeReady(AVQuestState const& state, TeamId team)
    {
        return state.defenderTier[team] < AV_DEFENDER_TIER_CHAMPION
            && state.scrapTurnIns[team] >= ScrapsThreshold(state.defenderTier[team] + 1);
    }

    bool CavalryReady(AVQuestState const& state, TeamId team)
    {
        return (state.StablesCompleted[team] && state.HidesCompleted[team]);
    }

    bool AirstrikeReady(AVQuestState const& state, AVAirFleet const& fleet, TeamId /*team*/)
    {
        // Use the fleet's configured team to match where turn-ins are recorded.
        uint32 turnIns = state.airTurnIns[fleet.team][fleet.index];
        uint32 required = sConfigMgr->GetOption<uint32>("IndividualProgression.AV.AirStrikeTurnIns", 50);

        return (turnIns >= required);
    }

    uint32 SupplyTextId(AVQuestState const& state, TeamId team)
    {
        AVSupplyTexts const& texts = team == TEAM_ALLIANCE ? AV_SUPPLY_TEXTS_ALLIANCE : AV_SUPPLY_TEXTS_HORDE;
        uint8 tier = state.defenderTier[team];
        if (tier >= AV_DEFENDER_TIER_CHAMPION)
            return texts.maxed;
        return UpgradeReady(state, team) ? texts.ready[tier] : texts.notReady[tier];
    }

    // Upgrade every DB-spawned defender of `team` to `newTier`, summons are not effected.
    // Dead defenders only get their original entry moved up; Creature::Respawn() then brings them back already upgraded. 
    void UpgradeDefenders(Battleground* bg, TeamId team, uint8 newTier)
    {
        auto const& chains = team == TEAM_ALLIANCE ? AV_ALLIANCE_DEFENDER_CHAINS : AV_HORDE_DEFENDER_CHAINS;

        for (auto const& pair : bg->GetBgMap()->GetCreatureBySpawnIdStore())
        {
            Creature* defender = pair.second;
            if (!defender)
                continue;

            for (AVDefenderChain const& chain : chains)
            {
                if (!chain.entries[0]) // placeholder chain, not filled in yet
                    continue;

                bool isLowerTier = false;
                for (uint8 tier = 0; tier < newTier; ++tier)
                {
                    if (defender->GetEntry() == chain.entries[tier])
                    {
                        isLowerTier = true;
                        break;
                    }
                }

                if (!isLowerTier)
                    continue;

                defender->SetOriginalEntry(chain.entries[newTier]);
                if (chain.upgradeAliveImmediately && defender->IsAlive())
                {
                    uint16 currentFaction = defender->GetFaction();
                    defender->UpdateEntry(chain.entries[newTier], defender->GetCreatureData(), true);
                    defender->SetFaction(currentFaction);
                }
                break;
            }
        }
    }

    void HandleBossTurnIn(Player* player, AVQuestState& state, TeamId team, uint32 points)
    {
        state.bossPoints[team] += points;

        bool isAlliance = team == TEAM_ALLIANCE;
        ChatHandler(player->GetSession()).PSendSysMessage("{}: {}/{}",
            isAlliance ? "Ivus the Forest Lord" : "Lokholar the Ice Lord",
            state.bossPoints[team], BossPointsRequired());

        if (state.ElementalSummoned[team] || state.bossPoints[team] < BossPointsRequired())
            return;

        AVSummonPos const& pos = isAlliance ? NPC_DRUIDS_POS_A : NPC_DRUIDS_POS_H;
        player->SummonCreature(isAlliance ? NPC_AV_DUMMY_A : NPC_AV_DUMMY_H,
            pos.x, pos.y, pos.z, pos.o, TEMPSUMMON_TIMED_DESPAWN, AV_DUMMY_LIFETIME_MS);
        state.ElementalSummoned[team] = true;
    }

    void HandleScrapsTurnIn(Player* player, AVQuestState& state, TeamId team)
    {
        uint32 turnIns = ++state.scrapTurnIns[team];

        if (!UpgradeReady(state, team))
            return;

        // Threshold reached: stop taking scraps until the upgrade is triggered
        uint32 npcEntry = team == TEAM_ALLIANCE ? NPC_MURGOT_DEEPFORGE : NPC_SMITH_REGZAR;
        if (Creature* quartermaster = player->FindNearestCreature(npcEntry, 50.0f))
            quartermaster->RemoveNpcFlag(UNIT_NPC_FLAG_QUESTGIVER);

        ChatHandler(player->GetSession()).PSendSysMessage(
            "Speak with {} to upgrade your troops to {}!",
            team == TEAM_ALLIANCE ? "Murgot Deepforge" : "Smith Regzar",
            AV_TIER_NAMES[state.defenderTier[team] + 1]);
    }

    void HandleStablesTurnIn(Player* player, AVQuestState& state, TeamId team)
    {
        uint32 turnIns = ++state.stablesTurnIns[team];
        uint32 required = sConfigMgr->GetOption<uint32>("IndividualProgression.AV.StablesTurnIns", 10);
        uint32 npcEntry = team == TEAM_ALLIANCE ? NPC_AV_ALTERAC_RAM : NPC_AV_FROSTWOLF;
        bool isAlliance = team == TEAM_ALLIANCE;
        AVSummonPos const* posPtr = nullptr;

        ChatHandler(player->GetSession()).PSendSysMessage("Mount turn-ins: {}/{}", turnIns, required);

        switch (turnIns)
        {
        case 1:
            if (isAlliance)
                posPtr = &NPC_STABLE_RAM_POS_1;
            else
                posPtr = &NPC_STABLE_WOLF_POS_1;
            break;
        case 2:
            if (isAlliance)
                posPtr = &NPC_STABLE_RAM_POS_2;
            else
                posPtr = &NPC_STABLE_WOLF_POS_2;
            break;
        case 3:
            if (isAlliance)
                posPtr = &NPC_STABLE_RAM_POS_3;
            else
                posPtr = &NPC_STABLE_WOLF_POS_3;
            break;
        case 4:
            if (isAlliance)
                posPtr = &NPC_STABLE_RAM_POS_4;
            else
                posPtr = &NPC_STABLE_WOLF_POS_4;
            break;
        case 5:
            if (isAlliance)
                posPtr = &NPC_STABLE_RAM_POS_5;
            else
                posPtr = &NPC_STABLE_WOLF_POS_5;
            break;
        case 6:
            if (isAlliance)
                posPtr = &NPC_STABLE_RAM_POS_6;
            else
                posPtr = &NPC_STABLE_WOLF_POS_6;
            break;
        case 7:
            if (isAlliance)
                posPtr = &NPC_STABLE_RAM_POS_7;
            else
                posPtr = &NPC_STABLE_WOLF_POS_7;
            break;
        case 8:
            if (isAlliance)
                posPtr = &NPC_STABLE_RAM_POS_8;
            else
                posPtr = &NPC_STABLE_WOLF_POS_8;
            break;
        }

        if (posPtr && npcEntry)
            player->SummonCreature(npcEntry, posPtr->x, posPtr->y, posPtr->z, posPtr->o, TEMPSUMMON_TIMED_DESPAWN, AV_2H_LIFETIME_MS);

        if (turnIns < required)
            return;

        state.StablesCompleted[team] = true;

        if (team == TEAM_ALLIANCE)
            ChatHandler(player->GetSession()).PSendSysMessage("Well done, Alliance! We have enough Alterac Rams in our stables to provide mounts to all of our ram riders!");
        else
            ChatHandler(player->GetSession()).PSendSysMessage("Well done, Horde! We have enough Frostwolves in our stables to provide mounts to all of our wolf riders!");
    }

    void HandleHidesTurnIn(Player* player, AVQuestState& state, TeamId team)
    {
        uint32 turnIns = ++state.hidesTurnIns[team];
        uint32 required = sConfigMgr->GetOption<uint32>("IndividualProgression.AV.StablesTurnIns", 10);

        ChatHandler(player->GetSession()).PSendSysMessage("Hides turn-ins: {}/{}", turnIns, required);

        if (turnIns < required)
            return;

        state.HidesCompleted[team] = true;

        bool isAlliance = team == TEAM_ALLIANCE;

        if (isAlliance)
            ChatHandler(player->GetSession()).PSendSysMessage("We have gathered enough hides from the wolves. Soon, the cavalry will be ready to ride! Speak to me again when we have stabled enough rams.");
        else
            ChatHandler(player->GetSession()).PSendSysMessage("We have gathered enough hides from the rams. Soon, the cavalry will be ready to ride! Speak to me again when we have stabled enough wolves.");


        uint32 npcEntryQuest = team == TEAM_ALLIANCE ? NPC_CAV_CMDR_A : NPC_CAV_CMDR_H;
        Creature* npcQuest = player->FindNearestCreature(npcEntryQuest, 50.0f);

        npcQuest->RemoveNpcFlag(UNIT_NPC_FLAG_QUESTGIVER);

    }

    // Estimate for the supplies gossip option, using existing broadcast texts as examples
    char const* ScrapsEstimateLine(AVQuestState const& state, TeamId team)
    {
        uint8 tier = state.defenderTier[team];
        if (tier >= AV_DEFENDER_TIER_CHAMPION)
            return "I cannot store any more supplies. I have all I can handle!";

        uint32 next = ScrapsThreshold(tier + 1);
        uint32 prev = tier > 0 ? ScrapsThreshold(tier) : 0;
        uint32 turnIns = state.scrapTurnIns[team];

        uint32 interval = next > prev ? next - prev : 1;
        uint32 remaining = next > turnIns ? next - turnIns : 0;

        if (remaining * 4 >= interval * 3)  // less than a quarter done
            return "I barely have any supplies for upgrades.";
        if (remaining * 4 >= interval * 2)  // under halfway
            return "I need many more supplies in order to upgrade our units.";
        if (remaining * 4 <= interval * 2 && remaining * 4 >= interval * 3) // over halfway and under three-quarters
            return "I have about half the supplies needed to upgrade our units.";
        return "I almost have enough supplies for the next upgrade!"; // over three-quarters done
    }

    void HandleAirStrikeTurnIn(Player* player, AVQuestState& state, AVAirFleet const& fleet)
    {
        uint32 turnIns = ++state.airTurnIns[fleet.team][fleet.index];
        uint32 required = sConfigMgr->GetOption<uint32>("IndividualProgression.AV.AirStrikeTurnIns", 50);

        ChatHandler(player->GetSession()).PSendSysMessage("{}'s Fleet turn-ins: {}/{}", fleet.commanderName, turnIns, required);

        if (turnIns < required)
            return;

        if (!AirstrikeReady(state, fleet, fleet.team))
            return;

        AVSummonPos const* posPtr = nullptr;
        uint32 dummyEntry = 0;

        switch (fleet.questGiverEntry)
        {
        case NPC_WING_CMDR_GUSE:
            posPtr = &NPC_CMDR_POS_GUSE;
            dummyEntry = NPC_DUMMY_CMDR_GUSE;
            break;
        case NPC_WING_CMDR_JEZTOR:
            posPtr = &NPC_CMDR_POS_JEZTOR;
            dummyEntry = NPC_DUMMY_CMDR_JEZTOR;
            break;
        case NPC_WING_CMDR_MULVERICK:
            posPtr = &NPC_CMDR_POS_MULV;
            dummyEntry = NPC_DUMMY_CMDR_MULV;
            break;
        case NPC_WING_CMDR_ICHMAN:
            posPtr = &NPC_CMDR_POS_ICHMAN;
            dummyEntry = NPC_DUMMY_CMDR_ICHMAN;
            break;
        case NPC_WING_CMDR_SLIDORE:
            posPtr = &NPC_CMDR_POS_SLIDORE;
            dummyEntry = NPC_DUMMY_CMDR_SLIDORE;
            break;
        case NPC_WING_CMDR_VIPORE:
            posPtr = &NPC_CMDR_POS_VIPORE;
            dummyEntry = NPC_DUMMY_CMDR_VIPORE;
            break;
        default:
            break;
        }

        if (posPtr && dummyEntry)
            player->SummonCreature(dummyEntry, posPtr->x, posPtr->y, posPtr->z, posPtr->o, TEMPSUMMON_TIMED_DESPAWN, AV_2H_LIFETIME_MS);

        if (Creature* commander = player->FindNearestCreature(fleet.questGiverEntry, 30.0f))
        {
            commander->SetVisible(false);
            commander->SetFaction(AV_FACTION_FRIENDLY);
            commander->RemoveNpcFlag(UNIT_NPC_FLAG_QUESTGIVER);
        }
    }

    void SendSupplyStatus(Player* player, Creature* creature, AVQuestState& state, TeamId team)
    {
        ClearGossipMenuFor(player);

        if (UpgradeReady(state, team))
        {
            AddGossipItemFor(player, GOSSIP_ICON_CHAT,
                Acore::StringFormat("Upgrade our troops to {}!", AV_TIER_NAMES[state.defenderTier[team] + 1]),
                GOSSIP_SENDER_MAIN, AV_GOSSIP_ACTION_UPGRADE);
        }
        else if (state.defenderTier[team] < AV_DEFENDER_TIER_CHAMPION)
        {
            AddGossipItemFor(player, GOSSIP_ICON_CHAT, ScrapsEstimateLine(state, team), GOSSIP_SENDER_MAIN, 0);

            if (sConfigMgr->GetOption<bool>("IndividualProgression.AV.GossipExactNumbers", false))
                AddGossipItemFor(player, GOSSIP_ICON_CHAT,
                    Acore::StringFormat("(Turn-ins: {}/{})", state.scrapTurnIns[team],
                        ScrapsThreshold(state.defenderTier[team] + 1)),
                    GOSSIP_SENDER_MAIN, 0);
        }

        SendGossipMenuFor(player, SupplyTextId(state, team), creature);
    }
}

class ip_av_quests_player : public PlayerScript
{
public:
    ip_av_quests_player() : PlayerScript("ip_av_quests_player") {}

    bool OnPlayerCanCastItemUseSpell(Player* player, Item* item, SpellCastTargets const& /*targets*/, uint8 /*cast_count*/, uint32 /*glyphIndex*/) override
    {
        if (!player || !item)
            return false;

        if (item->GetEntry() == ITEM_FROSTWOLF_MUZZLE || item->GetEntry() == ITEM_STORMPIKE_COLLAR)
        {
            Unit* selected = player->GetSelectedUnit();
            if (!selected)
                return false;

            Creature* creature = selected->ToCreature();
            if (!creature)
                return false;

            if (creature->GetEntry() == NPC_AV_FROSTWOLF)
            {
                if (player->HasQuest(AV_Q_H_STABLES) && player->GetQuestStatus(AV_Q_H_STABLES) == QUEST_STATUS_INCOMPLETE)
                    player->CompleteQuest(AV_Q_H_STABLES);
            }
            else if (creature->GetEntry() == NPC_AV_ALTERAC_RAM)
            {
                if (player->HasQuest(AV_Q_A_STABLES) && player->GetQuestStatus(AV_Q_A_STABLES) == QUEST_STATUS_INCOMPLETE)
                    player->CompleteQuest(AV_Q_A_STABLES);
            }
        }

        return true;
    }

    void OnPlayerCompleteQuest(Player* player, Quest const* quest) override
    {
        if (!player || !quest)
            return;

        Battleground* bg = player->GetBattleground();
        if (!bg || bg->GetBgTypeID(true) != BATTLEGROUND_AV)
            return;

        AVQuestState& state = avState[bg->GetInstanceID()];

        switch (quest->GetQuestId())
        {
            // ----------- Summon Elemental Boss -----------
        case AV_Q_A_BOSS1:
            HandleBossTurnIn(player, state, TEAM_ALLIANCE, 5);
            break;
        case AV_Q_A_BOSS2:
            HandleBossTurnIn(player, state, TEAM_ALLIANCE, 1);
            break;
        case AV_Q_H_BOSS1:
            HandleBossTurnIn(player, state, TEAM_HORDE, 5);
            break;
        case AV_Q_H_BOSS2:
            HandleBossTurnIn(player, state, TEAM_HORDE, 1);
            break;

            // ---------------- Armor Scraps ----------------
        case AV_Q_A_SCRAPS1:
        case AV_Q_A_SCRAPS2:
            HandleScrapsTurnIn(player, state, TEAM_ALLIANCE);
            break;
        case AV_Q_H_SCRAPS1:
        case AV_Q_H_SCRAPS2:
            HandleScrapsTurnIn(player, state, TEAM_HORDE);
            break;

            // --------------- Empty Stables ---------------
        case AV_Q_A_STABLES:
            HandleStablesTurnIn(player, state, TEAM_ALLIANCE);
            break;
        case AV_Q_H_STABLES:
            HandleStablesTurnIn(player, state, TEAM_HORDE);
            break;

            // ----------------- Harnesses -----------------
        case AV_Q_A_HARNESS:
            HandleHidesTurnIn(player, state, TEAM_ALLIANCE);
            break;
        case AV_Q_H_HARNESS:
            HandleHidesTurnIn(player, state, TEAM_HORDE);
            break;

            // ---------------- Air strikes (Call of Air) ----------------
        case AV_Q_A_COMMANDER1:
        case AV_Q_A_COMMANDER2:
        case AV_Q_A_COMMANDER3:
        case AV_Q_H_COMMANDER1:
        case AV_Q_H_COMMANDER2:
        case AV_Q_H_COMMANDER3:
            for (AVAirFleet const& fleet : AV_AIR_FLEETS)
            {
                if (fleet.questId == quest->GetQuestId())
                {
                    HandleAirStrikeTurnIn(player, state, fleet);
                    break;
                }
            }
            break;

        default:
            break;
        }
    }
};

class ip_av_quests_gossip : public AllCreatureScript
{
public:
    ip_av_quests_gossip() : AllCreatureScript("ip_av_quests_gossip") {}

    bool CanCreatureGossipHello(Player* player, Creature* creature) override
    {
        TeamId team;

        if (creature->GetEntry() == NPC_SMITH_REGZAR || creature->GetEntry() == NPC_MURGOT_DEEPFORGE)
        {
            AVQuestState* state = GetStateScraps(player, creature, team);

            if (!state)
                return false;

            player->PrepareGossipMenu(creature, creature->GetCreatureTemplate()->GossipMenuId, true);
            SendGossipMenuFor(player, SupplyTextId(*state, team), creature);
            return true;
        }
  
        if (creature->GetEntry() == NPC_CAV_CMDR_A || creature->GetEntry() == NPC_CAV_CMDR_H)
        {
            AVQuestState* state = GetStateStables(player, creature, team);

            if (!state)
                return false;

            bool isAlliance = team == TEAM_ALLIANCE;

            if (!state->StablesCompleted[team] || !state->HidesCompleted[team])
                return false;

            uint32 npcEntryQuest = team == TEAM_ALLIANCE ? NPC_CAV_CMDR_A : NPC_CAV_CMDR_H;
            uint32 npcEntryPatrol = team == TEAM_ALLIANCE ? NPC_CAV_CMDR_A_PATROL : NPC_CAV_CMDR_H_PATROL;

            Creature* npcQuest = player->FindNearestCreature(npcEntryQuest, 50.0f);
            Creature* npcPatrol = player->FindNearestCreature(npcEntryPatrol, 50.0f);

            if (!npcQuest || !npcPatrol)
                return false;

            npcQuest->SetVisible(false);
            npcQuest->SetFaction(AV_FACTION_FRIENDLY);

            npcPatrol->SetVisible(true);
            npcPatrol->SetFaction(isAlliance ? AV_FACTION_STORMPIKE_PVP : AV_FACTION_FROSTWOLF_PVP);

            return true;
        }

        // Let the default handler show gossip for all other creatures.
        return false;
    }

    bool CanCreatureGossipSelect(Player* player, Creature* creature, uint32 /*sender*/, uint32 action) override
    {
        TeamId team;

        AVQuestState* state = GetStateScraps(player, creature, team);

        if (!state)
            return false;

        // DB-provided option selected -> show scripted supply/airstrike menu depending on NPC.
        if (action == GOSSIP_OPTION_GOSSIP)
        {
            if (state)
            {
                SendSupplyStatus(player, creature, *state, team);
                return true;
            }
            return false;
        }

        // Scrap upgrade action unchanged.
        if (action == AV_GOSSIP_ACTION_UPGRADE)
        {
            if (state && UpgradeReady(*state, team))
            {
                ++state->defenderTier[team];
                UpgradeDefenders(player->GetBattleground(), team, state->defenderTier[team]);
                creature->SetNpcFlag(UNIT_NPC_FLAG_QUESTGIVER); // resume turn-ins
            }
            if (state)
                SendSupplyStatus(player, creature, *state, team); // show the new status
            return true;
        }

        return false;
    }
private:
    static AVQuestState* GetStateScraps(Player* player, Creature* creature, TeamId& team)
    {
        uint32 entry = creature->GetEntry();
        if (entry != NPC_MURGOT_DEEPFORGE && entry != NPC_SMITH_REGZAR)
            return nullptr;

        Battleground* bg = player->GetBattleground();
        if (!bg || bg->GetBgTypeID(true) != BATTLEGROUND_AV)
            return nullptr;

        team = entry == NPC_MURGOT_DEEPFORGE ? TEAM_ALLIANCE : TEAM_HORDE;
        return &avState[bg->GetInstanceID()];
    }

    static AVQuestState* GetStateStables(Player* player, Creature* creature, TeamId& team)
    {
        uint32 entry = creature->GetEntry();
        if (entry != NPC_CAV_CMDR_A && entry != NPC_CAV_CMDR_H)
            return nullptr;

        Battleground* bg = player->GetBattleground();
        if (!bg || bg->GetBgTypeID(true) != BATTLEGROUND_AV)
            return nullptr;

        team = entry == NPC_CAV_CMDR_A ? TEAM_ALLIANCE : TEAM_HORDE;
        return &avState[bg->GetInstanceID()];
    }
};

// Clear per-match state when the BG is destroyed so avState can't grow forever.
class ip_av_quests_bg : public AllBattlegroundScript
{
public:
    ip_av_quests_bg() : AllBattlegroundScript("ip_av_quests_bg") {}

    void OnBattlegroundDestroy(Battleground* bg) override
    {
        if (bg)
            avState.erase(bg->GetInstanceID());
    }
};

void AddSC_mod_individual_progression_av_quests()
{
    new ip_av_quests_player();
    new ip_av_quests_gossip();
    new ip_av_quests_bg();
}
