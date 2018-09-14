-- include
local appData = require( "misc.appData" )
local M = {}

-- functions
M.resetVariables = function()
    -- Tokens
    appData.session = {accessToken = "", refreshToken = ""}
    appData.refreshTokenFilePath = system.pathForFile( "refreshToken.txt", system.DocumentsDirectory )

    -- User
    appData.user = {
        userName = "",
        passWord = "",
        firstName = "",
        middleName = "",
        lastName = "",
        country = "",
        phoneNumber = "",
        home = "",
        work = "",
        homeAddress = "",
        workAddress = "",
        id = "",
        userID = "",
        eMail = "",
        morningTime = "08:00",
        morningFlexibility = "900",
        afternoonTime = "16:00",
        afternoonFlexibility = "900", 
        mode = "passenger"
    }

    appData.userFilePath = system.pathForFile( "user.txt", system.DocumentsDirectory )

    -- Session
    appData.session = {accessToken = "", refreshToken = ""}

    -- Address
    appData.addresses = {
        home = {
              address="",
              address_id="1",
              country="NO",
              location="",
              name="",
              number="",
              place="",
              postcode="",
              region=""
        },

        work = {
              address="",
              address_id="1",
              country="NO",
              location="",
              name="",
              number="",
              place="",
              postcode="",
              region=""
        }
    }

    appData.addressesFilePath = system.pathForFile( "addresses.txt", system.DocumentsDirectory )

    appData.addressListFilePath = system.pathForFile( "addresslist.txt", system.DocumentsDirectory )

    appData.tempAddresses = {
        home = {
        location = "",
        address = "",
        postcode = "",
        place = "",
        region = "",
        country = "",
        address_id = "1"
        },

        work = {
        location = "",
        address = "",
        postcode = "",
        place = "",
        region = "",
        country = "",
        address_id = "2"
        }
    }

    -- Car
    appData.car = {
      license_plate = "",
      make = "",
      model = "",
      year = "2000",
      color = "",
      seats = "1",
      vehicle_type_id = "1",
      vehicle_engine_type_id = "2",
      vehicle_id = "",
      id = "0"
    }

    appData.carFilePath = system.pathForFile( "car.txt", system.DocumentsDirectory )

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

    appData.scheduleFilePath = system.pathForFile( "schedule.txt", system.DocumentsDirectory )

    -- Transport
    appData.transport = {
        id = "",
        user_id = "",
        route_id = "",
        vehicle_id = "",
        transport_id = "",
        transport_entity_type_id = "",
      mode = "passenger",
      from = "",
      to = "",
      ts = "",
      starting_at = "",
      eta = "",
      position = "",
      capacity = "1",
      flexibility = "",
      rate = "",
      currency = "NOK",
      created_at = "",
      updated_at = ""
    }

    -- time - all in UTC
    appData.time = {
      morning={
        now, 
        myDeparture, 
        myFlex, 
        otherDeparture, 
        otherFlex 
      },
      afternoon={
        now, 
        myDeparture, 
        myFlex, 
        otherDeparture, 
        otherFlex 
      }
    }

    -- location 
    appData.location = {
      morning={
        departure={ln, lt}, 
        destination={ln, lt}, 
        pick_up={ln, lt}
      },
      afternoon={
        departure={ln, lt}, 
        destination={ln, lt}, 
        pick_up={ln, lt}
      }
    }

    -- ready
    appData.ready = {user = false, addresses = false, schedule = false, transports = false, car = false}

    -- status
    appData.status = {morning="", afternoon=""}

    appData.transportFilePath = system.pathForFile( "transport.txt", system.DocumentsDirectory )

    appData.transports = {}

    appData.dummyTransports = {{},{},{},{},{},{},{},{},{},{},{},{},{},{}}

    appData.firebaseToken = ""
    appData.firebaseFilePath = system.pathForFile( "firebase.txt", system.DocumentsDirectory )

    appData.transportsFilePath = system.pathForFile( "transports.txt", system.DocumentsDirectory )

    appData.dummyTransportsFilePath = system.pathForFile( "dummyTransports.txt", system.DocumentsDirectory )

    appData.match = {morning = {}, afternoon = {}, tomorrowMorning = {}, tomorrowAfternoon = {}}

    appData.matchFilePath = system.pathForFile( "match.txt", system.DocumentsDirectory )

    print(appData.user.userName)

    -- Hide Status Bar
    display.setStatusBar( display.HiddenStatusBar )

    -- --------------------------------------------------------------------------------------
    -- LOCATION
    -- --------------------------------------------------------------------------------------

    appData.myLocation = {lt = "59.95", ln = "10.75"}
    appData.myDirection = "0"
    appData.mySpeed = "0"  
