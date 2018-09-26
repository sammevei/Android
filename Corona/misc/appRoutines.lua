local M = {}
-- Split

M.split = function(pString, pPattern)
   local Table = {}  -- NOTE: use {n = 0} in Lua-5.0
   local fpat = "(.-)" .. pPattern
   local last_end = 1
   local s, e, cap = pString:find(fpat, 1)
   while s do
      if s ~= 1 or cap ~= "" then
         table.insert(Table,cap)
      end
      last_end = e+1
      s, e, cap = pString:find(fpat, last_end)
   end
   if last_end <= #pString then
      cap = pString:sub(last_end)
      table.insert(Table, cap)
  end

   return Table
end

-- Create Options Icon
M.createOptionsIcon = function(color, x, y)
	local iconGroup = display.newGroup()
	iconGroup.anchorChildren = true;
	iconGroup.anchorX = 1
	iconGroup.anchorY = 0

	local bar1=display.newRect(0,0,30,2)
	bar1.fill=barsColor
	iconGroup:insert(bar1)

	local bar2=display.newRect(0,9,30,2)
	bar2.fill=barsColor
	iconGroup:insert(bar2)

	local bar3=display.newRect(0,18,30,2)
	bar3.fill=barsColor
	iconGroup:insert(bar3)

	iconGroup.x = x
	iconGroup.y = y
end

-- ------------------------------------------------------------------------- --
-- TIME
-- ------------------------------------------------------------------------- --

M.calculateNow = function()
	local date = os.date( "*t" )
	date.hour = date.hour-os.date("%z")/100
	local now = os.time( date )
	return now
end

M.UTCtoSec = function(utc)

    -- takes UTC string, returns UTC time in seconds

	local string = utc
	local timeTable = {year, month, day, hour, sec}
	local seconds

	timeTable.year = string.sub(string, 1, 4)
	timeTable.month = string.sub(string, 6, 7)
	timeTable.day = string.sub(string, 9, 10)
	timeTable.hour = string.sub(string, 12, 13)
	timeTable.sec = tonumber(string.sub(string, 15, 16))*60
	seconds = os.time(timeTable)

	return seconds
end

M.localToUTC = function(y, m, d, h, s)

    -- takes local year, month, day, hour and minutes as numbers or strings,
    -- calculates UTC time and outputs in 2018-01-18T07:30:00.000Z format

	local utcTime = ""

	-- translate to seconds
	local time1 = os.time {
		year = tonumber(y),
		month = tonumber(m),
		day = tonumber(d),
		hour = tonumber(h),
		sec = tonumber(s)
	}

	-- calculate difference between actual timezone and UTC
  local now = os.time()
  local difference = os.difftime(now, os.time(os.date("!*t", now)))
	time1 = time1 - difference

	-- assemble result
	local y = os.date("%Y", time1)
	local m = os.date("%m", time1)
	local d = os.date("%d", time1)
	local h = os.date("%H", time1)
	local min = os.date("%M", time1)
	local s = 60*os.date("%M", time1)

	utcTime = y.."-"..m.."-"..d.."T"..h..":"..min..":".."00.000Z"

	-- return UTC time as string
	return utcTime
end
-- -------------------------------------------------------------------------

M.UTCtoLocal = function(utcTime)
	if utcTime ~= nil then

	    -- disassemble the UTC string 2018-02-18T15:00:00+00:00
	    local y = string.sub(utcTime, 1, 4)
	    local m = string.sub(utcTime, 6, 7)
	    local d = string.sub(utcTime, 9, 10)
	    local h = string.sub(utcTime, 12, 13)
	    local s = tonumber(string.sub(utcTime, 15, 16))*60

	    -- change timezone
		local shift = 2
		h = h + shift

		-- translate to seconds
		local time1 = os.time{year = y, month = m, day = d, hour = h, sec = s}

		local y = os.date("%Y", time1)
		local m = os.date("%m", time1)
		local d = os.date("%d", time1)
		local h = os.date("%H", time1)
		local s = 60*os.date("%M", time1)

		-- print("this is local again: ".." "..y.." - "..m.." - "..d.." - "..h.." - "..s)
		local localTime = {year = y, month = m, day = d, hour = h, sec = s}
		return localTime
	end
end

