local composer = require( "composer" )
local widget = require( "widget" )
local appData = require( "misc.appData" )

local M = {}

M.showBackground = function(event)
    M.background = display.newRect( 0, 0, appData.screenW, appData.screenH )
    M.background.fill = appData.colors.background
    M.background.x = appData.contentW/2
    M.background.y = appData.contentH/2
    M.sceneGroup:insert( M.background )
end

M.showJourneyMenu = function(event)
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
	    text = "",
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

  --  Car Factory Text Field
  	M.colorFieldBackground = display.newRoundedRect(
  		appData.contentW/2, 
  		100, 
  		appData.screenW - appData.margin*2 - appData.actionMargin*2, 
  		30, 
  		appData.actionCorner/2 
  	)
  	M.colorFieldBackground.fill = appData.colors.actionText
  	M.postJourneyRideGroup:insert( M.colorFieldBackground )

    M.colorField = native.newTextField( 
    	appData.contentW/2, 
    	100, 
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
    -- M.colorField:resizeHeightToFitFont()
    M.colorField.hasBackground = false
    M.postJourneyRideGroup:insert( M.colorField )

  --  Destination Text Field
    M.plateFieldBackground = display.newRoundedRect(
  		appData.contentW/2, 
  		30 + 10 + 100, 
  		appData.screenW - appData.margin*2 - appData.actionMargin*2, 
  		30, 
  		appData.actionCorner/2 
  	)
  	M.plateFieldBackground.fill = appData.colors.actionText
  	M.postJourneyRideGroup:insert( M.plateFieldBackground )

    M.plateField = native.newTextField( 
    	appData.contentW/2, 
    	30 + 10 + 100, 
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
    M.postJourneyRideGroup:insert( M.plateField )

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
	M.commentText.y = M.postJourneyRideBackground.y + appData.actionMargin + 165
	M.postJourneyRideGroup:insert( M.commentText ) 	
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
    M.dot2.alpha = 1
    M.postJourneyRideGroup:insert( M.dot2)

    M.dot3 = display.newImageRect( "images/dot.png", 10, 10 )
    M.dot3.anchorX = 0.5
    M.dot3.anchorY = 1
    M.dot3.x = appData.contentW/2 + 20
    M.dot3.y = appData.contentH - 2*display.screenOriginY - appData.actionMargin-appData.margin
    M.dot3.alpha = 0.5
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