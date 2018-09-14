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
        text = "NY BRUKER",
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
    -- Email
    -- email background
     M.emailFieldBackground = display.newRoundedRect(
  		appData.contentW/2, 
  		150 + 15, 
  		appData.screenW - appData.margin*2 - appData.actionMargin*2, 
  		30, 
  		appData.actionCorner/2 
  	)

  	M.emailFieldBackground.fill = appData.colors.actionText
  	M.sceneGroup:insert( M.emailFieldBackground )

    -- email field
    M.emailField = native.newTextField( 
    	appData.contentW/2, 
    	150 + 15, 
    	appData.screenW - appData.margin*4 - appData.actionMargin*2,  
    	30  
    )

    M.emailField.placeholder = "E-postadresse"
    M.emailField.inputType = "email"
    M.emailField.font = appData.fonts.actionText
    M.emailField.align = "left"
    M.emailField.hasBackground = false

    -- Password I
    -- password I background
     M.passwordFieldBackground1 = display.newRoundedRect(
  		appData.contentW/2, 
  		150 + 30 + 10+15, 
  		appData.screenW - appData.margin*2 - appData.actionMargin*2, 
  		30, 
  		appData.actionCorner/2 
  	)

  	M.passwordFieldBackground1.fill = appData.colors.actionText
  	M.sceneGroup:insert( M.passwordFieldBackground1 )

    -- email field
    M.passwordField1 = native.newTextField( 
    	appData.contentW/2, 
    	150 + 30 + 10+15, 
    	appData.screenW - appData.margin*4 - appData.actionMargin*2, 
    	30 
    )

    M.passwordField1.placeholder = "Passord"
    M.passwordField1.font = appData.fonts.actionText
    M.passwordField1.align = "left"
    -- M.passwordField1.isSecure = true
    M.passwordField1.hasBackground = false
    M.sceneGroup:insert( M.passwordField1 ) 


    -- Password II
     M.passwordFieldBackground2 = display.newRoundedRect(
        appData.contentW/2, 
        150 + 30*2 + 10*2+15, 
        appData.screenW - appData.margin*2 - appData.actionMargin*2, 
        30, 
        appData.actionCorner/2 
    )

    M.passwordFieldBackground2.fill = appData.colors.actionText
    M.sceneGroup:insert( M.passwordFieldBackground2 )    
	
    M.passwordField2 = native.newTextField( 
    	appData.contentW/2, 
    	150 + 30*2 + 10*2+15, 
    	appData.screenW - appData.margin*4 - appData.actionMargin*2,  
    	30 
    )

    M.passwordField2.placeholder = "Bekreft passord"
    M.passwordField2.font = appData.fonts.actionText
    M.passwordField2.align = "left"
    M.passwordField2.hasBackground = false 
    M.sceneGroup:insert( M.passwordField2 ) 
       
end

-- Register Button 
M.showRegisterButton = function(event)

    -- login button
    M.registerButton = widget.newButton(
        {
            left = 0,
            top = 0,
            shape = "roundedRect",
            width = 95,
            height = 24,
            cornerRadius = 12,
            label = "REGISTRER",
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

    M.registerButton.anchorX = 0.5
    M.registerButton.anchorY = 0
    M.registerButton.x = appData.contentW/2
    M.registerButton.y = 275, 
    M.sceneGroup:insert( M.registerButton )


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