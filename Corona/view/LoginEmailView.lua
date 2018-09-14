local composer = require( "composer" )
local widget = require( "widget" )
local appData = require( "misc.appData" )

local M = {}
-- Background
M.showBackground = function(event)
    M.background = display.newRect( 0, 0, appData.screenW, appData.screenH )
    M.background.fill = appData.colors.actionBackground
    M.background.x = appData.contentW/2
    M.background.y = appData.contentH/2
    M.sceneGroup:insert(  M.background )
end

-- Info
M.showInfo = function(event)
    local infoOptions = 
    {
        text = "LOGG INN",
        width = appData.contentW,
        font = appData.fonts.titleText,
        align = "center"
    }

    M.loginText = display.newText( infoOptions )
    M.loginText.fill = appData.colors.actionText

    M.loginText.anchorX = 0.5
    M.loginText.anchorY = 0
    M.loginText.x = appData.contentW/2
    M.loginText.y = display.screenOriginY + 120
    M.sceneGroup:insert( M.loginText )
end

-- Name Text Field
M.showFields = function(event)
    -- Email -----------------------------------------------------------------------------
    -- email background
     M.emailFieldBackground = display.newRoundedRect(
  		3000, 
  		appData.contentH/2 - 15 - 40, 
  		appData.screenW - appData.margin*2 - appData.actionMargin*2, 
  		30, 
  		appData.actionCorner/2 
  	)

  	M.emailFieldBackground.fill = appData.colors.actionText
    M.emailFieldBackground.alpha = 0
  	M.sceneGroup:insert( M.emailFieldBackground )

    -- email field
    M.loginEmailField = native.newTextField( 
    	3000, 
    	appData.contentH/2 - 15 - 40, 
    	appData.screenW - appData.margin*4 - appData.actionMargin*2,  
    	30 
    )

    M.loginEmailField.placeholder = "E-postadresse"
    M.loginEmailField.font = appData.fonts.actionText
    M.loginEmailField.align = "left"
    M.loginEmailField.hasBackground = false
    M.loginEmailField.alpha = 0
    M.sceneGroup:insert( M.loginEmailField )

    print("LOGIN...............emailEmailField CREATED")

    -- Password I ------------------------------------------------------------------------
    -- password I background
     M.passwordFieldBackground1 = display.newRoundedRect(
  		3000, 
  		appData.contentH/2 - 15, 
  		appData.screenW - appData.margin*2 - appData.actionMargin*2, 
  		30, 
  		appData.actionCorner/2 
  	)

  	M.passwordFieldBackground1.fill = appData.colors.actionText
    M.passwordFieldBackground1.alpha = 0
  	M.sceneGroup:insert( M.passwordFieldBackground1 )

    -- email field
    M.loginPasswordField = native.newTextField( 
    	3000, 
    	appData.contentH/2 - 15, 
    	appData.screenW - appData.margin*4 - appData.actionMargin*2, 
    	30 
    )

    M.loginPasswordField.placeholder = "Passord"
    M.loginPasswordField.font = appData.fonts.actionText
    M.loginPasswordField.align = "left"
    M.loginPasswordField.hasBackground = false
    M.loginPasswordField.alpha = 0
    M.sceneGroup:insert( M.loginPasswordField )

    -- Password II
	--[[
    M.passwordField2 = native.newTextField( 
    	appData.contentW/2, 
    	150 + 30*2 + 10*2, 
    	appData.screenW - appData.margin*2 - appData.actionMargin*2,  
    	30 
    )

    M.passwordField2:addEventListener( "userInput", appData.passwordFieldListener )
    M.passwordField2.placeholder = "gjenta passord"
    M.passwordField2.font = appData.fonts.actionText
    M.passwordField2.align = "center"
    M.passwordField2.hasBackground = false 
    --]]   
end

-- Login
M.showForgot = function(event)
    local tosOptions = 
    {
        text = "Glemt passord",
        width = 280,
        font = appData.fonts.actionText,
        align = "left"
    }

    
    M.forgotText = display.newText( tosOptions )
    M.forgotText.fill = appData.colors.actionComment

    M.forgotText.anchorX = 0
    M.forgotText.anchorY = 0
    M.forgotText.x = display.screenOriginX + appData.actionMargin + appData.margin*2
    M.forgotText.y = 253
    M.forgotText.alpha = 1
    M.sceneGroup:insert( M.forgotText )
    
    M.forgotButton = display.newImageRect( "images/white.png", 100, 20 )
    M.forgotButton.anchorX = 0
    M.forgotButton.anchorY = 0
    M.forgotButton.x = display.screenOriginX + appData.actionMargin + appData.margin*2
    M.forgotButton.y = 250
    M.forgotButton.alpha = 0.01
    M.sceneGroup:insert( M.forgotButton )
end

-- Register Button 
M.showButtons = function(event)

    -- login button
    M.loginButton = widget.newButton(
        {
            left = 0,
            top = 0,
            shape = "roundedRect",
            width = 80,
            height = 24,
            cornerRadius = 12,
            label = "LOGG IN",
            fontSize = 13,
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

    M.loginButton.anchorX = 1
    M.loginButton.anchorY = 1
    M.loginButton.x = appData.contentW - appData.margin - appData.actionMargin
    M.loginButton.y = 275, 
    M.sceneGroup:insert( M.loginButton )

    -- new user button
    M.newUserButton = widget.newButton(
        {
            left = 0,
            top = 0,
            shape = "roundedRect",
            width = 120,
            height = 35,
            cornerRadius = 18,
            label = "NY BRUKER",
            fontSize = 13,
            labelColor = { default=appData.colors.confirmButtonLabelDefault, 
                           over=appData.colors.confirmButtonLabelOver 
                         },
            fillColor = { default={0.8, 0.1, 0.45}, 
                          over={1, 0.8, 0.9}
                        },
            strokeColor = { default=appData.colors.confirmButtonLabelDefault, 
                           over=appData.colors.confirmButtonLabelOver 
                        },

            strokeWidth = 0   
        } 
    )

    M.newUserButton.anchorY = 1
    M.newUserButton.x = appData.contentW/2
    M.newUserButton.y = appData.contentH - display.screenOriginY - M.newUserButton.height - appData.actionMargin
    M.sceneGroup:insert( M.newUserButton )

    -- cancel button
    M.cancelButton = widget.newButton(
        {
            left = 0,
            top = 0,
            shape = "roundedRect",
            width = 90,
            height = 25,
            cornerRadius = 4,
            label = "Avbryt",
            fontSize = 12,
            labelColor = { default=appData.colors.confirmButtonLabelDefault, 
                           over=appData.colors.confirmButtonLabelOver 
                         },
            fillColor = { default={0, 0, 0, 0.01}, 
                          over={0, 0, 0, 0.01}
                        },
            strokeColor = { default={0, 0, 0, 0.01}, 
                           over={1, 0, 0, 0.01} 
                        },

            strokeWidth = 0  
        } 
    )

    M.cancelButton.anchorY = 1
    M.cancelButton.alpha = 0.7
    M.cancelButton.x = appData.contentW/2
    M.cancelButton.y = appData.contentH - display.screenOriginY  - appData.actionMargin
    M.sceneGroup:insert( M.cancelButton )
end 

return M