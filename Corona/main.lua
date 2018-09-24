---------------------------------------------------------------------------------
--
-- main.lua
--
---------------------------------------------------------------------------------

-- compile with no.sammevei.app

local appData = require( "misc.appData" ) 

-- NOTIFICATIONS ------------------------------------------------------------------- --
if ( system.getInfo( "environment" ) == "simulator" ) then
	appData.useNotifications = false
else	
	appData.useNotifications = true
end	

appData.developerMode = false
-- ---------------------------------------------------------------------------- --

if appData.useNotifications == true then
	appData.notifications = require( "plugin.notifications.v2" )	
end	

appData.composer = require( "composer" )
appData.json = require( "json")
appData.widget = require( "widget")
routines = require( "misc.appRoutines" )

-- Transition setup
appData.composer.effectList.slideLeft.from.transition = easing.inSine
appData.composer.effectList.slideLeft.to.transition = easing.outSine
appData.composer.effectList.slideRight.from.transition = easing.inSine
appData.composer.effectList.slideRight.to.transition = easing.outSine

appData.transitionOptions = {effect = "slideLeft", time = 350,}
appData.transitionLeftOptions = {effect = "slideLeft", time = 350,}
appData.transitionRightOptions = {effect = "slideRight", time = 350,}

-- Google Places Setup
appData.googlePlaces={}
-- appData.googlePlaces.APIkey = "AIzaSyCkdPmEA7DmIczfNLdQG7panWEUqMJsExI"
appData.googlePlaces.APIkey = "AIzaSyCzZYfHU1o5-ntg0UdYoEei7nBnyDaVORY"

-- App System Variables
appData.system = {}
appData.system.appVersion = system.getInfo( "appVersionString" ) 
appData.system.appBuild = system.getInfo( "build" ) 
appData.system.phoneType = "android"
appData.system.userLocale = "nb_NO"
appData.system.userTimezone = "Europe/Oslo"
appData.system.phoneModel = system.getInfo( "model" ) 
appData.system.osName = "Android" 
appData.system.osVersion = system.getInfo( "platformVersion" )

-- App Setup Sizes
appData.screenW = display.contentWidth - (display.screenOriginX  * 2)
appData.screenH = display.contentHeight - (display.screenOriginY * 2)
appData.contentW = display.contentWidth
appData.contentH = display.contentHeight
appData.margin = 7 
appData.actionMargin = 15
appData.actionCorner = 5

-- App Setup Colors
appData.colors = {
	background={0, 0, 0, 1},
	confirmButtonFillDefault={0.141, 0.141, 0.211, 0.1}, 
	confirmButtonFillOver={0.141, 0.141, 0.211, 0.1},
	confirmButtonLabelDefault={1, 1, 1, 1},
	confirmButtonLabelOver={1, 1, 1, 0.9},
	cancelButtonFillDefault={0.6, 0, 0, 1}, 
	cancelButtonFillOver={0.8, 0, 0, 1},
	cancelButtonLabelDefault={1, 1, 1, 1},
	cancelButtonLabelOver={1, 1, 1, 1},
	infoButtonFillDefault={0.078, 0.321, 0.89, 1}, 
	infoButtonFillOver={0.078, 0.321, 0.89, 1},
	infoButtonLabelDefault={1, 1, 1, 1},
	infoButtonLabelOver={1, 1, 1, 1},
	actionBackground={0.1, 0.1, 0.1, 1}, 
	actionText={1, 1, 1, 1},
	statusText={0.015, 0.831, 0.388, 1},
	actionComment={0.7, 0.7, 0.7, 1},
	fieldText={0, 0, 0},
	divisionLine={0, 0, 0}, 
	transportBackground={0.2, 0.2, 0.2, 1},
	infoBackround={1, 1, 1, 1},
	infoText={0, 0, 0} 
}

-- App Setup Fonts
appData.fonts = {
	-- actionText = native.newFont( "AvenirNext-Regular.ttf", 12 ),
	-- actionComment = native.newFont( "AvenirNext-Regular.ttf", 12 ), 
	-- titleText = native.newFont( "AvenirNext-Regular.ttf", 17 ),
	-- titleTextBold = native.newFont( "AvenirNext-Regular.ttf", 17 ) 

	actionText = native.newFont( "native.systemFont", 12 ),
	actionComment = native.newFont( "native.systemFont", 12 ), 
	titleText = native.newFont( "native.systemFont", 17 ),
	titleTextBold = native.newFont( "native.systemFont", 17 )  
}

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

appData.mode = ""

appData.userFilePath = system.pathForFile( "user.txt", system.DocumentsDirectory )

-- Session
appData.session = {accessToken = "", refreshToken = ""}
appData.firstSession = false

