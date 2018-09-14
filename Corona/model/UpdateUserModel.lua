-- include
local appData = require( "misc.appData" )
local M = {}

-- functions
M.addNames = function(firstName, middleName, lastName)
	appData.user.firstName = firstName
	appData.user.middleName = middleName
	appData.user.lastName = lastName						
end

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