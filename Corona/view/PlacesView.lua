local composer = require( "composer" )
local widget = require( "widget" )
local appData = require( "misc.appData" )

local M = {}

M.showBackground = function()
    M.background = display.newRect( 0, 0, appData.screenW, appData.screenH*2 )
    M.background.fill = appData.colors.actionBackground
    M.background.x = appData.contentW/2
    M.background.y = appData.contentH/2
    M.sceneGroup:insert( M.background )
end

M.showTitle = function()
    print("showing title .............. ")
    local titleOptions = 
    {
        text = "VELKOMMEN",
        width = appData.contentW,
        font = appData.fonts.titleText,
        align = "center"
    }

    M.titleText = display.newText( titleOptions )
    M.titleText.fill = appData.colors.actionText

    M.titleText.anchorX = 0.5
    M.titleText.anchorY = 0
    M.titleText.x = appData.contentW/2
    M.titleText.y = display.screenOriginY + appData.actionMargin*2
    M.sceneGroup:insert( M.titleText )
end    

M.showJourneyMenu = function()
   	M.postJourneyRideGroup = display.newGroup()
    -- M.postJourneyRideGroup.y = 300

  --  Tab Background
   	M.postJourneyRideBackground = display.newRect( 0, 0, appData.screenW, appData.screenH*4 )
   	M.postJourneyRideBackground.fill = appData.colors.actionBackground
   	M.postJourneyRideBackground.anchorY = 0
   	M.postJourneyRideBackground.x = appData.contentW/2
   	M.postJourneyRideBackground.y = display.screenOriginY
   	M.postJourneyRideGroup:insert( M.postJourneyRideBackground )

    -- Comment Text
    local commentOptions = 
    {
        text = "Passasjerer plukkes opp innenfor gangavstand fra angitt avreisested.",
        width = appData.contentW - appData.margin*2 - appData.actionMargin*2,
        height = 300,
        font = appData.fonts.actionComment,
    }

    M.commentText = display.newText( commentOptions )
    M.commentText.fill = appData.colors.actionText
 
    M.commentText.anchorX = 0.5
    M.commentText.anchorY = 0
    M.commentText.x = appData.contentW/2
    M.commentText.y = 65
    M.postJourneyRideGroup:insert( M.commentText )  
    M.postJourneyRideGroup.y = display.screenOriginY
    M.sceneGroup:insert( M.postJourneyRideGroup )

  --  Departure Text Field
  	M.departureFieldBackground = display.newRoundedRect(
  		appData.contentW/2, 
  		140, 
  		appData.screenW - appData.margin*2 - appData.actionMargin*2, 
  		30, 
  		appData.actionCorner/2 
  	)
  	M.departureFieldBackground.fill = appData.colors.actionText
  	M.postJourneyRideGroup:insert( M.departureFieldBackground )

    M.departureField = native.newTextField( 
    	appData.contentW/2, 
    	140, 
    	appData.screenW - appData.margin*4 - appData.actionMargin*2, 
    	30 
    )
  
    M.departureField.font = appData.fonts.actionText
    if (appData.transport.from == "") then
        M.departureField.placeholder = "Fra (gate, nummer, by)"
    else
        M.departureField.placeholder = ""
        M.departureField.text = appData.transport.fromAddress
    end          
    M.departureField.align = "left"
    M.departureField.hasBackground = false
    M.departureField.alpha = 0
    M.postJourneyRideGroup:insert( M.departureField )

  --  Destination Text Field
    M.destinationFieldBackground = display.newRoundedRect(
  		appData.contentW/2, 
  		180, 
  		appData.screenW - appData.margin*2 - appData.actionMargin*2, 
  		30, 
  		appData.actionCorner/2 
  	)
  	M.destinationFieldBackground.fill = appData.colors.actionText
  	M.postJourneyRideGroup:insert( M.destinationFieldBackground )

    M.destinationField = native.newTextField( 
    	appData.contentW/2, 
    	180, 
    	appData.screenW - appData.margin*4 - appData.actionMargin*2, 
    	30 
    )
    
    M.destinationField.font = appData.fonts.actionText
    if (appData.transport.to == "") then
        M.destinationField.placeholder = "Til (gate, nummer, by)"
    else
        M.destinationField.placeholder = ""
        M.destinationField.text = appData.transport.toAddress
    end   
    M.destinationField.align = "left"
    M.destinationField.hasBackground = false
    M.destinationField.alpha = 0
    M.postJourneyRideGroup:insert( M.destinationField )
end

M.showDepartureSearchResults = function(places)
    appData.places = places
    M.destinationField.x = 1000 -- move appData.destinationField form out of the view

    -- Departure Table View Row Fender Listener
    local departureSearchResultsRowRender = function(event)
        -- Get reference to the row group
        local row = event.row

        -- Set variable for text
        local rowTitle
        local rowHeight = row.contentHeight
        local rowWidth = row.contentWidth
     
        if appData.places[row.index] ~= nil then
            rowTitle = display.newText( row, appData.places[row.index].description, 0, 0, nil, 12 )
            rowTitle:setFillColor( fieldText )

            -- Align the label left and vertically centered
            rowTitle.anchorX = 0
            rowTitle.x = 10
            rowTitle.y = rowHeight * 0.5
        end
        

    end

    -- Create the departure widget
    if M.departureSearchResults ~= nil then
        M.departureSearchResults:removeSelf()
        M.departureSearchResults = nil
    end 

    M.departureSearchResults = widget.newTableView(
        {
            left = 0,
            top = 200,
            height = 330,
            width = appData.screenW - appData.margin*2 - appData.actionMargin*2,
            onRowRender = departureSearchResultsRowRender,
            noLines = true
        }
    )

    M.departureSearchResults.anchorY = 0
    M.departureSearchResults.anchorX = 0.5
    M.departureSearchResults.x = appData.contentW/2
    M.departureSearchResults.y = appData.margin*2 + 140
    M.postJourneyRideGroup:insert( M.departureSearchResults )
     
    -- Insert Rows
    for i = 1, 5 do
        -- Insert a row into the tableView
        M.departureSearchResults:insertRow{}
    end
