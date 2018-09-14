-- include
local appData = require( "misc.appData" )
local M = {}

-- Open FifeBase Token
M.openFirebaseToken = function() 
--     read data from disk ---------------------------------------------------------------		
	fileName = io.open( appData.firebaseFilePath, "r" )
	  
	if fileName then 
	  	-- read all contents of file into a string
	   	encodedData = fileName:read( "*a" )
	   	io.close( fileName )
	   
	  	-- decode data
	   	firebaseToken = appData.json.decode( encodedData )
	else
		return false
	end 

	return firebaseToken   	 
end	


-- Save FCM token
M.saveFirebaseToken = function(firebaseToken)

	-- encode table to json
    encodedData = appData.json.encode( firebaseToken )
    print("schedule saved")

	-- save data to disk, go to disclaimer
   fileName = io.open( appData.firebaseFilePath, "w" )
   
   if fileName then
      fileName:write( encodedData )
      io.close( fileName )
   else
      native.showAlert( "System Error!", "Reinstall SammeVei, please.", { "OK" } )
   end 

end

-- Store Config
M.openUser = function()
--     read data from disk ---------------------------------------------------------------		
	fileName = io.open( appData.userFilePath, "r" )
	  
	if fileName then 
	  	-- read all contents of file into a string
	   	encodedData = fileName:read( "*a" )
	   	io.close( fileName )
	   
	  	-- decode data
	   	appData.user = appData.json.decode( encodedData )
	else
		return false
	end 

-- return true if the user was already registered
	if (appData.user.id ~= nil) then
	  	return true
	else
	    return true
	end    	 
end

M.openAddresses = function()
	--     read data from disk ---------------------------------------------------------------		
	fileName = io.open( appData.addressesFilePath, "r" )
	  
	if fileName then 
	  	-- read all contents of file into a string
	   	encodedData = fileName:read( "*a" )
	   	io.close( fileName )
	   
	  	-- decode data
	   	appData.addresses = appData.json.decode( encodedData )
	   	print("HOME        "..appData.addresses.home.location)
	else
		return false
	end 

	-- return true if the user was already registered
	if (appData.addresses.home.location ~= "") then
	  	return true
	else
	    return false
	end 
end

M.openCar = function()
	fileName = io.open( appData.carFilePath, "r" )
	  
	if fileName then 
	  	-- read all contents of file into a string
	   	encodedData = fileName:read( "*a" )
	   	io.close( fileName )
	   
	  	-- decode data
	   	appData.car = appData.json.decode( encodedData )
	else
		return false
	end 

	-- return true if the user was already registered
	if (appData.car.color ~= "") then
	  	return true
	else
	    return false
	end 
end

M.openTransports = function()
 	--     read data from disk ---------------------------------------------------------------		
	fileName = io.open( appData.transportsFilePath, "r" )
	  
	if fileName then 
	  	-- read all contents of file into a string
	   	encodedData = fileName:read( "*a" )
	   	io.close( fileName )
	   
	  	-- decode data
	   	appData.transports = appData.json.decode( encodedData )

	   	return true
	else
		return false
	end 
end

M.openAddressList = function()
	 --     read data from disk ---------------------------------------------------------------		
	fileName = io.open( appData.addressListFilePath, "r" )
	  
	if fileName then 
	  	-- read all contents of file into a string
	   	encodedData = fileName:read( "*a" )
	   	io.close( fileName )
	   
	  	-- decode data
	   	appData.addressList = appData.json.decode( encodedData )

	   	return true
	else
		return false
	end 
end

-- ------------------------------------------------------------------------------------ --
-- SCHEDULE
-- ------------------------------------------------------------------------------------ --

-- Open Schedule
M.openSchedule = function()
	-- read data from disk ---------------------------------------------------------------		
	fileName = io.open( appData.scheduleFilePath, "r" )
	  
	if fileName then 
	  	-- read all contents of file into a string
	   	encodedData = fileName:read( "*a" )
	   	io.close( fileName )
	   
	  	-- decode data
	   	appData.schedule = appData.json.decode( encodedData )

	   	return true
	else
		return false
	end  	 
end

-- Create Schedule
local days = {"mon", "mon", "tue", "tue", "wed", "wed", "thu", "thu", "fri", "fri", "sat", "sat", "sun", "sun" }

M.createSchedule = function()
    print("-- ---------------------------------------------------- --")
    print("-- SETUP MODEL")
    print("-- ---------------------------------------------------- --")

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
		appData.schedule[i+1].from_address_id = appData.addresses.work.address_id
		appData.schedule[i+1].to_address_id = appData.addresses.home.address_id
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
    print("schedule saved")

	-- save data to disk, go to disclaimer
   fileName = io.open( appData.scheduleFilePath, "w" )
   
   if fileName then
      fileName:write( encodedData )
      io.close( fileName )
   else
      native.showAlert( "System Error!", "Reinstall SammeVei, please.", { "OK" } )
   end 
end

-- return
return M