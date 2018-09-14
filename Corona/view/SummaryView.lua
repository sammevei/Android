local composer = require( "composer" )
local widget = require( "widget" )
local appData = require( "misc.appData" )
-- widget.setTheme( "widget_theme_1" )

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

    if (appData.transport.mode == "driver") then driverSwitchState = true
    elseif (appData.transport.mode == "passenger") then passengerSwitchState = true     
    elseif (appData.transport.mode == "both") then bothSwitchState = true 
    end    

    M.postJourneyRideGroup = display.newGroup()

    --  Tab Background -----------------------------------------------------------------------------

    M.postTimeBackground = display.newRoundedRect( 0, 0, appData.screenW - appData.margin * 2, 255, appData.actionCorner )
    M.postTimeBackground.fill = appData.colors.actionBackground
    M.postTimeBackground.anchorY = 0
    M.postTimeBackground.x = appData.contentW/2
    M.postTimeBackground.y = 0
    M.postJourneyRideGroup:insert( M.postTimeBackground )

    -- Info Text ---------------------------------------------------------------------------------
    local minutes = tostring((tonumber(appData.transport.flexibility))/60)

    local infoOptions = 
    {
        text = "Fra: "..appData.transport.fromAddress..       
                "\n"..
                "To: "..appData.transport.toAddress..
                "\n"..
                "Tid: "..appData.transport.ts.." +/- "..minutes.." min"..
                "\n"..
                "Modus: "..appData.transport.mode
                ,

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

    -- Comment Text
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
    M.commentText.y = M.postTimeBackground.y + appData.actionMargin + 165
    M.postJourneyRideGroup:insert( M.commentText )    
 
    

    -- Final Setup --------------------------------------------------------------------------------------
    M.postJourneyRideGroup.y = display.screenOriginY + 50
    M.sceneGroup:insert( M.postJourneyRideGroup )
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
    M.dot2.alpha = 0.5
    M.postJourneyRideGroup:insert( M.dot2)

    M.dot3 = display.newImageRect( "images/dot.png", 10, 10 )
    M.dot3.anchorX = 0.5
    M.dot3.anchorY = 0.5
    M.dot3.x = appData.contentW/2 + 20
    M.dot3.y = 230
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
    M.postJourneyRideGroup:insert( M.backButton)

    -- Enter Button
    M.enterButton = widget.newButton(
        {
            left = 0,
            top = 0,
            shape = "roundedRect",
            width = 60,
            height = 20,
            cornerRadius = 2.5,
            label = "FULLFØR",
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

    M.enterButton.anchorX = 1
    M.enterButton.anchorY = 0.5 
    M.enterButton.x = appData.contentW - display.screenOriginX - 23
    M.enterButton.y = 230
    M.postJourneyRideGroup:insert( M.enterButton )
end

return M