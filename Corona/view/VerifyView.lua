local composer = require( "composer" )
local widget = require( "widget" )
local appData = require( "misc.appData" )

local M = {}
-- Layout
M.showBackground = function(event)
    M.background = display.newRect( 0, 0, appData.screenW, appData.screenH )
    M.background.fill = appData.colors.actionBackground
    M.background.x = appData.contentW/2
    M.background.y = appData.contentH/2
    M.sceneGroup:insert(  M.background )

    local infoOptions = 
    {
        text = "",
        width = appData.screenW - appData.margin*2 - appData.margin*2,
        font = appData.fonts.titleText,
        align = "center"
    }

    M.infoText = display.newText( infoOptions )
    M.infoText.fill = appData.colors.actionText
 
    M.infoText.anchorX = 0.5
    M.infoText.anchorY = 0
    M.infoText.x = appData.contentW/2
    M.infoText.y = display.screenOriginY  + appData.margin
    M.sceneGroup:insert( M.infoText )

    local instructionsOptions = 
    {
        text = "Verification Code:",
        width = appData.screenW - appData.margin*2 - appData.actionMargin*2,
        font = appData.fonts.actionText,
        align = "left"
    }

    M.instructionsText = display.newText( instructionsOptions )
    M.instructionsText.fill = appData.colors.actionText
 
    M.instructionsText.anchorX = 0.5
    M.instructionsText.anchorY = 0
    M.instructionsText.x = appData.contentW/2
    M.instructionsText.y = 110
    M.sceneGroup:insert( M.instructionsText )

    local info2Options = 
    {
        text = "You will receive a verification code via SMS shortly",
        width = appData.screenW - appData.margin*2 - appData.actionMargin*2,
        font = appData.fonts.actionText,
        align = "left"
    }

    M.info2Text = display.newText( info2Options )
    M.info2Text.fill = appData.colors.actionText
 
    M.info2Text.anchorX = 0
    M.info2Text.anchorY = 0
    M.info2Text.x = appData.actionMargin+appData.margin
    M.info2Text.y = 175
    M.sceneGroup:insert( M.info2Text )
end

-- Name Text Field
M.showFields = function(event)
-- Email
    -- email background
     M.verificationFieldBackground = display.newRoundedRect(
  		appData.contentW/2, 
  		150, 
  		appData.screenW - appData.margin*2 - appData.actionMargin*2, 
  		30, 
  		appData.actionCorner/2 
  	)

  	M.verificationFieldBackground.fill = appData.colors.actionText
  	M.sceneGroup:insert( M.verificationFieldBackground )

    -- email field
    M.verificationField = native.newTextField( 
    	appData.contentW/2, 
    	150, 
    	appData.screenW - appData.margin*2 - appData.actionMargin*2,  
    	30 
    )

    M.verificationField.placeholder = "Your code"
    M.verificationField.font = appData.fonts.actionText
    M.verificationField.align = "left"
    M.verificationField.hasBackground = false
    M.verificationField.inputType = "number"

end


-- Verify Button 
M.showVerifyButton = function(event)

    M.verifyButton = widget.newButton(
        {
            left = 0,
            top = 0,
            shape = "roundedRect",
            width = 80,
            height = 20,
            cornerRadius = 2.5,
            label = "CONFIRM",
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

    M.verifyButton.anchorY = 1
    M.verifyButton.x = appData.contentW/2
    M.verifyButton.y = appData.contentH - display.screenOriginY - appData.margin
    M.sceneGroup:insert( M.verifyButton )

end 

return M