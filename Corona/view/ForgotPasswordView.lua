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
        text = "Gjenopprett passord",
        width = appData.contentW,
        font = appData.fonts.titleText,
        align = "left"
    }

    M.infoText = display.newText( infoOptions )
    M.infoText.fill = appData.colors.actionText

    M.infoText.anchorX = 0
    M.infoText.anchorY = 0
    M.infoText.x = display.screenOriginX + appData.actionMargin + appData.margin
    M.infoText.y = 110
    M.sceneGroup:insert( M.infoText )
end

-- Name Text Field
M.showFields = function(event)
-- Email
    -- email background
     M.emailFieldBackground = display.newRoundedRect(
  		appData.contentW/2, 
  		150, 
  		appData.screenW - appData.margin*2 - appData.actionMargin*2, 
  		30, 
  		appData.actionCorner/2 
  	)

  	M.emailFieldBackground.fill = appData.colors.actionText
  	M.sceneGroup:insert( M.emailFieldBackground )

    -- email field
    M.emailField = native.newTextField( 
    	appData.contentW/2, 
    	150, 
    	appData.screenW - appData.margin*4 - appData.actionMargin*2,   
    	30 
    )

    M.emailField.placeholder = "E-postadresse"
    M.emailField.font = appData.fonts.actionText
    M.emailField.align = "left"
    M.emailField.hasBackground = false
    -- M.emailField.alpha = 0
    M.sceneGroup:insert( M.emailField )

    print("FORGOT...............emailField CREATED")
    -- ------------------------------------------------------------------- --
 
    M.pinFieldBackground = display.newRoundedRect(
        appData.contentW/2, 
        150 + 30 + 20, 
        appData.screenW/3, 
        30, 
        appData.actionCorner/2 
    )

    M.pinFieldBackground.fill = appData.colors.actionText
    M.pinFieldBackground.alpha = 0
    M.sceneGroup:insert( M.pinFieldBackground )


    -- email field
    M.pinField = native.newTextField( 
        appData.contentW/2, 
        150 + 30 + 20, 
        appData.screenW/3, 
        30 
    )

    M.pinField.placeholder = "______"
    M.pinField.font = appData.fonts.actionText
    M.pinField.align = "center"
    M.pinField.hasBackground = false
    M.pinField.alpha = 0
    M.sceneGroup:insert( M.pinField )

    -- Instructions -----------------------------------------------------------------
    local instructionsOptions = 
    {
        text = "Sjekk inboksen din og skriv pin-koden i feltet over",
        width = appData.screenW - appData.margin*2 - appData.actionMargin*2,
        font = appData.fonts.actionText,
        align = "left"
    }

    M.instructionsText = display.newText( instructionsOptions )
    M.instructionsText.fill = appData.colors.actionText

    M.instructionsText.anchorX = 0.5
    M.instructionsText.anchorY = 0
    M.instructionsText.alpha = 0
    M.instructionsText.x = appData.contentW/2
    M.instructionsText.y = 150 + 30 + 20 + 30,
    M.sceneGroup:insert( M.instructionsText )

  
    -- Password I -------------------------------------------------------------------
    -- password I background
     M.passwordFieldBackground1 = display.newRoundedRect(
        appData.contentW/2, 
        150 + 30 + 10, 
        appData.screenW - appData.margin*2 - appData.actionMargin*2, 
        30, 
        appData.actionCorner/2 
    )

    M.passwordFieldBackground1.fill = appData.colors.actionText
    M.passwordFieldBackground1.alpha = 0
    M.passwordFieldBackground1.x = 3000
    M.sceneGroup:insert( M.passwordFieldBackground1 )

    -- email field
    M.passwordField1 = native.newTextField( 
        appData.contentW/2, 
        150 + 30 + 10, 
        appData.screenW - appData.margin*4 - appData.actionMargin*2, 
        30 
    )

    M.passwordField1.placeholder = "Nytt passord"
    M.passwordField1.isSecure = true
    M.passwordField1.font = appData.fonts.actionText
    M.passwordField1.align = "left"
    M.passwordField1.alpha = 0
    M.passwordField1.x = 3000
    M.passwordField1.hasBackground = false

    -- ----------------------------------------------------------------------------- --
    -- password II background
     M.passwordFieldBackground2 = display.newRoundedRect(
        appData.contentW/2, 
        150 + 30*2 + 10*2, 
        appData.screenW - appData.margin*2 - appData.actionMargin*2, 
        30, 
        appData.actionCorner/2 
    )

    M.passwordFieldBackground2.fill = appData.colors.actionText
    M.passwordFieldBackground2.alpha = 0
    M.passwordFieldBackground2.x = 3000
    M.sceneGroup:insert( M.passwordFieldBackground2 )


    -- Password II
 
    M.passwordField2 = native.newTextField( 
        appData.contentW/2, 
        150 + 30*2 + 10*2, 
        appData.screenW - appData.margin*4 - appData.actionMargin*2,  
        30 
    )

    M.passwordField2.placeholder = "Bekreft passord"
    M.passwordField2.isSecure = true
    M.passwordField2.font = appData.fonts.actionText
    M.passwordField2.align = "left"
    M.passwordField2.alpha = 0
    M.passwordField2.x = 3000    
    M.passwordField2.hasBackground = false    
end


-- Login
M.showForgot = function(event)
    local forgotOptions = 
    {
        text = "Forgot password?",
        width = 280,
        font = appData.fonts.actionText,
        align = "left"
    }

    
    M.forgotText = display.newText( forgotOptions )
    M.forgotText.fill = appData.colors.actionComment

    M.forgotText.anchorX = 0
    M.forgotText.anchorY = 0
    M.forgotText.x = display.screenOriginX + appData.actionMargin + appData.margin
    M.forgotText.y = 120+100
    M.forgotText.alpha = 1
    M.sceneGroup:insert( M.forgotText )
    
    M.button3 = display.newImageRect( "images/white.png", 100, 20 )
    M.button3.anchorX = 0
    M.button3.anchorY = 0
    M.button3.x = display.screenOriginX + appData.actionMargin + appData.margin
    M.button3.y = 110+110
    M.button3.alpha = 0.01
    M.sceneGroup:insert( M.button3 )
end

-- Register Button 
M.showButtons = function(event)

    -- login button
    M.updateButton = widget.newButton(
        {
            left = 0,
            top = 0,
            shape = "roundedRect",
            width = 80,
            height = 24,
            cornerRadius = 12,
            label = "OPPDATER",
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

    M.updateButton.anchorX = 1
    M.updateButton.anchorY = 1
    M.updateButton.x = appData.contentW - appData.margin - appData.actionMargin
    M.updateButton.y = 280 
    M.updateButton.alpha = 0
    M.sceneGroup:insert( M.updateButton )

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