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
        text = "Bekreft mobil",
        width = appData.screenW - appData.margin*2 - appData.actionMargin*2,
        font = appData.fonts.actionText,
        align = "left"
    }

    M.instructionsText = display.newText( instructionsOptions )
    M.instructionsText.fill = appData.colors.actionText
 
    M.instructionsText.anchorX = 0.5
    M.instructionsText.anchorY = 0
    M.instructionsText.x = appData.contentW/2
    M.instructionsText.y = 115
    M.sceneGroup:insert( M.instructionsText )


    local infoOptions = 
    {
        text = "En tekstmelding skal være sendt til din mobil."
        .." Fyll inn feltet over med koden for å bekrefte mobilnummeret.",
        width = appData.screenW - appData.margin*2 - appData.actionMargin*2,
        font = appData.fonts.actionText,
        align = "left"
    }

    M.infoText = display.newText( infoOptions )
    M.infoText.fill = appData.colors.actionText
 
    M.infoText.anchorX = 0
    M.infoText.anchorY = 0
    M.infoText.x = appData.actionMargin+appData.margin
    M.infoText.y = 225
    M.infoText.alpha = 0
    M.sceneGroup:insert( M.infoText )
end

-- Name Text Field
M.showFields = function(event)
    -- Email
    -- email background
     M.phoneFieldBackground = display.newRoundedRect(
  		3000, 
  		150, 
  		appData.screenW - appData.margin*2 - appData.actionMargin*2, 
  		30, 
  		appData.actionCorner/2 
  	)

  	M.phoneFieldBackground.fill = appData.colors.actionText
    M.phoneFieldBackground.alpha = 0
  	M.sceneGroup:insert( M.phoneFieldBackground )

    -- email field
    M.phoneField = native.newTextField( 
    	-- appData.contentW/2 + 15,
        3000, 
    	150, 
    	appData.screenW - appData.margin*8 - appData.actionMargin*2,  
    	30 
    )

    M.phoneField.placeholder = "Mobilnummer"
    M.phoneField.font = appData.fonts.actionText
    M.phoneField.align = "left"
    M.phoneField.hasBackground = false
    M.phoneField.inputType = "phone"
    M.sceneGroup:insert( M.phoneField )

    -- +47
    local countryOptions = 
    {
        text = "+47",
        width = appData.screenW - appData.margin*2 - appData.actionMargin*2,
        font = appData.fonts.actionText,
        align = "left"
    }

    M.countryText = display.newText( countryOptions )
    M.countryText.fill = appData.colors.actionComment
 
    M.countryText.anchorX = 0
    M.countryText.anchorY = 0.5
    M.countryText.x = appData.actionMargin+appData.actionMargin
    M.countryText.y = 150
    M.countryText.alpha = 1
    M.sceneGroup:insert( M.countryText )

    -- CODE field + text ----------------------------------------------------

    M.codeBackground = display.newRoundedRect(
        appData.contentW/2, 
        150 + 30 + 20, 
        appData.screenW/3, 
        30, 
        appData.actionCorner/2 
    )

    M.codeBackground.fill = appData.colors.actionText
    M.codeBackground.alpha = 0.0
    M.sceneGroup:insert( M.codeBackground )


    -- email field
    M.codeField = native.newTextField( 
        appData.contentW/2, 
        150 + 30 + 20, 
        appData.screenW/3, 
        30 
    )

    M.codeField.placeholder = ""
    M.codeField.font = appData.fonts.actionText
    M.codeField.align = "center"
    M.codeField.inputType = "phone"
    M.codeField.hasBackground = false
    M.codeField.alpha = 0.0
    M.sceneGroup:insert( M.codeField )
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