M.minutesToHours = function(time_offset)
        -- calculate hours and minutes
        local time_offset = tonumber(time_offset)
        local integralPart, fractionalPart = math.modf(time_offset/60)
        local hours = integralPart
        local minutes = math.fmod(time_offset, 60)

        if minutes == nil then
            minutes = 0
        end

        hours = tostring(hours)
        minutes = tostring(minutes)

        if string.len(hours) < 2 then
            hours = "0"..hours
        end

        if string.len(minutes) < 2 then
            minutes = "0"..minutes
        end

        -- assemble string
        local time = tostring(hours)..":"..tostring(minutes)

        -- return hours:minutes
        return time
end

-- ------------------------------------------------------------------------- --
-- MAPS
-- ------------------------------------------------------------------------- --

-- General Map ------------------------------------------------------------- --

M.createMap = function(lat1, lon1, lat2, lon2)

	-- MAPBOX
	------------------------
	--REQUIRED VARIABLES
	------------------------

	local APIkey = "AIzaSyAj5D-S7WTwtU7h8ZKYAI3T_4n1r3zxHoM"
	local path = system.pathForFile( "map.html", system.DocumentsDirectory )

	local lat1 = tostring(lat1)
	local lon1 = tostring(lon1)
	local lat2 = tostring(lat2)
	local lon2 = tostring(lon2)

	------------------------
	--HTML & JAVASCRIPT CODE
	------------------------

	local mapString = [[
		<html>
		<head>
		<meta charset=utf-8 />
		<title>A simple map</title>
		<meta name='viewport' content='initial-scale=1,maximum-scale=1,user-scalable=no' />
		<script src='https://api.mapbox.com/mapbox.js/v3.1.1/mapbox.js'></script>
		<script src='http://silver.tf/libraries/mb_directions.js'></script>
		<link href='https://api.mapbox.com/mapbox.js/v3.1.1/mapbox.css' rel='stylesheet' />
		<style>
		  body { margin:0; padding:0; }
		  #map { position:absolute; top:0; bottom:0; width:100%; }
		</style>
		</head>
		<body>

		<script src='https://api.mapbox.com/mapbox.js/plugins/leaflet-locatecontrol/v0.43.0/L.Control.Locate.min.js'></script>
		<link href='https://api.mapbox.com/mapbox.js/plugins/leaflet-locatecontrol/v0.43.0/L.Control.Locate.mapbox.css' rel='stylesheet' />
		<link href='https://api.mapbox.com/mapbox.js/plugins/leaflet-locatecontrol/v0.43.0/css/font-awesome.min.css' rel='stylesheet' />

		<div id='map'></div>
		<script>

		// [1] INCLUDE LISTENER =====================================================================
		function getURLParameter(name) {
            return decodeURIComponent((new RegExp('[?|&]' + name + '=' + '([^&;]+?)(&|#|;|$)').exec(location.href)||[,""])[1].replace(/\+/g, '%20'))||null;
        }
        // ======================================================================================= //


        // ========================================================================================== //

		L.mapbox.accessToken = 'pk.eyJ1Ijoib2NoZWxzZXQiLCJhIjoiY2ltbmZqbXA4MDAxdXgza3E2OW44ZzZ2NyJ9.Kgl_Fc5Gu2QnpXcvL9UXRQ';

		// example origin and destination
		var start = {lat: ]]..lat1..[[, lon: ]]..lon1..[[};
		var finish = {lat: ]]..lat2..[[, lon: ]]..lon2..[[};

		// [2] GET VARIABLES =====================================================================
		start.lat = getURLParameter("lat1")
		start.lon = getURLParameter("lon1")
		finish.lat = getURLParameter("lat2")
		finish.lon = getURLParameter("lon2")
		// =======================================================================================

        // [3] CENTER MAP ========================================================================
		var map = L.mapbox.map('map', 'mapbox.streets', {
		    zoomControl: false }).setView([start.lat, start.lon], 9);
		// =======================================================================================


        // STYLE ================================================ //

		// L.mapbox.tileLayer('https://api.mapbox.com/v3/mapbox.dark.json').addTo(map);

		// map.attributionControl.setPosition('bottomleft');
		var directions = L.mapbox.directions({
		    profile: 'mapbox.driving'
		});

		// [4] DRAW DIRECTIONS ===================================================================
		// Set the origin and destination for the direction and call the routing service
		directions.setOrigin(L.latLng(start.lat, start.lon));
		directions.setDestination(L.latLng(finish.lat, finish.lon));
		// =======================================================================================

		directions.query();

        if (start.lon != 10.70) {
			var directionsLayer = L.mapbox.directions.layer(directions).addTo(map);
			var directionsRoutesControl = L.mapbox.directions.routesControl('routes', directions)
		    	.addTo(map);
		}

		// ========================================================================================== //

		// L.control.locate().addTo(map);

		</script>
		</body>
		</html>]]

	--This string is the text that will be written to our HTML file.

	------------------------
	--HTML FILE CREATION
	------------------------

	local htmlFile = io.open( path, "w" )
	htmlFile:write( mapString )
	io.close( htmlFile )
	--The above code writes our "mapString" variable to an HTML file and saves it in the Documents directory.

	-- print("the map was created")
