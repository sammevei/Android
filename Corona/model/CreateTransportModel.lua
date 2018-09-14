local appData = require( "misc.appData" )
local M = {}

-- -----------------------------------------------------------------------------
-- SCHEDULE
-- -----------------------------------------------------------------------------


-- Create Schedule
local days = {"mon", "mon", "tue", "tue", "wed", "wed", "thu", "thu", "fri", "fri", "sat", "sat", "sun", "sun" }

M.createSchedule = function()
    print("-- ---------------------------------------------------- --")
    print("-- SCHEDULE MODEL")
    print("-- ---------------------------------------------------- --")

	-- Schedule: Array for 7 days, morning + afternoon
	appData.schedule = 
	{
		{
			day = "mon",
			id = "",
			user_id = "",
			from_address_id = "",
			to_address_id = "",
			time_offset = "",
			time_flex = "15",
			mode = "1",
			is_enabled = false,	
			created_at="",    
			updated_at=""
		},
			
		{
			day = "mon",
			id = "",
			user_id = "",
			from_address_id = "",
			to_address_id = "",
			time_offset = "",
			time_flex = "15",
			mode = "1",
			is_enabled = false,	
			created_at="",    
			updated_at=""
		},

		{
			day = "tue",
			id = "",
			user_id = "",
			from_address_id = "",
			to_address_id = "",
			time_offset = "",
			time_flex = "15",
			mode = "1",
			is_enabled = false,	
			created_at="",    
			updated_at=""
		},
			
		{
			day = "tue",
			id = "",
			user_id = "",
			from_address_id = "",
			to_address_id = "",
			time_offset = "",
			time_flex = "15",
			mode = "1",
			is_enabled = false,	
			created_at="",    
			updated_at=""
		},	

		{
			day = "wed",
			id = "",
			user_id = "",
			from_address_id = "",
			to_address_id = "",
			time_offset = "",
			time_flex = "15",
			mode = "1",
			is_enabled = false,	
			created_at="",    
			updated_at=""
		},
			
		{
			day = "wed",
			id = "",
			user_id = "",
			from_address_id = "",
			to_address_id = "",
			time_offset = "",
			time_flex = "15",
			mode = "1",
			is_enabled = false,	
			created_at="",    
			updated_at=""
		},	

		{
			day = "thu",
			id = "",
			user_id = "",
			from_address_id = "",
			to_address_id = "",
			time_offset = "",
			time_flex = "15",
			mode = "1",
			is_enabled = false,	
			created_at="",    
			updated_at=""
		},
			
		{
			day = "thu",
			id = "",
			user_id = "",
			from_address_id = "",
			to_address_id = "",
			time_offset = "",
			time_flex = "15",
			mode = "1",
			is_enabled = false,	
			created_at="",    
			updated_at=""
		},

		{
			day = "fri",
			id = "",
			user_id = "",
			from_address_id = "",
			to_address_id = "",
			time_offset = "",
			time_flex = "15",
			mode = "1",
			is_enabled = false,	
			created_at="",    
			updated_at=""
		},
			
		{
			day = "fri",
			id = "",
			user_id = "",
			from_address_id = "",
			to_address_id = "",
			time_offset = "",
			time_flex = "15",
			mode = "1",
			is_enabled = false,	
			created_at="",    
			updated_at=""
		},

		{
			day = "sat",
			id = "",
			user_id = "",
			from_address_id = "",
			to_address_id = "",
			time_offset = "",
			time_flex = "15",
			mode = "1",
			is_enabled = false,	
			created_at="",    
			updated_at=""
		},
			
		{
			day = "sat",
			id = "",
			user_id = "",
			from_address_id = "",
			to_address_id = "",
			time_offset = "",
			time_flex = "15",
			mode = "1",
			is_enabled = false,	
			created_at="",    
			updated_at=""
		},	

		{
			day = "sun",
			id = "",
			user_id = "",
			from_address_id = "",
			to_address_id = "",
			time_offset = "",
			time_flex = "15",
			mode = "1",
			is_enabled = false,	
			created_at="",    
			updated_at=""
		},
			
		{
			day = "sun",
			id = "",
			user_id = "",
			from_address_id = "",
			to_address_id = "",
			time_offset = "",
			time_flex = "15",
			mode = "1",
			is_enabled = false,	
			created_at="",    
			updated_at=""
		}			
	}  

	print(#appData.schedule)  

	for i=1, #appData.schedule, 2 do

		print("------------------------------- this is i: "..i)

	    -- morning
	    appData.schedule[i].day = days[i]
		appData.schedule[i].from_address_id = appData.addresses.home.address_id
		appData.schedule[i].to_address_id = appData.addresses.work.address_id
		appData.schedule[i].time_offset = appData.user.morningTime
		appData.schedule[i].time_flex = appData.user.morningFlexibility

		if appData.user.mode == "passenger" then
			appData.schedule[i].mode = "1"
	    elseif appData.user.mode == "driver" then
	    	appData.schedule[i].mode = "2"
	    elseif appData.user.mode == "both" then
			appData.schedule[i].mode = "3"
		end	  

		appData.schedule[i].is_enabled = false

        print("------------------------------- this is i: "..i+1)

		-- afternoon
		appData.schedule[i+1].day = days[i+1]
		appData.schedule[i+1].from_address_id = appData.addresses.home.address_id
		appData.schedule[i+1].to_address_id = appData.addresses.work.address_id
		appData.schedule[i+1].time_offset = appData.user.afternoonTime
		appData.schedule[i+1].time_flex = appData.user.afternoonFlexibility

		if appData.user.mode == "passenger" then
			appData.schedule[i+1].mode = "1"
	    elseif appData.user.mode == "driver" then
	    	appData.schedule[i+1].mode = "2"
	    elseif appData.user.mode == "driver" then
			appData.schedule[i+1].mode = "3"
		end	  
		  			
		appData.schedule[i+1].is_enabled = false
	end	
end

-- Sort Schedule
local compare = function( a, b )
	return a.id < b.id
end


M.sortSchedule = function(schedule)
    print("sorting")

   	-- create temp schedule aray
   	tempSchedule = {{}, {}, {}, {}, {}, {}, {}}
   
   	-- fill in the temp schedule
   	for i=1, #schedule do
 		if (schedule[i].day) == "mon" then
        	table.insert( tempSchedule[1], schedule[i] )
        end	
	end

   	for i=1, #schedule do
 		if (schedule[i].day) == "tue" then
        	table.insert( tempSchedule[2], schedule[i] )
        end
	end

	for i=1, #schedule do
 		if (schedule[i].day) == "wed" then
        	table.insert( tempSchedule[3], schedule[i] )
        end	
	end

	for i=1, #schedule do
 		if (schedule[i].day) == "thu" then
        	table.insert( tempSchedule[4], schedule[i] )
        end	
	end

	for i=1, #schedule do
 		if (schedule[i].day) == "fri" then
        	table.insert( tempSchedule[5], schedule[i] )
        end	
	end

	for i=1, #schedule do
 		if (schedule[i].day) == "sat" then
        	table.insert( tempSchedule[6], schedule[i] )
        end	
	end

	for i=1, #schedule do
 		if (schedule[i].day) == "sun" then
        	table.insert( tempSchedule[7], schedule[i] )
        end	
	end

   	-- sort days
    for i=1, #tempSchedule do 
	    if (tonumber(tempSchedule[i][1].time_offset) > tonumber(tempSchedule[i][2].time_offset) ) then
	    	local temp = tempSchedule[i][1]
	    	tempSchedule[i][1] = tempSchedule[i][2]
	    	tempSchedule[i][2] = temp
	    end	
	end


   	-- fill in the schedule

   	local scheduleIndex = 1

   	for i=1, #tempSchedule do
	   	schedule[scheduleIndex] =  tempSchedule[i][1]
	   	scheduleIndex = scheduleIndex + 1
	   	schedule[scheduleIndex] =  tempSchedule[i][2]
	   	scheduleIndex = scheduleIndex + 1
   	end	

   	-- Adjust to Calendar
    local s = 0

    if (os.date( "%a" ) == "Mon") then s = 6 
    elseif (os.date( "%a" ) == "Tue") then s = 5 
    elseif (os.date( "%a" ) == "Wed") then s = 4 
    elseif (os.date( "%a" ) == "Thu") then s = 3 
    elseif (os.date( "%a" ) == "Fri") then s = 2 
    elseif (os.date( "%a" ) == "Sat") then s = 1 
    elseif (os.date( "%a" ) == "Sun") then s = 0     
    end

    for i = 1, s do
        table.insert( appData.schedule, 1, appData.schedule[#appData.schedule] )
        table.remove( appData.schedule, #appData.schedule )
        table.insert( appData.schedule, 1, appData.schedule[#appData.schedule] )
        table.remove( appData.schedule, #appData.schedule )
    end


	
    -- return schedule
	return schedule
end

-- Save Schedule
M.saveSchedule = function(schedule)

	-- encode table to json
    encodedData = appData.json.encode( schedule )
    print("- - - - - - - - - - - - - - - - - - - - - - - - schedule saved")

	-- save data to disk, go to disclaimer
   fileName = io.open( appData.scheduleFilePath, "w" )
   
   if fileName then
      fileName:write( encodedData )
      io.close( fileName )
   else
      native.showAlert( "System Error!", "Reinstall SammeVei, please.", { "OK" } )
   end 
end

M.updateSchedule = function()
	for i=1, #appData.schedule, 2 do

        if appData.schedule[i].is_enabled == false then

            print("------------------------------- this is i: "..i)
            
		    -- morning
			appData.schedule[i].from_address_id = tostring(appData.addresses.home.address_id)
			appData.schedule[i].to_address_id = tostring(appData.addresses.work.address_id)
			
            local h = tonumber(string.sub(appData.user.morningTime, 1, 2))
            local m = tonumber(string.sub(appData.user.morningTime, 4, 5))
            local offset = h*60 + m
            offset = tostring(offset)
			appData.schedule[i].time_offset = offset
			appData.schedule[i].time_flex = tostring(tonumber(appData.user.morningFlexibility)/60)

            
			if appData.user.mode == "passenger" then
				appData.schedule[i].mode = 1
		    elseif appData.user.mode == "driver" then
		    	appData.schedule[i].mode = 2
		    elseif appData.user.mode == "both" then
				appData.schedule[i].mode = 3
			end
			
	    end			  

		-- afternoon
		if appData.schedule[i+1].is_enabled == false then

			print("------------------------------- this is i: "..i+1)
			
			appData.schedule[i+1].from_address_id = tostring(appData.addresses.work.address_id)
			appData.schedule[i+1].to_address_id = tostring(appData.addresses.home.address_id)
			
			local h = tonumber(string.sub(appData.user.afternoonTime, 1, 2))
	        local m = tonumber(string.sub(appData.user.afternoonTime, 4, 5))
	        local offset = h*60 + m
	        offset = tostring(offset)
			appData.schedule[i+1].time_offset = offset
			appData.schedule[i+1].time_flex = tostring(tonumber(appData.user.afternoonFlexibility)/60)
			
			if appData.user.mode == "passenger" then
				appData.schedule[i+1].mode = 1
		    elseif appData.user.mode == "driver" then
		    	appData.schedule[i+1].mode = 2
		    elseif appData.user.mode == "driver" then
				appData.schedule[i+1].mode = 3
			end

		end			  	  			
	end		
end	

-- -----------------------------------------------------------------------------
-- TIME
-- -----------------------------------------------------------------------------
M.UTCtoLocal = function(utcTime)

    -- disassemble the UTC string 2018-02-18T15:00:00+00:00
    local y = string.sub(utcTime, 1, 4)
    local m = string.sub(utcTime, 6, 7)
    local d = string.sub(utcTime, 9, 10)
    local h = string.sub(utcTime, 12, 13)
    local s = tonumber(string.sub(utcTime, 15, 16))*60

    -- change timezone
	local shift = tonumber(os.date("%z"))/100
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

-- Calculate UTC
M.calculateUTC = function(dayShift)

	-- Translate days to seconds
	dayShift = dayShift * 60*60*24 

	-- Define today's midnight
	local y = os.date("%Y")
	local m = os.date("%m")
	local d = os.date("%d")

	-- Calculate today's midnight in secs
	local time1 = os.time {
		year = y, 
		month = m, 
		day = d, 
		hour = 0, 
		sec = 0
	}

	-- Calculate difference between actual timezone and UTC
	local difference = 36 * os.date("%z")

	-- Calculate today's midnight in UTC
	time1 = time1 - difference

	-- Add day shift
	time1 = time1 + dayShift
	
	-- Add trip time // to improve later
	local time_offset
    time_offset = 480

	time_offset = time_offset*60 -- translate minutes to seconds
	time1 = time1 + time_offset

	-- Assemble UTC
	local y = os.date("%Y", time1)
	local m = os.date("%m", time1)
	local d = os.date("%d", time1)
	local h = os.date("%H", time1)
	local min = os.date("%M", time1)
	local s = 60*os.date("%M", time1)

	utcTime = y.."-"..m.."-"..d.."T"..h..":"..min..":".."00.000Z"

	-- Return UTC time as string
	return utcTime
end

-- Calculate UTC
M.calculateTransportUTC = function(dayShift, dayPart, i)

	-- print("========================CALCULATING TransportUTC =================================")

	-- Translate days to seconds
	dayShift = dayShift * 60*60*24 

	-- Define today's midnight
	local y = os.date("%Y")
	local m = os.date("%m")
	local d = os.date("%d")

	-- Calculate today's midnight in secs
	local time1 = os.time {
		year = y, 
		month = m, 
		day = d, 
		hour = 0, 
		sec = 0
	}

	-- Calculate difference between actual timezone and UTC
	local difference = 36 * os.date("%z")

	-- Calculate today's midnight in UTC
	time1 = time1 - difference

	-- Add day shift
	time1 = time1 + dayShift
	
	-- Add trip time
	local time_offset

	time_offset = tonumber(appData.schedule[i].time_offset)

	time_offset = time_offset*60 -- translate minutes to seconds
	time1 = time1 + time_offset

	-- Assemble UTC
	local y = os.date("%Y", time1)
	local m = os.date("%m", time1)
	local d = os.date("%d", time1)
	local h = os.date("%H", time1)
	local min = os.date("%M", time1)
	local s = 60*os.date("%M", time1)

	utcTime = y.."-"..m.."-"..d.."T"..h..":"..min..":".."00.000Z"

	-- Return UTC time as string
	return utcTime
end

-- Calculate UTC
M.calculateChangedTransportUTC = function(dayShift, dayPart, time_offset)


	print("========================CALCULATING Changed Transport UTC =================================")
    print(time_offset)

    time_offset = tonumber(time_offset)

	-- Translate days to seconds
	dayShift = dayShift * 60*60*24 

	-- Define today's midnight
	local y = os.date("%Y")
	local m = os.date("%m")
	local d = os.date("%d")

	-- Calculate today's midnight in secs
	local time1 = os.time {
		year = y, 
		month = m, 
		day = d, 
		hour = 0, 
		sec = 0
	}

	-- Calculate difference between actual timezone and UTC
	local difference = 36 * os.date("%z")

	-- Calculate today's midnight in UTC
	time1 = time1 - difference

	-- Add day shift
	time1 = time1 + dayShift

	time_offset = time_offset*60 -- translate minutes to seconds
	time1 = time1 + time_offset

	-- Assemble UTC
	local y = os.date("%Y", time1)
	local m = os.date("%m", time1)
	local d = os.date("%d", time1)
	local h = os.date("%H", time1)
	local min = os.date("%M", time1)
	local s = 60*os.date("%M", time1)

	utcTime = y.."-"..m.."-"..d.."T"..h..":"..min..":".."00.000Z"

	-- Return UTC time as string
	print(utcTime)
	return utcTime
end

-- -----------------------------------------------------------------------------
-- TRANSPORTS
-- -----------------------------------------------------------------------------

-- Update Transports
M.updateTransports = function(json)
    -- decode json
	downloadedTransport = appData.json.decode(json)

    -- update transport table
	appData.transport.id = downloadedTransport.id
    appData.transport.user_id = downloadedTransport.user_id
    appData.transport.route_id = downloadedTransport.route_id
    appData.transport.vehicle_id = downloadedTransport.vehicle_id
    appData.transport.transport_id = downloadedTransport.transport_id
    appData.transport.transport_entity_type_id = downloadedTransport.transport_entity_type_id
	appData.transport.mode = "passenger"
	appData.transport.from = ""
	appData.transport.to = ""
	appData.transport.ts = ""
	appData.transport.starting_at = downloadedTransport.starting_at
	appData.transport.eta = downloadedTransport.eta
	appData.transport.position = downloadedTransport.position
	appData.transport.capacity = "1"
	appData.transport.flexibility = downloadedTransport.flexibility
	appData.transport.rate = downloadedTransport.rate
	appData.transport.currency = downloadedTransport.currency
	appData.transport.created_at = downloadedTransport.created_at
	appData.transport.updated_at = downloadedTransport.updated_at

	-- update transports table
	-- table.insert( appData.transports, appData.transport )
end

-- Save Transport
M.saveTransports = function()
	-- encode table to json
    encodedData = appData.json.encode( appData.transport )
    print("transport saved")

	-- save data to disk, go to disclaimer
   fileName = io.open( appData.transportFilePath, "w" )
   
   if fileName then
      fileName:write( encodedData )
      io.close( fileName )
   else
      native.showAlert( "System Error!", "Reinstall SammeVei, please.", { "OK" } )
   end 


   	-- encode table to json
    encodedData = appData.json.encode( appData.transports )
    print("transports saved")

	-- save data to disk, go to disclaimer
   fileName = io.open( appData.transportsFilePath, "w" )
   
   if fileName then
      fileName:write( encodedData )
      io.close( fileName )
   else
      native.showAlert( "System Error!", "Reinstall SammeVei, please.", { "OK" } )
   end 
end

-- Save Match
M.saveMatch = function(match)

	-- encode table to json
    encodedData = appData.json.encode( match )
    
    print("match saved")

	-- save data to disk, go to disclaimer
   fileName = io.open( appData.matchFilePath, "w" )
   
   if fileName then
      fileName:write( encodedData )
      io.close( fileName )
   else
      native.showAlert( "System Error!", "Reinstall SammeVei, please.", { "OK" } )
   end 
end

-- -----------------------------------------------------------------------------
-- ADDRESES
-- -----------------------------------------------------------------------------

-- Adjust addresses 
M.adjustAddresses = function()
	print("-------- adjusting -------")
	appData.addressList[1] = appData.addresses.home
	appData.addressList[2] = appData.addresses.work
end

-- Save Transport
M.saveAddressList = function()
	-- encode table to json
    encodedData = appData.json.encode( appData.addressList )
    print("addressList saved")

	-- save data to disk, go to disclaimer
   fileName = io.open( appData.addressListFilePath, "w" )
   
   if fileName then
      fileName:write( encodedData )
      io.close( fileName )
   else
      native.showAlert( "System Error!", "Reinstall SammeVei, please.", { "OK" } )
   end 
end

-- Update Addresses
M.updateAdresses = function(location, lat, lon, address)
   print("updating addresses -------------------------")
   

    if (location == "from") then
        appData.tempAddresses.home.location = lon..","..lat
        appData.tempAddresses.home.address = address
    elseif (location == "to") then  
        appData.tempAddresses.work.location = lon..","..lat
        appData.tempAddresses.work.address = address

        
    end 
end

-- updateAddressID
M.updateAdressID = function(location, id)
	print("updating id ------------------------- ------------------------- -------------------------")
    if (location == "from") then

        appData.tempAddresses.home.address_id = tostring(id)
        print("home updated: "..appData.addresses.home.address_id)

        -- from address id in schedule
        -- appData.schedule[appData.i].from_address_id = id

        -- update addressList
        table.insert(appData.addressList, appData.tempAddresses.home)

    elseif (location == "to") then  

        appData.tempAddresses.work.address_id = tostring(id)
        print("work updated: "..appData.addresses.work.address_id)

        -- to address id in schedule
        -- appData.schedule[appData.i].to_address_id = id

        -- update addressList
        table.insert(appData.addressList, appData.tempAddresses.work) 
    end 

    -- save addressList
    M.saveAddressList()

    -- Save Schedule
    -- M.saveSchedule()   
end


-- -----------------------------------------------------------------------------
-- DUMMY TRANSPORTS
-- -----------------------------------------------------------------------------

local dayPart = "a"
local dayShift
local utcTime

M.createDummyTransports = function()
	for i=1, #appData.schedule, 1 do

        --- calculate UTC
        local integralPart, fractionalPart = math.modf( (i+1)/2 )
        local dayPart 
        local dayShift = integralPart

        if fractionalPart == 0 then dayPart = "m" end
        if fractionalPart > 0 then dayPart = "a" end

        -- print("Days Shift  = "..dayShift)
        -- print("Day Part  = "..dayPart)
        -- print("i  = "..i)

        local utcTime = M.calculateTransportUTC(dayShift, dayPart, i) 
        -- print(utcTime.." ===============")
        -- print(dayPart.." ===============")

        -- adjust addresses
	    local from_address 
		local from_location
	    local to_address 
		local to_location

        if dayPart == "m" then 
	        from_address = appData.addresses.home.name 
		    from_location = appData.addresses.home.location 
	        to_address = appData.addresses.work.name 
		    to_location = appData.addresses.work.location 
	    elseif dayPart == "a" then
	        from_address = appData.addresses.work.name  
		    from_location = appData.addresses.work.location 
	        to_address = appData.addresses.home.name 
		    to_location = appData.addresses.home.location 
	    end 

        -- print(from_address.." ===============")

		-- create transport
		-- print("-------- creating dummy transport -------- :"..i)

		appData.dummyTransports[i] = {
	         available = "1",
	         created_at =  "",
	         currency =  "NOK",
	         eta =  "",
	         event = "null",
	         flexibility =  tostring(tonumber(appData.schedule[i].time_flex)*60),
	         matches = {},
	         owner = { 
	             firstname = appData.user.firstName,
	             id = appData.user.id,
	             user_id = appData.user.userID 
	        },
	         position = {
	             coordinates = { "10.7636079, 59.9190099"},
	             type =  "Point" 
	        },
	         rate = "0",
	         route = {
	             distance = "",
	             duration = "",
	             from_address =  from_address,
	             from_location = {
	                 coordinates = {from_location},
	                 type =  "Point" 
	            },
	             id = "14159",
	             to_address =  to_address,
	             to_location = {
	                 coordinates = {to_location},
	                 type =  "Point" 
	            }
	        },
	         route_id =  "",
	         starting_at =  utcTime,
	         status = "null",
	         transport_id =  "",
	         updated_at =  "",
	         user_id =  appData.user.id,
	         vehicle = {}
	    }

	    if appData.user.mode == "passenger" then
	    	appData.dummyTransports[i].vehicle.id = "0"
	    else
	    	appData.dummyTransports[i].vehicle.id = "9"
	    end 	

	    -- Save Dummy Transports --------------------------------------
	    -- encode table to json
	    encodedData = appData.json.encode( appData.dummyTransports )
	    -- print("- - - - - - - - - - - - - - - - - - - - - - - - dummy transporsts saved")

		-- save data to disk, go to disclaimer
	   fileName = io.open( appData.dummyTransportsFilePath, "w" )
	   
	   if fileName then
	      fileName:write( encodedData )
	      io.close( fileName )
	   else
	      native.showAlert( "System Error!", "Reinstall SammeVei, please.", { "OK" } )
	   end 
    end		
end


-- Update Transports ===========================================================

M.updateDummyTransports = function()



    -- print(" - - - - - - - - - - - - updating transports 1")
	for i=1, #appData.dummyTransports, 1 do
        -- print(" - - - - - - - - - - - - updating transports 2")

        local date_original
        local day_original
        local hour_original
        
        local date_downloaded 
        local day_downloaded        
        local hour_downloaded

        local dayPart = "m"

        date_original = M.UTCtoLocal(appData.dummyTransports[i].starting_at)
	    day_original = tonumber(date_original.day)
	    hour_original = tonumber(date_original.hour)

	    for j=1, #appData.transports, 1 do
	    	-- print(" - - - - - - - - - - - - updating transports 3")
	    	date_downloaded = M.UTCtoLocal(appData.transports[j].starting_at)
	    	day_downloaded = tonumber(date_downloaded.day)
	    	hour_downloaded = tonumber(date_downloaded.hour)

            -- print("day_original ------------ "..day_original)
            -- print("day_downloaded ------------ "..day_downloaded)

	    	if day_original == day_downloaded 
	    		and hour_original <= 12 
	    		and hour_downloaded <= 12 then

	    		-- print("======================== THESE TRANSPORTS ARE MORNING EQUAL! "..i.." - "..j)
                -- appData.dummyTransports[i] = appData.transports[j]
                table.remove(appData.dummyTransports, i)
                table.insert(appData.dummyTransports, i, appData.transports[j])
                -- print("======================== THESE TRANSPORTS WERE UPDATED! "..i.." - "..j)
	        end	

	    	if day_original == day_downloaded 
	    		and hour_original > 12 
	    		and hour_downloaded > 12 then

	    		-- print("======================== THESE TRANSPORTS ARE AFTERNOON EQUAL! "..i.." - "..j)
                -- appData.dummyTransports[i] = appData.transports[j]
                table.remove(appData.dummyTransports, i)
                table.insert(appData.dummyTransports, i, appData.transports[j])
                -- print("======================== THESE TRANSPORTS WERE UPDATED! "..i.." - "..j)
	        end	
	    end 	
	end

	-- Save Dummy Transports --------------------------------------
    -- encode table to json
    encodedData = appData.json.encode( appData.dummyTransports )
    -- print("- - - - - - - - - - - - - - - - - - - - - - - - dummy transports saved")

	-- save data to disk, go to disclaimer
   fileName = io.open( appData.dummyTransportsFilePath, "w" )
   
   if fileName then
      fileName:write( encodedData )
      io.close( fileName )
   else
      native.showAlert( "System Error!", "Reinstall SammeVei, please.", { "OK" } )
   end 
   	
end

-- -----------------------------------------------------------------------------
-- UTILITIES
-- -----------------------------------------------------------------------------

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