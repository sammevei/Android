local composer = require( "composer" )
local widget = require( "widget" )
local appData = require( "misc.appData" )
-- local optionsWidth = (appData.screenW/4)*3
local optionsWidth = appData.screenW
local optionsLine = 1
local optionsTabHeight = 35

local M = {}
-- ----------------------------------------------------------------------------------------------
-- TOP MENU
-- ----------------------------------------------------------------------------------------------
-- Background
M.showBackground = function()
    M.shade = display.newRect( display.screenOriginY + 35, 0, appData.screenW, appData.screenH*2 )
    M.shade.fill = appData.colors.actionBackground
    M.shade.alpha = 0
    M.shade.x = appData.contentW/2
    M.shade.y = appData.contentH/2
    M.sceneGroup:insert(  M.shade )

    M.background = display.newRect( display.screenOriginY + 35, 0, optionsWidth, appData.screenH )
    M.background.fill = appData.colors.actionBackground
    M.background.anchorX = 0
    M.background.x = 0 + display.screenOriginX
    M.background.y = display.screenOriginY + appData.contentH/2 + 100 + 35
    M.background.alpha = 1
    M.sceneGroup:insert(  M.background )
end

M.showUser = function()
    M.userTab = display.newGroup()
    M.userTab.y = display.screenOriginY + 35 + optionsLine
    M.sceneGroup:insert(  M.userTab )

    -- Background
    local userBackground = display.newRect( 0, 0, optionsWidth, optionsTabHeight*2 )
    userBackground.fill = appData.colors.actionBackground
    userBackground.anchorX = 0
    userBackground.anchorY= 0
    userBackground.x = 0 + display.screenOriginX
    userBackground.y = 0 + optionsTabHeight*2 * 0
    userBackground.alpha = 1
    M.userTab:insert( userBackground ) 

    local topLine = display.newRect( 0, 0, optionsWidth, optionsLine )
    topLine.fill = appData.colors.divisionLine
    topLine.anchorX = 0
    topLine.anchorY= 0
    topLine.x = 0 + display.screenOriginX
    topLine.y = 0
    M.userTab:insert( topLine )    

    local bottomLine = display.newRect( 0, 0, optionsWidth, optionsLine )
    bottomLine.fill = appData.colors.divisionLine
    bottomLine.anchorX = 0
    bottomLine.anchorY= 0
    bottomLine.x = 0 + display.screenOriginX
    bottomLine.y = optionsTabHeight*2
    M.userTab:insert( bottomLine )   

    -- Photo
    local portrait = display.newImageRect( "images/portrait.png", 50, 50 )
    portrait.anchorX = 0
    portrait.anchorY = 0
    portrait.x = 0 + appData.margin + display.screenOriginX
    portrait.y = 10
    M.userTab:insert(portrait)
    

    local portraitMask = graphics.newMask( "images/portraitMask.png" )

    portrait:setMask( portraitMask )
    portrait.maskScaleX = 0.2
    portrait.maskScaleY = 0.2

    -- Name
    local nameOptions = 
    {
        text = appData.user.firstName.."\n"..appData.user.lastName,
        width = (appData.screenW/4)*2,
        font = appData.fonts.actionText,
    }

    local nameText = display.newText( nameOptions )
    nameText.fill = appData.colors.actionText
 
    nameText.anchorX = 0
    nameText.anchorY = 0
    nameText.x = appData.contentW/4 + display.screenOriginX
    nameText.y = 20
    M.userTab:insert( nameText )
end

-- Show Settings
M.showSettings = function()
    M.settingsTab = display.newGroup()
    M.settingsTab.y = display.screenOriginY + 35 + optionsTabHeight * 2
    M.sceneGroup:insert(  M.settingsTab )

    -- Background
    local userBackground = display.newRect( 0, 0, optionsWidth, optionsTabHeight )
    userBackground.fill = appData.colors.actionBackground
    userBackground.anchorX = 0
    userBackground.anchorY= 0
    userBackground.x = 0 + display.screenOriginX
    userBackground.y = 0
    userBackground.alpha = 1
    M.settingsTab:insert( userBackground ) 

    local topLine = display.newRect( 0, 0, optionsWidth, optionsLine )
    topLine.fill = appData.colors.divisionLine
    topLine.anchorX = 0
    topLine.anchorY= 0
    topLine.x = 0 + display.screenOriginX
    topLine.y = 0
    topLine.alpha = 1
    M.settingsTab:insert( topLine )    

    local bottomLine = display.newRect( 0, 0, optionsWidth, optionsLine )
    bottomLine.fill = appData.colors.divisionLine
    bottomLine.anchorX = 0
    bottomLine.anchorY= 0
    bottomLine.x = 0 + display.screenOriginX
    bottomLine.y = optionsTabHeight
    bottomLine.alpha = 1
    M.settingsTab:insert( bottomLine )   

    -- Name
    local addressesOptions = 
    {
        text = "SETTINGS",
        -- width = (appData.screenW/4)*2,
        font = appData.fonts.actionText,
    }

    M.addressesText = display.newText( addressesOptions )
    M.addressesText.fill = appData.colors.actionText
 
    M.addressesText.anchorX = 0
    M.addressesText.anchorY = 0
    M.addressesText.x = 0 + appData.margin + display.screenOriginX
    M.addressesText.y = 10
    M.settingsTab:insert( M.addressesText )
