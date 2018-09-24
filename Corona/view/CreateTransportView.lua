local composer = require( "composer" )
local widget = require( "widget" )
local appData = require( "misc.appData" )
local routines = require( "misc.appRoutines" )
local model = require("model.CreateTransportModel")

widget.setTheme( "widget_theme_ios7" )

local M = {}
-- -----------------------------------------------------------------------------
-- BACKGROUND
-- -----------------------------------------------------------------------------
M.showBackground = function(event)
    M.background = display.newRect( 0, 0, appData.screenW, appData.screenH )
    M.background.fill = appData.colors.actionBackground
    M.background.x = appData.contentW/2
    M.background.y = appData.contentH/2
    M.sceneGroup:insert( M.background )
end

-- -----------------------------------------------------------------------------
-- MY ROUTE MAP
-- -----------------------------------------------------------------------------
M.myRouteMap = function()

    -- show map2
        print("showing map2")
        M.routeMap2 = native.newWebView( 
            0, 
            0, 
            display.contentWidth, 
            appData.contentH - display.screenOriginY - 195
        )

        M.routeMap2:request( "map.html", system.DocumentsDirectory )
        M.routeMap2.anchorX = 0
        M.routeMap2.anchorY = 0
        M.routeMap2.x = 3000
        M.routeMap2.y = display.screenOriginY + 35
        M.sceneGroup:insert( M.routeMap2 ) 
        M.sceneGroup.alpha = 0.1

    -- show map1
        print("showing map1")
        M.routeMap1 = native.newWebView( 
            0, 
            0, 
            display.contentWidth, 
            appData.contentH - display.screenOriginY - 195
        )

        M.routeMap1.anchorX = 0
        M.routeMap1.anchorY = 0
        M.routeMap1.x = 3000
        M.routeMap1.y = display.screenOriginY + 35
        -- M.routeMap1:request( "map.html", system.DocumentsDirectory )
        M.sceneGroup:insert( M.routeMap1 ) 
end

-- -----------------------------------------------------------------------------
-- TRIP CREATION DETAILS
-- -----------------------------------------------------------------------------

