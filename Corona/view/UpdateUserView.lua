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


M.showFields = function(event)
-- First Name
    -- First Name Background
     M.firstNameFieldBackground = display.newRoundedRect(
  		appData.contentW/2, 
  		150, 
  		appData.screenW - appData.margin*2 - appData.actionMargin*2, 
  		30, 
  		appData.actionCorner/2 
  	)

  	M.firstNameFieldBackground.fill = appData.colors.actionText
  	M.sceneGroup:insert( M.firstNameFieldBackground )

    -- First Name Field
    M.firstNameField = native.newTextField( 
    	appData.contentW/2, 
    	150, 
    	appData.screenW - appData.margin*2 - appData.actionMargin*2,  
    	30 
    )

    M.firstNameField.placeholder = "First Name"
    M.firstNameField.font = appData.fonts.actionText
    M.firstNameField.align = "center"
    M.firstNameField.hasBackground = false

-- Middle Name
    -- Middle Name Background
     M.middleNameFieldBackground = display.newRoundedRect(
  		appData.contentW/2, 
  		150 + 30 + 10, 
  		appData.screenW - appData.margin*2 - appData.actionMargin*2, 
  		30, 
  		appData.actionCorner/2 
  	)

  	M.middleNameFieldBackground.fill = appData.colors.actionText
  	M.sceneGroup:insert( M.middleNameFieldBackground )

    -- email field
    M.middleNameField = native.newTextField( 
    	appData.contentW/2, 
    	150 + 30 + 10, 
    	appData.screenW - appData.margin*2 - appData.actionMargin*2, 
    	30 
    )

    M.middleNameField.placeholder = "Middle Name"
    M.middleNameField.font = appData.fonts.actionText
    M.middleNameField.align = "center"
    M.middleNameField.hasBackground = false

-- Last Name
    -- Last Name Background
     M.lastNameFieldBackground = display.newRoundedRect(
      appData.contentW/2, 
      150 + 30*2 + 10*2, 
      appData.screenW - appData.margin*2 - appData.actionMargin*2, 
      30, 
      appData.actionCorner/2 
    )

    M.lastNameFieldBackground.fill = appData.colors.actionText
    M.sceneGroup:insert( M.lastNameFieldBackground )

    -- Last name Field
    M.lastNameField = native.newTextField( 
      appData.contentW/2, 
      150 + 30*2 + 10*2, 
      appData.screenW - appData.margin*2 - appData.actionMargin*2, 
      30 
    )

    M.lastNameField.placeholder = "Last Name"
    M.lastNameField.font = appData.fonts.actionText
    M.lastNameField.align = "center"
    M.lastNameField.hasBackground = false  
end

-- Register Button 
M.showUpdateButton = function(event)

    M.updateButton = widget.newButton(
        {
            left = 0,
            top = 0,
            shape = "roundedRect",
            width = 80,
            height = 20,
            cornerRadius = 2.5,
            label = "SEND",
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

    M.updateButton.anchorY = 1
    M.updateButton.x = appData.contentW/2
    M.updateButton.y = appData.contentH - display.screenOriginY - appData.margin
    M.sceneGroup:insert( M.updateButton )

end 

return M