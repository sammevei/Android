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
    M.postJourneyRideBackground = display.newRect( 0, 0, appData.screenW, 150 )
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
    M.infoText.y = 0
    M.postJourneyRideGroup:insert( M.infoText )

  --  Car Factory Text Field
    M.factoryFieldBackground = display.newRoundedRect(
        appData.contentW/2, 
        35, 
        appData.screenW - appData.margin*2 - appData.actionMargin*2, 
        30, 
        appData.actionCorner/2 
    )
    M.factoryFieldBackground.fill = appData.colors.actionText
    M.postJourneyRideGroup:insert( M.factoryFieldBackground )

    M.factoryField = native.newTextField( 
        appData.contentW/2, 
        35, 
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
    M.postJourneyRideGroup:insert( M.factoryField )

  --  Car Model Text Field
    M.modelFieldBackground = display.newRoundedRect(
        appData.contentW/2, 
        75, 
        appData.screenW - appData.margin*2 - appData.actionMargin*2, 
        30, 
        appData.actionCorner/2 
    )
    M.modelFieldBackground.fill = appData.colors.actionText
    M.postJourneyRideGroup:insert( M.modelFieldBackground )

    M.modelField = native.newTextField( 
        appData.contentW/2, 
        75, 
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
    M.postJourneyRideGroup:insert( M.modelField )

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
    M.postJourneyRideGroup.y = display.screenOriginY + 35
    M.sceneGroup:insert( M.postJourneyRideGroup )
end

M.showButtons = function()
    -- Three Dots
    M.dot1 = display.newImageRect( "images/dot.png", 10, 10 )
    M.dot1.anchorX = 0.5
    M.dot1.anchorY = 1
    M.dot1.x = appData.contentW/2 - 20
    M.dot1.y = 120
    M.dot1.alpha = 1
    M.postJourneyRideGroup:insert( M.dot1)

    M.dot2 = display.newImageRect( "images/dot.png", 10, 10 )
    M.dot2.anchorX = 0.5
    M.dot2.anchorY = 1
    M.dot2.x = appData.contentW/2
    M.dot2.y = 120
    M.dot2.alpha = 0.5
    M.postJourneyRideGroup:insert( M.dot2)

    M.dot3 = display.newImageRect( "images/dot.png", 10, 10 )
    M.dot3.anchorX = 0.5
    M.dot3.anchorY = 1
    M.dot3.x = appData.contentW/2 + 20
    M.dot3.y = 120
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
    M.backButton.y = 120
    M.backButton.alpha = 0
    M.postJourneyRideGroup:insert( M.backButton)

    -- Forward Button
    M.forwardButton = widget.newButton(
        {
            width = 15,
            height = 15,
            defaultFile = "images/forwardB.png",
            overFile = "images/forwardB.png",
        }
    )

    M.forwardButton.anchorX = 1.0
    M.forwardButton.anchorY = 1
    M.forwardButton.x = appData.contentW - display.screenOriginX - appData.actionMargin - 5
    M.forwardButton.y = 125
    M.postJourneyRideGroup:insert( M.forwardButton)
end

return M