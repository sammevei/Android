local composer = require( "composer" )
local widget = require( "widget" )
local appData = require( "misc.appData" )

widget.setTheme( "widget_theme_ios7" )

local M = {}

M.showBackground = function(event)
    M.background = display.newRect( 0, 0, appData.screenW, appData.screenH )
    M.background.fill = appData.colors.background
    M.background.x = appData.contentW/2
    M.background.y = appData.contentH/2
    M.sceneGroup:insert( M.background )
end

M.showMenu = function(event)

    local driverSwitchState = false
    local passengerSwitchState = false
    local bothSwitchState = false

    if (appData.user.mode == "driver") then driverSwitchState = true
    elseif (appData.user.mode == "passenger") then passengerSwitchState = true     
    elseif (appData.user.mode == "both") then bothSwitchState = true 
    end   

    M.postJourneyRideGroup = display.newGroup()

    --  Tab Background -----------------------------------------------------------------------------

    M.postTimeBackground = display.newRect( 0, 0, appData.screenW, appData.screenH )
    M.postTimeBackground.fill = appData.colors.actionBackground
    M.postTimeBackground.anchorY = 0
    M.postTimeBackground.x = appData.contentW/2
    M.postTimeBackground.y = 0
    M.postJourneyRideGroup:insert( M.postTimeBackground )

    -- Info Text ---------------------------------------------------------------------------------

    local infoOptions = 
    {
        text = "You are primary:",
        width = appData.screenW - appData.margin*2 - appData.actionMargin*2,
        font = appData.fonts.actionText,
    }

    M.infoText = display.newText( infoOptions )
    M.infoText.fill = appData.colors.actionText
 
    M.infoText.anchorX = 0.5
    M.infoText.anchorY = 0
    M.infoText.x = appData.contentW/2
    M.infoText.y = M.postTimeBackground.y + appData.actionMargin
    M.postJourneyRideGroup:insert( M.infoText )

  --  Driver ----------------------------------------------------------------------------------
    local driverSwitchPress = function(event)
        if (event.target.isOn == true) then
            M.passengerSwitch:setState( { isOn=false } )
            M.bothSwitch:setState( { isOn=false } )
        else 
            M.passengerSwitch:setState( { isOn=true } )        
        end
    end

    -- 

    M.driverSwitch = widget.newSwitch(
        {
            left = display.screenOriginX - 5,
            top = 40,
            id = "driverSwitch",
            style = "onOff",
            initialSwitchState = driverSwitchState,
            onRelease = driverSwitchPress
        }
    )

    M.driverSwitch.anchorY = 0
    M.driverSwitch.anchorX = 0
    M.driverSwitch:scale(0.6, 0.6)
    M.postJourneyRideGroup:insert( M.driverSwitch )

    --

    local driverTextOptions = 
    {
        text = "Driver",
        font = appData.fonts.actionText,
    }

    M.driverText = display.newText( driverTextOptions )
    M.driverText.fill = appData.colors.actionText
 
    M.driverText.anchorX = 0
    M.driverText.anchorY = 1
    M.driverText.x = display.screenOriginX + 70
    M.driverText.y = 75
    M.postJourneyRideGroup:insert( M.driverText )

    -- Passenger -------------------------------------------------------------------------------
    local passengerSwitchPress = function(event)
        if (event.target.isOn == true) then
            M.driverSwitch:setState( { isOn=false } )
            M.bothSwitch:setState( { isOn=false } )
        else 
            M.driverSwitch:setState( { isOn=true } )
        end
    end

    -- 

    M.passengerSwitch = widget.newSwitch(
        {
            left = display.screenOriginX - 5,
            top = 80,
            id = "passengerSwitch",
            style = "onOff",
            initialSwitchState = passengerSwitchState,
            onRelease = passengerSwitchPress
        }
    )

    M.passengerSwitch.anchorY = 0
    M.passengerSwitch.anchorX = 0
    M.passengerSwitch:scale(0.6, 0.6)
    M.postJourneyRideGroup:insert( M.passengerSwitch )

    local passengerTextOptions = 
    {
        text = "Passenger",
        font = appData.fonts.actionText,
    }

    M.passengerText = display.newText( passengerTextOptions )
    M.passengerText.fill = appData.colors.actionText
 
    M.passengerText.anchorX = 0
    M.passengerText.anchorY = 1
    M.passengerText.x = display.screenOriginX + 70
    M.passengerText.y = 115
    M.postJourneyRideGroup:insert( M.passengerText )
 
    -- Both --------------------------------------------------------------------------------------
    local bothSwitchPress = function(event)
        if (event.target.isOn == true) then
            M.driverSwitch:setState( { isOn=false } )
            M.passengerSwitch:setState( { isOn=false } )
        else 
            M.driverSwitch:setState( { isOn=true } )            
        end
    end

    --     
    M.bothSwitch = widget.newSwitch(
        {
            left = display.screenOriginX - 5,
            top = 120,
            id = "bothSwitch",
            style = "onOff",
            initialSwitchState = bothSwitchState,
            onRelease = bothSwitchPress
        }
    )

    M.bothSwitch.anchorY = 0
    M.bothSwitch.anchorX = 0
    M.bothSwitch:scale(0.6, 0.6)
    M.postJourneyRideGroup:insert( M.bothSwitch )
    M.bothSwitch.alpha = 0

    local bothTextOptions = 
    {
        text = "Both",
        font = appData.fonts.actionText,
    }

    M.bothText = display.newText( bothTextOptions )
    M.bothText.fill = appData.colors.actionText
 
    M.bothText.anchorX = 0
    M.bothText.anchorY = 1
    M.bothText.x = display.screenOriginX + 70
    M.bothText.y = 155
    M.postJourneyRideGroup:insert( M.bothText )  
    M.bothText.alpha = 0

    -- Comment Text
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
    M.commentText.y = M.postTimeBackground.y + appData.actionMargin + 165
    M.postJourneyRideGroup:insert( M.commentText )    
 
    

    -- Final Setup --------------------------------------------------------------------------------------
    M.postJourneyRideGroup.y = display.screenOriginY
    M.sceneGroup:insert( M.postJourneyRideGroup )
