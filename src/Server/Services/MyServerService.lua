

local UtilServices = game.ReplicatedStorage:WaitForChild('Utils')
local MyUtilService = require(UtilServices:WaitForChild('MyUtilService'))
local MyMathService = require(UtilServices:WaitForChild('MyMathService'))

local ServerStorageService = require(game.ServerStorage:WaitForChild('Services'):WaitForChild('MyServerStorageService'))

local MyServerService = {

}

function MyServerService.Exec()
   print('MyServerService.Exec')
   ServerStorageService.Exec()
   MyUtilService.Exec()
   MyMathService.Exec()
end

return MyServerService