local PlayerData = {}

-- Sementara masih simple, nanti bisa disambung ke DataStore
local _data = {}

function PlayerData:InitPlayer(player)
    _data[player.UserId] = {
        name = player.Name,
        semester = 1,
        credits = 0,
        mainProgress = 0, -- progress dari maba -> wisuda
    }

    print(("[UPN LIFE] Init data untuk %s (semester %d)")
        :format(player.Name, _data[player.UserId].semester))
end

function PlayerData:Get(player)
    return _data[player.UserId]
end

return PlayerData
