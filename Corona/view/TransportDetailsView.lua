local composer = require( "composer" )
local widget = require( "widget" )
local appData = require( "misc.appData" )
local routines = require( "misc.appRoutines" )

local M = {}

-- background
M.showBackground = function()
    M.background = display.newRect( 0, 0, appData.screenW, appData.screenH )
    M.background.fill = appData.colors.transportBackground
    M.background.x = appData.contentW/2
    M.background.y = appData.contentH/2
    M.sceneGroup:insert( M.background )
end 

M.showDetails = function(i)
	print("============== "..i)

	-- details group
    M.detailsGroup = display.newGroup()
    M.sceneGroup:insert( M.detailsGroup )

    -- transport.id 
    M.transport_id  = appData.transports[i].transport_id

    -- role
    local myModeString
    if appData.transports[i].vehicle.id == nil then
       myModeString = "SOM PASSASJER"
    else
        myModeString = "SOM SJÅFØR"
    end   

    M.myMode = display.newText( 
        myModeString, 0, 0, appData.actionText, 12 )

    M.myMode.anchorX = 1
    M.myMode.x = appData.contentW - appData.margin*2

    M.myMode.anchorY = 0
    M.myMode.y = appData.margin*2
    M.myMode.fill = appData.colors.actionText 
    M.detailsGroup:insert( M.myMode )

    -- date and time
    local t = string.sub(appData.transports[i].starting_at, 12, 13)
    t = tonumber(t) + 2
    t = tostring(t)
    if string.len(t) == 1 then
        t = "0"..t
    end  

    local dateTimeString = string.sub(appData.transports[i].starting_at, 9, 10)
                        .."."
                        .. string.sub(appData.transports[i].starting_at, 6, 7)
                        ..". "
                        .. string.sub(appData.transports[i].starting_at, 1, 4)
                        .." "
                        .."kl. "
                        ..t
                        .. string.sub(appData.transports[i].starting_at, 15, 16)

    if appData.transports[i].matches[1] ~= nil and  myModeString == "SOM PASSASJER"  then
        
        local t = string.sub(appData.transports[i].matches[1].pick_up_at, 12, 13)
        t = tonumber(t) + 2
        t = tostring(t)
        if string.len(t) == 1 then
            t = "0"..t
        end  

        dateTimeString = string.sub(appData.transports[i].matches[1].pick_up_at, 9, 10)
                            .."."
                            .. string.sub(appData.transports[i].matches[1].pick_up_at, 6, 7)
                            ..". "
                            .. string.sub(appData.transports[i].matches[1].pick_up_at, 1, 4)
                            .." "
                            .."kl. "
                            ..t
                            .. string.sub(appData.transports[i].matches[1].pick_up_at, 15, 16)    

    elseif appData.transports[i].matches[1] ~= nil and  myModeString == "SOM SJÅFØR"  then
        
        local t = string.sub(appData.transports[i].matches[1].starting_at, 12, 13)
        t = tonumber(t) + 2
        t = tostring(t)
        if string.len(t) == 1 then
            t = "0"..t
        end  

        dateTimeString = string.sub(appData.transports[i].matches[1].starting_at, 9, 10)
                            .."."
                            .. string.sub(appData.transports[i].matches[1].starting_at, 6, 7)
                            ..". "
                            .. string.sub(appData.transports[i].matches[1].starting_at, 1, 4)
                            .." "
                            .."kl. "
                            ..t
                            .. string.sub(appData.transports[i].matches[1].starting_at, 15, 16)    
    end    

    M.dateTime = display.newText( 
        dateTimeString, 0, 0, appData.actionText, 12 )

    M.dateTime.anchorX = 0
    M.dateTime.x = appData.margin*2

    M.dateTime.anchorY = 0
    M.dateTime.y = appData.margin*2
    M.dateTime.fill = appData.colors.actionText
    M.detailsGroup:insert( M.dateTime )

    -- from
    local fromAddressString = "fra: "
                              ..appData.transports[i].route.from_address

    M.fromAddress = display.newText( 
        fromAddressString, 0, 0, appData.actionText, 12 )

    M.fromAddress.anchorX = 0
    M.fromAddress.x = appData.margin*2

    M.fromAddress.anchorY = 0
    M.fromAddress.y = appData.margin*3 + 10
    M.fromAddress.fill = appData.colors.actionText
    M.detailsGroup:insert( M.fromAddress )  

    -- from
    local toAddressString = "til: "
                              ..appData.transports[i].route.to_address

    M.toAddress = display.newText( 
        toAddressString, 0, 0, appData.actionText, 12 )

    M.toAddress.anchorX = 0
    M.toAddress.x = appData.margin*2

    M.toAddress.anchorY = 0
    M.toAddress.y = appData.margin*4 + 20
    M.toAddress.fill = appData.colors.actionText 
    M.detailsGroup:insert( M.toAddress )   

    -- status
    local myStatusString
    if appData.transports[i].matches[1] == nil then
        myStatusString = ""
    else
        myStatusString = "" 
    end   

    M.myStatus = display.newText( 
        myStatusString, 0, 0, appData.actionText, 12 )

    M.myStatus.anchorX = 1
    M.myStatus.x = appData.contentW - appData.margin*2

    M.myStatus.anchorY = 0
    M.myStatus.y = appData.margin*4 + 20
    M.myStatus.fill = appData.colors.actionText 
    M.detailsGroup:insert( M.myStatus )  

    -- final adjustmens
    M.detailsGroup.y = appData.contentH 
    				 - display.screenOriginY 
    				 - appData.margin*2 
    				 - M.footerGroup.height
    				 - M.detailsGroup.height
    				 - 50 
