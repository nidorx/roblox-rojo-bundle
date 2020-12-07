
local UtilService = require(game.ReplicatedStorage:WaitForChild('Utils'):WaitForChild('MyUtilService'))

local MyServerStorageService = {

}

function MyServerStorageService.Exec()
   print('MyServerStorageService.Exec')

   UtilService.Exec()
end

return MyServerStorageService