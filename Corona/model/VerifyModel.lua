-- include
local appData = require( "misc.appData" )
local M = {}

M.saveUser = function()
-- encode table to json
    encodedData = appData.json.encode( appData.user )

-- save data to disk, go to disclaimer
   fileName = io.open( appData.userFilePath, "w" )
   
   if fileName then
      fileName:write( encodedData )
      io.close( fileName )
   else
      native.showAlert( "System Error!", "Reinstall SammeVei, please.", { "OK" } )
   end 
end

-- return
return M