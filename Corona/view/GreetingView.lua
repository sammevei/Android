local composer = require( "composer" )
local widget = require( "widget" )
local appData = require( "misc.appData" )
local routines = require( "misc.appRoutines" )

widget.setTheme( "widget_theme_ios7" )

local M = {}
-- -----------------------------------------------------------------------------
-- BACKGROUND
-- -----------------------------------------------------------------------------
M.showBackground = function(event)
    M.background = display.newRect( 0, 0, appData.screenW, appData.screenH )
    M.background.fill = appData.colors.transportBackground
    M.background.x = appData.contentW/2
    M.background.y = appData.contentH/2
    M.sceneGroup:insert( M.background )
end

-- -----------------------------------------------------------------------------
-- BAR
-- -----------------------------------------------------------------------------
M.showBar = function(event)
    M.commutingGroup = display.newGroup()

    --  Tab Background -----------------------------------------------------------------------------

    M.topBar = display.newRect( 0, 0, appData.screenW, 35)
    M.topBar.fill = appData.colors.actionBackground
    M.topBar.anchorY = 0
    M.topBar.x = appData.contentW/2
    M.topBar.y = 0
    M.commutingGroup:insert( M.topBar )

    -- Info Text ---------------------------------------------------------------------------------

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
    M.infoText.y = M.topBar.y + appData.margin
    M.commutingGroup:insert( M.infoText )

    -- Options Icon
    M.optionsIcon = display.newImageRect( "images/settings.png", 90, 35 )
    M.optionsIcon.x = -5
    M.optionsIcon.y = 0
    M.optionsIcon.anchorX = 0
    M.optionsIcon.anchorY = 0
    M.optionsIcon.alpha = 0.8
    M.commutingGroup:insert( M.optionsIcon )

    -- Final Setup --------------------------------------------------------------------------------------
    M.commutingGroup.y = display.screenOriginY
    M.sceneGroup:insert( M.commutingGroup )
end

