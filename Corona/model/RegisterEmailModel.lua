-- include
local appData = require( "misc.appData" )
local M = {}


-- functions
M.defineUser = function(userName, passWord)

	appData.user.userName = userName
	appData.user.passWord = passWord
	appData.user.eMail = userName
						
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

M.saveRefreshToken = function()
-- encode table to json
    encodedData = appData.session.refreshToken

-- save data to disk, go to disclaimer
   fileName = io.open( appData.refreshTokenFilePath, "w" )
   
   if fileName then
      fileName:write( encodedData )
      io.close( fileName )
   else
      native.showAlert( "System Error!", "Reinstall SammeVei, please.", { "OK" } )
   end 
end

-- return
return M