end

M.showButtons = function()
    -- Three Dots
    M.dot1 = display.newImageRect( "images/dot.png", 10, 10 )
    M.dot1.anchorX = 0.5
    M.dot1.anchorY = 1
    M.dot1.x = appData.contentW/2 - 20
    M.dot1.y = appData.contentH - 2*display.screenOriginY - appData.actionMargin-appData.margin
    M.dot1.alpha = 0.5
    M.postJourneyRideGroup:insert( M.dot1)

    M.dot2 = display.newImageRect( "images/dot.png", 10, 10 )
    M.dot2.anchorX = 0.5
    M.dot2.anchorY = 1
    M.dot2.x = appData.contentW/2
    M.dot2.y = appData.contentH - 2*display.screenOriginY - appData.actionMargin-appData.margin
    M.dot2.alpha = 0.5
    M.postJourneyRideGroup:insert( M.dot2)

    M.dot3 = display.newImageRect( "images/dot.png", 10, 10 )
    M.dot3.anchorX = 0.5
    M.dot3.anchorY = 1
    M.dot3.x = appData.contentW/2 + 20
    M.dot3.y = appData.contentH - 2*display.screenOriginY - appData.actionMargin-appData.margin
    M.dot3.alpha = 1
    M.postJourneyRideGroup:insert( M.dot3)

    -- Back Button
    M.backButton = widget.newButton(
        {
            width = 15,
            height = 15,
            defaultFile = "images/backB.png",
            overFile = "images/backB.png",
        }
    )

    M.backButton.anchorX = 0.0
    M.backButton.anchorY = 0.5
    M.backButton.x = display.screenOriginX + 23
    M.backButton.y = 230 
    M.backButton.alpha = 0
    M.postJourneyRideGroup:insert( M.backButton)
    
    -- Forward Button
    M.forwardButton = widget.newButton(
        {
            width = 45,
            height = 45,
            defaultFile = "images/fB.png",
            overFile = "images/fB.png",
        }
    )

    M.forwardButton.anchorX = 1.0
    M.forwardButton.anchorY = 1
    M.forwardButton.x = appData.contentW - display.screenOriginX - appData.actionMargin
    M.forwardButton.y = appData.contentH - 2*display.screenOriginY - appData.actionMargin
    M.postJourneyRideGroup:insert( M.forwardButton)

    M.sceneGroup:insert( M.postJourneyRideGroup)
end

return M