-- Show Trip Change (trip details for now)
M.showTransportDetails = function(address)
    -- setup
    M.tripChangeGroup = display.newGroup()
    M.sceneGroup:insert( M.tripChangeGroup )
    M.tripChangeGroup.alpha = 1

    M.tripChangeGroup.anchorX = 0.5
    M.tripChangeGroup.anchorY = 0
    M.tripChangeGroup.y = -3000

    -- Background ------------------------------------------------------------------------------
    M.tripChangeBackground = display.newRect( 0, -20, appData.screenW, 150 )
    M.tripChangeBackground.fill = appData.colors.actionBackground
    M.tripChangeBackground.anchorX = 0.5
    M.tripChangeBackground.anchorY = 0
    M.tripChangeBackground.x = appData.contentW/2
    M.tripChangeGroup:insert( M.tripChangeBackground ) 

    --  Departure Text -------------------------------------------------------------------
    local tripDepartureTextString = "Fra:"

    M.tripDepartureText = display.newText( 
        tripDepartureTextString, 0, 0, appData.fonts.actionText, 12 )

    M.tripDepartureText.anchorX = 0
    M.tripDepartureText.x = appData.margin*2

    M.tripDepartureText.anchorY = 0
    M.tripDepartureText.y = 0 - 55 - 30 - 30
    M.tripDepartureText.fill = appData.colors.actionComment
    M.tripChangeGroup:insert( M.tripDepartureText )


    --  Departure Background -------------------------------------------------------------------
    M.departureFieldBackground = display.newRoundedRect(
        appData.contentW/2 + 3000, 0, 
        appData.screenW - appData.actionMargin*2, 30, 
        appData.actionCorner/2 
    )

    M.departureFieldBackground.fill = appData.colors.actionText
    M.departureFieldBackground.y = 0 - 80
    M.departureFieldBackground.alpha = 0
    M.tripChangeGroup:insert( M.departureFieldBackground )

    -- Departure Field -------------------------------------------------------------------------

    M.departureField = native.newTextField( 
        appData.contentW/2+appData.margin + 3000, 0, 
        appData.screenW - appData.actionMargin*2, 30 
    )
  
    M.departureField.font = appData.fonts.actionText
    if (appData.transport.from == "") then
        M.departureField.placeholder = ""
    else
        M.departureField.placeholder = ""
        M.departureField.text = appData.transport.fromAddress
    end 

    M.departureField.fill = infoText
    M.departureField.placeholer = "Adresse:"
    M.departureField.align = "left"
    M.departureField.hasBackground = false
    M.departureField.y = 3 - 80
    M.departureField.alpha = 0
    M.tripChangeGroup:insert( M.departureField )

    --  Destination Text -------------------------------------------------------------------
    local tripDestinationTextString = "Til:"

    M.tripDestinationText = display.newText( 
        tripDestinationTextString, 0, 0, appData.fonts.actionText, 12 )

    M.tripDestinationText.anchorX = 0
    M.tripDestinationText.x = appData.margin*2

    M.tripDestinationText.anchorY = 0
    M.tripDestinationText.y = 0 - 55
    M.tripDestinationText.fill = appData.colors.actionComment
    M.tripChangeGroup:insert( M.tripDestinationText )

    --  Destination Background -----------------------------------------------------------------
    M.destinationFieldBackground = display.newRoundedRect(
        appData.contentW/2 + 3000, 0, 
        appData.screenW - appData.actionMargin*2, 30, 
        appData.actionCorner/2 
    )

    M.destinationFieldBackground.fill = appData.colors.actionText
    M.destinationFieldBackground.y = 45 - 60
    M.destinationFieldBackground.alpha = 0
    M.tripChangeGroup:insert( M.destinationFieldBackground )

    -- Destination Field -----------------------------------------------------------------------

    M.destinationField = native.newTextField( 
        appData.contentW/2+appData.margin*2 + 3000, 0, 
        appData.screenW - appData.actionMargin, 30
    )
    
    M.destinationField.font = appData.fonts.actionText
    M.destinationField.placeholder = "Adresse:"
    M.destinationField.align = "left"
    M.destinationField.hasBackground = false
    M.destinationField.y = 48 - 60
    M.destinationField.alpha = 0
    M.tripChangeGroup:insert( M.destinationField )

    --  Date & Time Text -------------------------------------------------------------------
    local dateTimeTextString = "Dato og tid:"

    M.dateTimeText = display.newText( 
        dateTimeTextString, 0, 0, appData.fonts.actionText, 12 )

    M.dateTimeText.anchorX = 0
    M.dateTimeText.x = appData.margin*2

    M.dateTimeText.anchorY = 0
    M.dateTimeText.y = 0 - 55 + 30 + 35
    M.dateTimeText.fill = appData.colors.actionComment
    M.tripChangeGroup:insert( M.dateTimeText )

    -- Date Background -------------------------------------------------------------------------
    M.tripDateBackground = display.newRoundedRect(0, 0, 50, 30, appData.actionCorner/2 )
    M.tripDateBackground.fill = appData.colors.actionText
    M.tripDateBackground.anchorX = 1
    M.tripDateBackground.anchorY = 0
    M.tripDateBackground.x = 305 - 65 - 20 - 65 - 20 - 50 - 20
    M.tripDateBackground.y = 75 - 40
    M.tripChangeGroup:insert( M.tripDateBackground )

    -- Date Text -------------------------------------------------------------------------------
    local tomorrow = model.calculateUTC(1) 
    tomorrow = string.sub(tomorrow,9,10).."."..string.sub(tomorrow,6,7).."."

    local tripDateOptions = 
    {
        text = tomorrow,
        font = appData.fonts.actionText,
        align = "center",
        width = 50
    }

    M.tripDate = display.newText( tripDateOptions )
    M.tripDate.fill = appData.colors.fieldText
    M.tripDate.anchorX = 1
    M.tripDate.anchorY = 0
    M.tripDate.x = 305 - 65 - 20 - 65 - 20 - 50 - 20
    M.tripDate.y = 80 - 40
    M.tripChangeGroup:insert( M.tripDate )      

    -- Time Background -------------------------------------------------------------------------
    M.tripTimeBackground = display.newRoundedRect(0, 0, 50, 30, appData.actionCorner/2 )
    M.tripTimeBackground.fill = appData.colors.actionText
    M.tripTimeBackground.anchorX = 1
    M.tripTimeBackground.anchorY = 0
    M.tripTimeBackground.x = 305 - 65 - 20 - 65 - 20
    M.tripTimeBackground.y = 75 - 40
    M.tripChangeGroup:insert( M.tripTimeBackground )

    -- Time Text -------------------------------------------------------------------------------
    local tripTimeOptions = 
    {
        text = "08:30",
        font = appData.fonts.actionText,
        align = "center",
        width = 50
    }

    M.tripTime = display.newText( tripTimeOptions )
    M.tripTime.fill = appData.colors.fieldText
    M.tripTime.anchorX = 1
    M.tripTime.anchorY = 0
    M.tripTime.x = 305 - 65 - 20 - 65 - 20
    M.tripTime.y = 80 - 40
    M.tripChangeGroup:insert( M.tripTime )   

    -- Tolerance Background --------------------------------------------------------------------
    M.tripToleranceBackground = display.newRoundedRect(0, 0, 65, 30, appData.actionCorner/2)
    M.tripToleranceBackground.fill = appData.colors.actionText
    M.tripToleranceBackground.anchorX = 1
    M.tripToleranceBackground.anchorY = 0
    M.tripToleranceBackground.x = 305 - 65 - 20
    M.tripToleranceBackground.y = 75 - 40    
    M.tripChangeGroup:insert( M.tripToleranceBackground )
    
    -- Tolerance Text --------------------------------------------------------------------------
    local tripToleranceOptions = 
    {
        -- text = tostring(appData.user.morningFlexibility/60).." min",
        text = "+/- 30 min",
        font = appData.fonts.actionText,
        align = "center",
        width = 65
    }

    M.tripTolerance = display.newText( tripToleranceOptions )
    M.tripTolerance.fill = appData.colors.fieldText
 
    M.tripTolerance.anchorX = 1
    M.tripTolerance.anchorY = 0
    M.tripTolerance.x = 305 - 65 - 20
    M.tripTolerance.y = 80 - 40
    M.tripChangeGroup:insert( M.tripTolerance ) 

    -- Role Background --------------------------------------------------------------------
    M.tripRoleBackground = display.newRoundedRect(0, 0, 65, 30, appData.actionCorner/2)
    M.tripRoleBackground.fill = appData.colors.actionText
    M.tripRoleBackground.anchorX = 1
    M.tripRoleBackground.anchorY = 0
    M.tripRoleBackground.x = 305 -- 0 - display.screenOriginX - appData.actionMargin
    M.tripRoleBackground.y = 75 - 40    
    M.tripChangeGroup:insert( M.tripRoleBackground )
    
    -- Role Text --------------------------------------------------------------------------

    local tripRoleOptions = 
    {
        text = "",
        font = appData.fonts.actionText,
        align = "center",
        width = 65
    }

    M.tripRole = display.newText( tripRoleOptions )
    M.tripRole.fill = appData.colors.fieldText
 
    M.tripRole.anchorX = 1
    M.tripRole.anchorY = 0
    M.tripRole.x = 305
    M.tripRole.y = 80 - 40
    M.tripChangeGroup:insert( M.tripRole ) 

    M.tripChangeGroup.y = -3000

    --  Weekdays Switch -------------------------------------------------------------------
    M.weekdaysSwitch = widget.newSwitch(
        {
            left = 0,
            top = 0,
            style = "onOff",
            initialSwitchState = false
            -- onRelease = morningSwitchListener
        }
    )

    M.weekdaysSwitch.anchorX = 0
    M.weekdaysSwitch.anchorY = 0
    M.weekdaysSwitch.x = appData.margin*2
    M.weekdaysSwitch.y = 0 - 55 + 30 + 35 + 35 + 30 + 10        
    M.weekdaysSwitch:scale(0.6, 0.6)
    M.weekdaysSwitch.alpha = 0.9
    M.tripChangeGroup:insert( M.weekdaysSwitch )     

    --  Weekdays Info -------------------------------------------------------------------
    local weekdaysTextString = "Gjenta for hele arbeidsuken"

    M.weekdaysText = display.newText( 
        weekdaysTextString, 0, 0, appData.fonts.titleText, 17 )

    M.weekdaysText.anchorX = 0
    M.weekdaysText.x = appData.margin*2 + 55

    M.weekdaysText.anchorY = 0
    M.weekdaysText.y = 0 - 55 + 30 + 35 + 35 + 30 + 10
    M.weekdaysText.fill = appData.colors.actionText
    M.tripChangeGroup:insert( M.weekdaysText )


    --  Weekdays Text -------------------------------------------------------------------
    local weekdaysTextString = ""

    M.weekdaysTimeText = display.newText( 
        weekdaysTextString, 0, 0, appData.fonts.actionText, 12 )

    M.weekdaysTimeText.anchorX = 0
    M.weekdaysTimeText.x = appData.margin*2 + 55

    M.weekdaysTimeText.anchorY = 0
    M.weekdaysTimeText.y = 0 - 55 + 30 + 35 + 35 + 30 + 30
    M.weekdaysTimeText.fill = appData.colors.actionComment
    M.tripChangeGroup:insert( M.weekdaysTimeText )

    -- Week Day
    local y = 2018 
    local m = string.sub(M.tripDate.text,4,5)
    local d = string.sub(M.tripDate.text,1,2)
    local h = string.sub(M.tripTime.text, 1, 2)
    local s = tonumber(string.sub(M.tripTime.text, 4, 5))*60 

    local weekDay = routines.localToWeekday(y, m, d, h, s)

    if weekDay == "Mon" then M.weekdaysTimeText.text = "Man, Tir, Ons, Tor, Fre" end
    if weekDay == "Tue" then M.weekdaysTimeText.text = "Tir, Ons, Tor, Fre" end
    if weekDay == "Wed" then M.weekdaysTimeText.text = "Ons, Tor, Fre" end
    if weekDay == "Thu" then M.weekdaysTimeText.text = "Tor, Fre" end

    -- Hide Multiple Trip Option if Fri, Sat or Sun
    if weekDay == "Fri" or weekDay == "Sat" or weekDay == "Sun" then 
        M.weekdaysSwitch.alpha = 0
        M.weekdaysText.alpha = 0
        M.weekdaysTimeText.alpha = 0
    else
        M.weekdaysSwitch.alpha = 1
        M.weekdaysText.alpha = 1
        M.weekdaysTimeText.alpha = 1           
    end