end

-- Show Car
M.showCar = function()
    M.carTab = display.newGroup()
    M.carTab.y = display.screenOriginY + 35 + optionsTabHeight * 3
    M.sceneGroup:insert(  M.carTab )

    -- Background
    M.carBackground = display.newRect( 5, 0, optionsWidth, optionsTabHeight - 10)
    M.carBackground.fill = appData.colors.actionBackground
    M.carBackground.anchorX = 0
    M.carBackground.anchorY= 0
    M.carBackground.x = 0 + display.screenOriginX
    M.carBackground.y = 0
    M.carBackground.alpha = 1
    M.carTab:insert( M.carBackground ) 

    local topLine = display.newRect( 0, 0, optionsWidth, optionsLine )
    topLine.fill = appData.colors.divisionLine
    topLine.anchorX = 0
    topLine.anchorY= 0
    topLine.x = 0 + display.screenOriginX
    topLine.y = 0
    topLine.alpha = 1
    M.carTab:insert( topLine )    

    local bottomLine = display.newRect( 0, 0, optionsWidth, optionsLine )
    bottomLine.fill = appData.colors.divisionLine
    bottomLine.anchorX = 0
    bottomLine.anchorY= 0
    bottomLine.x = 0 + display.screenOriginX
    bottomLine.y = optionsTabHeight
    M.carTab:insert( bottomLine )   

    -- Name
    local settingsOptions = 
    {
        text = "CAR",
        -- width = (appData.screenW/4)*2,
        font = appData.fonts.actionText,
    }

    M.carText = display.newText( settingsOptions )
    M.carText.fill = appData.colors.actionText
 
    M.carText.anchorX = 0
    M.carText.anchorY = 0
    M.carText.x = 0 + appData.margin + display.screenOriginX
    M.carText.y = 10
    M.carTab:insert( M.carText )
end

-- Show Logout
M.showLogout = function()
    M.logoutTab = display.newGroup()
    M.logoutTab.y = display.screenOriginY + 35 + optionsTabHeight * 4
    M.sceneGroup:insert(  M.logoutTab )

    -- Background
    M.logoutBackground = display.newRect( 5, 0, optionsWidth, optionsTabHeight - 10)
    M.logoutBackground.fill = appData.colors.actionBackground
    M.logoutBackground.anchorX = 0
    M.logoutBackground.anchorY= 0
    M.logoutBackground.x = 0 + display.screenOriginX
    M.logoutBackground.y = 0
    M.logoutBackground.alpha = 0.01
    M.logoutTab:insert( M.logoutBackground ) 

    local topLine = display.newRect( 0, 0, optionsWidth, optionsLine )
    topLine.fill = appData.colors.divisionLine
    topLine.anchorX = 0
    topLine.anchorY= 0
    topLine.x = 0 + display.screenOriginX
    topLine.y = 0
    topLine.alpha = 1
    M.logoutTab:insert( topLine )    

    local bottomLine = display.newRect( 0, 0, optionsWidth, optionsLine )
    bottomLine.fill = appData.colors.divisionLine
    bottomLine.anchorX = 0
    bottomLine.anchorY= 0
    bottomLine.x = 0 + display.screenOriginX
    bottomLine.y = optionsTabHeight
    M.logoutTab:insert( bottomLine )   

    -- Name
    local settingsOptions = 
    {
        text = "LOG OUT",
        -- width = (appData.screenW/4)*2,
        font = appData.fonts.actionText,
    }

    M.logoutText = display.newText( settingsOptions )
    M.logoutText.fill = appData.colors.actionText
 
    M.logoutText.anchorX = 0
    M.logoutText.anchorY = 0
    M.logoutText.x = 0 + appData.margin + display.screenOriginX
    M.logoutText.y = 10
    M.logoutTab:insert( M.logoutText )
end

-- Show Buttons
M.showButtons = function()
    
    -- Options Icon
    M.optionsIcon = display.newImageRect( "images/settings.png", 90, 35 )
    M.optionsIcon.x = -5
    M.optionsIcon.y = 0 + display.screenOriginY
    M.optionsIcon.anchorX = 0
    M.optionsIcon.anchorY = 0
    M.optionsIcon.alpha = 0.0
    M.sceneGroup:insert( M.optionsIcon )  
