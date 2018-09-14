local appData = require( "misc.appData" )
local M = {}

-- Update Car
M.updateCar = function(engineType)
    appData.car.vehicle_engine_type_id = engineType
end

M.updateCarID = function(vehicle_id )
  appData.car.vehicle_id = vehicle_id
end

-- Save User
M.saveCar = function()
-- encode table to json
    encodedData = appData.json.encode( appData.car )
    print("car saved")

-- save data to disk, go to disclaimer
   fileName = io.open( appData.carFilePath, "w" )
   
   if fileName then
      fileName:write( encodedData )
      io.close( fileName )
   else
      native.showAlert( "System Error!", "Reinstall SammeVei, please.", { "OK" } )
   end 
end

-- Utilities
M.urlEncode = function( str )
    if ( str ) then
        str = string.gsub( str, "\n", "\r\n" )
        str = string.gsub( str, "([^%w ])",
              function ( c ) return string.format ( "%%%02X", string.byte( c ) ) end )
        str = string.gsub( str, " ", "+" )
    end
    return str
end

-- return
return M