end

M.showWheels = function()
    -- White Background
    M.whiteBackground = display.newRect( 
        0, 0+display.screenOriginY, appData.screenW, appData.screenH*4 )
    M.whiteBackground.fill = appData.colors.infoButtonLabelDefault
    M.whiteBackground.x = appData.contentW/2
    M.whiteBackground.y = appData.contentH/2
    M.whiteBackground.alpha = 0
    M.sceneGroup:insert( M.whiteBackground )

    -- Transport Date Wheel
    --  generate 10 days from now
    local labelList = {}

    for i=1, 30 do
        local utc = model.calculateUTC(i) 
        labelList[i] = string.sub(utc,9,10).."."..string.sub(utc,6,7).."."
    end    

    local utc = model.calculateUTC(0) 
    local value = string.sub(utc,9,10).."."..string.sub(utc,6,7).."."
    table.insert(labelList, 1, value)

    local transportDateWheelData =
    {
        {
            align = "left",
            width = 1,
            labelPadding = 0,
            startIndex = 1,
            labels = { "" }
        },

        {
            align = "center",
            labelPadding = 0,
            width = appData.contentW,
            startIndex = 5,
            labels = labelList
        }
    }
     
    -- Create the widget
    M.transportDateWheel = widget.newPickerWheel(
    {
        x = 0,
        top = display.contentHeight - 250,
        style = "resizable",
        width = appData.screenW*2,
        height = appData.screenW,
        rowHeight = 30,
        font = appData.fonts.actionText,
        fontSize = 14,
        columns = transportDateWheelData
    }) 
    
    M.transportDateWheel.anchorX = 0
    M.transportDateWheel.x = 0
    M.transportDateWheel.y = -3000
    M.sceneGroup:insert( M.transportDateWheel )     

    -- Transport Time Wheel
    local transportTimeWheelData =
    {
        {
            align = "left",
            width = 1,
            startIndex = 1,
            labels = { "" }
        },

        {
            align = "right",
            width = appData.contentW/2,
            labelPadding = 0,
            startIndex = 9,
            labels = {
                "00", "01", "02", "03", "04", "05", "06",
                "07", "08", "09", "10", "11", "12",
                "13", "14", "15", "16", "17", "18",
                "19", "20", "21", "22", "23", "24"
            }
        },

        {
            align = "center",
            width = 4,
            labelPadding = 0,
            startIndex = 1,
            labels = { ":" }
        },

        {
            align = "left",
            labelPadding = 0,
            width = appData.contentW/2,
            startIndex = 1,
            labels = { 
                "00", "05", "10", "15", "20", "25", "30", "35", "40", "45", "50", "55"
            }
        },

        {
            align = "left",
            startIndex = 1,
            labels = { "" }
        }
    }
     
    -- Create the widget
    M.transportTimeWheel = widget.newPickerWheel(
    {
        x = 0,
        top = display.contentHeight - 222,
        style = "resizable",
        width = appData.screenW,
        height = appData.screenW,
        rowHeight = 30,
        font = appData.fonts.actionText,
        fontSize = 14,
        columns = transportTimeWheelData
    }) 
    
    M.transportTimeWheel.anchorX = 0.0
    M.transportTimeWheel.x = 0
    M.transportTimeWheel.y = -3000
    M.sceneGroup:insert( M.transportTimeWheel ) 

    -- Transport Tolerance Wheel

    local transportToleranceWheelData =
    {
        {
            align = "left",
            width = 1,
            labelPadding = 0,
            startIndex = 1,
            labels = { "" }
        },

        {
            align = "center",
            labelPadding = 0,
            width = appData.contentW,
            startIndex = 5,
            labels = { 
                "05 min", "10 min", "15 min", "20 min", "25 min", "30 min", "35 min", "40 min", "45 min", "50 min", "55 min", "60 min"
            }
        }
    }
     
    -- Create the widget
    M.transportToleranceWheel = widget.newPickerWheel(
    {
        x = 0,
        top = display.contentHeight - 250,
        style = "resizable",
        width = appData.screenW*2,
        height = appData.screenW,
        rowHeight = 30,
        font = appData.fonts.actionText,
        fontSize = 14,
        columns = transportToleranceWheelData
    }) 
    
    M.transportToleranceWheel.anchorX = 0
    M.transportToleranceWheel.x = 0
    M.transportToleranceWheel.y = -3000
    M.sceneGroup:insert( M.transportToleranceWheel ) 

    -- Transport Role Button
    local transportRoleWheelData =
    {
        {
            align = "left",
            width = 1,
            labelPadding = 0,
            startIndex = 1,
            labels = { "" }
        },

        {
            align = "center",
            labelPadding = 0,
            width = appData.contentW,
            labelPadding = 0,
            startIndex = 1,
            labels = { "Passasjer", "Sjåfør" }
        }
    }
    
    -- Create the widget
    M.transportRoleWheel = widget.newPickerWheel(
    {
        x = 0,
        top = display.contentHeight - 250,
        style = "resizable",
        width = appData.contentW,
        height = appData.screenW,
        rowHeight = 30,
        font = appData.fonts.actionText,
        fontSize = 14,
        columns = transportRoleWheelData
    }) 
    
    M.transportRoleWheel.anchorX = 0.0
    M.transportRoleWheel.x = 0
    M.transportRoleWheel.y = -3000
    M.sceneGroup:insert( M.transportRoleWheel ) 

    -- Wheel Button 
    M.wheelButton = widget.newButton(
        {
            left = 0,
            top = 0,
            shape = "roundedRect",
            width = 80,
            height = 24,
            cornerRadius = 2,
            label = "LAGRE",
            fontSize = 13,
            labelColor = { default=appData.colors.actionComment, 
                           over=appData.colors.actionComment 
                         },
            fillColor = { default=appData.colors.actionText, 
                          over=appData.colors.actionText
                        },
            strokeColor = { default=appData.colors.actionComment, 
                           over=appData.colors.actionComment 
                        },

            strokeWidth = 1   
        } 
    )

    M.wheelButton.anchorX = 1
    M.wheelButton.anchorY = 1 
    M.wheelButton.x = appData.contentW - display.screenOriginX - appData.margin*2
    M.wheelButton.y = appData.contentH - display.screenOriginY - appData.margin*2


    M.wheelButton.alpha = 0
    M.sceneGroup:insert( M.wheelButton )      
