
local UtilServices = game.ReplicatedStorage:WaitForChild('Utils')
local MyUtilService = require(UtilServices:WaitForChild('MyUtilService'))
local MyMathService = require(UtilServices:WaitForChild('MyMathService'))

local MyClientService = {

}

function MyClientService.Exec()
   print('MyClientService.Exec')
  
   MyUtilService.Exec()
   MyMathService.Exec()
end

return MyClientService