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

M.showJourneyMenu = function(event)

    local petrolSwitchState = false
    local dieselSwitchState = false
    local electricSwitchState = false

    if (appData.car.vehicle_engine_type_id == "1") then petrolSwitchState = true
    elseif (appData.car.vehicle_engine_type_id == "2") then dieselSwitchState = true     
    elseif (appData.car.vehicle_engine_type_id == "5") then electricSwitchState = true 
    end    

   	M.postJourneyRideGroup = display.newGroup()

  --  Tab Background
   	M.postJourneyRideBackground = display.newRect( 0, 0, appData.screenW, appData.screenH )
   	M.postJourneyRideBackground.fill = appData.colors.actionBackground
   	M.postJourneyRideBackground.anchorY = 0
   	M.postJourneyRideBackground.x = appData.contentW/2
   	M.postJourneyRideBackground.y = 0
   	M.postJourneyRideGroup:insert( M.postJourneyRideBackground )

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
	M.infoText.y = M.postJourneyRideBackground.y + appData.actionMargin
	M.postJourneyRideGroup:insert( M.infoText )

    --  Driver ----------------------------------------------------------------------------------
    local petrolSwitchPress = function(event)
        if (event.target.isOn == true) then
            M.dieselSwitch:setState( { isOn=false } )
            M.electricSwitch:setState( { isOn=false } )
        else 
            M.dieselSwitch:setState( { isOn=true } )        
        end
    end

    -- 

    M.petrolSwitch = widget.newSwitch(
        {
            left = display.screenOriginX - 5,
            top = 70,
            id = "petrolSwitch",
            style = "onOff",
            initialSwitchState = petrolSwitchState,
            onRelease = petrolSwitchPress
        }
    )

    M.petrolSwitch.anchorY = 0
    M.petrolSwitch.anchorX = 0
    M.petrolSwitch:scale(0.6, 0.6)
    M.postJourneyRideGroup:insert( M.petrolSwitch )

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
    M.petrolText.y = 110
    M.postJourneyRideGroup:insert( M.petrolText )

    -- Passenger -------------------------------------------------------------------------------
    local dieselSwitchPress = function(event)
        if (event.target.isOn == true) then
            M.petrolSwitch:setState( { isOn=false } )
            M.electricSwitch:setState( { isOn=false } )
        else 
            M.petrolSwitch:setState( { isOn=true } )
        end
    end

    -- 

    M.dieselSwitch = widget.newSwitch(
        {
            left = display.screenOriginX - 5,
            top = 110,
            id = "dieselSwitch",
            style = "onOff",
            initialSwitchState = dieselSwitchState,
            onRelease = dieselSwitchPress
        }
    )

    M.dieselSwitch.anchorY = 0
    M.dieselSwitch.anchorX = 0
    M.dieselSwitch:scale(0.6, 0.6)
    M.postJourneyRideGroup:insert( M.dieselSwitch )

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
    M.dieselText.y = 150
    M.postJourneyRideGroup:insert( M.dieselText )
 
    -- Both --------------------------------------------------------------------------------------
    local electricSwitchPress = function(event)
        if (event.target.isOn == true) then
            M.petrolSwitch:setState( { isOn=false } )
            M.dieselSwitch:setState( { isOn=false } )
        else 
            M.petrolSwitch:setState( { isOn=true } )            
        end
    end

    --     
    M.electricSwitch = widget.newSwitch(
        {
            left = display.screenOriginX - 5,
            top = 150,
            id = "electricSwitch",
            style = "onOff",
            initialSwitchState = electricSwitchState,
            onRelease = electricSwitchPress
        }
    )

    M.electricSwitch.anchorY = 0
    M.electricSwitch.anchorX = 0
    M.electricSwitch:scale(0.6, 0.6)
    M.postJourneyRideGroup:insert( M.electricSwitch )

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
    M.electricText.y = 190
    M.postJourneyRideGroup:insert( M.electricText ) 

    -- Comment Text
    --[[
    local commentOptions = 
	{
	    text = "(Dette kan forandres senere)",
	    width = appData.screenW - appData.margin*2 - appData.actionMargin*2,
	    font = appData.fonts.actionComment,
	}

	M.commentText = display.newText( commentOptions )
	M.commentText.fill = appData.colors.actionComment
 
	M.commentText.anchorX = 0.5
	M.commentText.anchorY = 0
	M.commentText.x = appData.contentW/2
	M.commentText.y = M.postJourneyRideBackground.y + appData.actionMargin + 165
	M.postJourneyRideGroup:insert( M.commentText ) 	
    --]]

    -- Finalize
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
end

return M