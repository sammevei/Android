local composer = require( "composer" )
local widget = require( "widget" )
local appData = require( "misc.appData" )
local routines = require( "misc.appRoutines" )

local M = {}

-- background
M.showBackground = function()
    M.background = display.newRect( 0, 0, appData.screenW, appData.screenH )
    M.background.fill = appData.colors.actionText
    M.background.x = appData.contentW/2
    M.background.y = appData.contentH/2
    M.sceneGroup:insert( M.background )
end

-- show header
M.showHeader = function()
  local notificationObject = appData.notification

  -- header
  local titleString
  titleString = notificationObject.header

  M.title = display.newText(
      titleString, 0, 0, appData.transportBackground, native.systemFontBold, 16)

  M.title.x = appData.contentW/2
  M.title.y = display.screenOriginY + appData.margin
  M.title.anchorY = 0
  M.title.fill = appData.colors.background
  M.sceneGroup:insert( M.title )

  -- body
  local timeString
  timeString = notificationObject.body

  M.time = display.newText(
      timeString, 0, 0, appData.transportBackground, 12)

  M.time.x = appData.contentW/2
  M.time.y = 0
  M.time.anchorY = 1
  M.time.fill = appData.colors.background
  M.sceneGroup:insert( M.time )

end

-- adding details
M.showDetails = function()
	-- details group
    M.detailsGroup = display.newGroup()
    M.sceneGroup:insert( M.detailsGroup )

    -- gratis tur
    local gratisString
    gratisString = "Gratis tur"

    M.gratis = display.newText(
        gratisString, 0, 0, appData.actionText, native.systemFontBold, 12 )

    M.gratis.anchorX = 1
    M.gratis.x = appData.contentW - appData.margin*6

    M.gratis.anchorY = 0
    M.gratis.y = appData.margin*4 + 20
    M.gratis.fill = appData.colors.background
    M.detailsGroup:insert( M.gratis )

    -- final adjustmens
    M.detailsGroup.y = appData.contentH
    				 - display.screenOriginY
    				 - appData.margin*2
    				 - M.footerGroup.height
    				 - M.detailsGroup.height
    				 - 50
end

 -- show footer
M.showFooter = function(matched)

    -- footer group
    M.footerGroup = display.newGroup()
    M.sceneGroup:insert( M.footerGroup )

    -- new user button
    M.jaButton = widget.newButton(
        {
            left = 0,
            top = 0,
            shape = "roundedRect",
            width = 120,
            height = 35,
            cornerRadius = 18,
            label = "JA TAKK",
            fontSize = 13,
            labelColor = { default=appData.colors.confirmButtonLabelDefault,
                           over=appData.colors.confirmButtonLabelOver
                         },
            fillColor = { default= appData.colors.blue,
                          over= appData.colors.blue
                        },
            strokeColor = { default=appData.colors.confirmButtonLabelDefault,
                           over=appData.colors.confirmButtonLabelOver
                        },

            strokeWidth = 0
        }
    )

    M.jaButton.anchorY = 0
    M.jaButton.anchorX = 1
    M.jaButton.x = appData.contentW - appData.margin*2
    M.jaButton.y = 0
    M.footerGroup:insert( M.jaButton )

	-- nei button
  M.neiButton = widget.newButton(
      {
          left = 0,
          top = 0,
          shape = "roundedRect",
          width = 120,
          height = 35,
          cornerRadius = 18,
          label = "NEI TAKK",
          fontSize = 13,
          labelColor = { default=appData.colors.confirmButtonLabelDefault,
                         over=appData.colors.confirmButtonLabelOver
                       },
          fillColor = { default= appData.colors.red,
                        over= appData.colors.red
                      },
          strokeColor = { default=appData.colors.confirmButtonLabelDefault,
                         over=appData.colors.confirmButtonLabelOver
                      },

          strokeWidth = 0
      }
  )

  M.neiButton.anchorX = 0;
	M.neiButton.x = appData.margin*2
  M.neiButton.alpha = 0.9
	M.footerGroup:insert( M.neiButton )

	-- final adjustments
	M.footerGroup.x = 0
	M.footerGroup.y = appData.contentH - display.screenOriginY - appData.margin*2 - M.footerGroup.height
end

-- show map
M.showMap = function()

    -- create map
    local myDeparture = {lt, ln}
    local myDestination = {lt, ln}

    local notification = appData.notification

    myDeparture.lt = notification.transport.passenger.from.location.coordinates[2]
    myDeparture.ln = notification.transport.passenger.from.location.coordinates[1]
    myDestination.lt = notification.transport.passenger.to.location.coordinates[2]
    myDestination.ln = notification.transport.passenger.to.location.coordinates[1]

	  routines.createMap(myDeparture.lt, myDeparture.ln, myDestination.lt, myDestination.ln)

    local lon1 = "lon1="..myDeparture.ln
    local lat1 = "lat1="..myDeparture.lt
    local lon2 = "lon2="..myDestination.ln
    local lat2 = "lat2="..myDestination.lt

    local params = lon1.."&"..lat1.."&"..lon2.."&"..lat2
    print("- - - - - - - - - "..params)

	-- show map
	M.transportMap = native.newWebView(
        0,
        0,
        display.contentWidth,
        appData.contentH - display.screenOriginY*2 - 135
    )

    M.transportMap:request( "map.html?"..params, system.DocumentsDirectory )
    M.transportMap.anchorX = 0
    M.transportMap.anchorY = 0
    M.transportMap.x = 0
    M.transportMap.y = display.screenOriginY + 55
    M.sceneGroup:insert( M.transportMap )
end

return M