-- Address
appData.addresses = {
		home = {
	        address="",
	        address_id="1",
	        country="NO",
	        location="0,0",
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
	        location="0,0",
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

appData.refreshTable = false

appData.dummyTransports = {{},{},{},{},{},{},{},{},{},{},{},{},{},{}}

appData.firebaseToken = ""
appData.firebaseFilePath = system.pathForFile( "firebase.txt", system.DocumentsDirectory )

appData.transportsFilePath = system.pathForFile( "transports.txt", system.DocumentsDirectory )

appData.dummyTransportsFilePath = system.pathForFile( "dummyTransports.txt", system.DocumentsDirectory )

appData.match = {morning = {}, afternoon = {}, tomorrowMorning = {}, tomorrowAfternoon = {}}

appData.matchFilePath = system.pathForFile( "match.txt", system.DocumentsDirectory )

print(appData.user.userName)

appData.transportDetails = 0

-- Hide Status Bar
display.setStatusBar( display.HiddenStatusBar )

-- --------------------------------------------------------------------------------------
-- LOCATION
-- --------------------------------------------------------------------------------------

appData.myLocation = {lt = "59.95", ln = "10.75"}
appData.myDirection = "0"
appData.mySpeed = "0"

local locationHandler = function( event )
    if event.errorCode ~= nil then
        local alert = native.showAlert( 
            "Location Problem!",
            "Enable GPS in your phone settings and restart the app, please!", 
            { "OK", "" } 
            )
    end	

    if event.latitude ~= nil and event.longitude ~= nil then
      appData.myLocation.lt = string.format( '%.4f', event.latitude )
      appData.myLocation.ln = string.format( '%.4f', event.longitude )
      appData.myDirection =string.format( '%.3f', event.direction )
      appData.mySpeed = string.format( '%.3f', event.speed )
    else
        local alert = native.showAlert( 
            "Location Problem!",
            "Enable GPS in your phone settings and restart the app, please!", 
            { "OK", "" } 
            )    	
    end  
end

-- Listener
Runtime:addEventListener( "location", locationHandler ) -- track GPS

-- --------------------------------------------------------------------------------------
-- SUSPENSION
-- --------------------------------------------------------------------------------------
appData.appIsRunning = true

local delayedLogin = function()
	appData.composer.gotoScene( "controller.IntroController" )
end	

-- Refresh Token
local tokenRefreshed = function(event)
    local data = appData.json.decode(event.response)

    if data ~= nil then
        if data.token.accessToken ~= nil then
            appData.session.accessToken = data.token.accessToken
        end 
    end   
end

local refreshToken = function()

	if appData.session.refreshToken ~= nil 
    and appData.session.refreshToken == nil 		
    then
	    print("refreshing token")

	    -- prepare data
	    local url = "https://api.sammevei.no/api/1/auth/token" 


	    local params = {}

	    -- HEADERS
	    local headers = {}
	    headers["Content-Type"] = "application/x-www-form-urlencoded"
	    headers["Authorization"] = "Bearer "..appData.session.accessToken      
	    params.headers = headers

	    -- BODY
	    params.body = 'refreshToken='..appData.session.refreshToken
	    print(params.body)

	    -- send request
	    network.request( url, "POST", tokenRefreshed, params)
	end      
end 

local delayedRefresh = function()
	-- refreshToken()
    if appData.creatingTransport == true then
    	appData.composer.showOverlay( "controller.CreateTransportController" )
    elseif appData.transportDetails ~= 0 then
        appData.composer.setVariable( "i", appData.transportDetails )
    	appData.composer.showOverlay( "controller.TransportDetailsController", options)	
	elseif appData.appIsRunning	== false then
		appData.composer.showOverlay( "controller.OptionsController" )
    else 	 
    end		
end	

-- ---------------------------------------------------------------------------------------

appData.restart = false
appData.creatingTransport = false
local suspensionTime = 0
local resumeTime = 0
local idleTime = 1

local onResume = function( event )
	if event.type == "applicationSuspend" then
	    print("----------- suspended -----------")
	    appData.refreshing = true
	    suspensionTime = os.time()
	    appData.composer.removeHidden()
	    if appData.restart == true then
			-- native.requestExit()
		end
 	elseif event.type == "applicationResume" then
 		print("! ----------- resume ----------- !")
 		appData.refreshing = true
 		resumeTime = os.time()
 		idleTime = resumeTime - suspensionTime
 		print(tostring(idleTime))

 		if idleTime > 1000*60*60*12 then
			-- login again
			timer.performWithDelay( 1000, delayedLogin, 1 )
	    else
	        -- refresh token
	        timer.performWithDelay( 1000, delayedRefresh, 1 )
	    end
    end
end

-- Listener
Runtime:addEventListener( "system", onResume )


-- --------------------------------------------------------------------------------------
-- NOTIFICATIONS
-- --------------------------------------------------------------------------------------

local function notificationListener( event )

	local data
	
    if ( event.type == "remote" ) then
    	
    	-- EXTRACT data.type and data.type from data message
    	-- print("================ TABLE ===============")
    	-- printTable(event)

        if event.androidPayload.data ~= nil then
    	 	data = appData.json.decode(event.androidPayload.data)
    	end 	

    	print("================ DATA ===============")

    	if data ~= nil then
    		if data.type ~= nil then
		    	print(data.type)
		    end 
		    
		    if data.body ~= nil then	
		    	print(data.body)

		    	local alert = native.showAlert( 
		            "",
		            data.body, 
		            { "OK", "" } 
		            )
		    end	
    	end

        print("================ DATA ===============")

    elseif ( event.type == "local" ) then
    end
end
 
if appData.useNotifications == true then
	Runtime:addEventListener( "notification", notificationListener )
end	
-- --------------------------------------------------------------------------------------
-- START
-- --------------------------------------------------------------------------------------

-- Load the first screen
appData.composer.gotoScene( "controller.IntroController" )
-- appData.composer.gotoScene("controller.CreateTransportController")  