end

M.showDestinationSearchResults = function(places)
    appData.places = places

    -- Table View Row Listener
    local destinationSearchResultsRowRender = function(event)
        -- print("DESTINATION")
        -- Get reference to the row group
        local row = event.row

        -- Set variable for text
        local rowTitle
     
        -- Cache the row "contentWidth" and "contentHeight" because the row bounds can change as children objects are added
        local rowHeight = row.contentHeight
        local rowWidth = row.contentWidth
     
        if appData.places[row.index] ~= nil then
            rowTitle = display.newText( row, appData.places[row.index].description, 0, 0, nil, 12 )
            rowTitle:setFillColor( fieldText )

            -- Align the label left and vertically centered
            rowTitle.anchorX = 0
            rowTitle.x = 10
            rowTitle.y = rowHeight * 0.5
        end
        

    end

    -- Create the widget
    if M.destinationSearchResults ~= nil then
        M.destinationSearchResults:removeSelf()
        M.destinationSearchResults = nil
    end 

    M.destinationSearchResults = widget.newTableView(
        {
            left = 0,
            top = 200,
            height = 330,
            width = appData.screenW - appData.margin*2 - appData.actionMargin*2,
            onRowRender = destinationSearchResultsRowRender,
            noLines = true
        }
    )

    M.destinationSearchResults.anchorY = 0
    M.destinationSearchResults.anchorX = 0.5
    M.destinationSearchResults.x = appData.contentW/2
    M.destinationSearchResults.y = appData.margin*2+180
    M.postJourneyRideGroup:insert( M.destinationSearchResults )
     
    -- Insert Rows
    for i = 1, 5 do
        -- Insert a row into the tableView
        M.destinationSearchResults:insertRow{}
    end
end

M.showCircle = function()
    local circle = display.newImageRect( 
    "images/circle.png", 
    appData.contentW - appData.actionMargin*8 - display.screenOriginY*0.7, 
    appData.contentW - appData.actionMargin*8 - display.screenOriginY*0.7)
    circle.anchorX = 0.5
    circle.anchorY = 0.0
    circle.x = appData.contentW/2
    circle.y = 220
    circle.alpha = 1
    M.postJourneyRideGroup:insert( circle )
end

M.showButtons = function()
    -- Three Dots
    M.dot1 = display.newImageRect( "images/dot.png", 8, 8 )
    M.dot1.anchorX = 0.5
    M.dot1.anchorY = 1
    M.dot1.x = appData.contentW/2 - 8
    M.dot1.y = appData.contentH - display.screenOriginY - appData.margin*4 - 2
    M.dot1.alpha = 1
    M.sceneGroup:insert( M.dot1)

    M.dot2 = display.newImageRect( "images/dot.png", 8, 8 )
    M.dot2.anchorX = 0.5
    M.dot2.anchorY = 1
    M.dot2.x = appData.contentW/2 + 8
    M.dot2.y = appData.contentH - display.screenOriginY - appData.margin*4 - 2
    M.dot2.alpha = 0.5
    M.sceneGroup:insert( M.dot2)

    -- login button
    M.nextButton = widget.newButton(
        {
            left = 0,
            top = 0,
            shape = "roundedRect",
            width = 80,
            height = 24,
            cornerRadius = 12,
            label = "Neste",
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

    M.nextButton.anchorX = 1
    M.nextButton.anchorY = 1
    M.nextButton.x = appData.contentW - appData.margin*3
    M.nextButton.y = appData.contentH - display.screenOriginY - appData.margin*3 
    M.sceneGroup:insert( M.nextButton )    

    --[[
    M.dot3 = display.newImageRect( "images/dot.png", 10, 10 )
    M.dot3.anchorX = 0.5
    M.dot3.anchorY = 1
    M.dot3.x = appData.contentW/2 + 20
    M.dot3.y = appData.contentH - 2*display.screenOriginY - appData.actionMargin-appData.margin
    M.dot3.alpha = 0.5
    M.postJourneyRideGroup:insert( M.dot3)
    --]]

    -- Back Button 
    --[[
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
    

    -- Forward Button
    M.forwardButton = widget.newButton(
        {
            width = 45,
            height = 45,
            defaultFile = "images/fB.png",
            overFile = "images/fB.png",
        }
    )

    M.forwardButton.anchorX = 1.0
    M.forwardButton.anchorY = 1
    M.forwardButton.x = appData.contentW - display.screenOriginX - appData.actionMargin
    M.forwardButton.y = appData.contentH - 2*display.screenOriginY - appData.actionMargin
    M.postJourneyRideGroup:insert( M.forwardButton)
    --]]
end

return M