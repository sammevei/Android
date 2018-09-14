local composer = require( "composer" )
local widget = require( "widget" )
local appData = require( "misc.appData" )

widget.setTheme( "widget_theme_ios7" )

local M = {}

M.showBackground = function(event)  
    M.background = display.newRect( 0, 0, appData.screenW, appData.screenH )
    M.background.fill = appData.colors.background
    M.background.x = appData.contentW/2
    M.background.y = appData.contentH/2
    M.sceneGroup:insert( M.background )
end

M.showTitle = function()

    M.postJourneyRideGroup = display.newGroup()
    M.postJourneyRideGroup.y = display.screenOriginY

    print("showing title .............. ")
    local titleOptions = 
    {
        text = "VELKOMMEN",
        width = appData.contentW,
        font = appData.fonts.titleText,
        align = "center"
    }

    local titleText = display.newText( titleOptions )
    titleText.fill = appData.colors.actionText

    titleText.anchorX = 0.5
    titleText.anchorY = 0
    titleText.x = appData.contentW/2
    titleText.y = display.screenOriginY + appData.actionMargin*2
    M.sceneGroup:insert( titleText )
end  

M.showRoles = function(event)

    local driverSwitchState = false
    local passengerSwitchState = false
    local bothSwitchState = false

    if (appData.user.mode == "driver") then driverSwitchState = true
    elseif (appData.user.mode == "passenger") then passengerSwitchState = true     
    elseif (appData.user.mode == "both") then bothSwitchState = true 
    end   

    M.switchesGroup = display.newGroup()

    --  Driver ----------------------------------------------------------------------------------
    local driverSwitchPress = function(event)
        if (event.target.isOn == true) then
            M.passengerSwitch:setState( { isOn=false } )
            M.bothSwitch:setState( { isOn=false } )
        else 
            M.passengerSwitch:setState( { isOn=true } )        
        end
    end

    -- 

    M.driverSwitch = widget.newSwitch(
        {
            left = display.screenOriginX - 5,
            top = 40,
            id = "driverSwitch",
            style = "onOff",
            initialSwitchState = driverSwitchState,
            onRelease = driverSwitchPress
        }
    )

    M.driverSwitch.anchorY = 0
    M.driverSwitch.anchorX = 0
    M.driverSwitch:scale(0.6, 0.6)
    M.switchesGroup:insert( M.driverSwitch )

    --

    local driverTextOptions = 
    {
        text = "Sjåfør",
        font = appData.fonts.actionText,
    }

    M.driverText = display.newText( driverTextOptions )
    M.driverText.fill = appData.colors.actionText
 
    M.driverText.anchorX = 0
    M.driverText.anchorY = 1
    M.driverText.x = display.screenOriginX + 70
    M.driverText.y = 75
    M.switchesGroup:insert( M.driverText )

    -- Passenger -------------------------------------------------------------------------------
    local passengerSwitchPress = function(event)
        if (event.target.isOn == true) then
            M.driverSwitch:setState( { isOn=false } )
            M.bothSwitch:setState( { isOn=false } )
        else 
            M.driverSwitch:setState( { isOn=true } )
        end
    end

    -- 

    M.passengerSwitch = widget.newSwitch(
        {
            left = display.screenOriginX - 2,
            top = 70,
            id = "passengerSwitch",
            style = "onOff",
            initialSwitchState = passengerSwitchState,
            onRelease = passengerSwitchPress
        }
    )

    M.passengerSwitch.anchorY = 0
    M.passengerSwitch.anchorX = 0
    M.passengerSwitch:scale(0.6, 0.6)
    M.switchesGroup:insert( M.passengerSwitch )

    local passengerTextOptions = 
    {
        text = "Passasjer",
        font = appData.fonts.actionText,
    }

    M.passengerText = display.newText( passengerTextOptions )
    M.passengerText.fill = appData.colors.actionText
 
    M.passengerText.anchorX = 0
    M.passengerText.anchorY = 1
    M.passengerText.x = display.screenOriginX + 70
    M.passengerText.y = 110
    M.switchesGroup:insert( M.passengerText )
 
    -- Both --------------------------------------------------------------------------------------
    local bothSwitchPress = function(event)
        if (event.target.isOn == true) then
            M.driverSwitch:setState( { isOn=false } )
            M.passengerSwitch:setState( { isOn=false } )
        else 
            M.driverSwitch:setState( { isOn=true } )            
        end
    end

    --     
    M.bothSwitch = widget.newSwitch(
        {
            left = display.screenOriginX - 5,
            top = 120,
            id = "bothSwitch",
            style = "onOff",
            initialSwitchState = bothSwitchState,
            onRelease = bothSwitchPress
        }
    )

    M.bothSwitch.anchorY = 0
    M.bothSwitch.anchorX = 0
    M.bothSwitch:scale(0.6, 0.6)
    M.switchesGroup:insert( M.bothSwitch )
    M.bothSwitch.alpha = 0

    local bothTextOptions = 
    {
        text = "Both",
        font = appData.fonts.actionText,
    }

    M.bothText = display.newText( bothTextOptions )
    M.bothText.fill = appData.colors.actionText
 
    M.bothText.anchorX = 0
    M.bothText.anchorY = 1
    M.bothText.x = display.screenOriginX + 70
    M.bothText.y = 155
    M.switchesGroup:insert( M.bothText )  
    M.bothText.alpha = 0

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
    M.commentText.y = M.postTimeBackground.y + appData.actionMargin + 165
    M.switchesGroup:insert( M.commentText )    
 
    

    -- Final Setup --------------------------------------------------------------------------------------
    M.switchesGroup.y = display.screenOriginY + 235
    M.postJourneyRideGroup:insert( M.switchesGroup )
