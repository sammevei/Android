local appData = require( "misc.appData" )
local M = {}

-- Update Car
M.updateCar = function(factory, model)
    appData.car.make = factory
    appData.car.model = model
    print("car updated: "..appData.car.make)
    print("car updated: "..appData.car.model)
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