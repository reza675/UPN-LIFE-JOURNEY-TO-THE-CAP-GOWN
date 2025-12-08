local QuestSystem = {}

-- Sementara 1 quest awal: "Ospek & Tur Kampus"
local starterQuest = {
    id = "MAIN_INTRO",
    title = "Hari Pertama Sebagai Maba",
    description = "Datangi Aula UPN dan bicara dengan Kakak Pendamping.",
    rewardXP = 100,
}

local activeQuests = {}

function QuestSystem:GiveStarterQuest(player)
    activeQuests[player.UserId] = activeQuests[player.UserId] or {}
    table.insert(activeQuests[player.UserId], starterQuest)

    print(("[UPN LIFE] Starter quest diberikan ke %s: %s")
        :format(player.Name, starterQuest.title))
end

function QuestSystem:GetActiveQuests(player)
    return activeQuests[player.UserId] or {}
end

return QuestSystem