end

M.showWheels = function()
    -- White Background
    M.whiteBackground = display.newRect( 
        0, 0+display.screenOriginY, appData.screenW, appData.screenH*2 )
    M.whiteBackground.fill = appData.colors.background
    M.whiteBackground.x = appData.contentW/2
    M.whiteBackground.y = appData.contentH/2
    M.whiteBackground.alpha = 0
    M.postJourneyRideGroup:insert( M.whiteBackground )

    -- Morning Wheels
    local morningTimeWheelData =
    {
        {
            align = "left",
            width = 1,
            labelPadding = 0,
            startIndex = 1,
            labels = { "" }
        },

        {
            align = "right",
            width = appData.contentW/2 - 5,
            labelPadding = 0,
            startIndex = 4,
            labels = { 
                "05", "06", "07", "08", "09", "10"
            }
        },

        {
            align = "center",
            width = 4,
            labelPadding = 0,
            labelPadding = 0,
            startIndex = 1,
            labels = { ":" }
        },

        {
            align = "left",
            labelPadding = 0,
            startIndex = 1,
            labels = { 
                "00", "05", "10", "15", "20", "25", "30", "35", "40", "45", "50", "55"
            }
        },

    }
     

    -- Create the widget
    M.morningTimeWheel = widget.newPickerWheel(
    {
        x = display.contentCenterX,
        top = display.contentHeight - 222,
        -- style = "resizable",
        width = appData.contentW,
        -- height = appData.screenW,
        -- rowHeight = 30,
        font = appData.fonts.actionText,
        fontSize = 14,
        columns = morningTimeWheelData
    }) 
    
    M.morningTimeWheel.anchorX = 0.5
    M.morningTimeWheel.x = appData.contentW/2-20
    M.morningTimeWheel.y = -3000
    M.postJourneyRideGroup:insert( M.morningTimeWheel ) 

    -- 

    local morningToleranceWheelData =
    {
        {
            align = "left",
            width = appData.screenW/2 + 60,
            startIndex = 1,
            labels = { "" }
        },

        {
            align = "left",
            labelPadding = 0,
            width = 50,
            startIndex = 6,
            labels = { 
                "5 min", "10 min", "15 min", "20 min", "25 min", "30 min", "35 min", "40 min", "45 min", "50 min", "55 min", "60 min"
            }
        }
    }
     
    -- Create the widget
    M.morningToleranceWheel = widget.newPickerWheel(
    {
        x = display.contentCenterX,
        top = display.contentHeight - 222,
        -- style = "resizable",
        -- width = appData.screenW,
        -- height = appData.screenW,
        -- rowHeight = 30,
        font = appData.fonts.actionText,
        fontSize = 14,
        columns = morningToleranceWheelData
    }) 
    
    M.morningToleranceWheel.anchorX = 0.5
    M.morningToleranceWheel.x = appData.contentW/2
    M.morningToleranceWheel.y = -3000
    M.postJourneyRideGroup:insert( M.morningToleranceWheel ) 


    -- Afternoon Wheels

    local afternoonTimeWheelData =
    {
        {
            align = "left",
            labelPadding = 0,
            width = 1,
            startIndex = 1,
            labels = { "" }
        },

        {
            align = "right",
            labelPadding = 0,
            width = appData.contentW/2 - 5,
            startIndex = 3,
            labels = { 
               "14", "15", "16", "17", "18"
            }
        },

        {
            align = "center",
            width = 4,
            labelPadding = 0,
            startIndex = 1,
            labels = { ":" }
        },

        {
            align = "left",
            labelPadding = 0,
            startIndex = 1,
            labels = { 
                "00", "05", "10", "15", "20", "25", "30", "35", "40", "45", "50", "55"
            }
        },
    }
     
    M.afternoonTimeWheel = widget.newPickerWheel(
    {
        x = display.contentCenterX,
        top = display.contentHeight - 222,
        -- style = "resizable",
        width = appData.contentH,
        -- height = appData.screenW,
        -- rowHeight = 30,
        font = appData.fonts.actionText,
        fontSize = 14,
        columns = afternoonTimeWheelData
    }) 
    
    M.afternoonTimeWheel.anchorX = 0.5
    M.afternoonTimeWheel.x = appData.contentW/2-20
    M.afternoonTimeWheel.y = -3000
    M.postJourneyRideGroup:insert( M.afternoonTimeWheel ) 

    -- 

    local afternoonToleranceWheelData =
    {
        {
            align = "left",
            width = appData.screenW/2 + 60,
            startIndex = 1,
            labels = { "" }
        },

        {
            align = "left",
            labelPadding = 0,
            width = 50,
            startIndex = 5,
            labels = { 
                "10 min", "15 min", "20 min", "25 min", "30 min", "35 min", "40 min", "45 min", "50 min", "55 min", "60 min"
            }
        }
    }
     
    -- Create the widget
    M.afternoonToleranceWheel = widget.newPickerWheel(
    {
        x = display.contentCenterX,
        top = display.contentHeight - 222,
        -- style = "resizable",
        width = appData.screenW,
        height = appData.screenW,
        rowHeight = 30,
        font = appData.fonts.actionText,
        fontSize = 14,
        columns = afternoonToleranceWheelData
    }) 
    
    M.afternoonToleranceWheel.anchorX = 0.5
    M.afternoonToleranceWheel.x = appData.contentW/2
    M.afternoonToleranceWheel.y = -3000
    M.postJourneyRideGroup:insert( M.afternoonToleranceWheel ) 

    -- Wheel Button 
    M.wheelButton = widget.newButton(
        {
            left = 0,
            top = 0,
            shape = "roundedRect",
            width = 75,
            height = 24,
            cornerRadius = 12,
            label = "VELG",
            fontSize = 13,
            labelColor = { default=appData.colors.confirmButtonFillOver, 
                           over=appData.colors.actionComment 
                         },
            fillColor = { default=appData.colors.actionText, 
                          over=appData.colors.actionText
                        },
            strokeColor = { default=appData.colors.confirmButtonFillOver, 
                           over=appData.colors.actionComment 
                        },

            strokeWidth = 1   
        } 
    )

    M.wheelButton.anchorX = 1
    M.wheelButton.anchorY = 0.5 
    M.wheelButton.x = appData.contentW - display.screenOriginX - 23
    M.wheelButton.y = appData.contentH - display.screenOriginY*2 - appData.actionMargin*2
    M.wheelButton.alpha = 0

    M.postJourneyRideGroup:insert( M.wheelButton )      