end

-- Driver Map -------------------------------------------------------------- --

M.createDriverMap = function(lat1, lon1, lat2, lon2)
	print("really making driver map")

	-- MAPBOX
	------------------------
	--REQUIRED VARIABLES
	------------------------

	local APIkey = "AIzaSyAj5D-S7WTwtU7h8ZKYAI3T_4n1r3zxHoM"
	local path = system.pathForFile( "drivermap.html", system.DocumentsDirectory )

	local lat1 = tostring(lat1)
	local lon1 = tostring(lon1)
	local lat2 = tostring(lat2)
	local lon2 = tostring(lon2)

	------------------------
	--HTML & JAVASCRIPT CODE
	------------------------

	local mapString = [[
		<html>
		<head>
		<meta charset=utf-8 />
		<title>A simple map</title>
		<meta name='viewport' content='initial-scale=1,maximum-scale=1,user-scalable=no' />
		<script src='https://api.mapbox.com/mapbox.js/v3.1.1/mapbox.js'></script>
		<script src='http://silver.tf/libraries/mb_directions.js'></script>
		<link href='https://api.mapbox.com/mapbox.js/v3.1.1/mapbox.css' rel='stylesheet' />
		<style>
		  body { margin:0; padding:0; }
		  #map { position:absolute; top:0; bottom:0; width:100%; }
		</style>
		</head>
		<body>

		<script src='http://silver.tf/libraries/L.Control.Locate.js'></script>
		<link href='https://api.mapbox.com/mapbox.js/plugins/leaflet-locatecontrol/v0.43.0/L.Control.Locate.mapbox.css' rel='stylesheet' />
		<link href='https://api.mapbox.com/mapbox.js/plugins/leaflet-locatecontrol/v0.43.0/css/font-awesome.min.css' rel='stylesheet' />

		<div id='map'></div>
		<script>


        // ========================================================================================== //

		L.mapbox.accessToken = 'pk.eyJ1Ijoib2NoZWxzZXQiLCJhIjoiY2ltbmZqbXA4MDAxdXgza3E2OW44ZzZ2NyJ9.Kgl_Fc5Gu2QnpXcvL9UXRQ';

		// example origin and destination
		var start = {lat: ]]..lat1..[[, lon: ]]..lon1..[[};
		var finish = {lat: ]]..lat2..[[, lon: ]]..lon2..[[};

		var map = L.mapbox.map('map', 'mapbox.streets', {
		    zoomControl: false }).setView([]]..lat1..[[, ]]..lon1..[[], 9);

		// map.attributionControl.setPosition('bottomleft');
		var directions = L.mapbox.directions({
		    profile: 'mapbox.driving'
		});

		// Set the origin and destination for the direction and call the routing service
		directions.setOrigin(L.latLng(]]..lat1..[[, ]]..lon1..[[));
		directions.setDestination(L.latLng(]]..lat2..[[, ]]..lon2..[[));

		directions.query();

		var directionsLayer = L.mapbox.directions.layer(directions).addTo(map);
		var directionsRoutesControl = L.mapbox.directions.routesControl('routes', directions)
		    .addTo(map);

		// ========================================================================================== //

		var locator = L.control.locate({
		    position: 'bottomright',
		    setView: 'always',
		    keepCurrentZoomLevel: false,
		    locateOptions: {
		    	enableHighAccuracy: true,
                maxZoom: 14,
                watch: true,   // if you overwrite this, visualization cannot be updated
                setView: false  // have to set this to false because we have to
                               // do setView manually
            }
		}).addTo(map);

		locator.start()

		</script>
		</body>
		</html>]]

	--This string is the text that will be written to our HTML file.

	------------------------
	--HTML FILE CREATION
	------------------------

	local htmlFile = io.open( path, "w" )
	htmlFile:write( mapString )
	io.close( htmlFile )
	--The above code writes our "mapString" variable to an HTML file and saves it in the Documents directory.

	-- print("the map was created")
