
local MyServerService = require(game.ServerScriptService:WaitForChild('Services'):WaitForChild('MyServerService'))

print('Server started')

MyServerService.Exec()