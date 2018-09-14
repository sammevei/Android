local appData = require( "misc.appData" )
local M = {}

-- Update Addresses
M.updateAdresses = function(location, lat, lon, address)
    if (location == "from") then
        appData.user.home = lon..","..lat
        appData.addresses.home.location = lon..","..lat
        appData.addresses.home.address = address
        print("home updated: "..appData.user.home)
    elseif (location == "to") then  
        appData.user.work = lon..","..lat 
        appData.addresses.work.location = lon..","..lat
        appData.addresses.work.address = address
        print("work updated: "..appData.user.work)
    end 
end

-- updateAddressID
M.updateAdressID = function(location, id)
    if (location == "from") then
        appData.addresses.home.address_id = tostring(id)
        print("home updated: "..appData.addresses.home.address_id)
    elseif (location == "to") then  
        appData.addresses.work.address_id = tostring(id)
        print("work updated: "..appData.addresses.work.address_id)
    end 
end

-- Save User
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

-- Save Adresses
M.saveAddresses = function()
  -- encode table to json
  encodedData = appData.json.encode( appData.addresses )

  -- save data to disk, go to disclaimer
  fileName = io.open( appData.addressesFilePath, "w" )
   
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