-- -----------------------------------------------------------------------------
-- SCHEDULE
-- -----------------------------------------------------------------------------
M.showSchedule = function()

    -- Prepare Variables
    local viewRows = 0
    for k,v in pairs(appData.schedule) do
        viewRows = viewRows + 1
        -- print("ROW="..viewRows)
    end
    viewRows = viewRows/2

    M.rowHeight = 60
    local rowHeight = M.rowHeight
    M.headerHeight = 30
    local headerHeight = M.headerHeight

    local headers = {}
    M.mornings = {}
    M.afternoons = {}
    local days = {}
    local dayNames = {"MANDAG", "TIRSDAG", "ONSDAG", "TORSDAG", "FREDAG", "LØRDAG", "SØNDAG"}     
     
     -- Shift dayNames Array
    local s = 0

    if (os.date( "%a" ) == "Mon") then s = 6 
    elseif (os.date( "%a" ) == "Tue") then s = 5 
    elseif (os.date( "%a" ) == "Wed") then s = 4 
    elseif (os.date( "%a" ) == "Thu") then s = 3 
    elseif (os.date( "%a" ) == "Fri") then s = 2 
    elseif (os.date( "%a" ) == "Sat") then s = 1 
    elseif (os.date( "%a" ) == "Sun") then s = 0     
    end

    for i = 1, s do
        table.insert( dayNames, 1, dayNames[#dayNames] )
        table.remove( dayNames, #dayNames )
    end

    -- Shift Schedule
    -- MODE
    local modes = {
            {morningMode = appData.schedule[1].mode, afternoonMode = appData.schedule[2].mode},
            {morningMode = appData.schedule[3].mode, afternoonMode = appData.schedule[4].mode}, 
            {morningMode = appData.schedule[5].mode, afternoonMode = appData.schedule[6].mode},
            {morningMode = appData.schedule[7].mode, afternoonMode = appData.schedule[8].mode},
            {morningMode = appData.schedule[9].mode, afternoonMode = appData.schedule[10].mode},
            {morningMode = appData.schedule[11].mode, afternoonMode = appData.schedule[12].mode},
            {morningMode = appData.schedule[13].mode, afternoonMode = appData.schedule[14].mode},      
        }

    local mt1=routines.UTCtoLocal(appData.dummyTransports[1].starting_at) 
    local at1=routines.UTCtoLocal(appData.dummyTransports[2].starting_at) 
    local mt2=routines.UTCtoLocal(appData.dummyTransports[3].starting_at)  
    local at2=routines.UTCtoLocal(appData.dummyTransports[4].starting_at) 
    local mt3=routines.UTCtoLocal(appData.dummyTransports[5].starting_at)  
    local at3=routines.UTCtoLocal(appData.dummyTransports[6].starting_at) 
    local mt4=routines.UTCtoLocal(appData.dummyTransports[7].starting_at) 
    local at4=routines.UTCtoLocal(appData.dummyTransports[8].starting_at) 
    local mt5=routines.UTCtoLocal(appData.dummyTransports[9].starting_at) 
    local at5=routines.UTCtoLocal(appData.dummyTransports[10].starting_at) 
    local mt6=routines.UTCtoLocal(appData.dummyTransports[11].starting_at) 
    local at6=routines.UTCtoLocal(appData.dummyTransports[12].starting_at) 
    local mt7=routines.UTCtoLocal(appData.dummyTransports[13].starting_at) 
    local at7=routines.UTCtoLocal(appData.dummyTransports[14].starting_at) 

    local times = {
        {morningTime = mt1.hour*60 + mt1.sec/60, afternoonTime = at1.hour*60 + at1.sec/60},
        {morningTime = mt2.hour*60 + mt2.sec/60, afternoonTime = at2.hour*60 + at2.sec/60},
        {morningTime = mt3.hour*60 + mt3.sec/60, afternoonTime = at3.hour*60 + at3.sec/60},
        {morningTime = mt4.hour*60 + mt4.sec/60, afternoonTime = at4.hour*60 + at4.sec/60},
        {morningTime = mt5.hour*60 + mt5.sec/60, afternoonTime = at5.hour*60 + at5.sec/60},
        {morningTime = mt6.hour*60 + mt6.sec/60, afternoonTime = at6.hour*60 + at6.sec/60},
        {morningTime = mt7.hour*60 + mt6.sec/60, afternoonTime = at7.hour*60 + at7.sec/60}   
    }   


    M.status={ morning = {}, afternoon = {} }
    M.statusInfo={ morning = {}, afternoon = {} } 
    M.hint = { morning = {}, afternoon = {} }   
    M.switches={ morning = {}, afternoon = {} }
    M.masks={ morning = {}, afternoon = {} }
    M.portraits={ morning = {}, afternoon = {} }
    M.names={ morning = {}, afternoon = {} }
    M.roles={ morning = {}, afternoon = {} }
    M.phones={ morning = {}, afternoon = {} }
    M.chats={ morning = {}, afternoon = {} }
    M.periods={ morning = {}, afternoon = {} }
    M.hours={ morning = {}, afternoon = {} }
    M.dots={ morning = {}, afternoon = {} }



    -- Show Schedule ------------------------------------------------------------------------------------------
    M.scheduleView = display.newGroup()
    local scheduleView = M.scheduleView

    -- Make Today ---------------------------------------------------------------------------------------------
       
       M.todayGroup = display.newGroup()
       local todayGroup = M.todayGroup
       
       todayGroup.anchorY = 0
       todayGroup.y = 0
       todayGroup.alpha = 1

       local i = 0
        -- Header

        -- background   
        M.todayHeader = display.newRect( 0, 0, appData.screenW, headerHeight )
        M.todayHeader.fill = appData.colors.actionBackground
        M.todayHeader.anchorX = 0
        M.todayHeader.anchorY = 0 
        M.todayHeader.x=display.screenOriginX 
        M.todayHeader.y=(i-1)*(headerHeight+rowHeight+rowHeight)
        todayGroup:insert( M.todayHeader ) 

            -- day name 
        local daysOptions = 
            {
                text = "I DAG",
                width = appData.screenW - appData.margin*2 - appData.actionMargin*2,
                font = appData.fonts.actionText,
                align = "left"
            }

        M.day = display.newText( daysOptions )
        M.day.fill = appData.colors.actionText
        M.day.anchorX = 0
        M.day.anchorY = 0
        M.day.x = display.screenOriginX + appData.margin
        M.day.y = (i-1)*(headerHeight+rowHeight+rowHeight)+appData.margin
        todayGroup:insert( M.day )

        days.text = "I DAG"
           
        -- MORNING ---------------------------------------------------------------------

            -- background  
        M.todayMorning = display.newRect( 0, 0, appData.screenW, rowHeight )
        M.todayMorning.fill = appData.colors.transportBackground
        M.todayMorning.anchorX = 0
        M.todayMorning.anchorY = 0 
        M.todayMorning.x = display.screenOriginX 
        M.todayMorning.y=(i-1)*(headerHeight+rowHeight+rowHeight)+headerHeight
        todayGroup:insert( M.todayMorning )

        -- period
        local periodsOptions = 
        
            {
                text = "Morgen", 
                width = appData.screenW - appData.margin*2 - appData.actionMargin*2,
                font = appData.fonts.titleTextBold,
                align = "left"
            }

        M.todayMorningPeriod = display.newText( periodsOptions )
        M.todayMorningPeriod.fill = appData.colors.actionText
        M.todayMorningPeriod.anchorX = 0
        M.todayMorningPeriod.anchorY = 0
        M.todayMorningPeriod.x = display.screenOriginX + appData.margin
        M.todayMorningPeriod.y = 3+(i-1)*(headerHeight+rowHeight+rowHeight)+headerHeight
        todayGroup:insert( M.todayMorningPeriod ) 
        M.todayMorningPeriod.alpha = 1

            -- photo  
        M.todayMorningPortrait = display.newImageRect( "images/portrait.png", 50, 50 )
        M.todayMorningPortrait.anchorX = 0
        M.todayMorningPortrait.anchorY = 0
        M.todayMorningPortrait.x = 0 + appData.margin + display.screenOriginX
        M.todayMorningPortrait.y = 5+(i-1)*(headerHeight+rowHeight+rowHeight)+headerHeight
        todayGroup:insert(M.todayMorningPortrait)
        M.todayMorningPortrait.alpha = 0
    
        
        local morningPortraitMask
        M.morningPortraitMask = morningPortraitMask

        morningPortraitMask = graphics.newMask( "images/portraitMask.png" )
        M.todayMorningPortrait:setMask( morningPortraitMask )
        M.todayMorningPortrait.maskScaleX = 0.2
        M.todayMorningPortrait.maskScaleY = 0.2

        -- role
        local todayMorningRoleOptions = 
        
            {
                text = "", 
                width = appData.screenW - appData.margin*2 - appData.actionMargin*2,
                font = appData.fonts.actionText,
                align = "left"
            }

        M.todayMorningRole = display.newText( todayMorningRoleOptions )
        M.todayMorningRole.fill = appData.colors.actionText
        M.todayMorningRole.anchorX = 0
        M.todayMorningRole.anchorY = 0
        M.todayMorningRole.x = display.screenOriginX + appData.margin + 60
        M.todayMorningRole.y = 5+(i-1)*(headerHeight+rowHeight+rowHeight)+headerHeight
        todayGroup:insert( M.todayMorningRole ) 
        M.todayMorningRole.alpha = 0

        -- name
        local todayMorningNameOptions = 
        
            {
                text = "Name", 
                width = appData.screenW - appData.margin*2 - appData.actionMargin*2,
                font = appData.fonts.titleTextBold,
                align = "left"
            }

        M.todayMorningName = display.newText( todayMorningNameOptions )
        M.todayMorningName.fill = appData.colors.statusText
        M.todayMorningName.anchorX = 0
        M.todayMorningName.anchorY = 0
        M.todayMorningName.x = display.screenOriginX + appData.margin + 60
        M.todayMorningName.y = 35+(i-1)*(headerHeight+rowHeight+rowHeight)+headerHeight
        todayGroup:insert( M.todayMorningName ) 
        M.todayMorningName.alpha = 0

            -- mode
        local modeOptions = 
        
            {
                text = "", 
                width = appData.screenW - appData.margin*2 - appData.actionMargin*2,
                font = appData.fonts.actionText,
                align = "left"
            }

        local mode

        mode = display.newText( modeOptions )
        mode.fill = appData.colors.actionText
        mode.anchorX = 0
        mode.anchorY = 0
        mode.x = display.screenOriginX + appData.margin + 60
        mode.y = 5+(i-1)*(headerHeight+rowHeight+rowHeight)+headerHeight
        todayGroup:insert( mode ) 
        mode.alpha = 0

    --    if (modes[i].morningMode == "1") then  
    --        mode.text = "Passasjer"
    --    elseif (modes[i].morningMode == "2") then 
    --        mode.text = "Sjåfør"
    --    elseif (modes[i].morningMode == "3") then 
    --        mode.text = "Begge deler" 
    --    end 

            --offset
        local morningTimeOptions = 
        
            {
                text = "",
                width = appData.screenW - appData.margin*2 - appData.actionMargin*2,
                font = appData.fonts.actionText,
                align = "right"
            }

        M.todayMorningTime = display.newText( morningTimeOptions )
        M.todayMorningTime.fill = appData.colors.actionText
        M.todayMorningTime.anchorX = 1
        M.todayMorningTime.anchorY = 0
        M.todayMorningTime.x = appData.contentW - display.screenOriginX - appData.actionMargin
        M.todayMorningTime.y = 5+(i-1)*(headerHeight+rowHeight+rowHeight)+headerHeight
        todayGroup:insert( M.todayMorningTime ) 

        -- enabled
        M.todayMorningSwitch = widget.newSwitch(
            {
                left = 0,
                top = 0,
                style = "onOff",
                initialSwitchState = false
            }
        )

        M.todayMorningSwitch.anchorX = 1
        M.todayMorningSwitch.anchorY = 0
        M.todayMorningSwitch.x = appData.contentW - display.screenOriginX - appData.actionMargin
        M.todayMorningSwitch.y = 28+(i-1)*(headerHeight+rowHeight+rowHeight)+headerHeight        
        M.todayMorningSwitch:scale(0.6, 0.6)
        todayGroup:insert( M.todayMorningSwitch ) 
        M.todayMorningSwitch.alpha = 0


        M.todayMorningMask = display.newRect( 0, 0, 30, 15 )
        M.todayMorningMask.id = "m".."0"
        M.todayMorningMask.fill = {1, 0, 0, 0.01}
        M.todayMorningMask.anchorX = 1
        M.todayMorningMask.anchorY = 0 
        M.todayMorningMask.x=appData.contentW - display.screenOriginX - appData.actionMargin
        M.todayMorningMask.y=33+(i-1)*(headerHeight+rowHeight+rowHeight)+headerHeight 
        todayGroup:insert( M.todayMorningMask ) 

        -- status
        local statusOptions = 
        
            {
                text = "", 
                width = appData.screenW - appData.margin*2, -- - appData.actionMargin*2,
                font = appData.fonts.actionText,
                align = "right"
            }

        M.todayMorningStatus = display.newText( statusOptions )
        M.todayMorningStatus.fill = appData.colors.statusText
        M.todayMorningStatus.anchorX = 1
        M.todayMorningStatus.anchorY = 0
        M.todayMorningStatus.x = appData.contentW - display.screenOriginX - appData.actionMargin -- - 50
        M.todayMorningStatus.y = 5+(i-1)*(headerHeight+rowHeight+rowHeight)+headerHeight
        todayGroup:insert( M.todayMorningStatus )

        -- phone
        M.todayMorningPhone = display.newImageRect( "images/phone.png", 32, 24 )
        M.todayMorningPhone.anchorX = 1
        M.todayMorningPhone.anchorY = 0
        M.todayMorningPhone.x = appData.contentW - display.screenOriginX - appData.actionMargin
        M.todayMorningPhone.y = 30+(i-1)*(headerHeight+rowHeight+rowHeight)+headerHeight
        M.todayMorningPhone.alpha = 0
        todayGroup:insert( M.todayMorningPhone )

        -- chat
        M.todayMorningChat = display.newImageRect( "images/chat.png", 32, 24 )
        M.todayMorningChat.anchorX = 1
        M.todayMorningChat.anchorY = 0
        M.todayMorningChat.x = appData.contentW - 40 - display.screenOriginX - appData.actionMargin
        M.todayMorningChat.y = 30+(i-1)*(headerHeight+rowHeight+rowHeight)+headerHeight
        M.todayMorningChat.alpha = 0
        todayGroup:insert( M.todayMorningChat )

        -- AFTERNOON ---------------------------------------------------------------------

            -- background 
        local todayAfternoon   
        M.todayAfternoon = todayAfternoon

        todayAfternoon = display.newRect( 0, 0, appData.screenW, rowHeight )
        todayAfternoon.fill = appData.colors.transportBackground
        todayAfternoon.anchorX = 0
        todayAfternoon.anchorY = 0 
        todayAfternoon.x = display.screenOriginX 
        todayAfternoon.y=(i-1)*(headerHeight+rowHeight+rowHeight)+headerHeight+rowHeight
        todayGroup:insert( todayAfternoon )

        -- period
        local periodsOptions = 
        
            {
                text = "Ettermiddag", 
                width = appData.screenW - appData.margin*2 - appData.actionMargin*2,
                font = appData.fonts.titleTextBold,
                align = "left"
            }

        M.todayAfternoonPeriod = display.newText( periodsOptions )
        M.todayAfternoonPeriod.fill = appData.colors.actionText
        M.todayAfternoonPeriod.anchorX = 0
        M.todayAfternoonPeriod.anchorY = 0
        M.todayAfternoonPeriod.x = display.screenOriginX + appData.margin
        M.todayAfternoonPeriod.y = 3+(i-1)*(headerHeight+rowHeight+rowHeight)+headerHeight+rowHeight
        todayGroup:insert( M.todayAfternoonPeriod ) 
        M.todayAfternoonPeriod.alpha = 1 

            -- photo   
        M.todayAfternoonPortrait = display.newImageRect( "images/portrait.png", 50, 50 )
        M.todayAfternoonPortrait.anchorX = 0
        M.todayAfternoonPortrait.anchorY = 0
        M.todayAfternoonPortrait.x = 0 + appData.margin + display.screenOriginX
        M.todayAfternoonPortrait.y = 5+(i-1)*(headerHeight+rowHeight+rowHeight)+headerHeight+rowHeight
        todayGroup:insert( M.todayAfternoonPortrait)
        M.todayAfternoonPortrait.alpha = 0
    
        local afternoonPortraitMask = graphics.newMask( "images/portraitMask.png" )
        M.todayAfternoonPortrait:setMask( afternoonPortraitMask )
        M.todayAfternoonPortrait.maskScaleX = 0.2
        M.todayAfternoonPortrait.maskScaleY = 0.2


        -- role
        local todayRoleOptions = 
        
            {
                text = "", 
                width = appData.screenW - appData.margin*2 - appData.actionMargin*2,
                font = appData.fonts.actionText,
                align = "left"
            }

        M.todayAfternoonRole = display.newText( todayRoleOptions )
        M.todayAfternoonRole.fill = appData.colors.actionText
        M.todayAfternoonRole.anchorX = 0
        M.todayAfternoonRole.anchorY = 0
        M.todayAfternoonRole.x = display.screenOriginX + appData.margin + 60
        M.todayAfternoonRole.y = 5+(i-1)*(headerHeight+rowHeight+rowHeight)+headerHeight
        todayGroup:insert( M.todayAfternoonRole ) 
        M.todayAfternoonRole.alpha = 0

        -- name
        local todayAfternoonNameOptions = 
        
            {
                text = "Name", 
                width = appData.screenW - appData.margin*2 - appData.actionMargin*2,
                font = appData.fonts.titleTextBold,
                align = "left"
            }

        M.todayAfternoonName = display.newText( todayAfternoonNameOptions )
        M.todayAfternoonName.fill = appData.colors.statusText
        M.todayAfternoonName.anchorX = 0
        M.todayAfternoonName.anchorY = 0
        M.todayAfternoonName.x = display.screenOriginX + appData.margin + 60
        M.todayAfternoonName.y = 35+(i-1)*(headerHeight+rowHeight+rowHeight)+headerHeight
        todayGroup:insert( M.todayAfternoonName ) 
        M.todayAfternoonName.alpha = 0

            -- mode
        local modeOptions = 
        
            {
                text = "", 
                width = appData.screenW - appData.margin*2 - appData.actionMargin*2,
                font = appData.fonts.actionText,
                align = "left"
            }

        local mode

        mode = display.newText( modeOptions )
        mode.fill = appData.colors.actionText
        mode.anchorX = 0
        mode.anchorY = 0
        mode.x = display.screenOriginX + appData.margin + 60
        mode.y = 5+(i-1)*(headerHeight+rowHeight+rowHeight)+headerHeight+rowHeight
        todayGroup:insert( mode ) 
        mode.alpha = 0

            --offset
        local afternoonTimeOptions = 
        
            {
                text = "", 
                width = appData.screenW - appData.margin*2 - appData.actionMargin*2,
                font = appData.fonts.actionText,
                align = "right"
            }

        M.todayAfternoonTime = display.newText( afternoonTimeOptions )
        M.todayAfternoonTime.fill = appData.colors.actionText
        M.todayAfternoonTime.anchorX = 1
        M.todayAfternoonTime.anchorY = 0
        M.todayAfternoonTime.x = appData.contentW - display.screenOriginX - appData.actionMargin
        M.todayAfternoonTime.y = 5+(i-1)*(headerHeight+rowHeight+rowHeight)+headerHeight+rowHeight
        todayGroup:insert( M.todayAfternoonTime ) 

        -- enabled
        M.todayAfternoonSwitch = widget.newSwitch(
            {
                left = 0,
                top = 0,
                style = "onOff",
                initialSwitchState = false
            }
        )

        M.todayAfternoonSwitch.anchorX = 1
        M.todayAfternoonSwitch.anchorY = 0
        M.todayAfternoonSwitch.x = appData.contentW - display.screenOriginX - appData.actionMargin
        M.todayAfternoonSwitch.y = 28+(i-1)*(headerHeight+rowHeight+rowHeight)+headerHeight+rowHeight        
        M.todayAfternoonSwitch:scale(0.6, 0.6)
        todayGroup:insert( M.todayAfternoonSwitch )
        M.todayAfternoonSwitch.alpha = 0 


        M.todayAfternoonMask = display.newRect( 0, 0, 30, 15 )
        M.todayAfternoonMask.id = "m".."0"
        M.todayAfternoonMask.fill = {1, 0, 0, 0.01}
        M.todayAfternoonMask.anchorX = 1
        M.todayAfternoonMask.anchorY = 0 
        M.todayAfternoonMask.x=appData.contentW - display.screenOriginX - appData.actionMargin
        M.todayAfternoonMask.y=33+(i-1)*(headerHeight+rowHeight+rowHeight)+headerHeight+rowHeight 
        todayGroup:insert( M.todayAfternoonMask ) 

        -- status     
        local statusOptions = 
        
            {
                text = "", 
                width = appData.screenW - appData.margin*2, -- - appData.actionMargin*2,
                font = appData.fonts.actionText,
                align = "right"
            }

        M.todayAfternoonStatus = display.newText( statusOptions )
        M.todayAfternoonStatus.fill = appData.colors.statusText
        M.todayAfternoonStatus.anchorX = 1
        M.todayAfternoonStatus.anchorY = 0
        M.todayAfternoonStatus.x = appData.contentW - display.screenOriginX - appData.actionMargin -- - 50
        M.todayAfternoonStatus.y = 5+(i-1)*(headerHeight+rowHeight+rowHeight)+headerHeight+rowHeight
        todayGroup:insert( M.todayAfternoonStatus )

        -- role
        local roleOptions = 
        
            {
                text = "", 
                width = appData.screenW - appData.margin*2 - appData.actionMargin*2,
                font = appData.fonts.actionText,
                align = "left"
            }

        M.todayAfternoonRole = display.newText( roleOptions )
        M.todayAfternoonRole.fill = appData.colors.actionText
        M.todayAfternoonRole.anchorX = 0
        M.todayAfternoonRole.anchorY = 0
        M.todayAfternoonRole.x = display.screenOriginX + appData.margin + 60
        M.todayAfternoonRole.y = 5+(i-1)*(headerHeight+rowHeight+rowHeight)+headerHeight+rowHeight
        todayGroup:insert( M.todayAfternoonRole ) 
        M.todayAfternoonRole.alpha = 1
        
        -- name
        local nameOptions = 
        
            {
                text = "", 
                width = appData.screenW - appData.margin*2 - appData.actionMargin*2,
                font = appData.fonts.titleTextBold,
                align = "left"
            }

        M.todayAfternoonName = display.newText( nameOptions )
        M.todayAfternoonName.fill = appData.colors.statusText
        M.todayAfternoonName.anchorX = 0
        M.todayAfternoonName.anchorY = 0
        M.todayAfternoonName.x = display.screenOriginX + appData.margin + 60
        M.todayAfternoonName.y = 35+(i-1)*(headerHeight+rowHeight+rowHeight)+headerHeight + rowHeight
        todayGroup:insert( M.todayAfternoonName ) 
        M.todayAfternoonName.alpha = 1

        -- phone
        M.todayAfternoonPhone = display.newImageRect( "images/phone.png", 32, 24 )
        M.todayAfternoonPhone.anchorX = 1
        M.todayAfternoonPhone.anchorY = 0
        M.todayAfternoonPhone.x = appData.contentW - display.screenOriginX - appData.actionMargin
        M.todayAfternoonPhone.y = 30+(i-1)*(headerHeight+rowHeight+rowHeight)+headerHeight + rowHeight
        M.todayAfternoonPhone.alpha = 0
        todayGroup:insert( M.todayAfternoonPhone ) 

        -- chat
        M.todayAfternoonChat = display.newImageRect( "images/chat.png", 32, 24 )
        M.todayAfternoonChat.anchorX = 1
        M.todayAfternoonChat.anchorY = 0
        M.todayAfternoonChat.x = appData.contentW - 40 - display.screenOriginX - appData.actionMargin
        M.todayAfternoonChat.y = 30+(i-1)*(headerHeight+rowHeight+rowHeight)+headerHeight + rowHeight
        M.todayAfternoonChat.alpha = 0
        todayGroup:insert( M.todayAfternoonChat ) 

        -- fimalize today
        scheduleView:insert( todayGroup )
        todayGroup.alpha = 1


     


    -- Populate The View for next days-------------------------------------------------------------------------
    for i = 1, viewRows do 
        -- Header

            -- background
        headers[i] = display.newRect( 0, 0, appData.screenW, headerHeight )
        headers[i].fill = appData.colors.actionBackground
        headers[i].anchorX = 0
        headers[i].anchorY = 0 
        headers[i].x=display.screenOriginX 
        headers[i].y=(i-1)*(headerHeight+rowHeight+rowHeight)
        scheduleView:insert( headers[i] ) 

            -- day name
        local daysOptions = 
            {
                text = dayNames[i],
                width = appData.screenW - appData.margin*2 - appData.actionMargin*2,
                font = appData.fonts.actionText,
                align = "left"
            }

        days[i] = display.newText( daysOptions )
        days[i].fill = appData.colors.actionText
        days[i].anchorX = 0
        days[i].anchorY = 0
        days[i].x = display.screenOriginX + appData.margin
        days[i].y = (i-1)*(headerHeight+rowHeight+rowHeight)+appData.margin
        scheduleView:insert( days[i] )

        if (i == 1) then days[i].text = "I MORGEN" end
           
        -- MORNING ---------------------------------------------------------------------
        -- background 
        M.mornings[i] = display.newRect( 0, 0, appData.contentW, rowHeight )
        M.mornings[i].fill = appData.colors.transportBackground
        M.mornings[i].anchorX = 0
        M.mornings[i].anchorY = 0 
        M.mornings[i].x = display.screenOriginX 
        M.mornings[i].y=(i-1)*(headerHeight+rowHeight+rowHeight)+headerHeight
        M.mornings[i].id = i*2-1
        scheduleView:insert( M.mornings[i] ) 

        -- dots
        M.dots.morning[i] = display.newCircle( 0, 0, 3 )
        M.dots.morning[i].fill = appData.colors.statusText
        M.dots.morning[i].anchorX = 0
        M.dots.morning[i].anchorY = 0
        M.dots.morning[i].x = display.screenOriginX + appData.margin
        M.dots.morning[i].y = 30+(i-1)*(headerHeight+rowHeight+rowHeight)+headerHeight
        scheduleView:insert( M.dots.morning[i] ) 
        M.dots.morning[i].alpha = 0

        -- period
        local periodsOptions = 
        
            {
                text = "Morgen", 
                width = appData.screenW - appData.margin*2 - appData.actionMargin*2,
                font = appData.fonts.titleTextBold,
                align = "left"
            }

        M.periods.morning[i] = display.newText( periodsOptions )
        M.periods.morning[i].fill = appData.colors.actionText
        M.periods.morning[i].anchorX = 0
        M.periods.morning[i].anchorY = 0
        M.periods.morning[i].x = display.screenOriginX + appData.margin
        M.periods.morning[i].y = 3+(i-1)*(headerHeight+rowHeight+rowHeight)+headerHeight
        scheduleView:insert( M.periods.morning[i] ) 
        M.periods.morning[i].alpha = 1

        -- photo
        M.portraits.morning[i] = display.newImageRect( "images/portrait.png", 50, 50 )
        M.portraits.morning[i].anchorX = 0
        M.portraits.morning[i].anchorY = 0
        M.portraits.morning[i].x = 0 + appData.margin + display.screenOriginX
        M.portraits.morning[i].y = 5+(i-1)*(headerHeight+rowHeight+rowHeight)+headerHeight
        scheduleView:insert(M.portraits.morning[i])
        M.portraits.morning[i].alpha = 0
    
        local morningPortraitMask = graphics.newMask( "images/portraitMask.png" )
        M.portraits.morning[i]:setMask( morningPortraitMask )
        M.portraits.morning[i].maskScaleX = 0.2
        M.portraits.morning[i].maskScaleY = 0.2
        

        -- role
        local roleOptions = 
        
            {
                text = "", 
                width = appData.screenW - appData.margin*2 - appData.actionMargin*2,
                font = appData.fonts.actionText,
                align = "left"
            }

        M.roles.morning[i] = display.newText( roleOptions )
        M.roles.morning[i].fill = appData.colors.actionText
        M.roles.morning[i].anchorX = 0
        M.roles.morning[i].anchorY = 0
        M.roles.morning[i].x = display.screenOriginX + appData.margin + 60
        M.roles.morning[i].y = 5+(i-1)*(headerHeight+rowHeight+rowHeight)+headerHeight
        scheduleView:insert( M.roles.morning[i] ) 
        M.roles.morning[i].alpha = 0
        
        -- name
        local nameOptions = 
        
            {
                text = "Name", 
                width = appData.screenW - appData.margin*2 - appData.actionMargin*2,
                font = appData.fonts.titleTextBold,
                align = "left"
            }

        M.names.morning[i] = display.newText( nameOptions )
        M.names.morning[i].fill = appData.colors.statusText
        M.names.morning[i].anchorX = 0
        M.names.morning[i].anchorY = 0
        M.names.morning[i].x = display.screenOriginX + appData.margin + 60
        M.names.morning[i].y = 35+(i-1)*(headerHeight+rowHeight+rowHeight)+headerHeight
        scheduleView:insert( M.names.morning[i] ) 
        M.names.morning[i].alpha = 0

            -- mode
        local modeOptions = 
        
            {
                text = "", 
                width = appData.screenW - appData.margin*2 - appData.actionMargin*2,
                font = appData.fonts.actionText,
                align = "left"
            }

        local mode = display.newText( modeOptions )
        mode.fill = appData.colors.actionText
        mode.anchorX = 0
        mode.anchorY = 0
        mode.x = display.screenOriginX + appData.margin + 60
        mode.y = 5+(i-1)*(headerHeight+rowHeight+rowHeight)+headerHeight
        scheduleView:insert( mode ) 
        mode.alpha = 0

        if (modes[i].morningMode == "1") then  
            mode.text = "Passenger"
        elseif (modes[i].morningMode == "2") then 
            mode.text = "Driver"
        elseif (modes[i].morningMode == "3") then 
            mode.text = "Both" 
        end 

            --offset
        local morningTimeOptions = 
        
            {
                text = times[i].morningTime, 
                width = appData.screenW - appData.margin*2 - appData.actionMargin*2,
                font = appData.fonts.actionText,
                align = "right"
            }

        M.hours.morning[i] = display.newText( morningTimeOptions )
        M.hours.morning[i].fill = appData.colors.actionText
        M.hours.morning[i].anchorX = 1
        M.hours.morning[i].anchorY = 0
        M.hours.morning[i].x = appData.contentW - display.screenOriginX - appData.actionMargin
        M.hours.morning[i].y = 5+(i-1)*(headerHeight+rowHeight+rowHeight)+headerHeight
        scheduleView:insert( M.hours.morning[i] ) 

            -- enabled
        local morningSwitchListener = function()
           
        end

        M.switches.morning[i] = widget.newSwitch(
            {
                left = 0,
                top = 0,
                style = "onOff",
                initialSwitchState = false,
                onRelease = morningSwitchListener
            }
        )

        M.switches.morning[i].anchorX = 1
        M.switches.morning[i].anchorY = 0
        M.switches.morning[i].x = appData.contentW - display.screenOriginX - appData.actionMargin
        M.switches.morning[i].y = 28+(i-1)*(headerHeight+rowHeight+rowHeight)+headerHeight        
        M.switches.morning[i]:scale(0.6, 0.6)
        M.switches.morning[i].alpha = 0.9
        scheduleView:insert( M.switches.morning[i] ) 

        M.masks.morning[i] = display.newRect( 0, 0, 30, 15 )
        M.masks.morning[i].id = "m"..i
        M.masks.morning[i].fill = {1, 0, 0, 0.01}
        M.masks.morning[i].anchorX = 1
        M.masks.morning[i].anchorY = 0 
        M.masks.morning[i].x=appData.contentW - display.screenOriginX - appData.actionMargin
        M.masks.morning[i].y=33+(i-1)*(headerHeight+rowHeight+rowHeight)+headerHeight 
        scheduleView:insert( M.masks.morning[i] ) 

            -- set the morning switch
            
            -- calculate utc

            -- search for the related transport in app.Data.transports

            -- set the switch

        -- status
        local statusOptions = 
        
            {
                text = "Aktiver tur", 
                width = appData.screenW - appData.margin*2 - appData.actionMargin*2,
                font = appData.fonts.actionText,
                align = "right"
            }

        M.status.morning[i] = display.newText( statusOptions )
        M.status.morning[i].fill = appData.colors.statusText
        M.status.morning[i].anchorX = 1
        M.status.morning[i].anchorY = 0
        M.status.morning[i].x = appData.contentW - display.screenOriginX - appData.actionMargin - 50
        M.status.morning[i].y = 5+(i-1)*(headerHeight+rowHeight+rowHeight)+headerHeight
        scheduleView:insert( M.status.morning[i] )

        -- hint
        if i == 1 then
            local hintOptions = 
            
                {
                    text = "Før 21:00 i dag", 
                    width = appData.screenW - appData.margin*2 - appData.actionMargin*2,
                    font = appData.fonts.actionText,
                    align = "right"
                }

            M.hint.morning[i] = display.newText( hintOptions )
            M.hint.morning[i].fill = appData.colors.actionComment
            M.hint.morning[i].anchorX = 1
            M.hint.morning[i].anchorY = 0
            M.hint.morning[i].x = appData.contentW - display.screenOriginX - appData.actionMargin - 50
            M.hint.morning[i].y = 28+(i-1)*(headerHeight+rowHeight+rowHeight)+headerHeight
            scheduleView:insert( M.hint.morning[i] )
        end 

        -- phone
        M.phones.morning[i] = display.newImageRect( "images/phone.png", 32, 24 )
        M.phones.morning[i].anchorX = 1
        M.phones.morning[i].anchorY = 0
        M.phones.morning[i].x = appData.contentW - display.screenOriginX - appData.actionMargin
        M.phones.morning[i].y = 60+(i-1)*(headerHeight+rowHeight+rowHeight) 
        M.phones.morning[i].alpha = 0
        scheduleView:insert( M.phones.morning[i] ) 

        M.chats.morning[i] = display.newImageRect( "images/chat.png", 32, 24 )
        M.chats.morning[i].anchorX = 1
        M.chats.morning[i].anchorY = 0
        M.chats.morning[i].x = appData.contentW - 40 - display.screenOriginX - appData.actionMargin
        M.chats.morning[i].y = 60+(i-1)*(headerHeight+rowHeight+rowHeight) 
        M.chats.morning[i].alpha = 0
        scheduleView:insert( M.chats.morning[i] ) 
                   
        -- AFTERNOON ---------------------------------------------------------------------
        M.afternoons[i] = display.newRect( 0, 0, appData.contentW, rowHeight )
        M.afternoons[i].fill = appData.colors.transportBackground
        M.afternoons[i].anchorX = 0
        M.afternoons[i].anchorY = 0 
        M.afternoons[i].x = display.screenOriginX 
        M.afternoons[i].y=(i-1)*(headerHeight+rowHeight+rowHeight)+headerHeight+rowHeight
        M.afternoons[i].id = i*2
        scheduleView:insert( M.afternoons[i] ) 

        -- dots
        M.dots.afternoon[i] = display.newCircle( 0, 0, 3 )
        M.dots.afternoon[i].fill = appData.colors.statusText
        M.dots.afternoon[i].anchorX = 0
        M.dots.afternoon[i].anchorY = 0
        M.dots.afternoon[i].x = display.screenOriginX + appData.margin
        M.dots.afternoon[i].y = 30+(i-1)*(headerHeight+rowHeight+rowHeight)+headerHeight+rowHeight
        scheduleView:insert( M.dots.afternoon[i] ) 
        M.dots.afternoon[i].alpha = 0

        -- period
        local periodsOptions = 
        
            {
                text = "Ettermiddag", 
                width = appData.screenW - appData.margin*2 - appData.actionMargin*2,
                font = appData.fonts.titleTextBold,
                align = "left"
            }

        M.periods.afternoon[i] = display.newText( periodsOptions )
        M.periods.afternoon[i].fill = appData.colors.actionText
        M.periods.afternoon[i].anchorX = 0
        M.periods.afternoon[i].anchorY = 0
        M.periods.afternoon[i].x = display.screenOriginX + appData.margin
        M.periods.afternoon[i].y = 3+(i-1)*(headerHeight+rowHeight+rowHeight)+headerHeight+rowHeight
        scheduleView:insert( M.periods.afternoon[i] ) 
        M.periods.afternoon[i].alpha = 1

            -- photo
        M.portraits.afternoon[i] = display.newImageRect( "images/portrait.png", 50, 50 )
        M.portraits.afternoon[i].anchorX = 0
        M.portraits.afternoon[i].anchorY = 0
        M.portraits.afternoon[i].x = 0 + appData.margin + display.screenOriginX
        M.portraits.afternoon[i].y = 5+(i-1)*(headerHeight+rowHeight+rowHeight)+headerHeight+rowHeight
        scheduleView:insert(M.portraits.afternoon[i])
        M.portraits.afternoon[i].alpha = 0
    
        local afternoonPortraitMask = graphics.newMask( "images/portraitMask.png" )
        M.portraits.afternoon[i]:setMask( afternoonPortraitMask )
        M.portraits.afternoon[i].maskScaleX = 0.2
        M.portraits.afternoon[i].maskScaleY = 0.2 

            -- mode
        local modeOptions = 
        
            {
                text = "", 
                width = appData.screenW - appData.margin*2 - appData.actionMargin*2,
                font = appData.fonts.actionText,
                align = "left"
            }

        local mode = display.newText( modeOptions )
        mode.fill = appData.colors.actionText
        mode.anchorX = 0
        mode.anchorY = 0
        mode.x = display.screenOriginX + appData.margin + 60
        mode.y = 5+(i-1)*(headerHeight+rowHeight+rowHeight)+headerHeight+rowHeight
        scheduleView:insert( mode ) 
        mode.alpha = 0

        if (modes[i].afternoonMode == "1") then  
            mode.text = "Passasjer"
        elseif (modes[i].afternoonMode == "2") then 
            mode.text = "Sjåfør"
        elseif (modes[i].afternoonMode == "3") then 
            mode.text = "Begge deler" 
        end  

            --offset
        local afternoonTimeOptions = 
        
            {
                text = times[i].afternoonTime, 
                width = appData.screenW - appData.margin*2 - appData.actionMargin*2,
                font = appData.fonts.actionText,
                align = "right"
            }

        M.hours.afternoon[i] = display.newText( afternoonTimeOptions )
        M.hours.afternoon[i].fill = appData.colors.actionText
        M.hours.afternoon[i].anchorX = 1
        M.hours.afternoon[i].anchorY = 0
        M.hours.afternoon[i].x = appData.contentW - display.screenOriginX - appData.actionMargin
        M.hours.afternoon[i].y = 5+(i-1)*(headerHeight+rowHeight+rowHeight)+headerHeight+rowHeight
        scheduleView:insert( M.hours.afternoon[i] ) 

            -- enabled
        local afternoonSwitchListener = function(event)
            
        end

        M.switches.afternoon[i] = widget.newSwitch(
            {
                left = 0,
                top = 0,
                style = "onOff",
                initialSwitchState = false,
                onRelease = afternoonSwitchListener
            }
        )

        M.switches.afternoon[i].anchorX = 1
        M.switches.afternoon[i].anchorY = 0
        M.switches.afternoon[i].x = appData.contentW - display.screenOriginX - appData.actionMargin
        M.switches.afternoon[i].y = 28+(i-1)*(headerHeight+rowHeight+rowHeight)+headerHeight+rowHeight      
        M.switches.afternoon[i]:scale(0.6, 0.6)
        M.switches.afternoon[i].alpha = 0.9
        scheduleView:insert( M.switches.afternoon[i] ) 

        
        M.masks.afternoon[i] = display.newRect( 0, 0, 30, 15 )
        M.masks.afternoon[i].id = "a"..i
        M.masks.afternoon[i].fill = {1, 0, 0, 0.01}
        M.masks.afternoon[i].anchorX = 1
        M.masks.afternoon[i].anchorY = 0 
        M.masks.afternoon[i].x=appData.contentW - display.screenOriginX - appData.actionMargin
        M.masks.afternoon[i].y=33+(i-1)*(headerHeight+rowHeight+rowHeight)+headerHeight+rowHeight 
        scheduleView:insert( M.masks.afternoon[i]) 

        -- role
        local roleOptions = 
        
            {
                text = "", 
                width = appData.screenW - appData.margin*2 - appData.actionMargin*2,
                font = appData.fonts.actionText,
                align = "left"
            }

        M.roles.afternoon[i] = display.newText( roleOptions )
        M.roles.afternoon[i].fill = appData.colors.actionText
        M.roles.afternoon[i].anchorX = 0
        M.roles.afternoon[i].anchorY = 0
        M.roles.afternoon[i].x = display.screenOriginX + appData.margin + 60
        M.roles.afternoon[i].y = 5+(i-1)*(headerHeight+rowHeight+rowHeight)+headerHeight+rowHeight 
        scheduleView:insert( M.roles.afternoon[i] ) 
        M.roles.afternoon[i].alpha = 0 

        -- name
        local nameOptions = 
        
            {
                text = "", 
                width = appData.screenW - appData.margin*2 - appData.actionMargin*2,
                font = appData.fonts.titleTextBold,
                align = "left"
            }

        M.names.afternoon[i] = display.newText( nameOptions )
        M.names.afternoon[i].fill = appData.colors.statusText
        M.names.afternoon[i].anchorX = 0
        M.names.afternoon[i].anchorY = 0
        M.names.afternoon[i].x = display.screenOriginX + appData.margin + 60
        M.names.afternoon[i].y = 35+(i-1)*(headerHeight+rowHeight+rowHeight)+headerHeight+rowHeight 
        scheduleView:insert( M.names.afternoon[i] ) 
        M.names.afternoon[i].alpha = 0

        -- status
        local statusOptions = 
        
            {
                text = "Aktiver tur", 
                width = appData.screenW - appData.margin*2 - appData.actionMargin*2,
                font = appData.fonts.actionText,
                align = "right"
            }

        M.status.afternoon[i] = display.newText( statusOptions )
        M.status.afternoon[i].fill = appData.colors.statusText
        M.status.afternoon[i].anchorX = 1
        M.status.afternoon[i].anchorY = 0
        M.status.afternoon[i].x = appData.contentW - display.screenOriginX - appData.actionMargin - 50
        M.status.afternoon[i].y = 5+(i-1)*(headerHeight+rowHeight+rowHeight)+headerHeight+rowHeight
        scheduleView:insert( M.status.afternoon[i] ) 

        -- hint
        if i == 1 then
            local hintOptions = 
            
                {
                    text = "Før 21:00 i dag", 
                    width = appData.screenW - appData.margin*2 - appData.actionMargin*2,
                    font = appData.fonts.actionText,
                    align = "right"
                }

            M.hint.afternoon[i] = display.newText( hintOptions )
            M.hint.afternoon[i].fill = appData.colors.actionComment
            M.hint.afternoon[i].anchorX = 1
            M.hint.afternoon[i].anchorY = 0
            M.hint.afternoon[i].x = appData.contentW - display.screenOriginX - appData.actionMargin - 50
            M.hint.afternoon[i].y = 28+(i-1)*(headerHeight+rowHeight+rowHeight)+headerHeight + rowHeight
            scheduleView:insert( M.hint.afternoon[i] )
        end
      
        -- phone
        M.phones.afternoon[i] = display.newImageRect( "images/phone.png", 32, 24 )
        M.phones.afternoon[i].anchorX = 1
        M.phones.afternoon[i].anchorY = 0
        M.phones.afternoon[i].x = appData.contentW - display.screenOriginX - appData.actionMargin
        M.phones.afternoon[i].y = 60 + rowHeight +(i-1)*(headerHeight+rowHeight+rowHeight)
        M.phones.afternoon[i].alpha = 0
        scheduleView:insert( M.phones.afternoon[i] ) 

        -- chat
        M.chats.afternoon[i] = display.newImageRect( "images/chat.png", 32, 24 )
        M.chats.afternoon[i].anchorX = 1
        M.chats.afternoon[i].anchorY = 0
        M.chats.afternoon[i].x = appData.contentW - 40 - display.screenOriginX - appData.actionMargin
        M.chats.afternoon[i].y = 60 + rowHeight +(i-1)*(headerHeight+rowHeight+rowHeight)
        M.chats.afternoon[i].alpha = 0
        scheduleView:insert( M.chats.afternoon[i] )         
    end 

    -- FINISH
    M.scheduleSlide = display.newGroup() 
    scheduleView.y = appData.contentW
    M.scheduleSlide:insert( scheduleView ) 
    M.sceneGroup:insert( M.scheduleSlide ) 

    -- Time Control ---------------------------------------------------------------------------------
    --[[
    -- Before 8:00 - show morning and afernoon for today
    if tonumber(os.date( "%H" )) < 12 then
        scheduleView.y = appData.contentW + (headerHeight+rowHeight+rowHeight)

    -- After 8:00 and before 16:00 - show just afternoon for today
    elseif tonumber(os.date( "%H" )) < 23 then
        M.todayMorning.alpha = 0
        M.todayMorningTime.alpha = 0
        M.todayMorningSwitch.alpha = 0
        M.todayMorningStatus.alpha = 0
        M.todayMorningMask.alpha = 0

        header.y=header.y + rowHeight
        M.day.y = M.day.y + rowHeight

        scheduleView.y = appData.contentW + (headerHeight+rowHeight)
       
    -- After 16:00 -- don't show today
    else 
       todayGroup.alpha = 0
       scheduleView.y = appData.contentW      
    end 
    --]]
    --  ---------------------------------------------------------------------------------------------   
end

-- -----------------------------------------------------------------------------
-- TRIP
-- -----------------------------------------------------------------------------
M.showTransport = function()
    local rowHeight = 60
    local headerHeight = 30  

    M.transportView = display.newGroup()
    

    -- background 
    local transportBackground   

    transportBackground = display.newRect( 0, 0, appData.screenW, rowHeight+headerHeight )
    transportBackground.fill = appData.colors.transportBackground
    transportBackground.anchorX = 0
    transportBackground.anchorY = 0 
    transportBackground.x = display.screenOriginX 
    transportBackground.y=0
    M.transportView:insert( transportBackground ) 
    
    -- header
    local transportHeader  

    transportHeader = display.newRect( 0, 0, appData.screenW, headerHeight )
    transportHeader.fill = appData.colors.actionBackground
    transportHeader.anchorX = 0
    transportHeader.anchorY = 0 
    transportHeader.x = display.screenOriginX 
    transportHeader.y=rowHeight
    M.transportView:insert( transportHeader )    

        -- photo  
    M.transportPortrait = display.newImageRect( "images/portrait.png", 50, 50 )
    M.transportPortrait.anchorX = 0
    M.transportPortrait.anchorY = 0
    M.transportPortrait.x = 0 + appData.margin + display.screenOriginX
    M.transportPortrait.y = 5
    M.transportView:insert(M.transportPortrait)
    M.transportPortrait.alpha = 1

    local transportPortraitMask = graphics.newMask( "images/portraitMask.png" )
    M.transportPortrait:setMask( transportPortraitMask )
    M.transportPortrait.maskScaleX = 0.2
    M.transportPortrait.maskScaleY = 0.2

    

    --offset -- get it from match later
    local transportHour

    -- Before 8:00  show just morning      
    if (tonumber(os.date( "%H" )) < 11) then
        transportHour = appData.user.morningTime

    -- Before 16:00 - show just afternoon
    elseif tonumber(os.date( "%H" )) < 24 then
        transportHour = appData.user.afternoonTime

    else 
        transportHour = appData.user.morningTime    
    end  
 

    local transportTimeOptions = 
    
        {
            text = "",
            width = appData.screenW - appData.margin*2 - appData.actionMargin*2,
            font = appData.fonts.actionText,
            align = "right"
        }

    M.transportTime = display.newText( transportTimeOptions )
    M.transportTime.fill = appData.colors.actionText
    M.transportTime.anchorX = 1
    M.transportTime.anchorY = 0
    M.transportTime.x = appData.contentW - display.screenOriginX - appData.actionMargin
    M.transportTime.y = 5
    M.transportView:insert( M.transportTime ) 

            -- role
        local roleOptions = 
        
            {
                text = "", 
                width = appData.screenW - appData.margin*2 - appData.actionMargin*2,
                font = appData.fonts.actionText,
                align = "left"
            }

        M.transportRole = display.newText( roleOptions )
        M.transportRole.fill = appData.colors.actionText
        M.transportRole.anchorX = 0
        M.transportRole.anchorY = 0
        M.transportRole.x = display.screenOriginX + appData.margin + 60
        M.transportRole.y = 5
        M.transportView:insert( M.transportRole ) 
        M.transportRole.alpha = 1

        -- name
        local nameOptions = 
        
            {
                text = "", 
                width = appData.screenW - appData.margin*2 - appData.actionMargin*2,
                font = appData.fonts.titleTextBold,
                align = "left"
            }

        M.transportName = display.newText( nameOptions )
        M.transportName.fill = appData.colors.statusText
        M.transportName.anchorX = 0
        M.transportName.anchorY = 0
        M.transportName.x = display.screenOriginX + appData.margin + 60
        M.transportName.y = 35
        M.transportView:insert( M.transportName ) 
        M.transportName.alpha = 1

        M.transportPhone = display.newImageRect( "images/phone.png", 32, 24 )
        M.transportPhone.anchorX = 1
        M.transportPhone.anchorY = 0
        M.transportPhone.x = appData.contentW - display.screenOriginX - appData.actionMargin
        M.transportPhone.y = 28
        M.transportView:insert( M.transportPhone ) 

        M.transportChat = display.newImageRect( "images/chat.png", 32, 24 )
        M.transportChat.anchorX = 1
        M.transportChat.anchorY = 0
        M.transportChat.x = appData.contentW - display.screenOriginX - appData.actionMargin - 40
        M.transportChat.y = 28
        M.transportView:insert( M.transportChat ) 

        -- car
        local carOptions = 
        
            {
                text = "", 
                width = appData.screenW - appData.margin*2 - appData.actionMargin*2,
                font = appData.fonts.actionText,
                align = "center"
            }

        M.transportCar = display.newText( carOptions )
        M.transportCar.fill = appData.colors.actionText
        M.transportCar.anchorX = 0.5
        M.transportCar.anchorY = 0
        M.transportCar.x = appData.contentW/2
        M.transportCar.y = 65
        M.transportView:insert( M.transportCar ) 
        M.transportCar.alpha = 1       

    -- FINISH
    M.transportView.y = appData.contentH-(rowHeight+headerHeight)-display.screenOriginY
    M.transportView.alpha = 0 
    M.sceneGroup:insert( M.transportView ) 
end

-- -----------------------------------------------------------------------------
-- MY ROUTE MAP
-- -----------------------------------------------------------------------------
M.myRouteMap = function()

    -- show map2





        print("showing map2")

        -- Map 2
        M.routeMap2 = display.newImageRect( 
            "images/map.png", 
            appData.contentW, 
            (appData.contentW/792)*968 )
        M.routeMap2.anchorX = 0
        M.routeMap2.anchorY = 0
        M.routeMap2.x = 0
        M.routeMap2.y = display.screenOriginY + 35
        M.sceneGroup:insert( M.routeMap2 ) 
        M.sceneGroup.alpha = 0.1

    -- show map1
        print("showing map1")
        -- Map 1
        M.routeMap1 = display.newImageRect( 
            "images/map.png", 
            appData.contentW, 
            (appData.contentW/792)*968 )

        M.routeMap1.anchorX = 0
        M.routeMap1.anchorY = 0
        M.routeMap1.x = 3000
        M.routeMap1.y = display.screenOriginY + 35
        -- M.routeMap1:request( "map.html", system.DocumentsDirectory )
        M.sceneGroup:insert( M.routeMap1 ) 
end

-- -----------------------------------------------------------------------------
-- TRIP CHANGE
-- -----------------------------------------------------------------------------

-- Show Trip Change
M.showTripChange = function(address)
    -- setup
    M.tripChangeGroup = display.newGroup()
    M.sceneGroup:insert( M.tripChangeGroup )
    M.tripChangeGroup.alpha = 1

    M.tripChangeGroup.anchorX = 0.5
    M.tripChangeGroup.anchorY = 0
    M.tripChangeGroup.y = -3000

    -- Background ------------------------------------------------------------------------------
    M.tripChangeBackground = display.newRect( 0, -20, appData.screenW, 150 )
    M.tripChangeBackground.fill = appData.colors.actionBackground
    M.tripChangeBackground.anchorX = 0.5
    M.tripChangeBackground.anchorY = 0
    M.tripChangeBackground.x = appData.contentW/2
    M.tripChangeGroup:insert( M.tripChangeBackground ) 

    --  Departure Background -------------------------------------------------------------------
    M.departureFieldBackground = display.newRoundedRect(
        appData.contentW/2, 0, 
        appData.screenW - appData.actionMargin*2, 30, 
        appData.actionCorner/2 
    )

    M.departureFieldBackground.fill = appData.colors.actionText
    M.departureFieldBackground.y = 0
    M.tripChangeGroup:insert( M.departureFieldBackground )

    -- Departure Field -------------------------------------------------------------------------

    M.departureField = native.newTextField( 
        appData.contentW/2+appData.margin, 0, 
        appData.screenW - appData.actionMargin*2, 30 
    )
  
    M.departureField.font = appData.fonts.actionText
    if (appData.transport.from == "") then
        M.departureField.placeholder = ""
    else
        M.departureField.placeholder = ""
        M.departureField.text = appData.transport.fromAddress
    end 

    M.departureField.fill = infoText
    M.departureField.align = "left"
    M.departureField.hasBackground = false
    M.departureField.y = 3
    M.tripChangeGroup:insert( M.departureField )

    --  Destination Background -----------------------------------------------------------------
    M.destinationFieldBackground = display.newRoundedRect(
        appData.contentW/2, 0, 
        appData.screenW - appData.actionMargin*2, 30, 
        appData.actionCorner/2 
    )

    M.destinationFieldBackground.fill = appData.colors.actionText
    M.destinationFieldBackground.y = 45
    M.tripChangeGroup:insert( M.destinationFieldBackground )

    -- Destination Field -----------------------------------------------------------------------

    M.destinationField = native.newTextField( 
        appData.contentW/2+appData.margin*2, 0, 
        appData.screenW - appData.actionMargin, 30
    )
    
    M.destinationField.font = appData.fonts.actionText
    if (appData.transport.to == "") then
        M.destinationField.placeholder = ""
    else
        M.destinationField.placeholder = ""
        M.destinationField.text = appData.transport.toAddress
    end   

    M.destinationField.align = "left"
    M.destinationField.hasBackground = false
    M.destinationField.y = 48
    M.tripChangeGroup:insert( M.destinationField )

    -- Time Background -------------------------------------------------------------------------
    M.tripTimeBackground = display.newRoundedRect(0, 0, 60, 30, appData.actionCorner/2 )
    M.tripTimeBackground.fill = appData.colors.actionText
    M.tripTimeBackground.anchorX = 0
    M.tripTimeBackground.anchorY = 0
    M.tripTimeBackground.x = appData.actionMargin
    M.tripTimeBackground.y = 75
    M.tripChangeGroup:insert( M.tripTimeBackground )

    -- Time Text -------------------------------------------------------------------------------
    local tripTimeOptions = 
    {
        text = "08:30",
        font = appData.fonts.actionText,
    }

    M.tripTime = display.newText( tripTimeOptions )
    M.tripTime.fill = appData.colors.fieldText
    M.tripTime.anchorX = 0
    M.tripTime.anchorY = 0
    M.tripTime.x = display.screenOriginX + 25
    M.tripTime.y = 80
    M.tripChangeGroup:insert( M.tripTime )   

    -- Tolerance Background --------------------------------------------------------------------
    M.tripToleranceBackground = display.newRoundedRect(0, 0, 95, 30, appData.actionCorner/2)
    M.tripToleranceBackground.fill = appData.colors.actionText
    M.tripToleranceBackground.anchorX = 0
    M.tripToleranceBackground.anchorY = 0
    M.tripToleranceBackground.x = display.screenOriginX + appData.actionMargin + 65 + appData.actionMargin
    M.tripToleranceBackground.y = 75    
    M.tripChangeGroup:insert( M.tripToleranceBackground )
    
    -- Tolerance Text --------------------------------------------------------------------------
    local tripToleranceOptions = 
    {
        -- text = tostring(appData.user.morningFlexibility/60).." min",
        text = "",
        font = appData.fonts.actionText,
    }

    M.tripTolerance = display.newText( tripToleranceOptions )
    M.tripTolerance.fill = appData.colors.fieldText
 
    M.tripTolerance.anchorX = 0
    M.tripTolerance.anchorY = 0
    M.tripTolerance.x = display.screenOriginX + appData.actionMargin + 70 + appData.actionMargin + 20
    M.tripTolerance.y = 80
    M.tripChangeGroup:insert( M.tripTolerance ) 

    -- Role Background --------------------------------------------------------------------
    M.tripRoleBackground = display.newRoundedRect(0, 0, 95, 30, appData.actionCorner/2)
    M.tripRoleBackground.fill = appData.colors.actionText
    M.tripRoleBackground.anchorX = 1
    M.tripRoleBackground.anchorY = 0
    M.tripRoleBackground.x = 305 -- 0 - display.screenOriginX - appData.actionMargin
    M.tripRoleBackground.y = 75    
    M.tripChangeGroup:insert( M.tripRoleBackground )
    
    -- Role Text --------------------------------------------------------------------------

    local tripRoleOptions = 
    {
        text = "",
        font = appData.fonts.actionText,
    }

    M.tripRole = display.newText( tripRoleOptions )
    M.tripRole.fill = appData.colors.fieldText
 
    M.tripRole.anchorX = 0
    M.tripRole.anchorY = 0
    M.tripRole.x = 220
    M.tripRole.y = 80
    M.tripChangeGroup:insert( M.tripRole ) 

    M.tripChangeGroup.y = -3000 
end

M.showWheels = function()
    -- White Background
    M.whiteBackground = display.newRect( 
        0, 0+display.screenOriginY, appData.screenW, appData.screenH+200 )
    M.whiteBackground.fill = appData.colors.infoBackround
    M.whiteBackground.x = appData.contentW/2
    M.whiteBackground.y = appData.contentH/2
    M.whiteBackground.alpha = 0
    M.tripChangeGroup:insert( M.whiteBackground )

    -- Morning Wheels
    local transportTimeWheelData =
    {
        {
            align = "left",
            width = 1,
            startIndex = 1,
            labels = { "" }
        },

        {
            align = "right",
            width = appData.contentW/2,
            labelPadding = 0,
            startIndex = 4,
            labels = { 
                "05", "06", "07", "08", "09", "10", "14", "15","16", "17", "18"
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
            width = appData.contentW/2,
            startIndex = 1,
            labels = { 
                "00", "05", "10", "15", "20", "25", "30", "35", "40", "45", "50", "55"
            }
        },

        {
            align = "left",
            startIndex = 1,
            labels = { "" }
        }
    }
     
    -- Create the widget
    M.transportTimeWheel = widget.newPickerWheel(
    {
        x = 0,
        top = display.contentHeight - 222,
        style = "resizable",
        width = appData.screenW,
        height = appData.screenW,
        rowHeight = 30,
        font = appData.fonts.actionText,
        fontSize = 14,
        columns = transportTimeWheelData
    }) 
    
    M.transportTimeWheel.anchorX = 0.0
    M.transportTimeWheel.x = 0
    M.transportTimeWheel.y = -3000
    M.tripChangeGroup:insert( M.transportTimeWheel ) 

    -- Transport Tolerance Wheel

    local transportToleranceWheelData =
    {
        {
            align = "left",
            width = 1,
            labelPadding = 0,
            startIndex = 1,
            labels = { "" }
        },

        {
            align = "center",
            labelPadding = 0,
            width = appData.contentW,
            startIndex = 5,
            labels = { 
                "10 min", "15 min", "20 min", "25 min", "30 min", "35 min", "40 min", "45 min", "50 min", "55 min", "60 min"
            }
        }
    }
     
    -- Create the widget
    M.transportToleranceWheel = widget.newPickerWheel(
    {
        x = 0,
        top = display.contentHeight - 250,
        style = "resizable",
        width = appData.screenW*2,
        height = appData.screenW,
        rowHeight = 30,
        font = appData.fonts.actionText,
        fontSize = 14,
        columns = transportToleranceWheelData
    }) 
    
    M.transportToleranceWheel.anchorX = 0
    M.transportToleranceWheel.x = 0
    M.transportToleranceWheel.y = -3000
    M.tripChangeGroup:insert( M.transportToleranceWheel ) 

    -- Transport Role Button
    local transportRoleWheelData =
    {
        {
            align = "left",
            width = 1,
            labelPadding = 0,
            startIndex = 1,
            labels = { "" }
        },

        {
            align = "center",
            labelPadding = 0,
            width = appData.contentW,
            labelPadding = 0,
            startIndex = 1,
            labels = { "Passasjer", "Sjåfør" }
        }
    }
    
    -- Create the widget
    M.transportRoleWheel = widget.newPickerWheel(
    {
        x = 0,
        top = display.contentHeight - 250,
        style = "resizable",
        width = appData.contentW,
        height = appData.screenW,
        rowHeight = 30,
        font = appData.fonts.actionText,
        fontSize = 14,
        columns = transportRoleWheelData
    }) 
    
    M.transportRoleWheel.anchorX = 0.0
    M.transportRoleWheel.x = 0
    M.transportRoleWheel.y = -3000
    M.tripChangeGroup:insert( M.transportRoleWheel ) 

    -- Wheel Button 
    M.wheelButton = widget.newButton(
        {
            left = 0,
            top = 0,
            shape = "roundedRect",
            width = 60,
            height = 20,
            cornerRadius = 2.5,
            label = "LAGRE",
            fontSize = 12,
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
    M.wheelButton.y = 230
    M.wheelButton.alpha = 0
    M.tripChangeGroup:insert( M.wheelButton )      
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
            rowTitle.x = 15
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
            top = 0,
            height = 200,
            width = appData.screenContent,
            onRowRender = departureSearchResultsRowRender,
            noLines = true
        }
    )

    M.departureSearchResults.anchorY = 0
    M.departureSearchResults.anchorX = 0.5
    M.departureSearchResults.x = appData.contentW/2
    M.departureSearchResults.y = 15
    M.tripChangeGroup:insert( M.departureSearchResults )
     
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
            rowTitle.x = 15
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
            top = 0,
            height = 200,
            width = appData.screenContent,
            onRowRender = destinationSearchResultsRowRender,
            noLines = true
        }
    )

    M.destinationSearchResults.anchorY = 0
    M.destinationSearchResults.anchorX = 0.5
    M.destinationSearchResults.x = appData.contentW/2
    M.destinationSearchResults.y = 60
    M.tripChangeGroup:insert( M.destinationSearchResults )
     
    -- Insert Rows
    for i = 1, 5 do
        -- Insert a row into the tableView
        M.destinationSearchResults:insertRow{}
    end
end

-- -----------------------------------------------------------------------------
-- NEXT TRIP
-- -----------------------------------------------------------------------------
-- Show Start Driving Info
M.showingNextTrip = false
M.showNextTripInfo = function()
    if (M.showingNextTrip == false) then

        M.showingNextTrip = true

        -- setup
        M.nextTripGroup = display.newGroup()
        M.sceneGroup:insert( M.nextTripGroup ) 

        M.nextTripGroup.anchorX = 0.5
        M.nextTripGroup.anchorY = 0
        M.nextTripGroup.y = display.screenOriginY + 35

        -- background
        M.nextTripBackground = display.newRect( 0, 0, appData.screenW, 100 )
        M.nextTripBackground.fill = appData.colors.infoBackround
        M.nextTripBackground.anchorX = 0.5
        M.nextTripBackground.anchorY = 0
        M.nextTripBackground.x = appData.contentW/2
        M.nextTripGroup:insert( M.nextTripBackground ) 

        -- next trip
        local nextTripText = "Next trip:"

        local nextTripOptions = 
        
            {
                text = nextTripText,
                width = appData.contentW,
                font = appData.fonts.titleTextBold,
                align = "center"
            }

        M.nextTrip = display.newText( nextTripOptions )
        M.nextTrip.fill = appData.colors.infoText
        M.nextTrip.anchorX = 0.5
        M.nextTrip.anchorY = 0
        M.nextTrip.x = appData.contentW/2
        M.nextTrip.y = 20
        M.nextTripGroup:insert( M.nextTrip )   


        -- countdown
        local timeText = ""

        local timeOptions = 
        
            {
                text = timeText,
                width = appData.contentW,
                font = appData.fonts.actionText,
                align = "center"
            }

        M.timeInfo = display.newText( timeOptions )
        M.timeInfo.fill = appData.colors.infoText
        M.timeInfo.anchorX = 0.5
        M.timeInfo.anchorY = 0
        M.timeInfo.x = appData.contentW/2
        M.timeInfo.y = 50
        M.nextTripGroup:insert( M.timeInfo )
    end     
end

-- -----------------------------------------------------------------------------
-- DRIVING INFO
-- -----------------------------------------------------------------------------

-- Show Start Driving Info
M.showingStartDriving = false
M.showStartDrivingInfo = function(address)
    if (M.showingStartDriving == false) then

        M.showingStartDriving = true

        -- setup
        M.startDrivingGroup = display.newGroup()
        M.sceneGroup:insert( M.startDrivingGroup ) 

        M.startDrivingGroup.anchorX = 0.5
        M.startDrivingGroup.anchorY = 0
        M.startDrivingGroup.y = display.screenOriginY + 35

        -- background
        M.startDrivingBackground = display.newRect( 0, 0, appData.screenW, 100 )
        M.startDrivingBackground.fill = appData.colors.infoBackround
        M.startDrivingBackground.anchorX = 0.5
        M.startDrivingBackground.anchorY = 0
        M.startDrivingBackground.x = appData.contentW/2
        M.startDrivingGroup:insert( M.startDrivingBackground ) 

        -- next trip
        local nextTripText = "Next trip:"

        local nextTripOptions = 
        
            {
                text = nextTripText,
                width = appData.contentW,
                font = appData.fonts.titleTextBold,
                align = "center"
            }

        M.nextTripDriver = display.newText( nextTripOptions )
        M.nextTripDriver.fill = appData.colors.infoText
        M.nextTripDriver.anchorX = 0.5
        M.nextTripDriver.anchorY = 0
        M.nextTripDriver.x = appData.contentW/2
        M.nextTripDriver.y = 10
        M.startDrivingGroup:insert( M.nextTripDriver )   


        -- countdown
        local countdownText = ""

        local countdownOptions = 
        
            {
                text = countdownText,
                width = appData.contentW,
                font = appData.fonts.actionText,
                align = "center"
            }

        M.driverCountdown = display.newText( countdownOptions )
        M.driverCountdown.fill = appData.colors.infoText
        M.driverCountdown.anchorX = 0.5
        M.driverCountdown.anchorY = 0
        M.driverCountdown.x = appData.contentW/2
        M.driverCountdown.y = 37
        M.startDrivingGroup:insert( M.driverCountdown ) 

        -- start button 
        M.startButton = widget.newButton(
            {
                left = 0,
                top = 0,
                shape = "roundedRect",
                width = 90,
                height = 22,
                cornerRadius = 2.5,
                label = "START",
                fontSize = 12,
                labelColor = { default=appData.colors.infoButtonLabelDefault, 
                               over=appData.colors.infoButtonLabelOver 
                             },
                fillColor = { default=appData.colors.infoButtonFillDefault, 
                              over=appData.colors.infoButtonFillOver
                            },
                strokeColor = { default=appData.colors.infoButtonLabelDefault, 
                               over=appData.colors.infoButtonLabelOver 
                            },

                strokeWidth = 0   
            } 
        )

        M.startButton.anchorY = 1
        M.startButton.x = appData.contentW/2
        M.startButton.y = 85
        M.startDrivingGroup:insert( M.startButton )

        -- navigation button 
        M.navigationButton = widget.newButton(
            {
                width = 23,
                height = 22,
                defaultFile = "images/directions.png",
                overFile = "images/directions.png"
            }
        )

        M.navigationButton.anchorY = 1
        M.navigationButton.anchorX = 1
        M.navigationButton.x = appData.contentW + display.screenOriginX - appData.actionMargin
        M.navigationButton.y = display.screenOriginY + 90
        M.startDrivingGroup:insert( M.navigationButton )
        M.navigationButton.alpha = 0

    end     
end

M.showingDrivingInfo = false
M.showDrivingInfo = function(address)

    M.showingDrivingInfo = true

    -- setup
    M.drivingGroup = display.newGroup()
    M.sceneGroup:insert( M.drivingGroup ) 

    M.drivingGroup.anchorX = 0.5
    M.drivingGroup.anchorY = 0
    M.drivingGroup.y = display.screenOriginY + 35

    -- background
    M.drivingBackground = display.newRect( 0, 0, appData.screenW, 100 )
    M.drivingBackground.fill = appData.colors.infoBackround
    M.drivingBackground.anchorX = 0.5
    M.drivingBackground.anchorY = 0
    M.drivingBackground.x = appData.contentW/2
    M.drivingGroup:insert( M.drivingBackground ) 

    -- next trip
    local nextTripText = ""

    local nextTripOptions = 
    
        {
            text = nextTripText,
            width = appData.contentW,
            font = appData.fonts.titleTextBold,
            align = "center"
        }

    M.tripDriver = display.newText( nextTripOptions )
    M.tripDriver.fill = {1, 0, 0} -- appData.colors.infoText
    M.tripDriver.anchorX = 0.5
    M.tripDriver.anchorY = 0
    M.tripDriver.x = appData.contentW/2
    M.tripDriver.y = 10
    M.drivingGroup:insert( M.tripDriver )   


    -- countdown
    local countdownText = ""

    local countdownOptions = 
    
        {
            text = countdownText,
            width = appData.contentW,
            font = appData.fonts.actionText,
            align = "center"
        }

    M.driverCountdown2 = display.newText( countdownOptions )
    M.driverCountdown2.fill = appData.colors.infoText
    M.driverCountdown2.anchorX = 0.5
    M.driverCountdown2.anchorY = 0
    M.driverCountdown2.x = appData.contentW/2
    M.driverCountdown2.y = 37
    M.drivingGroup:insert( M.driverCountdown2 ) 

    -- start button 
    M.mapsButton = widget.newButton(
        {
            left = 0,
            top = 0,
            shape = "roundedRect",
            width = 160,
            height = 22,
            cornerRadius = 2.5,
            label = "Google Maps Navigation",
            fontSize = 12,
            labelColor = { default=appData.colors.infoButtonLabelDefault, 
                           over=appData.colors.infoButtonLabelOver 
                         },
            fillColor = { default=appData.colors.infoButtonFillDefault, 
                          over=appData.colors.infoButtonFillOver
                        },
            strokeColor = { default=appData.colors.infoButtonLabelDefault, 
                           over=appData.colors.infoButtonLabelOver 
                        },

            strokeWidth = 0   
        } 
    )

    M.mapsButton.anchorY = 1
    M.mapsButton.x = appData.contentW/2
    M.mapsButton.y = 85
    M.drivingGroup:insert( M.mapsButton )
    
    -- cancel button 
    M.cancelButton = widget.newButton(
        {
            width = 23,
            height = 22,
            defaultFile = "images/cancel.png",
            overFile = "images/cancel.png"
        }
    )


    M.cancelButton.anchorY = 1
    M.cancelButton.anchorX = 1
    M.cancelButton.x = appData.contentW + display.screenOriginX - appData.actionMargin
    M.cancelButton.y = 85
    M.drivingGroup:insert( M.cancelButton )
    M.cancelButton.alpha = 1  
end

-- -----------------------------------------------------------------------------
-- MAP FOR DRIVER
-- -----------------------------------------------------------------------------

M.showingDriverMap = false
M.showDriverMap = function()

    -- show map
        print("showing driver map")
        M.driverMap = native.newWebView( 
            0, 
            0, 
            display.contentWidth, 
            appData.contentH - 100 - 90 - 35 - display.screenOriginY*2
        )

        M.driverMap:request( "drivermap.html", system.DocumentsDirectory )

        M.driverMap.anchorX = 0
        M.driverMap.anchorY = 0
        M.driverMap.x = 0
        M.driverMap.y = display.screenOriginY + 130
        M.sceneGroup:insert( M.driverMap ) 
end

-- -----------------------------------------------------------------------------
-- INFO FOR PASSENGER 
-- -----------------------------------------------------------------------------

-- Show Start Driving Info
M.showingPickUp = false
M.showPickUpInfo = function(address)
    if (M.showingPickUp == false) then

        M.showingPickUp = true

        -- setup
        M.pickUpGroup = display.newGroup()
        M.sceneGroup:insert( M.pickUpGroup ) 

        M.pickUpGroup.anchorX = 0.5
        M.pickUpGroup.anchorY = 0
        M.pickUpGroup.y = display.screenOriginY + 35

        -- background
        M.pickUpBackground = display.newRect( 0, 0, appData.screenW, 100 )
        M.pickUpBackground.fill = appData.colors.infoBackround
        M.pickUpBackground.anchorX = 0.5
        M.pickUpBackground.anchorY = 0
        M.pickUpBackground.x = appData.contentW/2
        M.pickUpBackground.y = 0
        M.pickUpGroup:insert( M.pickUpBackground ) 

 
        -- next trip
        local nextTripText = "Your next trip"

        local nextTripOptions = 
        
            {
                text = nextTripText,
                width = appData.screenW - appData.margin*2 - appData.actionMargin*2,
                font = appData.fonts.titleTextBold,
                align = "center"
            }

        M.nextTrip = display.newText( nextTripOptions)
        M.nextTrip.fill = appData.colors.infoText
        M.nextTrip.anchorX = 1
        M.nextTrip.anchorY = 0
        M.nextTrip.x = appData.contentW - display.screenOriginX - appData.actionMargin
        M.nextTrip.y = 30
        M.pickUpGroup:insert( M.nextTrip )   


        -- countdown
        local countdownText = ""

        local countdownOptions = 
        
            {
                text = countdownText,
                width = appData.screenW - appData.margin*2 - appData.actionMargin*2,
                font = appData.fonts.actionText,
                align = "center"
            }

        M.passengerCountdown = display.newText( countdownOptions )
        M.passengerCountdown.fill = appData.colors.infoText
        M.passengerCountdown.anchorX = 1
        M.passengerCountdown.anchorY = 0
        M.passengerCountdown.x = appData.contentW - display.screenOriginX - appData.actionMargin
        M.passengerCountdown.y = 50
        M.pickUpGroup:insert( M.passengerCountdown ) 
    end     
end

-- -----------------------------------------------------------------------------
-- PASSENGER MAP
-- -----------------------------------------------------------------------------

M.showPassengerMap = function()

    -- show map
        print("showing passenger map")
        M.passengerMap = native.newWebView( 
            0, 
            0, 
            display.contentWidth, 
            appData.contentH - 100 - 90 - 35 - display.screenOriginY*2
        )

        M.passengerMap:request( "passengermap.html", system.DocumentsDirectory )

        M.passengerMap.anchorX = 0
        M.passengerMap.anchorY = 0
        M.passengerMap.x = 0
        M.passengerMap.y = display.screenOriginY + 130
        M.sceneGroup:insert( M.passengerMap ) 
end

-- -----------------------------------------------------------------------------
-- GREETING
-- -----------------------------------------------------------------------------

M.showGreeting = function()
    -- group
    M.greetingGroup = display.newGroup()
    M.greetingGroup.x = 0
    M.greetingGroup.y = display.screenOriginY
    M.sceneGroup:insert( M.greetingGroup )
    print("SHOWING ---------------------- GREETING")
    -- background
    M.gretingBackground = display.newRoundedRect(
        0, 
        0, 
        appData.contentW*2, 
        appData.contentH*2, 
        12
    )

    
    M.gretingBackground.anchorX = 0.5
    M.gretingBackground.anchorY = 0.5
    M.gretingBackground.x = appData.contentW/2
    M.gretingBackground.y = appData.contentH/2
    M.gretingBackground.fill = {1,1,1}
    M.greetingGroup:insert( M.gretingBackground )

    -- title
    local greetingOptions = 
    {
        text = "GRATULERER!",
        width = appData.contentW,
        font = appData.fonts.titleText,
        align = "center"
    }

    M.greetingTitle = display.newText( greetingOptions )
    M.greetingTitle.fill = appData.colors.infoText

    M.greetingTitle.anchorX = 0.5
    M.greetingTitle.anchorY = 0
    M.greetingTitle.x = appData.contentW/2
    M.greetingTitle.y = 160
    M.greetingGroup:insert( M.greetingTitle )


    -- text
    local greetingOptions = 
    {
        text = "Da har vi alt vi trenger for å "
                .."kunne koble deg med andre "
                .."pendlere. Aktiver turer i "
                .."ukeplanen under, og vi gir "
                .."beskjed når du har blitt matchet.",
        width = appData.contentW - appData.margin*8,
        height = 300,
        font = appData.fonts.actionText,
        align = "center"
    }

    M.greetingTitle = display.newText( greetingOptions )
    M.greetingTitle.fill = appData.colors.infoText

    M.greetingTitle.anchorX = 0.5
    M.greetingTitle.anchorY = 0
    M.greetingTitle.x = appData.contentW/2
    M.greetingTitle.y = 190
    M.greetingGroup:insert( M.greetingTitle )

    -- button
    M.greetingButton = widget.newButton(
        {
            left = 0,
            top = 0,
            shape = "roundedRect",
            width = 50,
            height = 24,
            cornerRadius = 12,
            label = "OK",
            fontSize = 13,
            labelColor = { default=appData.colors.infoButtonLabelDefault, 
                           over=appData.colors.infoButtonLabelOver 
                         },
            fillColor = { default=appData.colors.infoButtonFillDefault, 
                          over=appData.colors.infoButtonFillOver
                        },
            strokeColor = { default=appData.colors.infoButtonLabelDefault, 
                           over=appData.colors.infoButtonLabelOver 
                        },

            strokeWidth = 0   
        } 
    )

    M.greetingButton.anchorX = 0.5
    M.greetingButton.anchorY = 0
    M.greetingButton.x = appData.contentW/2
    M.greetingButton.y = 260, 
    M.greetingGroup:insert( M.greetingButton )
end    




return M