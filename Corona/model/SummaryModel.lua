local appData = require( "misc.appData" )
local M = {}

-- Update Transport
M.updateTransport = function(mode)
    appData.transport.mode = mode
    print(appData.transport.mode)
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