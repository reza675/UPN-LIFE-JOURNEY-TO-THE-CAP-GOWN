print("[UPN LIFE] Server started!")

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Nanti kita simpan module di ReplicatedStorage/Modules
local Modules = ReplicatedStorage:WaitForChild("Modules", 5)

local PlayerData
local QuestSystem

if Modules then
    PlayerData = require(Modules:WaitForChild("PlayerData"))
    QuestSystem = require(Modules:WaitForChild("QuestSystem"))
else
    warn("[UPN LIFE] Modules folder belum ada di ReplicatedStorage")
end

Players.PlayerAdded:Connect(function(player)
    print("[UPN LIFE] Player join:", player.Name)

    if PlayerData then
        PlayerData:InitPlayer(player)
    end

    if QuestSystem then
        QuestSystem:GiveStarterQuest(player)
    end
end)
