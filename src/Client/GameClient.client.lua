repeat wait() until game.Players.LocalPlayer.Character

local Players = game:GetService('Players')
local LocalPlayer = Players.LocalPlayer

local MyClientService = require(LocalPlayer.PlayerScripts:WaitForChild('Services'):WaitForChild('MyClientService'))

print('Player started')

MyClientService.Exec()