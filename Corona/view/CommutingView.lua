local composer = require( "composer" )
local widget = require( "widget" )
local appData = require( "misc.appData" )
local routines = require( "misc.appRoutines" )

local M = {}

M.showBackground = function(event)
    M.background = display.newRect( 0, 0, appData.screenW, appData.screenH )
    M.background.fill = appData.colors.background
    M.background.x = appData.contentW/2
    M.background.y = appData.contentH/2
    M.sceneGroup:insert( M.background )
end

M.showBar = function(event)
    M.commutingGroup = display.newGroup()

    --  Tab Background -----------------------------------------------------------------------------

    M.topBar = display.newRect( 0, 0, appData.screenW, 35)
    M.topBar.fill = appData.colors.actionBackground
    M.topBar.anchorY = 0
    M.topBar.x = appData.contentW/2
    M.topBar.y = 0
    M.commutingGroup:insert( M.topBar )

    -- Info Text ---------------------------------------------------------------------------------

    local infoOptions = 
    {
        text = "PENDLING",
        width = appData.screenW - appData.margin*2 - appData.margin*2,
        font = appData.fonts.titleText,
        align = "center"
    }

    M.infoText = display.newText( infoOptions )
    M.infoText.fill = appData.colors.actionText
 
    M.infoText.anchorX = 0.5
    M.infoText.anchorY = 0
    M.infoText.x = appData.contentW/2
    M.infoText.y = M.topBar.y + appData.margin
    M.commutingGroup:insert( M.infoText )

-- Options Icon
    M.optionsIcon = display.newGroup()
    M.optionsIcon.anchorChildren = true;
    M.optionsIcon.anchorX = 0
    M.optionsIcon.anchorY = 0

    local bar1=display.newRect(0,0,30,2)
    bar1.fill=appData.colors.background
    M.optionsIcon:insert(bar1)

    local bar2=display.newRect(0,9,30,2)
    bar2.fill=appData.colors.background
    M.optionsIcon:insert(bar2)

    local bar3=display.newRect(0,18,30,2)
    bar3.fill=appData.colors.background
    M.optionsIcon:insert(bar3)

    M.optionsIcon:scale(0.9, 0.9)

    M.optionsIcon.x = appData.margin
    M.optionsIcon.y = M.topBar.y + appData.margin

    M.commutingGroup:insert( M.optionsIcon )

    -- Final Setup --------------------------------------------------------------------------------------
    M.commutingGroup.y = display.screenOriginY
    M.sceneGroup:insert( M.commutingGroup )
end

M.showButtons = function()
    -- Three Dots
    M.dot1 = display.newImageRect( "images/dot.png", 10, 10 )
    M.dot1.anchorX = 0.5
    M.dot1.anchorY = 0.5
    M.dot1.x = appData.contentW/2 - 20
    M.dot1.y = 230
    M.dot1.alpha = 0.5
    M.postJourneyRideGroup:insert( M.dot1)

    M.dot2 = display.newImageRect( "images/dot.png", 10, 10 )
    M.dot2.anchorX = 0.5
    M.dot2.anchorY = 0.5
    M.dot2.x = appData.contentW/2
    M.dot2.y = 230
    M.dot2.alpha = 1
    M.postJourneyRideGroup:insert( M.dot2)

    M.dot3 = display.newImageRect( "images/dot.png", 10, 10 )
    M.dot3.anchorX = 0.5
    M.dot3.anchorY = 0.5
    M.dot3.x = appData.contentW/2 + 20
    M.dot3.y = 230
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
    M.forwardButton.anchorY = 0.5
    M.forwardButton.x = appData.contentW - display.screenOriginX - 23
    M.forwardButton.y = 230 
    M.postJourneyRideGroup:insert( M.forwardButton)
end

return M