end

-- Driver Info Map -------------------------------------------------------------- --

M.createDriverInfoMap = function(lat1, lon1, lat2, lon2)
	print("making driver info map")

	-- MAPBOX
	------------------------
	--REQUIRED VARIABLES
	------------------------

	local APIkey = "AIzaSyAj5D-S7WTwtU7h8ZKYAI3T_4n1r3zxHoM"
	local path = system.pathForFile( "driverinfomap.html", system.DocumentsDirectory )

	local lat1 = tostring(lat1)
	local lon1 = tostring(lon1)
	local lat2 = tostring(lat2)
	local lon2 = tostring(lon2)

	------------------------
	--HTML & JAVASCRIPT CODE
	------------------------

	local mapString = [[
		<html>
		<head>
		<meta charset=utf-8 />
		<title>A simple map</title>
		<meta name='viewport' content='initial-scale=1,maximum-scale=1,user-scalable=no' />
		<script src='https://api.mapbox.com/mapbox.js/v3.1.1/mapbox.js'></script>
		<script src='http://silver.tf/libraries/mb_directions.js'></script>
		<link href='https://api.mapbox.com/mapbox.js/v3.1.1/mapbox.css' rel='stylesheet' />
		<style>
		  body { margin:0; padding:0; }
		  #map { position:absolute; top:0; bottom:0; width:100%; }
		</style>
		</head>
		<body>

		<script src='https://api.mapbox.com/mapbox.js/plugins/leaflet-locatecontrol/v0.43.0/L.Control.Locate.min.js'></script>
		<link href='https://api.mapbox.com/mapbox.js/plugins/leaflet-locatecontrol/v0.43.0/L.Control.Locate.mapbox.css' rel='stylesheet' />
		<link href='https://api.mapbox.com/mapbox.js/plugins/leaflet-locatecontrol/v0.43.0/css/font-awesome.min.css' rel='stylesheet' />

		<div id='map'></div>
		<script>


        // ========================================================================================== //

		L.mapbox.accessToken = 'pk.eyJ1Ijoib2NoZWxzZXQiLCJhIjoiY2ltbmZqbXA4MDAxdXgza3E2OW44ZzZ2NyJ9.Kgl_Fc5Gu2QnpXcvL9UXRQ';

		// example origin and destination
		var start = {lat: ]]..lat1..[[, lon: ]]..lon1..[[};
		var finish = {lat: ]]..lat2..[[, lon: ]]..lon2..[[};

		var map = L.mapbox.map('map', 'mapbox.streets', {
		    zoomControl: false }).setView([]]..lat1..[[, ]]..lon1..[[], 9);

		// map.attributionControl.setPosition('bottomleft');
		var directions = L.mapbox.directions({
		    profile: 'mapbox.driving'
		});

		// Set the origin and destination for the direction and call the routing service
		directions.setOrigin(L.latLng(]]..lat1..[[, ]]..lon1..[[));
		directions.setDestination(L.latLng(]]..lat2..[[, ]]..lon2..[[));

		directions.query();

		var directionsLayer = L.mapbox.directions.layer(directions).addTo(map);
		var directionsRoutesControl = L.mapbox.directions.routesControl('routes', directions)
		    .addTo(map);

		// ========================================================================================== //

		L.control.locate().addTo(map);

		</script>
		</body>
		</html>]]

	--This string is the text that will be written to our HTML file.

	------------------------
	--HTML FILE CREATION
	------------------------

	local htmlFile = io.open( path, "w" )
	htmlFile:write( mapString )
	io.close( htmlFile )
	--The above code writes our "mapString" variable to an HTML file and saves it in the Documents directory.

	-- print("the map was created")
end

-- Passenger Map ----------------------------------------------------------- --