end  

M.defineUser = function(userName, passWord)

  appData.user.userName = userName
  appData.user.passWord = passWord
  appData.user.eMail = userName           
end

M.addNames = function(firstName, middleName, lastName)
  appData.user.firstName = firstName
  appData.user.middleName = middleName
  appData.user.lastName = lastName            
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

-- Update Car
M.updateCar1 = function(factory, model)
    appData.car.make = factory
    appData.car.model = model
    print("car updated: "..appData.car.make)
    print("car updated: "..appData.car.model)
end

M.updateCar2 = function(color, plate)
    appData.car.color = color
    appData.car.license_plate = plate
    print("color updated: "..appData.car.color)
    print("plate updated: "..appData.car.license_plate)
end

M.updateCar3 = function(engineType)
    appData.car.vehicle_engine_type_id = engineType
end

-- Update CarID
M.updateCarID = function(vehicle_id )
  appData.car.vehicle_id = vehicle_id
end

-- Save Car
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

-- -----------------------------------------------------------------------------
-- ADDRESES
-- -----------------------------------------------------------------------------

-- Adjust addresses 
M.adjustAddresses = function()
  print("-------- adjusting -------")
  appData.addressList[1] = appData.addresses.home
  appData.addressList[2] = appData.addresses.work
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

-- Save Address List
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
    -- ----------------------------------------------------
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
  print("updating id -------------------------")
    if (location == "from") then

        appData.tempAddresses.home.address_id = tostring(id)
        print("home updated 1: "..appData.addresses.home.address_id)
        appData.addresses.home.address_id = tostring(id)
        print("home updated 2: "..appData.addresses.home.address_id)        

        -- update addressList
        table.insert(appData.addressList, appData.tempAddresses.home)

    elseif (location == "to") then  

        appData.tempAddresses.work.address_id = tostring(id)
        print("work updated 1: "..appData.addresses.work.address_id)
        appData.addresses.work.address_id = tostring(id)
        print("work updated 2: "..appData.addresses.work.address_id)

        -- update addressList
        table.insert(appData.addressList, appData.tempAddresses.work) 
    end 

    -- --------------------------------------------------------------

    if (location == "from") then

    elseif (location == "to") then  

    end 

    -- save addressList
    M.saveAddressList()

    -- Save Addresses
    M.saveAddresses()   
end

-- -----------------------------------------------------------------------------
-- SCHEDULE
-- -----------------------------------------------------------------------------
M.updateSchedule = function()
  for i=1, #appData.schedule, 2 do

        if appData.schedule[i].is_enabled == false then

            print("------------------------------- this is i: "..i)
            
              -- morning
            if appData.tempAddresses.home.address_id ~= "1" and appData.tempAddresses.home.address_id ~= "2" then
              appData.schedule[i].from_address_id = tostring(appData.tempAddresses.home.address_id)
            end  

            if appData.tempAddresses.work.address_id ~= "1" and appData.tempAddresses.work.address_id ~= "2" then
              appData.schedule[i].to_address_id = tostring(appData.tempAddresses.work.address_id)
            end
      
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
      
      if appData.tempAddresses.work.address_id ~= "1" and appData.tempAddresses.work.address_id ~= "2" then
        appData.schedule[i+1].from_address_id = tostring(appData.tempAddresses.work.address_id)
      end  

      if appData.tempAddresses.home.address_id ~= "1" and appData.tempAddresses.home.address_id ~= "2" then
        appData.schedule[i+1].to_address_id = tostring(appData.tempAddresses.home.address_id)
      end
      
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