end

-- ----------------------------------------------------------------------------------------------
-- SETTINGS
-- ----------------------------------------------------------------------------------------------
 
M.showSettingsMenu = function()

    -- setup
    M.settingsGroup = display.newGroup()
    M.sceneGroup:insert( M.settingsGroup )
    M.settingsGroup.alpha = 1

    M.settingsGroup.anchorX = 0.5
    M.settingsGroup.anchorY = 0
    M.settingsGroup.y = display.screenOriginY + 200

    -- Background ------------------------------------------------------------------------------
    M.tripChangeBackground = display.newRect( 0, -20, appData.screenW, 150 )
    M.tripChangeBackground.fill = appData.colors.actionBackground
    M.tripChangeBackground.anchorX = 0.5
    M.tripChangeBackground.anchorY = 0
    M.tripChangeBackground.x = appData.contentW/2
    M.settingsGroup:insert( M.tripChangeBackground ) 

    --  Departure Background -------------------------------------------------------------------
    M.departureFieldBackground = display.newRoundedRect(
        appData.contentW/2, 0, 
        appData.screenW - appData.actionMargin*2, 30, 
        appData.actionCorner/2 
    )

    M.departureFieldBackground.fill = appData.colors.actionText
    M.departureFieldBackground.y = 0
    M.settingsGroup:insert( M.departureFieldBackground )

        -- Departure Field -------------------------------------------------------------------------

    M.departureField = native.newTextField( 
        appData.contentW/2, 0, 
        appData.screenW - appData.actionMargin*2, 30 
    )
  
    local placeholder = ""

    if appData.addresses.home.name ~= nil then
        placeholder = appData.addresses.home.name
    end
    

    M.departureField.font = appData.fonts.actionText
    M.departureField.placeholder = placeholder
    M.departureField.text = ""
    M.departureField.align = "left"
    M.departureField.hasBackground = false
    M.departureField.y = 5
    M.settingsGroup:insert( M.departureField )

    --  Destination Background -----------------------------------------------------------------
    M.destinationFieldBackground = display.newRoundedRect(
        appData.contentW/2, 0, 
        appData.screenW - appData.actionMargin*2, 30, 
        appData.actionCorner/2 
    )

    M.destinationFieldBackground.fill = appData.colors.actionText
    M.destinationFieldBackground.y = 45
    M.settingsGroup:insert( M.destinationFieldBackground )

    -- Destination Field -----------------------------------------------------------------------

    M.destinationField = native.newTextField( 
        appData.contentW/2, 0, 
        appData.screenW - appData.actionMargin*2, 30
    )

    local placeholder = ""

    if appData.addresses.work.name ~= nil then
        placeholder = appData.addresses.work.name
    end    
    
    M.destinationField.font = appData.fonts.actionText
    M.destinationField.placeholder = placeholder
    M.destinationField.text = ""
    M.destinationField.align = "left"
    M.destinationField.hasBackground = false
    M.destinationField.y = 50
    M.settingsGroup:insert( M.destinationField )


    -- ---------------------------------------------------------------------------------------------------
    -- MORNING
    -- ---------------------------------------------------------------------------------------------------

    -- Morning Time Background -------------------------------------------------------------------------
    M.morningTimeBackground = display.newRoundedRect(0, 0, 60, 30, appData.actionCorner/2 )
    M.morningTimeBackground.fill = appData.colors.actionText
    M.morningTimeBackground.anchorX = 1
    M.morningTimeBackground.anchorY = 0
    M.morningTimeBackground.x = appData.screenW - appData.actionMargin - 110
    M.morningTimeBackground.y = 75
    M.settingsGroup:insert( M.morningTimeBackground )


    -- Morning Text -------------------------------------------------------------------------------
    local morningOptions = 
    {
        text = "Morning",
        font = appData.fonts.actionText,
    }

    M.morning = display.newText( morningOptions )
    M.morning.fill = appData.colors.actionText
    M.morning.anchorX = 0
    M.morning.anchorY = 0
    M.morning.x = appData.actionMargin
    M.morning.y = 80
    M.settingsGroup:insert( M.morning ) 

    -- Morning Time Text -------------------------------------------------------------------------------
    local morningTimeOptions = 
    {
        text = appData.user.morningTime,
        font = appData.fonts.actionText,
    }

    M.morningTime = display.newText( morningTimeOptions )
    M.morningTime.fill = appData.colors.fieldText
    M.morningTime.anchorX = 1
    M.morningTime.anchorY = 0
    M.morningTime.x = appData.screenW - appData.actionMargin - 120
    M.morningTime.y = 80
    M.settingsGroup:insert( M.morningTime )   

    -- Mornig Tolerance Background --------------------------------------------------------------------
    M.morningToleranceBackground = display.newRoundedRect(0, 0, 95, 30, appData.actionCorner/2)
    M.morningToleranceBackground.fill = appData.colors.actionText
    M.morningToleranceBackground.anchorX = 1
    M.morningToleranceBackground.anchorY = 0
    M.morningToleranceBackground.x = appData.screenW - appData.actionMargin
    M.morningToleranceBackground.y = 75    
    M.settingsGroup:insert( M.morningToleranceBackground )
    
    -- Morning Tolerance Text --------------------------------------------------------------------------
    local morningToleranceOptions = 
    {
        text = tostring(appData.user.morningFlexibility/60).." min",
        font = appData.fonts.actionText,
    }

    M.morningTolerance = display.newText( morningToleranceOptions )
    M.morningTolerance.fill = appData.colors.fieldText
 
    M.morningTolerance.anchorX = 1
    M.morningTolerance.anchorY = 0
    M.morningTolerance.x = appData.screenW - appData.actionMargin - 30
    M.morningTolerance.y = 80
    M.settingsGroup:insert( M.morningTolerance ) 

    -- ---------------------------------------------------------------------------------------------------
    -- AFTERNOON
    -- ---------------------------------------------------------------------------------------------------

    -- Afternoon Time ------------------------------------------------------------------------------------
    local afternoonOptions = 
    {
        text = "Afternoon",
        font = appData.fonts.actionText,
    }

    M.afternoon = display.newText( afternoonOptions )
    M.afternoon.fill = appData.colors.actionText
    M.afternoon.anchorX = 0
    M.afternoon.anchorY = 0
    M.afternoon.x = appData.actionMargin
    M.afternoon.y = 125
    M.settingsGroup:insert( M.afternoon )  

    -- Afternoon Time Background -------------------------------------------------------------------------
    M.afternoonTimeBackground = display.newRoundedRect(0, 0, 60, 30, appData.actionCorner/2 )
    M.afternoonTimeBackground.fill = appData.colors.actionText
    M.afternoonTimeBackground.anchorX = 1
    M.afternoonTimeBackground.anchorY = 0
    M.afternoonTimeBackground.x = appData.screenW - appData.actionMargin - 110
    M.afternoonTimeBackground.y = 120
    M.settingsGroup:insert( M.afternoonTimeBackground )

    -- Afternoon Time Text -------------------------------------------------------------------------------
    local afternoonTimeOptions = 
    {
        text = appData.user.afternoonTime,
        font = appData.fonts.actionText,
    }

    M.afternoonTime = display.newText( afternoonTimeOptions )
    M.afternoonTime.fill = appData.colors.fieldText
    M.afternoonTime.anchorX = 1
    M.afternoonTime.anchorY = 0
    M.afternoonTime.x = appData.screenW - appData.actionMargin - 120
    M.afternoonTime.y = 125
    M.settingsGroup:insert( M.afternoonTime )   

    -- Mornig Tolerance Background --------------------------------------------------------------------
    M.afternoonToleranceBackground = display.newRoundedRect(0, 0, 95, 30, appData.actionCorner/2)
    M.afternoonToleranceBackground.fill = appData.colors.actionText
    M.afternoonToleranceBackground.anchorX = 1
    M.afternoonToleranceBackground.anchorY = 0
    M.afternoonToleranceBackground.x = appData.screenW - appData.actionMargin
    M.afternoonToleranceBackground.y = 120    
    M.settingsGroup:insert( M.afternoonToleranceBackground )
    
    -- Morning Tolerance Text --------------------------------------------------------------------------
    local afternoonToleranceOptions = 
    {
        text = tostring(appData.user.afternoonFlexibility/60).." min",
        font = appData.fonts.actionText,
    }

    M.afternoonTolerance = display.newText( afternoonToleranceOptions )
    M.afternoonTolerance.fill = appData.colors.fieldText
 
    M.afternoonTolerance.anchorX = 1
    M.afternoonTolerance.anchorY = 0
    M.afternoonTolerance.x = appData.screenW - appData.actionMargin - 30
    M.afternoonTolerance.y = 125
    M.settingsGroup:insert( M.afternoonTolerance ) 

    -- Role Background --------------------------------------------------------------------
    M.roleBackground = display.newRoundedRect(0, 0, 95, 30, appData.actionCorner/2)
    M.roleBackground.fill = appData.colors.actionText
    M.roleBackground.anchorX = 1
    M.roleBackground.anchorY = 0
    M.roleBackground.x = appData.screenW - appData.actionMargin
    M.roleBackground.y = 165    
    M.settingsGroup:insert( M.roleBackground )
    
    -- Role Text --------------------------------------------------------------------------
    local myRole = appData.user.mode

    local roleOptions = 
    {
        text = myRole,
        font = appData.fonts.actionText,
    }

    M.role = display.newText( roleOptions )
    M.role.fill = appData.colors.fieldText
 
    M.role.anchorX = 1
    M.role.anchorY = 0
    M.role.x = appData.screenW - appData.actionMargin - 30
    M.role.y = 170
    M.settingsGroup:insert( M.role ) 
