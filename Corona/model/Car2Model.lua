local appData = require( "misc.appData" )
local M = {}

-- Update Car
M.updateCar = function(color, plate)
    appData.car.color = color
    appData.car.license_plate = plate
    print("color updated: "..appData.car.color)
    print("plate updated: "..appData.car.license_plate)
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