end

M.showDepartureSearchResults = function(places)
    appData.places = places
    M.destinationField.x = 1000 -- move appData.destinationField form out of the view

    -- Departure Table View Row Fender Listener
    local departureSearchResultsRowRender = function(event)
        -- Get reference to the row group
        local row = event.row

        -- Set variable for text
        local rowTitle
        local rowHeight = row.contentHeight
        local rowWidth = row.contentWidth
     
        if appData.places[row.index] ~= nil then
            rowTitle = display.newText( row, appData.places[row.index].description, 0, 0, nil, 12 )
            rowTitle:setFillColor( fieldText )

            -- Align the label left and vertically centered
            rowTitle.anchorX = 0
            rowTitle.x = 15
            rowTitle.y = rowHeight * 0.5
        end
    end

    -- Create the departure widget
    if M.departureSearchResults ~= nil then
        M.departureSearchResults:removeSelf()
        M.departureSearchResults = nil
    end 

    M.departureSearchResults = widget.newTableView(
        {
            left = 0,
            top = 0,
            height = 200,
            width = appData.screenContent,
            onRowRender = departureSearchResultsRowRender,
            noLines = true
        }
    )

    M.departureSearchResults.anchorY = 0
    M.departureSearchResults.anchorX = 0.5
    M.departureSearchResults.x = appData.contentW/2
    M.departureSearchResults.y = 15
    M.tripChangeGroup:insert( M.departureSearchResults )
     
    -- Insert Rows
    for i = 1, 5 do
        -- Insert a row into the tableView
        M.departureSearchResults:insertRow{}
    end