end

M.showFooter = function(matched)

    -- footer group
    M.footerGroup = display.newGroup()
    M.sceneGroup:insert( M.footerGroup )

    -- delete button
    M.deleteButton = widget.newButton(
        {
            shape = "roundedRect",
            width = 80,
            height = 24,
            cornerRadius = 12,
            label = "SLETT",
            fontSize = 12,
            labelColor = { default=appData.colors.confirmButtonLabelDefault, 
                           over=appData.colors.confirmButtonLabelOver 
                         },
            fillColor = { default=appData.colors.confirmButtonFillDefault, 
                          over=appData.colors.confirmButtonFillOver
                        },
            strokeColor = { default=appData.colors.confirmButtonLabelDefault, 
                           over=appData.colors.confirmButtonLabelOver 
                        },

            strokeWidth = 1   
        } 
    )

    M.deleteButton.anchorX = 1
    M.deleteButton.x = appData.contentW - appData.margin*2
    M.deleteButton.alpha = 1 
    M.footerGroup:insert( M.deleteButton ) 

    if matched == true then M.deleteButton.alpha = 0 end   

	-- back button
	M.backButton = appData.widget.newButton{
	    width = 24,
	    height = 22,
	    defaultFile = "images/backB.png",
	    overFile = "images/backB.png"
	    -- onPress = pressFunction,
	    -- onRelease = backFunction
	}
	 
    M.backButton.anchorX = 0;
	M.backButton.x = appData.margin*2
    M.backButton.alpha = 0.9
	M.footerGroup:insert( M.backButton ) 

	-- final adjustments
	M.footerGroup.x = 0
	M.footerGroup.y = appData.contentH - display.screenOriginY - appData.margin*2 - M.footerGroup.height
end

M.showMap = function(i)

    -- create map
    local myDeparture = {lt, ln}
    local myDestination = {lt, ln}

    myDeparture.lt = appData.transports[i].route.from_location.coordinates[2]
    myDeparture.ln = appData.transports[i].route.from_location.coordinates[1]
    myDestination.lt = appData.transports[i].route.to_location.coordinates[2]
    myDestination.ln = appData.transports[i].route.to_location.coordinates[1]

	routines.createMap(myDeparture.lt, myDeparture.ln, myDestination.lt, myDestination.ln)

    local lon1 = "lon1="..myDeparture.ln
    local lat1 = "lat1="..myDeparture.lt
    local lon2 = "lon2="..myDestination.ln
    local lat2 = "lat2="..myDestination.lt

    local params = lon1.."&"..lat1.."&"..lon2.."&"..lat2
    print("- - - - - - - - - "..params)

	-- show map
	M.transportMap = native.newWebView( 
        0, 
        0, 
        display.contentWidth, 
        appData.contentH - display.screenOriginY*2 - 145
    )

    M.transportMap:request( "map.html?"..params, system.DocumentsDirectory )
    M.transportMap.anchorX = 0
    M.transportMap.anchorY = 0
    M.transportMap.x = 0
    M.transportMap.y = display.screenOriginY
    M.sceneGroup:insert( M.transportMap )  
end

return M