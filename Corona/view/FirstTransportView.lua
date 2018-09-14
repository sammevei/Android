local composer = require( "composer" )
local widget = require( "widget" )
local appData = require( "misc.appData" )
local routines = require( "misc.appRoutines" )
local model = require("model.CreateTransportModel")

widget.setTheme( "widget_theme_ios7" )
-- widget.setTheme( "widget_theme_android_holo_light" )
-- widget.setTheme( "widget_theme_1" )

local M = {}
-- -----------------------------------------------------------------------------
-- BACKGROUND
-- -----------------------------------------------------------------------------
M.showBackground = function(event)
    M.background = display.newRect( 0, 0, appData.screenW, appData.screenH )
    M.background.fill = {1,1,1}
    M.background.x = appData.contentW/2
    M.background.y = appData.contentH/2
    M.sceneGroup:insert( M.background )
end



-- -----------------------------------------------------------------------------
-- TRIP CHANGE
-- -----------------------------------------------------------------------------

-- Show Trip Change
M.showTripChange = function(address)
    -- setup
    M.tripChangeGroup = display.newGroup()
    M.sceneGroup:insert( M.tripChangeGroup )
    M.tripChangeGroup.alpha = 1

    M.tripChangeGroup.anchorX = 0.5
    M.tripChangeGroup.anchorY = 0

    -- Background ------------------------------------------------------------------------------
    M.tripChangeBackground = display.newRect( 0, -20, appData.screenW, 150 )
    -- M.tripChangeBackground.fill = appData.colors.actionBackground
    M.tripChangeBackground.fill = {1, 1, 1}
    M.tripChangeBackground.anchorX = 0.5
    M.tripChangeBackground.anchorY = 0
    M.tripChangeBackground.x = appData.contentW/2
    M.tripChangeGroup:insert( M.tripChangeBackground ) 
   
    M.tripChangeGroup.y = -3000 
end

M.showFooter = function()

    print("FOOTER SHOWING")

    -- footer group
    M.footerGroup = display.newGroup()
    M.sceneGroup:insert( M.footerGroup )
    print("1")

    -- back button
    M.backButton = appData.widget.newButton{
        width = 24,
        height = 22,
        defaultFile = "images/backB.png",
        overFile = "images/backB.png"
    }
     
     print("2")
    M.backButton.anchorX = 0.5
    M.backButton.anchorY = 0.5
    M.backButton.x = appData.margin*2 + M.backButton.width/2 
    M.footerGroup:insert( M.backButton ) 
    print("3")

    -- final adjustments
    -- M.footerGroup.alpha = 0.9
    M.footerGroup.x = 0
    print("4")
    M.footerGroup.y = appData.contentH - display.screenOriginY - appData.margin*2 - M.footerGroup.height
    -- M.footerGroup.x = 100
    -- M.footerGroup.y = 100
    print("5")
end


return M