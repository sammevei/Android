local appData = require( "misc.appData" )
local M = {}

-- Create Journey
M.createJourney = function(event)
	appData.journey = { 
            driver = { 
                    __type =  "Pointer",
                    className = "_User",
                    objectId = appData.user.objectId
                    },

            mode = "Driver",      
            starttime =  { 
                         __type = "Date",
                         iso = "2017-11-15T06:30:00.000Z"
                         },

            departure = "",

            destination = "",

            ["type"] = "planned",

            route = { start = {
                            __type = "GeoPoint",
                            latitude = 62.41205760718987,
                            longitude = 6.31640172559533
                            },
                      ["end"] = {
                            __type = "GeoPoint",
                            latitude = 62.4715803,
                            longitude = 6.148923299999999
                            } 
                    },
            endpoint =  {
                        __type = "GeoPoint",
                        latitude = 62.4715803,
                        longitude = 6.148923299999999
                        }        
        }
end

-- Create Ride
M.createRide = function(event)
    appData.ride = { 
            passenger = { 
                    __type =  "Pointer",
                    className = "_User",
                    objectId = appData.user.objectId
                    },

            mode = "Driver", 

            starttime =  { 
                         __type = "Date",
                         iso = "2017-11-15T06:30:00.000Z"
                         },

            departure = "",

            destination = "",

            ["type"] = "planned",

            locations = { start = {
                            __type = "GeoPoint",
                            latitude = 62.41205760718987,
                            longitude = 6.31640172559533
                            },
                      ["end"] = {
                            __type = "GeoPoint",
                            latitude = 62.4715803,
                            longitude = 6.148923299999999
                            } 
                    },
                    
            endpoint =  {
                        __type = "GeoPoint",
                        latitude = 62.4715803,
                        longitude = 6.148923299999999
                        }        
        }
end

-- Update Journey
M.updateJourney = function(event)
    appData.journey.driver.objectId = appData.user.objectId
    appData.journey.departure = appData.departureField.text
    appData.journey.destination = appData.destinationField.text
end

M.updateJourneyLocation = function(type, lat, lon)
    print("JOURNEY: "..type.." "..lat.." "..lon)
end

-- Update Ride
M.updateRide = function(event)
    appData.ride.passenger.objectId = appData.user.objectId
    appData.ride.departure = appData.departureField.text
    appData.ride.destination = appData.destinationField.text
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