end

-- GOOGLE PLACES --------------------------------------------------------------------------------

M.showWheels = function()
    -- White Background
    M.whiteBackground = display.newRect( 
        0, 0+display.screenOriginY, appData.screenW, appData.screenH+200 )
    M.whiteBackground.fill = appData.colors.infoBackround
    M.whiteBackground.x = appData.contentW/2
    M.whiteBackground.y = appData.contentH/2 -200
    M.whiteBackground.alpha = 0
    M.settingsGroup:insert( M.whiteBackground )

    -- ---------------------------------------------------------------------------
    -- Morning Wheels
    -- ---------------------------------------------------------------------------

    local morningTimeWheelData =
    {
        {
            align = "left",
            width = 1,
            labelPadding = 0,
            startIndex = 1,
            labels = { "" }
        },

        {
            align = "right",
            width = appData.contentW/2,
            labelPadding = 0,
            startIndex = 3,
            labels = { 
                "05", "06", "07", "08", "09", "10"
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
            width = appData.screenW/2,
            labelPadding = 0,
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
    M.morningTimeWheel = widget.newPickerWheel(
    {
        x = 0,
        top = 0,
        style = "resizable",
        width = appData.screenW,
        height = appData.screenW,
        rowHeight = 30,
        font = appData.fonts.actionText,
        fontSize = 14,
        columns = morningTimeWheelData
    }) 
    
    M.morningTimeWheel.anchorX = 0
    M.morningTimeWheel.x = 0
    M.morningTimeWheel.y = -3000
    M.settingsGroup:insert( M.morningTimeWheel ) 

    -- Transport Tolerance Wheel

    local morningToleranceWheelData =
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
                "10 min", "15 min", "20 min", "25 min", "30 min", "35 min", "40 min", "45 min", "50 min", "55 min", "60 min"
            }
        }
    }
     
    -- Create the widget
    M.morningToleranceWheel = widget.newPickerWheel(
    {
        x = 0,
        top = 0,
        style = "resizable",
        width = appData.screenW*2,
        height = appData.screenW,
        rowHeight = 30,
        font = appData.fonts.actionText,
        fontSize = 14,
        columns = morningToleranceWheelData
    }) 
    
    M.morningToleranceWheel.anchorX = 0
    M.morningToleranceWheel.x = 0
    M.morningToleranceWheel.y = -3000
    M.settingsGroup:insert( M.morningToleranceWheel ) 

    -- Transport Role Button

    local roleWheelData =
    {
        {
            align = "left",
            width = 1,
            startIndex = 1,
            labels = { "" }
        },

        {
            align = "left",
            labelPadding = 0,
            width = appData.contentW,
            startIndex = 1,
            labels = { "passenger", "driver" }
        }
    }
    
    -- ---------------------------------------------------------------------------
    -- Afternoon Wheels
    -- ---------------------------------------------------------------------------

    local afternoonTimeWheelData =
    {
        {
            align = "left",
            width = 1,
            labelPadding = 0,
            startIndex = 1,
            labels = { "" }
        },

        {
            align = "right",
            width = appData.screenW/2 - 5,
            labelPadding = 0,
            startIndex = 3,
            labels = { 
                "14", "15","16", "17"
            }
        },

        {
            align = "center",
            width = 5,
            labelPadding = 0,
            startIndex = 1,
            labels = { ":" }
        },

        {
            align = "left",
            labelPadding = 0,
            width = appData.screenW/2,
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
    M.afternoonTimeWheel = widget.newPickerWheel(
    {
        x = 0,
        top = 0,
        style = "resizable",
        width = appData.screenW*2,
        height = appData.screenW,
        rowHeight = 30,
        font = appData.fonts.actionText,
        fontSize = 14,
        columns = afternoonTimeWheelData
    }) 
    
    M.afternoonTimeWheel.anchorX = 0
    M.afternoonTimeWheel.x = 0
    M.afternoonTimeWheel.y = -3000
    M.settingsGroup:insert( M.afternoonTimeWheel ) 

    -- Afternoon Tolerance Wheel

    local afternoonToleranceWheelData =
    {
        {
            align = "left",
            width = 1,
            startIndex = 1,
            labels = { "" }
        },

        {
            align = "center",
            labelPadding = 0,
            width = appData.contentW,
            startIndex = 5,
            labels = { 
                "10 min", "15 min", "20 min", "25 min", "30 min", "35 min", "40 min", "45 min", "50 min", "55 min", "60 min"
            }
        }
    }
     
    -- Create the widget
    M.afternoonToleranceWheel = widget.newPickerWheel(
    {
        x = 0,
        top = 0,
        style = "resizable",
        width = appData.contentW,
        height = appData.screenW,
        rowHeight = 30,
        font = appData.fonts.actionText,
        fontSize = 14,
        columns = afternoonToleranceWheelData
    }) 
    
    M.afternoonToleranceWheel.anchorX = 0
    M.afternoonToleranceWheel.x = 0
    M.afternoonToleranceWheel.y = -3000
    M.settingsGroup:insert( M.afternoonToleranceWheel ) 

    -- ----------------------------------------------------------------------------
    -- Role Wheel
    -- ----------------------------------------------------------------------------

    local roleWheelData =
    {
        {
            align = "left",
            width = 1,
            startIndex = 1,
            labels = { "" }
        },

        {
            align = "center",
            labelPadding = 0,
            width = appData.contentW,
            startIndex = 1,
            labels = { "passenger", "driver" }
        }
    }

    -- Create the widget
    M.roleWheel = widget.newPickerWheel(
    {
        x = 0,
        top = 0,
        style = "resizable",
        width = appData.screenW*2,
        height = appData.screenW,
        rowHeight = 30,
        font = appData.fonts.actionText,
        fontSize = 14,
        columns = roleWheelData
    }) 
    
    M.roleWheel.anchorX = 0
    M.roleWheel.x = 0
    M.roleWheel.y = -3000
    M.settingsGroup:insert( M.roleWheel ) 

    -- Wheel Button 
    M.wheelButton = widget.newButton(
        {
            left = 0,
            top = 0,
            shape = "roundedRect",
            width = 60,
            height = 20,
            cornerRadius = 2.5,
            label = "CONFIRM",
            fontSize = 12,
            labelColor = { default=appData.colors.confirmButtonFillOver, 
                           over=appData.colors.actionComment 
                         },
            fillColor = { default=appData.colors.actionText, 
                          over=appData.colors.actionText
                        },
            strokeColor = { default=appData.colors.confirmButtonFillOver, 
                           over=appData.colors.actionComment 
                        },

            strokeWidth = 1   
        } 
    )

    M.wheelButton.anchorX = 1
    M.wheelButton.anchorY = 0.5 
    M.wheelButton.x = appData.contentW - display.screenOriginX - 23
    M.wheelButton.y = 230
    M.wheelButton.alpha = 0
    M.settingsGroup:insert( M.wheelButton )      
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
            width = appData.screenW - appData.actionMargin*2,
            onRowRender = departureSearchResultsRowRender,
            noLines = true
        }
    )

    M.departureSearchResults.anchorY = 0
    M.departureSearchResults.anchorX = 0.5
    M.departureSearchResults.x = appData.contentW/2
    M.departureSearchResults.y = 15
    M.settingsGroup:insert( M.departureSearchResults )
     
    -- Insert Rows
    for i = 1, 3 do
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
            width = appData.screenW - appData.actionMargin*2,
            onRowRender = destinationSearchResultsRowRender,
            noLines = true
        }
    )

    M.destinationSearchResults.anchorY = 0
    M.destinationSearchResults.anchorX = 0.5
    M.destinationSearchResults.x = appData.contentW/2
    M.destinationSearchResults.y = 60
    M.settingsGroup:insert( M.destinationSearchResults )
     
    -- Insert Rows
    for i = 1, 3 do
        -- Insert a row into the tableView
        M.destinationSearchResults:insertRow{}
    end