end

M.showMenu = function(event)

    --  Tab Background -----------------------------------------------------------------------------

    M.postTimeBackground = display.newRect( 0, 0, appData.screenW, appData.screenH )
    M.postTimeBackground.fill = appData.colors.actionBackground
    M.postTimeBackground.anchorY = 0
    M.postTimeBackground.x = appData.contentW/2
    M.postTimeBackground.y = 0
    M.postJourneyRideGroup:insert( M.postTimeBackground )

    -- Title
    local titleOptions = 
    {
        text = "VELKOMMEN",
        width = appData.contentW,
        font = appData.fonts.titleText,
        align = "center"
    }

    local titleText = display.newText( titleOptions )
    titleText.fill = appData.colors.actionText

    titleText.anchorX = 0.5
    titleText.anchorY = 0
    titleText.x = appData.contentW/2
    titleText.y = appData.actionMargin*2
    M.postJourneyRideGroup:insert( titleText )

    -- Info Text ---------------------------------------------------------------------------------

    local infoOptions = 
    {
        text = "",
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

  --  Morning Setup ------------------------------------------------------------------------------
    local morningTextOptions = 
    {
        text = "Morgen",
        font = appData.fonts.actionText,
    }

    M.morningText = display.newText( morningTextOptions )
    M.morningText.fill = appData.colors.actionText
 
    M.morningText.anchorX = 0
    M.morningText.anchorY = 1
    M.morningText.x = display.screenOriginX + 23
    M.morningText.y = 96
    M.postJourneyRideGroup:insert( M.morningText )
    --
    M.morningTimeBackground = display.newRoundedRect(
        appData.contentW/2, 
        90, 
        60, 
        30, 
        appData.actionCorner/2 
    )
    M.morningTimeBackground.fill = appData.colors.actionText
    M.postJourneyRideGroup:insert( M.morningTimeBackground )
    --

    print(appData.user.morningTime)
    local morningTimeOptions = 
    {
        text = appData.user.morningTime,
        font = appData.fonts.actionText,
    }

    M.morningTime = display.newText( morningTimeOptions )
    M.morningTime.fill = appData.colors.fieldText
 
    M.morningTime.anchorX = 0
    M.morningTime.anchorY = 1
    M.morningTime.x = 140
    M.morningTime.y = 98
    M.postJourneyRideGroup:insert( M.morningTime )   
    --
    local toleranceTextOptions1 = 
    {
        text = "+/-",
        font = appData.fonts.actionText,
    }

    M.toleranceText1 = display.newText( toleranceTextOptions1 )
    M.toleranceText1.fill = appData.colors.actionText
 
    M.toleranceText1.anchorX = 0
    M.toleranceText1.anchorY = 1
    M.toleranceText1.x = 198
    M.toleranceText1.y = 96
    M.postJourneyRideGroup:insert( M.toleranceText1 )
    --
    M.morningToleranceBackground = display.newRoundedRect(
        appData.contentW/2 + 104, 
        90, 
        60, 
        30, 
        appData.actionCorner/2 
    )
    M.morningToleranceBackground.fill = appData.colors.actionText
    M.postJourneyRideGroup:insert( M.morningToleranceBackground )
    --
    local morningToleranceOptions = 
    {
        text = "30 min",
        font = appData.fonts.actionText,
    }

    M.morningTolerance = display.newText( morningToleranceOptions )
    M.morningTolerance.fill = appData.colors.fieldText
 
    M.morningTolerance.anchorX = 0
    M.morningTolerance.anchorY = 1
    M.morningTolerance.x = appData.contentW/2 + 82
    M.morningTolerance.y = 98
    M.postJourneyRideGroup:insert( M.morningTolerance )   


    -- Afternoon Setup ------------------------------------------------------------------------------

    local afternoonTextOptions = 
    {
        text = "Ettermiddag",
        font = appData.fonts.actionText,
    }

    M.afternoonText = display.newText( afternoonTextOptions )
    M.afternoonText.fill = appData.colors.actionText
 
    M.afternoonText.anchorX = 0
    M.afternoonText.anchorY = 1
    M.afternoonText.x = display.screenOriginX + 23
    M.afternoonText.y = 139
    M.postJourneyRideGroup:insert( M.afternoonText )
    --
    M.afternoonTimeBackground = display.newRoundedRect(
        appData.contentW/2, 
        133, 
        60, 
        30, 
        appData.actionCorner/2 
    )
    M.afternoonTimeBackground.fill = appData.colors.actionText
    M.postJourneyRideGroup:insert( M.afternoonTimeBackground )
    --
    local afternoonTimeOptions = 
    {
        text = appData.user.afternoonTime,
        font = appData.fonts.actionText,
    }

    M.afternoonTime = display.newText( afternoonTimeOptions )
    M.afternoonTime.fill = appData.colors.fieldText
 
    M.afternoonTime.anchorX = 0
    M.afternoonTime.anchorY = 1
    M.afternoonTime.x = 140
    M.afternoonTime.y = 141
    M.postJourneyRideGroup:insert( M.afternoonTime )   
    --
    local toleranceTextOptions2 = 
    {
        text = "+/-",
        font = appData.fonts.actionText,
    }

    M.toleranceText2 = display.newText( toleranceTextOptions2 )
    M.toleranceText2.fill = appData.colors.actionText
 
    M.toleranceText2.anchorX = 0
    M.toleranceText2.anchorY = 1
    M.toleranceText2.x = 198
    M.toleranceText2.y = 139
    M.postJourneyRideGroup:insert( M.toleranceText2 )
    --
    M.afternoonToleranceBackground = display.newRoundedRect(
        appData.contentW/2 + 104, 
        133, 
        60, 
        30, 
        appData.actionCorner/2 
    )
    M.afternoonToleranceBackground.fill = appData.colors.actionText
    M.postJourneyRideGroup:insert( M.afternoonToleranceBackground )
    --
    local afternoonToleranceOptions = 
    {
        text = "30 min",
        font = appData.fonts.actionText,
    }

    M.afternoonTolerance = display.newText( afternoonToleranceOptions )
    M.afternoonTolerance.fill = appData.colors.fieldText
 
    M.afternoonTolerance.anchorX = 0
    M.afternoonTolerance.anchorY = 1
    M.afternoonTolerance.x = appData.contentW/2 + 82
    M.afternoonTolerance.y = 141
    M.postJourneyRideGroup:insert( M.afternoonTolerance ) 

    -- Comment Text --------------------------------------------------------------------------------------
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
    M.commentText.y = M.postTimeBackground.y + appData.actionMargin + 165
    M.postJourneyRideGroup:insert( M.commentText ) 

    M.sceneGroup:insert( M.postJourneyRideGroup )     
end

M.showButtons = function()
    -- Three Dots
    M.dot1 = display.newImageRect( "images/dot.png", 8, 8 )
    M.dot1.anchorX = 0.5
    M.dot1.anchorY = 1
    M.dot1.x = appData.contentW/2 - 8
    M.dot1.y = appData.contentH - display.screenOriginY - appData.margin*4 - 2
    M.dot1.alpha = 0.5
    M.sceneGroup:insert( M.dot1)

    M.dot2 = display.newImageRect( "images/dot.png", 8, 8 )
    M.dot2.anchorX = 0.5
    M.dot2.anchorY = 1
    M.dot2.x = appData.contentW/2 + 8
    M.dot2.y = appData.contentH - display.screenOriginY - appData.margin*4 - 2
    M.dot2.alpha = 1.0
    M.sceneGroup:insert( M.dot2)

    -- login button
    M.nextButton = widget.newButton(
        {
            left = 0,
            top = 0,
            shape = "roundedRect",
            width = 100,
            height = 24,
            cornerRadius = 12,
            label = "Kom i gang",
            fontSize = 13,
            labelColor = { default=appData.colors.confirmButtonLabelDefault, 
                           over=appData.colors.confirmButtonLabelOver 
                         },
            fillColor = { default={0, 0, 0, 0.01}, 
                          over={0, 0, 0, 0.01}
                        },
            strokeColor = { default=appData.colors.confirmButtonLabelDefault, 
                           over=appData.colors.confirmButtonLabelOver 
                        },

            strokeWidth = 1   
        } 
    )

    M.nextButton.anchorX = 1
    M.nextButton.anchorY = 1
    M.nextButton.x = appData.contentW - appData.margin*3
    M.nextButton.y = appData.contentH - display.screenOriginY*2 - appData.margin*3 
    M.postJourneyRideGroup:insert( M.nextButton ) 

end



return M