M.createPassengerMap = function(lat1, lon1, lat2, lon2, transport_id, accessToken)

	-- MAPBOX
	------------------------
	--REQUIRED VARIABLES
	------------------------

	local APIkey = "AIzaSyAj5D-S7WTwtU7h8ZKYAI3T_4n1r3zxHoM"
	local path = system.pathForFile( "passengermap.html", system.DocumentsDirectory )

	local lat1 = tostring(lat1)
	local lon1 = tostring(lon1)
	local lat2 = tostring(lat2)
	local lon2 = tostring(lon2)

	------------------------
	--HTML & JAVASCRIPT CODE
	------------------------

	local mapString = [[
    <html>
		<head>
		<meta charset=utf-8 />
		<title>passenger map</title>
		<meta name='viewport' content='initial-scale=1,maximum-scale=1,user-scalable=no' />
	    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
		<script src='https://api.mapbox.com/mapbox.js/v3.1.1/mapbox.js'></script>
		<script src='http://silver.tf/libraries/mb_directions.js'></script>
		<link href='https://api.mapbox.com/mapbox.js/v3.1.1/mapbox.css' rel='stylesheet' />
		<style>
		  body { margin:0; padding:0; }
		  #map { position:absolute; top:0; bottom:0; width:100%; }
		</style>
		</head>
		<body>
		<div id='map'></div>
		<script>

    // ========================================================================================== //

		L.mapbox.accessToken = 'pk.eyJ1Ijoib2NoZWxzZXQiLCJhIjoiY2ltbmZqbXA4MDAxdXgza3E2OW44ZzZ2NyJ9.Kgl_Fc5Gu2QnpXcvL9UXRQ';

		// example origin and destination
		var start = {lat: ]]..lat1..[[, lon: ]]..lon1..[[};
		var finish = {lat: ]]..lat2..[[, lon: ]]..lon2..[[};
		var driver = {lat: start.lat, lon: start.lon};

		var url = "https://api.sammevei.no/api/1/users/current/transports/]]..
		transport_id..
		[[/position"
        var authorization = "]]..accessToken..[["
	// ================================================================================================

		var map = L.mapbox.map('map', 'mapbox.streets', {
		     zoomControl: false }).setView([finish.lat, finish.lon], 9);

    var myLayer;
    var timerVar = setInterval(myTimer, 10000);
    var i = 0;

    var settings = {
      "async": true,
      "crossDomain": true,
      "url": url,
      "method": "GET",
      "headers": {
        "Authorization": authorization
      }
    }

	// ================================================================================================

         // DIRECTIONS ===================================================================== //
		 map.attributionControl.setPosition('bottomleft');
		 var directions = L.mapbox.directions({
	        profile: 'mapbox.driving'
		    });


		// Set the origin and destination for the direction and call the routing service
		directions.setOrigin(L.latLng(start.lat, start.lon)); // driver
		directions.setDestination(L.latLng(finish.lat, finish.lon)); // passenger

		// directions.query();

		// var directionsLayer = L.mapbox.directions.layer(directions).addTo(map);
		// var directionsRoutesControl = L.mapbox.directions.routesControl('routes', directions)
		//    .addTo(map);

	    // MOVE A CAR ON THE MAP =========================================================== //

	   function myTimer() {
        // get driver's position from server
        $.ajax(settings).done(function (response) {
          // console.log(response.position.coordinates[0]);
          // console.log(response.position.coordinates[1]);
          driver.lon = response.position.coordinates[0];
          driver.lat = response.position.coordinates[1];
        });

        console.log("great");

        var geojson = [
          {
            type: 'Feature',

            geometry: {
                type: 'Point',
                coordinates: [driver.lon, driver.lat] // lon, lat
            },

            properties: {
              'marker-color': '#00cc00',
              'marker-size': 'large',
              'marker-symbol': 'car'
            }

          }
        ];

        if (i > 0) {
            map.removeLayer(myLayer )
        }

        myLayer = L.mapbox.featureLayer().setGeoJSON(geojson).addTo(map);
        i++
    }

		// ========================================================================================== //

		</script>
		</body>
		</html>]]

	--This string is the text that will be written to the HTML file.

	------------------------
	--HTML FILE CREATION
	------------------------

	local htmlFile = io.open( path, "w" )
	htmlFile:write( mapString )
	io.close( htmlFile )

	--The above code writes our "mapString" variable to an HTML file and saves it in the Documents directory.
end

-- Reverse Table ----------------------------------------------------------- --

M.reverseTable = function (arr)
	local i, j = 1, #arr

	while i < j do
		arr[i], arr[j] = arr[j], arr[i]

		i = i + 1
		j = j - 1
	end
end


return M