end

M.showDestinationSearchResults = function(places)
    appData.places = places

    -- Table View Row Listener
    local destinationSearchResultsRowRender = function(event)
        -- print("DESTINATION")
        -- Get reference to the row group
        local row = event.row

        -- Set variable for text
        local rowTitle
     
        -- Cache the row "contentWidth" and "contentHeight" because the row bounds can change as children objects are added
        local rowHeight = row.contentHeight
        local rowWidth = row.contentWidth
     
        if appData.places[row.index] ~= nil then
            rowTitle = display.newText( row, appData.places[row.index].description, 0, 0, nil, 12 )
            rowTitle:setFillColor( fieldText )

            -- Align the label left and vertically centered
            rowTitle.anchorX = 0
            rowTitle.x = 15
            rowTitle.y = rowHeight * 0.5
        end
        

    end

    -- Create the widget
    if M.destinationSearchResults ~= nil then
        M.destinationSearchResults:removeSelf()
        M.destinationSearchResults = nil
    end 

    M.destinationSearchResults = widget.newTableView(
        {
            left = 0,
            top = 0,
            height = 200,
            width = appData.screenContent,
            onRowRender = destinationSearchResultsRowRender,
            noLines = true
        }
    )

    M.destinationSearchResults.anchorY = 0
    M.destinationSearchResults.anchorX = 0.5
    M.destinationSearchResults.x = appData.contentW/2
    M.destinationSearchResults.y = 60
    M.tripChangeGroup:insert( M.destinationSearchResults )
     
    -- Insert Rows
    for i = 1, 5 do
        -- Insert a row into the tableView
        M.destinationSearchResults:insertRow{}
    end