end

-- ----------------------------------------------------------------------------------------------
-- CAR
-- ----------------------------------------------------------------------------------------------
M.showCarMenu = function(event)
    M.carGroup = display.newGroup()

    -- Info Text
    local infoOptions = 
    {
        text = "Details about your car:",
        width = appData.screenW - appData.margin*2 - appData.actionMargin*2,
        font = appData.fonts.actionText,
    }

    M.infoText = display.newText( infoOptions )
    M.infoText.fill = appData.colors.actionText
 
    M.infoText.anchorX = 0.5
    M.infoText.anchorY = 0
    M.infoText.x = appData.contentW/2
    M.infoText.y = 55
    M.carGroup:insert( M.infoText )

  --  Brand ------------------------------------------------------------
    M.factoryFieldBackground = display.newRoundedRect(
        appData.contentW/2, 
        100, 
        appData.screenW - appData.margin*2 - appData.actionMargin*2, 
        30, 
        appData.actionCorner/2 
    )
    M.factoryFieldBackground.fill = appData.colors.actionText
    M.carGroup:insert( M.factoryFieldBackground )

    M.factoryField = native.newTextField( 
        appData.contentW/2, 
        100, 
        appData.screenW - appData.margin*2 - appData.actionMargin*2, 
        30 
    )
  
    M.factoryField.font = appData.fonts.actionText
    if (appData.car.make == "") then
        M.factoryField.placeholder = "Brand"
    else
        M.factoryField.placeholder = ""
        M.factoryField.text = appData.car.make
    end          
    M.factoryField.align = "left"
    M.factoryField.hasBackground = false
    M.carGroup:insert( M.factoryField )

  --  Model ------------------------------------------------------------
    M.modelFieldBackground = display.newRoundedRect(
        appData.contentW/2, 
        30 + 10 + 100, 
        appData.screenW - appData.margin*2 - appData.actionMargin*2, 
        30, 
        appData.actionCorner/2 
    )
    M.modelFieldBackground.fill = appData.colors.actionText
    M.carGroup:insert( M.modelFieldBackground )

    M.modelField = native.newTextField( 
        appData.contentW/2, 
        30 + 10 + 100, 
        appData.screenW - appData.margin*2 - appData.actionMargin*2, 
        30 
    )
    
    M.modelField.font = appData.fonts.actionText
    if (appData.car.model == "") then
        M.modelField.placeholder = "Model"
    else
        M.modelField.placeholder = ""
        M.modelField.text = appData.car.model
    end   
    M.modelField.align = "left"
    M.modelField.hasBackground = false
    M.carGroup:insert( M.modelField )

    -- Comment Text --------------------------------------------------
    local commentOptions = 
    {
        text = "",
        width = appData.screenW - appData.margin*2 - appData.actionMargin*2,
        font = appData.fonts.actionComment,
    }

    M.commentText = display.newText( commentOptions )
    M.commentText.fill = appData.colors.actionComment
 
    M.commentText.anchorX = 0.5
    M.commentText.anchorY = 0
    M.commentText.x = appData.contentW/2
    M.commentText.y = display.screenOriginY + 165
    M.carGroup:insert( M.commentText )

    -- CAR COLOR + PLATE ===================================================
    --  Color ----------------------------------------------------------
    M.colorFieldBackground = display.newRoundedRect(
        appData.contentW/2, 
        180, 
        appData.screenW - appData.margin*2 - appData.actionMargin*2, 
        30, 
        appData.actionCorner/2 
    )
    M.colorFieldBackground.fill = appData.colors.actionText
    M.carGroup:insert( M.colorFieldBackground )

    M.colorField = native.newTextField( 
        appData.contentW/2, 
        180, 
        appData.screenW - appData.margin*2 - appData.actionMargin*2, 
        30 
    )
  
    M.colorField.font = appData.fonts.actionText
    if (appData.car.color == "") then
        M.colorField.placeholder = "Car color"
    else
        M.colorField.placeholder = ""
        M.colorField.text = appData.car.color
    end          
    M.colorField.align = "left"
    M.colorField.hasBackground = false
    M.carGroup:insert( M.colorField )

  --  Plate ------------------------------------------------------------
    M.plateFieldBackground = display.newRoundedRect(
        appData.contentW/2, 
        30  + 190, 
        appData.screenW - appData.margin*2 - appData.actionMargin*2, 
        30, 
        appData.actionCorner/2 
    )
    M.plateFieldBackground.fill = appData.colors.actionText
    M.carGroup:insert( M.plateFieldBackground )

    M.plateField = native.newTextField( 
        appData.contentW/2, 
        30  + 190, 
        appData.screenW - appData.margin*2 - appData.actionMargin*2, 
        30 
    )
    
    M.plateField.font = appData.fonts.actionText
    if (appData.car.license_plate == "") then
        M.plateField.placeholder = "Car license plate"
    else
        M.plateField.placeholder = ""
        M.plateField.text = appData.car.license_plate
    end   
    M.plateField.align = "left"
    M.plateField.hasBackground = false
    M.carGroup:insert( M.plateField )

    -- CAR TYPE ======================================================

    local petrolSwitchState = false
    local dieselSwitchState = false
    local electricSwitchState = false

    if (appData.car.vehicle_engine_type_id == "1") then petrolSwitchState = true
    elseif (appData.car.vehicle_engine_type_id == "2") then dieselSwitchState = true     
    elseif (appData.car.vehicle_engine_type_id == "5") then electricSwitchState = true 
    end    


    --  Logic ----------------------------------------------------------------------------------
    local petrolSwitchPress = function(event)
        if (event.target.isOn == true) then
            M.dieselSwitch:setState( { isOn=false } )
            M.electricSwitch:setState( { isOn=false } )
        else 
            M.dieselSwitch:setState( { isOn=true } )        
        end
        return true
    end

    -- 

    M.petrolSwitch = widget.newSwitch(
        {
            left = display.screenOriginX - 5,
            top = 70+160,
            id = "petrolSwitch",
            style = "onOff",
            initialSwitchState = petrolSwitchState,
            onRelease = petrolSwitchPress
        }
    )

    M.petrolSwitch.anchorY = 0
    M.petrolSwitch.anchorX = 0
    M.petrolSwitch:scale(0.6, 0.6)
    M.carGroup:insert( M.petrolSwitch )

    --

    local petrolTextOptions = 
    {
        text = "Petrol",
        font = appData.fonts.actionText,
    }

    M.petrolText = display.newText( petrolTextOptions )
    M.petrolText.fill = appData.colors.actionText
 
    M.petrolText.anchorX = 0
    M.petrolText.anchorY = 1
    M.petrolText.x = display.screenOriginX + 70
    M.petrolText.y = 110+160
    M.carGroup:insert( M.petrolText )

    -- Diesel -------------------------------------------------------------------------------
    local dieselSwitchPress = function(event)
        if (event.target.isOn == true) then
            M.petrolSwitch:setState( { isOn=false } )
            M.electricSwitch:setState( { isOn=false } )
        else 
            M.petrolSwitch:setState( { isOn=true } )
        end
        return true
    end

    -- 

    M.dieselSwitch = widget.newSwitch(
        {
            left = display.screenOriginX - 5,
            top = 110+150,
            id = "dieselSwitch",
            style = "onOff",
            initialSwitchState = dieselSwitchState,
            onRelease = dieselSwitchPress
        }
    )

    M.dieselSwitch.anchorY = 0
    M.dieselSwitch.anchorX = 0
    M.dieselSwitch:scale(0.6, 0.6)
    M.carGroup:insert( M.dieselSwitch )

    local dieselTextOptions = 
    {
        text = "Diesel",
        font = appData.fonts.actionText,
    }

    M.dieselText = display.newText( dieselTextOptions )
    M.dieselText.fill = appData.colors.actionText
 
    M.dieselText.anchorX = 0
    M.dieselText.anchorY = 1
    M.dieselText.x = display.screenOriginX + 70
    M.dieselText.y = 150 + 150
    M.carGroup:insert( M.dieselText )
 
    -- Electric --------------------------------------------------------------------------------------
    local electricSwitchPress = function(event)
        if (event.target.isOn == true) then
            M.petrolSwitch:setState( { isOn=false } )
            M.dieselSwitch:setState( { isOn=false } )
        else 
            M.petrolSwitch:setState( { isOn=true } )            
        end
        return true
    end

    --     
    M.electricSwitch = widget.newSwitch(
        {
            left = display.screenOriginX - 5,
            top = 150+140,
            id = "electricSwitch",
            style = "onOff",
            initialSwitchState = electricSwitchState,
            onRelease = electricSwitchPress
        }
    )

    M.electricSwitch.anchorY = 0
    M.electricSwitch.anchorX = 0
    M.electricSwitch:scale(0.6, 0.6)
    M.carGroup:insert( M.electricSwitch )

    local electricTextOptions = 
    {
        text = "Electric",
        font = appData.fonts.actionText,
    }

    M.electricText = display.newText( electricTextOptions )
    M.electricText.fill = appData.colors.actionText
 
    M.electricText.anchorX = 0
    M.electricText.anchorY = 1
    M.electricText.x = display.screenOriginX + 70
    M.electricText.y = 190+140
    M.carGroup:insert( M.electricText ) 

    -- FINISH ========================================================

    M.carGroup.y = display.screenOriginY + 130
    M.sceneGroup:insert( M.carGroup )
end


-- ----------------------------------------------------------------------------------------------
-- APP INFO
-- ----------------------------------------------------------------------------------------------
M.showBottomMenu = function(event)
    M.bottomGroup = display.newGroup()

    -- Info Text
    local infoOptions = 
    {
        text = "App version: "..appData.system.appVersion,
        width = appData.screenW - appData.margin*2 - appData.actionMargin*2,
        font = appData.fonts.actionText,
        align = "center"
    }

    M.bottomText = display.newText( infoOptions )
    M.bottomText.fill = appData.colors.actionText
 
    M.bottomText.anchorX = 0.5
    M.bottomText.anchorY = 1
    M.bottomText.x = appData.contentW/2
    M.bottomText.y = appData.contentH - display.screenOriginY - 10
    M.bottomGroup:insert( M.bottomText )
    
    M.sceneGroup:insert( M.bottomGroup )
end

return M