end

M.showFooter = function()

    -- footer group
    M.footerGroup = display.newGroup()
    M.sceneGroup:insert( M.footerGroup )

    -- back button
    M.backButton = appData.widget.newButton{
        width = 24,
        height = 22,
        defaultFile = "images/backB.png",
        overFile = "images/backB.png"
    }
     
    M.backButton.anchorX = 0.5
    M.backButton.anchorY = 0.5
    M.backButton.x = appData.margin*2 + M.backButton.width/2 
    M.footerGroup:insert( M.backButton ) 


    -- Save Button -----------------------------------------------------------------------
    M.saveButton = widget.newButton(
        {
            shape = "roundedRect",
            width = 80,
            height = 24,
            cornerRadius = 12,
            label = "LAG TUR",
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

    M.saveButton.anchorX = 1
    M.saveButton.x = appData.contentW - appData.margin*2
    M.saveButton.alpha = 1
    M.footerGroup:insert( M.saveButton )

    -- final adjustments
    M.footerGroup.alpha = 0.9
    M.footerGroup.x = 0
    M.footerGroup.y = appData.contentH - display.screenOriginY - appData.margin*2 - M.footerGroup.height
end

M.showMap = function(lon1, lat1, lon2, lat2)

    -- create map
    routines.createMap(lat1, lon1, lat2, lon2)

    local lon1 = "lon1="..lon1
    local lat1 = "lat1="..lat1
    local lon2 = "lon2="..lon2
    local lat2 = "lat2="..lat2

    local params = lon1.."&"..lat1.."&"..lon2.."&"..lat2
    print("- - - - - - - - - "..params)

    -- show map
    M.transportMap = native.newWebView( 
        0, 
        0, 
        display.contentWidth, 
        appData.contentH - display.screenOriginY*2 - 300
    )

    M.transportMap:request( "map.html?"..params, system.DocumentsDirectory )
    M.transportMap.anchorX = 0
    M.transportMap.anchorY = 0
    M.transportMap.x = 0
    M.transportMap.y = display.screenOriginY*2 - 310
    M.tripChangeGroup:insert( M.transportMap )  
end



















-- -----------------------------------------------------------------------------
-- DRIVING INFO
-- -----------------------------------------------------------------------------

-- Show Start Driving Info
M.showingStartDriving = false
M.showStartDrivingInfo = function(address)
    if (M.showingStartDriving == false) then

        M.showingStartDriving = true

        -- setup
        M.startDrivingGroup = display.newGroup()
        M.sceneGroup:insert( M.startDrivingGroup ) 

        M.startDrivingGroup.anchorX = 0.5
        M.startDrivingGroup.anchorY = 0
        M.startDrivingGroup.y = display.screenOriginY + 35

        -- background
        M.startDrivingBackground = display.newRect( 0, 0, appData.screenW, 100 )
        M.startDrivingBackground.fill = appData.colors.infoBackround
        M.startDrivingBackground.anchorX = 0.5
        M.startDrivingBackground.anchorY = 0
        M.startDrivingBackground.x = appData.contentW/2
        M.startDrivingGroup:insert( M.startDrivingBackground ) 

        -- next trip
        local nextTripText = "Neste tur:"

        local nextTripOptions = 
        
            {
                text = nextTripText,
                width = appData.contentW,
                font = appData.fonts.titleTextBold,
                align = "center"
            }

        M.nextTripDriver = display.newText( nextTripOptions )
        M.nextTripDriver.fill = appData.colors.infoText
        M.nextTripDriver.anchorX = 0.5
        M.nextTripDriver.anchorY = 0
        M.nextTripDriver.x = appData.contentW/2
        M.nextTripDriver.y = 10
        M.startDrivingGroup:insert( M.nextTripDriver )   


        -- countdown
        local countdownText = ""

        local countdownOptions = 
        
            {
                text = countdownText,
                width = appData.contentW,
                font = appData.fonts.actionText,
                align = "center"
            }

        M.driverCountdown = display.newText( countdownOptions )
        M.driverCountdown.fill = appData.colors.infoText
        M.driverCountdown.anchorX = 0.5
        M.driverCountdown.anchorY = 0
        M.driverCountdown.x = appData.contentW/2
        M.driverCountdown.y = 37
        M.startDrivingGroup:insert( M.driverCountdown ) 

        -- start button 
        M.startButton = widget.newButton(
            {
                left = 0,
                top = 0,
                shape = "roundedRect",
                width = 90,
                height = 22,
                cornerRadius = 2.5,
                label = "START",
                fontSize = 12,
                labelColor = { default=appData.colors.infoButtonLabelDefault, 
                               over=appData.colors.infoButtonLabelOver 
                             },
                fillColor = { default=appData.colors.infoButtonFillDefault, 
                              over=appData.colors.infoButtonFillOver
                            },
                strokeColor = { default=appData.colors.infoButtonLabelDefault, 
                               over=appData.colors.infoButtonLabelOver 
                            },

                strokeWidth = 0   
            } 
        )

        M.startButton.anchorY = 1
        M.startButton.x = appData.contentW/2
        M.startButton.y = 85
        M.startDrivingGroup:insert( M.startButton )

        -- navigation button 
        M.navigationButton = widget.newButton(
            {
                width = 23,
                height = 22,
                defaultFile = "images/directions.png",
                overFile = "images/directions.png"
            }
        )

        M.navigationButton.anchorY = 1
        M.navigationButton.anchorX = 1
        M.navigationButton.x = appData.contentW + display.screenOriginX - appData.actionMargin
        M.navigationButton.y = display.screenOriginY + 90
        M.startDrivingGroup:insert( M.navigationButton )
        M.navigationButton.alpha = 0

    end     
end

M.showingDrivingInfo = false
M.showDrivingInfo = function(address)

    M.showingDrivingInfo = true

    -- setup
    M.drivingGroup = display.newGroup()
    M.sceneGroup:insert( M.drivingGroup ) 

    M.drivingGroup.anchorX = 0.5
    M.drivingGroup.anchorY = 0
    M.drivingGroup.y = display.screenOriginY + 35

    -- background
    M.drivingBackground = display.newRect( 0, 0, appData.screenW, 100 )
    M.drivingBackground.fill = appData.colors.infoBackround
    M.drivingBackground.anchorX = 0.5
    M.drivingBackground.anchorY = 0
    M.drivingBackground.x = appData.contentW/2
    M.drivingGroup:insert( M.drivingBackground ) 

    -- next trip
    local nextTripText = ""

    local nextTripOptions = 
    
        {
            text = nextTripText,
            width = appData.contentW,
            font = appData.fonts.titleTextBold,
            align = "center"
        }

    M.tripDriver = display.newText( nextTripOptions )
    M.tripDriver.fill = {1, 0, 0} -- appData.colors.infoText
    M.tripDriver.anchorX = 0.5
    M.tripDriver.anchorY = 0
    M.tripDriver.x = appData.contentW/2
    M.tripDriver.y = 10
    M.drivingGroup:insert( M.tripDriver )   


    -- countdown
    local countdownText = ""

    local countdownOptions = 
    
        {
            text = countdownText,
            width = appData.contentW,
            font = appData.fonts.actionText,
            align = "center"
        }

    M.driverCountdown2 = display.newText( countdownOptions )
    M.driverCountdown2.fill = appData.colors.infoText
    M.driverCountdown2.anchorX = 0.5
    M.driverCountdown2.anchorY = 0
    M.driverCountdown2.x = appData.contentW/2
    M.driverCountdown2.y = 37
    M.drivingGroup:insert( M.driverCountdown2 ) 

    -- start button 
    M.mapsButton = widget.newButton(
        {
            left = 0,
            top = 0,
            shape = "roundedRect",
            width = 160,
            height = 22,
            cornerRadius = 2.5,
            label = "Google Maps Navigation",
            fontSize = 12,
            labelColor = { default=appData.colors.infoButtonLabelDefault, 
                           over=appData.colors.infoButtonLabelOver 
                         },
            fillColor = { default=appData.colors.infoButtonFillDefault, 
                          over=appData.colors.infoButtonFillOver
                        },
            strokeColor = { default=appData.colors.infoButtonLabelDefault, 
                           over=appData.colors.infoButtonLabelOver 
                        },

            strokeWidth = 0   
        } 
    )

    M.mapsButton.anchorY = 1
    M.mapsButton.x = appData.contentW/2
    M.mapsButton.y = 85
    M.drivingGroup:insert( M.mapsButton )
    
    -- cancel button 
    M.cancelButton = widget.newButton(
        {
            width = 23,
            height = 22,
            defaultFile = "images/cancel.png",
            overFile = "images/cancel.png"
        }
    )


    M.cancelButton.anchorY = 1
    M.cancelButton.anchorX = 1
    M.cancelButton.x = appData.contentW + display.screenOriginX - appData.actionMargin
    M.cancelButton.y = 85
    M.drivingGroup:insert( M.cancelButton )
    M.cancelButton.alpha = 1  
end

-- -----------------------------------------------------------------------------
-- MAP FOR DRIVER
-- -----------------------------------------------------------------------------

M.showingDriverMap = false
M.showDriverMap = function()

    -- show map
        print("showing driver map")
        M.driverMap = native.newWebView( 
            0, 
            0, 
            display.contentWidth, 
            appData.contentH - 225 - display.screenOriginY*2
        )

        M.driverMap:request( "drivermap.html", system.DocumentsDirectory )

        M.driverMap.anchorX = 0
        M.driverMap.anchorY = 0
        M.driverMap.x = 0
        M.driverMap.y = display.screenOriginY + 130
        M.sceneGroup:insert( M.driverMap ) 
end

-- -----------------------------------------------------------------------------
-- INFO FOR PASSENGER 
-- -----------------------------------------------------------------------------

-- Show Start Driving Info
M.showingPickUp = false
M.showPickUpInfo = function(address)
    if (M.showingPickUp == false) then

        M.showingPickUp = true

        -- setup
        M.pickUpGroup = display.newGroup()
        M.sceneGroup:insert( M.pickUpGroup ) 

        M.pickUpGroup.anchorX = 0.5
        M.pickUpGroup.anchorY = 0
        M.pickUpGroup.y = display.screenOriginY + 35

        -- background
        M.pickUpBackground = display.newRect( 0, 0, appData.screenW, 100 )
        M.pickUpBackground.fill = appData.colors.infoBackround
        M.pickUpBackground.anchorX = 0.5
        M.pickUpBackground.anchorY = 0
        M.pickUpBackground.x = appData.contentW/2
        M.pickUpBackground.y = 0
        M.pickUpGroup:insert( M.pickUpBackground ) 

 
        -- next trip
        local nextTripText = "Neste tur:"

        local nextTripOptions = 
        
            {
                text = nextTripText,
                width = appData.screenW - appData.margin*2 - appData.actionMargin*2,
                font = appData.fonts.titleTextBold,
                align = "center"
            }

        M.nextTrip = display.newText( nextTripOptions)
        M.nextTrip.fill = appData.colors.infoText
        M.nextTrip.anchorX = 1
        M.nextTrip.anchorY = 0
        M.nextTrip.x = appData.contentW - display.screenOriginX - appData.actionMargin
        M.nextTrip.y = 30
        M.pickUpGroup:insert( M.nextTrip )   


        -- countdown
        local countdownText = ""

        local countdownOptions = 
        
            {
                text = countdownText,
                width = appData.screenW - appData.margin*2 - appData.actionMargin*2,
                font = appData.fonts.actionText,
                align = "center"
            }

        M.passengerCountdown = display.newText( countdownOptions )
        M.passengerCountdown.fill = appData.colors.infoText
        M.passengerCountdown.anchorX = 1
        M.passengerCountdown.anchorY = 0
        M.passengerCountdown.x = appData.contentW - display.screenOriginX - appData.actionMargin
        M.passengerCountdown.y = 50
        M.pickUpGroup:insert( M.passengerCountdown ) 
    end     
end


return M