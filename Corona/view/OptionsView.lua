local composer = require( "composer" )
local widget = require( "widget" )
local appData = require( "misc.appData" )
-- local optionsWidth = (appData.screenW/4)*3
local optionsWidth = appData.screenW
local optionsLine = 1
local optionsTabHeight = 35

local M = {}
-- ----------------------------------------------------------------------------------------------
-- TOP MENU
-- ----------------------------------------------------------------------------------------------
-- Background
M.showBackground = function()
    M.shade = display.newRect( display.screenOriginY + 35, 0, appData.screenW, appData.screenH*2 )
    M.shade.fill = appData.colors.actionBackground
    M.shade.alpha = 0
    M.shade.x = appData.contentW/2
    M.shade.y = appData.contentH/2
    M.sceneGroup:insert(  M.shade )

    M.background = display.newRect( 0, 0, optionsWidth, appData.screenH )
    M.background.fill = appData.colors.actionBackground
    M.background.anchorX = 0
    M.background.anchorY = 0
    M.background.x = 0 + display.screenOriginX
    M.background.y = display.screenOriginY + 33
    M.background.alpha = 1
    M.sceneGroup:insert(  M.background )
end

M.showUser = function()
    M.userTab = display.newGroup()
    M.userTab.y = display.screenOriginY + 35 + optionsLine
    M.sceneGroup:insert(  M.userTab )

    -- Background
    M.userBackground = display.newRect( 0, 0, optionsWidth, optionsTabHeight*2 )
    M.userBackground.fill = appData.colors.actionBackground
    M.userBackground.anchorX = 0
    M.userBackground.anchorY= 0
    M.userBackground.x = 0 + display.screenOriginX
    M.userBackground.y = 0 + optionsTabHeight*2 * 0
    M.userBackground.alpha = 1
    M.userTab:insert( M.userBackground ) 

    local topLine = display.newRect( 0, 0, optionsWidth, optionsLine )
    topLine.fill = appData.colors.divisionLine
    topLine.anchorX = 0
    topLine.anchorY= 0
    topLine.x = 0 + display.screenOriginX
    topLine.y = 0
    M.userTab:insert( topLine )    

    local bottomLine = display.newRect( 0, 0, optionsWidth, optionsLine )
    bottomLine.fill = appData.colors.divisionLine
    bottomLine.anchorX = 0
    bottomLine.anchorY= 0
    bottomLine.x = 0 + display.screenOriginX
    bottomLine.y = optionsTabHeight*2
    bottomLine.alpha = 0
    M.userTab:insert( bottomLine )   

    -- Photo
    M.portrait = display.newImage( "portrait.png", system.DocumentsDirectory )

    if M.portrait == nil then
        M.portrait = display.newImageRect( "images/portrait.png", 50, 50 )
    else    
        appData.portraitRatio = M.portrait.width/M.portrait.height

        if appData.portraitRatio > 1 then
            M.portrait.height = 50
            M.portrait.width = 50*appData.portraitRatio                                 
        else
            M.portrait.width = 50
            M.portrait.height = 50/appData.portraitRatio        
        end 
    end     

    M.portrait.anchorX = 0.5
    M.portrait.anchorY = 0.5
    M.portrait.x = display.screenOriginX + appData.margin*2 + 25
    M.portrait.y = 10 + 25
    M.userTab:insert(M.portrait)
    

    M.portraitMask = graphics.newMask( "images/portraitMask.png" )

    M.portrait:setMask( M.portraitMask )
    M.portrait.maskScaleX = 0.2
    M.portrait.maskScaleY = 0.2

    local userName = "" 

    if appData.user.firstName ~= nil and appData.user.firstName ~= "" then
        userName = userName..appData.user.firstName
    end 
       
    if appData.user.lastName ~= nil and appData.user.lastName ~= "" then
        userName = userName.."\n"..appData.user.lastName   
    end

    if userName == "" then
        userName = "Welcome"
    end    

    -- Name
    local nameOptions = 
    {
        text = userName,
        width = (appData.screenW/4)*2,
        font = appData.fonts.titleText,
    }

    M.nameText = display.newText( nameOptions )
    M.nameText.fill = appData.colors.actionText
 
    M.nameText.anchorX = 0
    M.nameText.anchorY = 0
    M.nameText.x = appData.contentW/4 + display.screenOriginX
    M.nameText.y = 20
    M.userTab:insert( M.nameText )
end

-- Show Profile
M.showProfile = function()
    M.profileTab = display.newGroup()
    M.profileTab.y = display.screenOriginY + 35 + optionsTabHeight * 2
    M.sceneGroup:insert(  M.profileTab )

    -- Background
    local profileBackground = display.newRect( 0, 0, optionsWidth, optionsTabHeight )
    profileBackground.fill = appData.colors.actionBackground
    profileBackground.anchorX = 0
    profileBackground.anchorY= 0
    profileBackground.x = 0 + display.screenOriginX
    profileBackground.y = 0
    profileBackground.alpha = 0.01
    M.profileTab:insert( profileBackground ) 

    local topLine = display.newRect( 0, 0, optionsWidth, optionsLine )
    topLine.fill = appData.colors.divisionLine
    topLine.anchorX = 0
    topLine.anchorY= 0
    topLine.x = 0 + display.screenOriginX
    topLine.y = 0
    topLine.alpha = 1
    M.profileTab:insert( topLine )    

    local bottomLine = display.newRect( 0, 0, optionsWidth, optionsLine )
    bottomLine.fill = appData.colors.divisionLine
    bottomLine.anchorX = 0
    bottomLine.anchorY= 0
    bottomLine.x = 0 + display.screenOriginX
    bottomLine.y = optionsTabHeight
    bottomLine.alpha = 0
    M.profileTab:insert( bottomLine )   

    -- Name
    local profileOptions = 
    {
        text = "PROFIL",
        -- width = (appData.screenW/4)*2,
        font = appData.fonts.actionText,
    }

    M.profileText = display.newText( profileOptions )
    M.profileText.fill = appData.colors.actionText
 
    M.profileText.anchorX = 0
    M.profileText.anchorY = 0
    M.profileText.x = display.screenOriginX + appData.margin*3
    M.profileText.y = 10
    M.profileTab:insert( M.profileText )
end

-- Show Addresses
M.showAddresses = function()
    M.addressesTab = display.newGroup()
    M.addressesTab.y = display.screenOriginY + 35 + optionsTabHeight * 3
    M.sceneGroup:insert(  M.addressesTab )

    -- Background
    M.addressesBackground = display.newRect( 5, 0, optionsWidth, optionsTabHeight - 10)
    M.addressesBackground.fill = appData.colors.actionBackground
    M.addressesBackground.anchorX = 0
    M.addressesBackground.anchorY= 0
    M.addressesBackground.x = 0 + display.screenOriginX
    M.addressesBackground.y = 0
    M.addressesBackground.alpha = 0.01
    M.addressesTab:insert( M.addressesBackground ) 

    local topLine = display.newRect( 0, 0, optionsWidth, optionsLine )
    topLine.fill = appData.colors.divisionLine
    topLine.anchorX = 0
    topLine.anchorY= 0
    topLine.x = 0 + display.screenOriginX
    topLine.y = 0
    topLine.alpha = 1
    M.addressesTab:insert( topLine )    

    local bottomLine = display.newRect( 0, 0, optionsWidth, optionsLine )
    bottomLine.fill = appData.colors.divisionLine
    bottomLine.anchorX = 0
    bottomLine.anchorY= 0
    bottomLine.x = 0 + display.screenOriginX
    bottomLine.y = optionsTabHeight
    bottomLine.alpha = 0
    M.addressesTab:insert( bottomLine )   

    -- Name
    local addressesOptions = 
    {
        text = "ADRESSER",
        -- width = (appData.screenW/4)*2,
        font = appData.fonts.actionText,
    }

    M.addressesText = display.newText( addressesOptions )
    M.addressesText.fill = appData.colors.actionText
 
    M.addressesText.anchorX = 0
    M.addressesText.anchorY = 0
    M.addressesText.x = display.screenOriginX + appData.margin*3
    M.addressesText.y = 10
    M.addressesTab:insert( M.addressesText )
end

-- Show Car
M.showCar = function()
    M.carTab = display.newGroup()
    M.carTab.y = display.screenOriginY + 35 + optionsTabHeight * 3
    M.sceneGroup:insert(  M.carTab )

    -- Background
    M.carBackground = display.newRect( 5, 0, optionsWidth, optionsTabHeight - 10)
    M.carBackground.fill = appData.colors.actionBackground
    M.carBackground.anchorX = 0
    M.carBackground.anchorY= 0
    M.carBackground.x = 0 + display.screenOriginX
    M.carBackground.y = 0
    M.carBackground.alpha = 0.01
    M.carTab:insert( M.carBackground ) 

    local topLine = display.newRect( 0, 0, optionsWidth, optionsLine )
    topLine.fill = appData.colors.divisionLine
    topLine.anchorX = 0
    topLine.anchorY= 0
    topLine.x = 0 + display.screenOriginX
    topLine.y = 0
    topLine.alpha = 1
    M.carTab:insert( topLine )    

    local bottomLine = display.newRect( 0, 0, optionsWidth, optionsLine )
    bottomLine.fill = appData.colors.divisionLine
    bottomLine.anchorX = 0
    bottomLine.anchorY= 0
    bottomLine.x = 0 + display.screenOriginX
    bottomLine.y = optionsTabHeight
    M.carTab:insert( bottomLine )   

    -- Name
    local carOptions = 
    {
        text = "MITT KJØRETØY",
        -- width = (appData.screenW/4)*2,
        font = appData.fonts.actionText,
    }

    M.carText = display.newText( carOptions )
    M.carText.fill = appData.colors.actionText
 
    M.carText.anchorX = 0
    M.carText.anchorY = 0
    M.carText.x = display.screenOriginX + appData.margin*3
    M.carText.y = 10
    M.carTab:insert( M.carText )
end

-- Show Settings
M.showSettings = function()
    M.settingsTab = display.newGroup()
    M.settingsTab.y = display.screenOriginY + 35 + optionsTabHeight * 5
    M.sceneGroup:insert(  M.settingsTab )

    -- Background
    M.settingsBackground = display.newRect( 5, 0, optionsWidth, optionsTabHeight - 10)
    M.settingsBackground.fill = appData.colors.actionBackground
    M.settingsBackground.anchorX = 0
    M.settingsBackground.anchorY= 0
    M.settingsBackground.x = 0 + display.screenOriginX
    M.settingsBackground.y = 0
    M.settingsBackground.alpha = 0.01
    M.settingsTab:insert( M.settingsBackground ) 

    local topLine = display.newRect( 0, 0, optionsWidth, optionsLine )
    topLine.fill = appData.colors.divisionLine
    topLine.anchorX = 0
    topLine.anchorY= 0
    topLine.x = 0 + display.screenOriginX
    topLine.y = 0
    topLine.alpha = 1
    M.settingsTab:insert( topLine )    

    local bottomLine = display.newRect( 0, 0, optionsWidth, optionsLine )
    bottomLine.fill = appData.colors.divisionLine
    bottomLine.anchorX = 0
    bottomLine.anchorY= 0
    bottomLine.x = 0 + display.screenOriginX
    bottomLine.y = optionsTabHeight
    M.settingsTab:insert( bottomLine )   

    -- Name
    local settingsOptions = 
    {
        text = "INNSTILLINGER",
        font = appData.fonts.actionText,
    }

    M.settingsText = display.newText( settingsOptions )
    M.settingsText.fill = appData.colors.actionText
 
    M.settingsText.anchorX = 0
    M.settingsText.anchorY = 0
    M.settingsText.x = display.screenOriginX + appData.margin*3
    M.settingsText.y = 10
    M.settingsTab:insert( M.settingsText )
end

-- Show Settings
M.showHelp = function()
    M.helpTab = display.newGroup()
    M.helpTab.y = display.screenOriginY + 35 + optionsTabHeight * 4
    M.sceneGroup:insert(  M.helpTab )

    -- Background
    M.helpBackground = display.newRect( 5, 0, optionsWidth, optionsTabHeight - 10)
    M.helpBackground.fill = appData.colors.actionBackground
    M.helpBackground.anchorX = 0
    M.helpBackground.anchorY= 0
    M.helpBackground.x = 0 + display.screenOriginX
    M.helpBackground.y = 0
    M.helpBackground.alpha = 0.01
    M.helpTab:insert( M.helpBackground ) 

    local topLine = display.newRect( 0, 0, optionsWidth, optionsLine )
    topLine.fill = appData.colors.divisionLine
    topLine.anchorX = 0
    topLine.anchorY= 0
    topLine.x = 0 + display.screenOriginX
    topLine.y = 0
    topLine.alpha = 1
    M.helpTab:insert( topLine )    

    local bottomLine = display.newRect( 0, 0, optionsWidth, optionsLine )
    bottomLine.fill = appData.colors.divisionLine
    bottomLine.anchorX = 0
    bottomLine.anchorY= 0
    bottomLine.x = 0 + display.screenOriginX
    bottomLine.y = optionsTabHeight
    M.helpTab:insert( bottomLine )   

    -- Name
    local helpOptions = 
    {
        text = "HJELP",
        font = appData.fonts.actionText,
    }

    M.helpText = display.newText( helpOptions )
    M.helpText.fill = appData.colors.actionText
 
    M.helpText.anchorX = 0
    M.helpText.anchorY = 0
    M.helpText.x = display.screenOriginX + appData.margin*3
    M.helpText.y = 10
    M.helpTab:insert( M.helpText )
end
-- Show Buttons
M.showButtons = function()
    
    -- Options Icon
    M.optionsIcon = display.newImageRect( "images/settings.png", 90, 35 )
    M.optionsIcon.x = -5
    M.optionsIcon.y = 0 + display.screenOriginY
    M.optionsIcon.anchorX = 0
    M.optionsIcon.anchorY = 0
    M.optionsIcon.alpha = 0.0
    M.sceneGroup:insert( M.optionsIcon )  
end






















-- FORMS
-- ----------------------------------------------------------------------------------------------
-- PROFILE
-- ----------------------------------------------------------------------------------------------
 
M.showProfileMenu = function(event)

    -- setup
    M.profileMenuGroup = display.newGroup()
    M.sceneGroup:insert( M.profileMenuGroup )
    M.profileMenuGroup.alpha = 1

    M.profileMenuGroup.anchorX = 0.5
    M.profileMenuGroup.anchorY = 0
    M.profileMenuGroup.x = 0 - 350
    M.profileMenuGroup.y = display.screenOriginY

    -- Background ------------------------------------------------------------------------------
    M.profileMenuBackground = display.newRect( 0, 0, appData.screenW, appData.screenH )
    M.profileMenuBackground.fill = appData.colors.actionBackground
    M.profileMenuBackground.anchorX = 0.5
    M.profileMenuBackground.anchorY = 0
    M.profileMenuBackground.x = appData.contentW/2
    M.profileMenuBackground.y = 0
    M.profileMenuGroup:insert( M.profileMenuBackground ) 

    -- Info Text -------------------------------------------------------------------------------
    local infoOptions = 
    {
        text = "Profil",
        width = appData.screenW - appData.margin*2 - appData.actionMargin*2,
        font = appData.fonts.titleText,
        align = "center"
    }

    local topText = display.newText( infoOptions )
    topText.fill = appData.colors.actionText
 
    topText.anchorX = 0.5
    topText.anchorY = 0
    topText.x = appData.contentW/2
    topText.y = 10
    M.profileMenuGroup:insert( topText )

    -- Options Button --------------------------------------------------------------------------
    M.optionsProfileIcon = display.newImageRect( "images/settings.png", 90, 35 )
    M.optionsProfileIcon.anchorX = 0
    M.optionsProfileIcon.anchorY = 0
    M.optionsProfileIcon.x = 0
    M.optionsProfileIcon.y = 0
    M.optionsProfileIcon.alpha = 0.9
    M.profileMenuGroup:insert( M.optionsProfileIcon ) 

    -- Log Out Button -----------------------------------------------------------------------
    M.logoutButton = widget.newButton(
        {
            left = 0,
            top = 0,
            shape = "roundedRect",
            width = 60,
            height = 16,
            cornerRadius = 8,
            label = "Logg ut",
            fontSize = 10,
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

    M.logoutButton.anchorY = 0
    M.logoutButton.anchorX = 1
    M.logoutButton.x = appData.screenW - appData.margin*2
    M.logoutButton.y = 12
    M.profileMenuGroup:insert( M.logoutButton )     


    -- Info Text -----------------------------------------------------------
    local infoOptions = 
    {
        text = "",
        width = appData.screenW - appData.margin*2 - appData.actionMargin*2,
        font = appData.fonts.actionText,
    }

    M.infoText = display.newText( infoOptions )
        M.profileMenuGroup:insert( M.infoText )

    M.infoText.fill = appData.colors.actionText
    M.infoText.anchorX = 0.5
    M.infoText.anchorY = 0
    M.infoText.x = appData.contentW/2
    M.infoText.y = 55








  --  First Name ------------------------------------------------------------
    local options = 
    {
        text = "Fornavn",
        align = "left",
        width = appData.contentW - appData.actionMargin*2,
        font = appData.fonts.actionText,
    }

    M.firstNameText = display.newText( options )
    M.profileMenuGroup:insert( M.firstNameText )

    M.firstNameText.fill = appData.colors.actionText
    M.firstNameText.anchorX = 0.5
    M.firstNameText.anchorY = 0
    M.firstNameText.x = appData.contentW/2
    M.firstNameText.y = 100 - 35

    M.firstnameFieldBackground = display.newRoundedRect(
        appData.contentW/2, 
        100, 
        appData.screenW - appData.actionMargin*2, 
        30, 
        appData.actionCorner/2 
    )
    M.firstnameFieldBackground.fill = appData.colors.actionText
    M.profileMenuGroup:insert( M.firstnameFieldBackground )

    M.firstnameField = native.newTextField( 
        appData.contentW/2-400, 
        100, 
        appData.screenW - appData.margin*2 - appData.actionMargin*2, 
        30 
    )

    M.profileMenuGroup:insert( M.firstnameField )  
    M.firstnameField.font = appData.fonts.actionText
    M.firstnameField.alpha = 0

    if (appData.user.firstName == "") then
        M.firstnameField.placeholder = ""
    else
        M.firstnameField.placeholder = ""
        M.firstnameField.text = appData.user.firstName
    end          
    M.firstnameField.align = "left"
    M.firstnameField.hasBackground = false
    

  --  Middle Name ------------------------------------------------------------
    local options = 
    {
        text = "Mellomnavn",
        align = "left",
        width = appData.contentW - appData.actionMargin*2,
        font = appData.fonts.actionText,
    }

    M.secondNameText = display.newText( options )
    M.profileMenuGroup:insert( M.secondNameText )

    M.secondNameText.fill = appData.colors.actionText
    M.secondNameText.anchorX = 0.5
    M.secondNameText.anchorY = 0
    M.secondNameText.x = appData.contentW/2
    M.secondNameText.y = 30 + 30 + 100 - 35

    M.middlenameFieldBackground = display.newRoundedRect(
        appData.contentW/2, 
        160, 
        appData.screenW - appData.actionMargin*2, 
        30, 
        appData.actionCorner/2 
    )

    M.profileMenuGroup:insert( M.middlenameFieldBackground )
    M.middlenameFieldBackground.fill = appData.colors.actionText

    M.middlenameField = native.newTextField( 
        appData.contentW/2-400, 
        160, 
        appData.screenW - appData.margin*2 - appData.actionMargin*2, 
        30 
    )

    M.profileMenuGroup:insert( M.middlenameField )
    
    M.middlenameField.font = appData.fonts.actionText
    if (appData.user.middleName == "") then
        M.middlenameField.placeholder = ""
    else
        M.middlenameField.placeholder = ""
        M.middlenameField.text = appData.user.middleName
    end   
    M.middlenameField.align = "left"
    M.middlenameField.hasBackground = false
    M.middlenameField.alpha = 0


    --  Last name ----------------------------------------------------------
    local options = 
    {
        text = "Etternavn",
        align = "left",
        width = appData.contentW - appData.actionMargin*2,
        font = appData.fonts.actionText,
    }

    M.lastNameText = display.newText( options )
    M.profileMenuGroup:insert( M.lastNameText )

    M.lastNameText.fill = appData.colors.actionText
    M.lastNameText.anchorX = 0.5
    M.lastNameText.anchorY = 0
    M.lastNameText.x = appData.contentW/2
    M.lastNameText.y = 220 - 35

    M.lastnameFieldBackground = display.newRoundedRect(
        appData.contentW/2, 
        220, 
        appData.screenW - appData.actionMargin*2, 
        30, 
        appData.actionCorner/2 
    )
    M.lastnameFieldBackground.fill = appData.colors.actionText
    M.profileMenuGroup:insert( M.lastnameFieldBackground )

    M.lastnameField = native.newTextField( 
        appData.contentW/2-400, 
        220, 
        appData.screenW - appData.margin*2 - appData.actionMargin*2, 
        30 
    )
  
    M.lastnameField.font = appData.fonts.actionText
    if (appData.user.lastName == "") then
        M.lastnameField.placeholder = ""
    else
        M.lastnameField.placeholder = ""
        M.lastnameField.text = appData.user.lastName
    end          
    M.lastnameField.align = "left"
    M.lastnameField.hasBackground = false
    M.lastnameField.alpha = 0
    M.profileMenuGroup:insert( M.lastnameField )

  --  E-mail ------------------------------------------------------------
    local options = 
    {
        text = "E-postadresse",
        align = "left",
        width = appData.contentW - appData.actionMargin*2,
        font = appData.fonts.actionText,
    }

    M.emailText = display.newText( options )
    M.profileMenuGroup:insert( M.emailText )

    M.emailText.fill = appData.colors.actionText
    M.emailText.anchorX = 0.5
    M.emailText.anchorY = 0
    M.emailText.x = appData.contentW/2
    M.emailText.y = 280 - 35

    M.emailFieldBackground = display.newRoundedRect(
        appData.contentW/2, 
        280, 
        appData.screenW - appData.actionMargin*2, 
        30, 
        appData.actionCorner/2 
    )
    M.emailFieldBackground.fill = appData.colors.actionText
    M.profileMenuGroup:insert( M.emailFieldBackground )

    M.emailField = native.newTextField( 
        appData.contentW/2-400, 
        280, 
        appData.screenW - appData.margin*2 - appData.actionMargin*2, 
        30 
    )
    
    M.emailField.font = appData.fonts.actionText
    if (appData.user.eMail == "") then
        M.emailField.placeholder = ""
    else
        M.emailField.placeholder = ""
        M.emailField.text = appData.user.eMail
    end   
    M.emailField.align = "left"
    M.emailField.hasBackground = false
    M.emailField.alpha = 0
    M.profileMenuGroup:insert( M.emailField )

  --  Phone ------------------------------------------------------------
    local options = 
    {
        text = "Mobil",
        align = "left",
        width = appData.contentW - appData.actionMargin*2,
        font = appData.fonts.actionText,
    }

    M.phoneText = display.newText( options )
    M.profileMenuGroup:insert( M.phoneText )

    M.phoneText.fill = appData.colors.actionText
    M.phoneText.anchorX = 0.5
    M.phoneText.anchorY = 0
    M.phoneText.x = appData.contentW/2
    M.phoneText.y = 340 - 35

    M.phoneFieldBackground = display.newRoundedRect(
        appData.contentW/2, 
        340, 
        appData.screenW - appData.actionMargin*2, 
        30, 
        appData.actionCorner/2 
    )
    M.phoneFieldBackground.fill = appData.colors.actionText
    M.profileMenuGroup:insert( M.phoneFieldBackground )

    M.phoneField = native.newTextField( 
        appData.contentW/2-400, 
        340, 
        appData.screenW - appData.margin*2 - appData.actionMargin*2, 
        30 
    )
    
    M.phoneField.font = appData.fonts.actionText
    if appData.user.phoneNumber == "" or appData.user.phoneNumber == nil then
        M.phoneField.placeholder = ""
    else
        M.phoneField.placeholder = ""
        M.phoneField.text = appData.user.phoneNumber
    end   
    M.phoneField.align = "left"
    M.phoneField.hasBackground = false
    M.phoneField.alpha = 0
    M.profileMenuGroup:insert( M.phoneField )

    -- Profile Button -----------------------------------------------------------------------
    M.profileButton = widget.newButton(
        {
            left = 0,
            top = 0,
            shape = "roundedRect",
            width = 80,
            height = 24,
            cornerRadius = 12,
            label = "LAGRE",
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

    M.profileButton.anchorY = 1
    M.profileButton.x = appData.contentW/2
    M.profileButton.y = appData.contentH - display.screenOriginY*2 - appData.actionMargin
    M.profileMenuGroup:insert( M.profileButton )   
end

-- ----------------------------------------------------------------------------------------------
-- ADDRESSES
-- ----------------------------------------------------------------------------------------------
 
M.showAddressesMenu = function()

    -- setup
    M.addressesMenuGroup = display.newGroup()
    M.sceneGroup:insert( M.addressesMenuGroup )
    M.addressesMenuGroup.alpha = 1

    M.addressesMenuGroup.anchorX = 0.5
    M.addressesMenuGroup.anchorY = 0
    M.addressesMenuGroup.x = 0 - 350
    M.addressesMenuGroup.y = display.screenOriginY

    -- Background ------------------------------------------------------------------------------
    M.addressesBackground = display.newRect( 0, 0, appData.screenW, appData.screenH )
    M.addressesBackground.fill = appData.colors.actionBackground
    M.addressesBackground.anchorX = 0.5
    M.addressesBackground.anchorY = 0
    M.addressesBackground.x = appData.contentW/2
    M.addressesBackground.y = 0
    M.addressesMenuGroup:insert( M.addressesBackground ) 

    -- Info Text -------------------------------------------------------------------------------
    local infoOptions = 
    {
        text = "Adresser",
        width = appData.screenW - appData.margin*2 - appData.actionMargin*2,
        font = appData.fonts.titleText,
        align = "center"
    }

    local topText = display.newText( infoOptions )
    topText.fill = appData.colors.actionText
 
    topText.anchorX = 0.5
    topText.anchorY = 0
    topText.x = appData.contentW/2
    topText.y = 10
    M.addressesMenuGroup:insert( topText )

    -- Options Button --------------------------------------------------------------------------
    M.optionsAddressesIcon = display.newImageRect( "images/settings.png", 90, 35 )
    M.optionsAddressesIcon.anchorX = 0
    M.optionsAddressesIcon.anchorY = 0
    M.optionsAddressesIcon.x = 0
    M.optionsAddressesIcon.y = 0
    M.optionsAddressesIcon.alpha = 0.9
    M.addressesMenuGroup:insert( M.optionsAddressesIcon ) 

    -- Departure Info --------------------------------------------------------------------------
    local departureOptions = 
    {
        text = "Fra",
        width = appData.contentW,
        font = appData.fonts.actionText,
        align = "left"
    }

    local departureText = display.newText( departureOptions )
    departureText.fill = appData.colors.actionText
 
    departureText.anchorX = 0
    departureText.anchorY = 1
    departureText.x = appData.actionMargin
    departureText.y = 75
    M.addressesMenuGroup:insert( departureText )


    --  Departure Background -------------------------------------------------------------------
    M.departureFieldBackground = display.newRoundedRect(
        appData.contentW/2, 0, 
        appData.screenW - appData.actionMargin*2, 30, 
        appData.actionCorner/2 
    )

    M.departureFieldBackground.fill = appData.colors.actionText
    M.departureFieldBackground.y = 90
    M.addressesMenuGroup:insert( M.departureFieldBackground )

    -- Departure Field -------------------------------------------------------------------------

    M.departureField = native.newTextField( 
        appData.contentW/2-400, 0, 
        appData.screenW - appData.margin*2 - appData.actionMargin*2, 30
    )
  
    local placeholder = ""

    if appData.addresses.home.name ~= nil then
        placeholder = appData.addresses.home.name
    end
    

    M.departureField.font = appData.fonts.actionText
    M.departureField.placeholder = ""
    M.departureField.text = placeholder
    M.departureField.align = "left"
    M.departureField.hasBackground = false
    M.departureField.y = 91
    M.departureField.alpha = 0
    M.addressesMenuGroup:insert( M.departureField )













    -- Destination Info --------------------------------------------------------------------------
    local destinationOptions = 
    {
        text = "Til",
        width = appData.contentW,
        font = appData.fonts.actionText,
        align = "left"
    }

    local destinationText = display.newText( destinationOptions )
    destinationText.fill = appData.colors.actionText
 
    destinationText.anchorX = 0
    destinationText.anchorY = 1
    destinationText.x = appData.actionMargin
    destinationText.y = 140
    M.addressesMenuGroup:insert( destinationText )

    --  Destination Background -----------------------------------------------------------------
    M.destinationFieldBackground = display.newRoundedRect(
        appData.contentW/2, 0, 
        appData.screenW - appData.actionMargin*2, 30, 
        appData.actionCorner/2 
    )

    M.destinationFieldBackground.fill = appData.colors.actionText
    M.destinationFieldBackground.y = 155
    M.addressesMenuGroup:insert( M.destinationFieldBackground )

    -- Destination Field -----------------------------------------------------------------------

    M.destinationField = native.newTextField( 
        appData.contentW/2-400, 0, 
        appData.screenW - appData.margin*2 - appData.actionMargin*2, 30
    )

    local placeholder = ""

    if appData.addresses.work.name ~= nil then
        placeholder = appData.addresses.work.name
    end    
    
    M.destinationField.font = appData.fonts.actionText
    M.destinationField.placeholder = ""
    M.destinationField.text = placeholder
    M.destinationField.align = "left"
    M.destinationField.hasBackground = false
    M.destinationField.y = 154
    M.destinationField.alpha = 0
    M.addressesMenuGroup:insert( M.destinationField )

    -- Addresses Button -----------------------------------------------------------------------
    M.addressesButton = widget.newButton(
        {
            left = 0,
            top = 0,
            shape = "roundedRect",
            width = 80,
            height = 24,
            cornerRadius = 12,
            label = "LAGRE",
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

    M.addressesButton.anchorY = 1
    M.addressesButton.x = appData.contentW/2
    M.addressesButton.y = appData.contentH - display.screenOriginY*2 - appData.actionMargin
    M.addressesMenuGroup:insert( M.addressesButton )  
end

-- GOOGLE PLACES 

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
            width = appData.screenW - appData.actionMargin*2,
            onRowRender = departureSearchResultsRowRender,
            noLines = true
        }
    )

    M.departureSearchResults.anchorY = 0
    M.departureSearchResults.anchorX = 0.5
    M.departureSearchResults.x = appData.contentW/2
    M.departureSearchResults.y = 105
    M.addressesMenuGroup:insert( M.departureSearchResults )
     
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
            width = appData.screenW - appData.actionMargin*2,
            onRowRender = destinationSearchResultsRowRender,
            noLines = true
        }
    )

    M.destinationSearchResults.anchorY = 0
    M.destinationSearchResults.anchorX = 0.5
    M.destinationSearchResults.x = appData.contentW/2
    M.destinationSearchResults.y = 170
    M.addressesMenuGroup:insert( M.destinationSearchResults )
     
    -- Insert Rows
    for i = 1, 5 do
        -- Insert a row into the tableView
        M.destinationSearchResults:insertRow{}
    end
end

-- ----------------------------------------------------------------------------------------------
-- CAR
-- ----------------------------------------------------------------------------------------------
M.showCarMenu = function(event)

    -- setup
    M.carMenuGroup = display.newGroup()
    M.sceneGroup:insert( M.carMenuGroup )
    M.carMenuGroup.alpha = 1

    M.carMenuGroup.anchorX = 0.5
    M.carMenuGroup.anchorY = 0
    M.carMenuGroup.x = 0 - 350
    M.carMenuGroup.y = display.screenOriginY

    -- Background ------------------------------------------------------------------------------
    M.carMenuBackground = display.newRect( 0, 0, appData.screenW, appData.screenH )
    M.carMenuBackground.fill = appData.colors.actionBackground
    M.carMenuBackground.anchorX = 0.5
    M.carMenuBackground.anchorY = 0
    M.carMenuBackground.x = appData.contentW/2
    M.carMenuBackground.y = 0
    M.carMenuGroup:insert( M.carMenuBackground ) 

    -- Info Text -------------------------------------------------------------------------------
    local infoOptions = 
    {
        text = "Mitt kjøretøy",
        width = appData.screenW - appData.margin*2 - appData.actionMargin*2,
        font = appData.fonts.titleText,
        align = "center"
    }

    local topText = display.newText( infoOptions )
    topText.fill = appData.colors.actionText
 
    topText.anchorX = 0.5
    topText.anchorY = 0
    topText.x = appData.contentW/2
    topText.y = 10
    M.carMenuGroup:insert( topText )

    -- Options Button --------------------------------------------------------------------------
    M.optionsCarIcon = display.newImageRect( "images/settings.png", 90, 35 )
    M.optionsCarIcon.anchorX = 0
    M.optionsCarIcon.anchorY = 0
    M.optionsCarIcon.x = 0
    M.optionsCarIcon.y = 0
    M.optionsCarIcon.alpha = 0.9
    M.carMenuGroup:insert( M.optionsCarIcon )    


    -- Info Text
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
    M.infoText.y = 55
    M.carMenuGroup:insert( M.infoText )

  --  Brand ------------------------------------------------------------
    local options = 
    {
        text = "Merke",
        align = "left",
        width = appData.contentW - appData.actionMargin*2,
        font = appData.fonts.actionText,
    }

    M.brandText = display.newText( options )
    M.carMenuGroup:insert( M.brandText )

    M.brandText.fill = appData.colors.actionText
    M.brandText.anchorX = 0.5
    M.brandText.anchorY = 0
    M.brandText.x = appData.contentW/2
    M.brandText.y = 100 - 35

    --

    M.factoryFieldBackground = display.newRoundedRect(
        appData.contentW/2, 
        100, 
        appData.screenW - appData.actionMargin*2, 
        30, 
        appData.actionCorner/2 
    )
    M.factoryFieldBackground.fill = appData.colors.actionText
    M.carMenuGroup:insert( M.factoryFieldBackground )

    M.factoryField = native.newTextField( 
        appData.contentW/2-400, 
        100, 
        appData.screenW - appData.margin*2 - appData.actionMargin*2, 
        30 
    )
  
    M.factoryField.font = appData.fonts.actionText
    if (appData.car.make == "") then
        M.factoryField.placeholder = ""
    else
        M.factoryField.placeholder = ""
        M.factoryField.text = appData.car.make
    end          
    M.factoryField.align = "left"
    M.factoryField.hasBackground = false
    M.factoryField.alpha = 0
    M.carMenuGroup:insert( M.factoryField )

    -- 

    M.factoryDot = display.newCircle( 0, 0, 3 )
    M.factoryDot.fill = appData.colors.infoButtonFillDefault
    M.factoryDot.anchorX = 0
    M.factoryDot.anchorY = 0.5
    M.factoryDot.x = display.screenOriginX + appData.margin/2
    M.factoryDot.y = 100
    M.carMenuGroup:insert( M.factoryDot ) 
    M.factoryDot.alpha = 0

  --  Model ------------------------------------------------------------
    local options = 
    {
        text = "Modell",
        align = "left",
        width = appData.contentW - appData.actionMargin*2,
        font = appData.fonts.actionText,
    }

    M.modelText = display.newText( options )
    M.carMenuGroup:insert( M.modelText )

    M.modelText.fill = appData.colors.actionText
    M.modelText.anchorX = 0.5
    M.modelText.anchorY = 0
    M.modelText.x = appData.contentW/2
    M.modelText.y = 160 - 35

    --

    M.modelFieldBackground = display.newRoundedRect(
        appData.contentW/2, 
        160, 
        appData.screenW - appData.actionMargin*2, 
        30, 
        appData.actionCorner/2 
    )
    M.modelFieldBackground.fill = appData.colors.actionText
    M.carMenuGroup:insert( M.modelFieldBackground )

    M.modelField = native.newTextField( 
        appData.contentW/2-400, 
        160, 
        appData.screenW - appData.margin*2 - appData.actionMargin*2, 
        30 
    )
    
    M.modelField.font = appData.fonts.actionText
    if (appData.car.model == "") then
        M.modelField.placeholder = ""
    else
        M.modelField.placeholder = ""
        M.modelField.text = appData.car.model
    end   
    M.modelField.align = "left"
    M.modelField.hasBackground = false
    M.modelField.alpha = 0
    M.carMenuGroup:insert( M.modelField )

    --  Color ----------------------------------------------------------
    local options = 
    {
        text = "Farge",
        align = "left",
        width = appData.contentW - appData.actionMargin*2,
        font = appData.fonts.actionText,
    }

    M.colorText = display.newText( options )
    M.carMenuGroup:insert( M.colorText )

    M.colorText.fill = appData.colors.actionText
    M.colorText.anchorX = 0.5
    M.colorText.anchorY = 0
    M.colorText.x = appData.contentW/2
    M.colorText.y = 220 - 35

    --

    M.colorFieldBackground = display.newRoundedRect(
        appData.contentW/2, 
        220, 
        appData.screenW - appData.actionMargin*2, 
        30, 
        appData.actionCorner/2 
    )
    M.colorFieldBackground.fill = appData.colors.actionText
    M.carMenuGroup:insert( M.colorFieldBackground )

    M.colorField = native.newTextField( 
        appData.contentW/2-400, 
        220, 
        appData.screenW - appData.margin*2 - appData.actionMargin*2, 
        30 
    )
  
    M.colorField.font = appData.fonts.actionText
    if (appData.car.color == "") then
        M.colorField.placeholder = ""
    else
        M.colorField.placeholder = ""
        M.colorField.text = appData.car.color
    end          
    M.colorField.align = "left"
    M.colorField.hasBackground = false
    M.colorField.alpha = 0
    M.carMenuGroup:insert( M.colorField )

  --  Plate ------------------------------------------------------------
   local options = 
    {
        text = "Registreringsnummer",
        align = "left",
        width = appData.contentW - appData.actionMargin*2,
        font = appData.fonts.actionText,
    }

    M.plateText = display.newText( options )
    M.carMenuGroup:insert( M.plateText )

    M.plateText.fill = appData.colors.actionText
    M.plateText.anchorX = 0.5
    M.plateText.anchorY = 0
    M.plateText.x = appData.contentW/2
    M.plateText.y = 280 - 35

    --

    M.plateFieldBackground = display.newRoundedRect(
        appData.contentW/2, 
        280, 
        appData.screenW - appData.actionMargin*2, 
        30, 
        appData.actionCorner/2 
    )
    M.plateFieldBackground.fill = appData.colors.actionText
    M.carMenuGroup:insert( M.plateFieldBackground )

    M.plateField = native.newTextField( 
        appData.contentW/2-400, 
        280, 
        appData.screenW - appData.margin*2 - appData.actionMargin*2, 
        30 
    )
    
    M.plateField.font = appData.fonts.actionText
    if (appData.car.license_plate == "") then
        M.plateField.placeholder = ""
    else
        M.plateField.placeholder = ""
        M.plateField.text = appData.car.license_plate
    end   
    M.plateField.align = "left"
    M.plateField.hasBackground = false
    M.plateField.alpha = 0
    M.carMenuGroup:insert( M.plateField )

    -- Car Button -----------------------------------------------------------------------
    M.carButton = widget.newButton(
        {
            left = 0,
            top = 0,
            shape = "roundedRect",
            width = 80,
            height = 24,
            cornerRadius = 12,
            label = "LAGRE",
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

    M.carButton.anchorY = 1
    M.carButton.x = appData.contentW/2
    M.carButton.y = appData.contentH - display.screenOriginY*2 - appData.actionMargin
    M.carMenuGroup:insert( M.carButton )   
end

-- ----------------------------------------------------------------------------------------------
-- SETTINGS
-- ----------------------------------------------------------------------------------------------

M.showSettingsMenu = function(event)

    -- setup
    M.settingsMenuGroup = display.newGroup()
    M.sceneGroup:insert( M.settingsMenuGroup )
    M.settingsMenuGroup.alpha = 1

    M.settingsMenuGroup.anchorX = 0.5
    M.settingsMenuGroup.anchorY = 0
    M.settingsMenuGroup.x = 0 - 350
    M.settingsMenuGroup.y = display.screenOriginY

    -- Background ------------------------------------------------------------------------------
    M.settingsMenuBgg = display.newRect( 0, 0, appData.screenW, appData.screenH )
    M.settingsMenuBgg.fill = appData.colors.actionBackground
    M.settingsMenuBgg.anchorX = 0
    M.settingsMenuBgg.anchorY = 0
    M.settingsMenuBgg.x = 0
    M.settingsMenuBgg.y = 0
    M.settingsMenuGroup:insert( M.settingsMenuBgg ) 
    

    -- Info Text -------------------------------------------------------------------------------
    local textOptions = 
    {
        text = "Innstillinger",
        width = appData.screenW - appData.margin*2 - appData.actionMargin*2,
        font = appData.fonts.titleText,
        align = "center"
    }

    local topText = display.newText( textOptions )
    topText.fill = appData.colors.actionText
 
    topText.anchorX = 0.5
    topText.anchorY = 0
    topText.x = appData.contentW/2
    topText.y = 10
    M.settingsMenuGroup:insert( topText )

    -- Options Button --------------------------------------------------------------------------
    M.settingsMenuIcon = display.newImageRect( "images/settings.png", 90, 35 )
    M.settingsMenuIcon.anchorX = 0
    M.settingsMenuIcon.anchorY = 0
    M.settingsMenuIcon.x = 0
    M.settingsMenuIcon.y = 0
    M.settingsMenuIcon.alpha = 0.9
    M.settingsMenuGroup:insert( M.settingsMenuIcon )  

    -- --------------------------------------------------------------------------------------- --
    -- Settings Button 
    -- --------------------------------------------------------------------------------------- --
    
    M.settingsMenuButton = widget.newButton(
        {
            left = 0,
            top = 0,
            shape = "roundedRect",
            width = 80,
            height = 24,
            cornerRadius = 12,
            label = "LAGRE",
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

    M.settingsMenuButton.anchorY = 1
    M.settingsMenuButton.x = appData.contentW/2
    M.settingsMenuButton.y = appData.contentH - display.screenOriginY*2 - appData.actionMargin
    M.settingsMenuGroup:insert( M.settingsMenuButton )  


    -- ---------------------------------------------------------------------------------------------------
    -- MORNING
    -- ---------------------------------------------------------------------------------------------------

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
            -- M.passengerSwitch:setState( { isOn=false } )
            -- M.bothSwitch:setState( { isOn=false } )
        else 
            -- M.passengerSwitch:setState( { isOn=true } )        
        end
    end

    local handleDriverSwitch = function(event)
        print("driver 1")
        if event.phase == "began" then
            --[[
            print("driver began")
            if appData.user.mode == "driver" then
                print("driver 2")
                M.driverSwitch:setState( { isOn=true } )
                M.passengerSwitch:setState( { isOn=false } )
            else
                M.passengerSwitch:setState( { isOn=false } )
                appData.user.mode = "driver" 
            end 
            --]]

        elseif event.phase == "ended" then 
            
            print("driver ended")
            if appData.user.mode == "driver" then
                print("driver 3")
                M.driverSwitch:setState( { isOn=true } )
                M.passengerSwitch:setState( { isOn=false } )
            else
                M.passengerSwitch:setState( { isOn=false } )
                appData.user.mode = "driver" 
            end 
                   
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
            onPress = handleDriverSwitch,
            onRelease = handleDriverSwitch
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
        if appData.user.mode == "passenger" then
            M.passengerSwitch:setState( { isOn=true } )
            M.driverSwitch:setState( { isOn=false } )
        else 
            -- M.driverSwitch:setState( { isOn=true } )
        end
    end

    local handlePassengerSwitch = function(event)
        print("passenger 1")
        if event.phase == "began" then
            print("passenger began")
            if appData.user.mode == "passenger" then
                print("passenger 1")
                M.passengerSwitch:setState( { isOn=true } )
                M.driverSwitch:setState( { isOn=false } )
            else 
                M.driverSwitch:setState( { isOn=false } )
                appData.user.mode = "passenger" 
            end 
        elseif event.phase == "ended" then 
            print("passenger ended")
            if appData.user.mode == "passenger" then
                print("passenger 2")
                M.passengerSwitch:setState( { isOn=true } )
                M.driverSwitch:setState( { isOn=false } )
            else
                M.driverSwitch:setState( { isOn=false } )
                appData.user.mode = "passenger"    
            end 
        end
    end
    -- 

    M.passengerSwitch = widget.newSwitch(
        {
            left = display.screenOriginX - 5,
            top = 70,
            id = "passengerSwitch",
            style = "onOff",
            initialSwitchState = passengerSwitchState,
            onPress = handlePassengerSwitch,
            onRelease = handlePassengerSwitch
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
    --[[
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
    --]]
    

    -- Final Setup --------------------------------------------------------------------------------------
    -- M.switchesGroup.y = display.screenOriginY + 135
    M.switchesGroup.y = display.screenOriginY + 240
    M.settingsMenuGroup:insert( M.switchesGroup )

    -- ---------------------------------------------------------------------------------------------------
    -- MORNING
    -- ---------------------------------------------------------------------------------------------------

    -- Morning Time Background -------------------------------------------------------------------------
    M.morningTimeBackground = display.newRoundedRect(0, 0, 60, 30, appData.actionCorner/2 )
    M.morningTimeBackground.fill = appData.colors.actionText
    M.morningTimeBackground.anchorX = 1
    M.morningTimeBackground.anchorY = 0
    M.morningTimeBackground.x = appData.screenW - appData.actionMargin - 110
    M.morningTimeBackground.y = 75
    M.settingsMenuGroup:insert( M.morningTimeBackground )


    -- Morning Text -------------------------------------------------------------------------------
    local morningOptions = 
    {
        text = "Morgen",
        font = appData.fonts.actionText,
    }

    M.morning = display.newText( morningOptions )
    M.morning.fill = appData.colors.actionText
    M.morning.anchorX = 0
    M.morning.anchorY = 0
    M.morning.x = appData.actionMargin
    M.morning.y = 80
    M.settingsMenuGroup:insert( M.morning ) 

    -- Morning Time Text -------------------------------------------------------------------------------
    local morningTimeOptions = 
    {
        text = appData.user.morningTime,
        font = appData.fonts.actionText,
    }

    M.morningTime = display.newText( morningTimeOptions )
    M.morningTime.fill = appData.colors.fieldText
    M.morningTime.anchorX = 1
    M.morningTime.anchorY = 0
    M.morningTime.x = appData.screenW - appData.actionMargin - 120
    M.morningTime.y = 80
    M.settingsMenuGroup:insert( M.morningTime )  

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
    M.toleranceText1.x = 213
    M.toleranceText1.y = 96
    M.settingsMenuGroup:insert( M.toleranceText1 )
    -- 

    -- Mornig Tolerance Background --------------------------------------------------------------------
    M.morningToleranceBackground = display.newRoundedRect(0, 0, 60, 30, appData.actionCorner/2)
    M.morningToleranceBackground.fill = appData.colors.actionText
    M.morningToleranceBackground.anchorX = 1
    M.morningToleranceBackground.anchorY = 0
    M.morningToleranceBackground.x = appData.screenW - appData.actionMargin
    M.morningToleranceBackground.y = 75    
    M.settingsMenuGroup:insert( M.morningToleranceBackground )
    
    -- Morning Tolerance Text --------------------------------------------------------------------------
    local morningToleranceOptions = 
    {
        text = tostring(appData.user.morningFlexibility/60).." min",
        font = appData.fonts.actionText,
    }

    M.morningTolerance = display.newText( morningToleranceOptions )
    M.morningTolerance.fill = appData.colors.fieldText
 
    M.morningTolerance.anchorX = 1
    M.morningTolerance.anchorY = 0
    M.morningTolerance.x = appData.screenW - appData.actionMargin - 10
    M.morningTolerance.y = 80
    M.settingsMenuGroup:insert( M.morningTolerance ) 

    -- ---------------------------------------------------------------------------------------------------
    -- AFTERNOON
    -- ---------------------------------------------------------------------------------------------------

    -- Afternoon Time ------------------------------------------------------------------------------------
    local afternoonOptions = 
    {
        text = "Ettermiddag",
        font = appData.fonts.actionText,
    }

    M.afternoon = display.newText( afternoonOptions )
    M.afternoon.fill = appData.colors.actionText
    M.afternoon.anchorX = 0
    M.afternoon.anchorY = 0
    M.afternoon.x = appData.actionMargin
    M.afternoon.y = 125
    M.settingsMenuGroup:insert( M.afternoon )  

    -- Afternoon Time Background -------------------------------------------------------------------------
    M.afternoonTimeBackground = display.newRoundedRect(0, 0, 60, 30, appData.actionCorner/2 )
    M.afternoonTimeBackground.fill = appData.colors.actionText
    M.afternoonTimeBackground.anchorX = 1
    M.afternoonTimeBackground.anchorY = 0
    M.afternoonTimeBackground.x = appData.screenW - appData.actionMargin - 110
    M.afternoonTimeBackground.y = 120
    M.settingsMenuGroup:insert( M.afternoonTimeBackground )

    -- Afternoon Time Text -------------------------------------------------------------------------------
    local afternoonTimeOptions = 
    {
        text = appData.user.afternoonTime,
        font = appData.fonts.actionText,
    }

    M.afternoonTime = display.newText( afternoonTimeOptions )
    M.afternoonTime.fill = appData.colors.fieldText
    M.afternoonTime.anchorX = 1
    M.afternoonTime.anchorY = 0
    M.afternoonTime.x = appData.screenW - appData.actionMargin - 120
    M.afternoonTime.y = 125
    M.settingsMenuGroup:insert( M.afternoonTime ) 

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
    M.toleranceText2.x = 213
    M.toleranceText2.y = 139
    M.settingsMenuGroup:insert( M.toleranceText2 )     

    -- Mornig Tolerance Background --------------------------------------------------------------------
    M.afternoonToleranceBackground = display.newRoundedRect(0, 0, 60, 30, appData.actionCorner/2)
    M.afternoonToleranceBackground.fill = appData.colors.actionText
    M.afternoonToleranceBackground.anchorX = 1
    M.afternoonToleranceBackground.anchorY = 0
    M.afternoonToleranceBackground.x = appData.screenW - appData.actionMargin
    M.afternoonToleranceBackground.y = 120    
    M.settingsMenuGroup:insert( M.afternoonToleranceBackground )
    
    -- Morning Tolerance Text --------------------------------------------------------------------------
    local afternoonToleranceOptions = 
    {
        text = tostring(appData.user.afternoonFlexibility/60).." min",
        font = appData.fonts.actionText,
    }

    M.afternoonTolerance = display.newText( afternoonToleranceOptions )
    M.afternoonTolerance.fill = appData.colors.fieldText
 
    M.afternoonTolerance.anchorX = 1
    M.afternoonTolerance.anchorY = 0
    M.afternoonTolerance.x = appData.screenW - appData.actionMargin - 10
    M.afternoonTolerance.y = 125
    M.settingsMenuGroup:insert( M.afternoonTolerance ) 

    -- --------------------------------------------------------------------------------------- --
    -- Settings Wheels 
    -- --------------------------------------------------------------------------------------- --
 
    -- White Background
    M.whiteBackground = display.newRect( 
        0, 0+display.screenOriginY, appData.screenW, appData.screenH+200 )
    M.whiteBackground.fill = appData.colors.infoBackround
    M.whiteBackground.anchorY = 0
    M.whiteBackground.x = appData.contentW/2
    M.whiteBackground.y = 0
    M.whiteBackground.alpha = 0
    M.settingsMenuGroup:insert( M.whiteBackground )

    -- ---------------------------------------------------------------------------
    -- Morning Wheels
    -- ---------------------------------------------------------------------------

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
            width = appData.screenW/2 - 5,
            labelPadding = 0,
            startIndex = 3,
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
            width = appData.screenW/2,
            labelPadding = 0,
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
    M.morningTimeWheel = widget.newPickerWheel(
    {
        x = display.contentCenterX,
        top = 0,
        style = "resizable",
        width = appData.screenW*2,
        height = appData.screenW,
        rowHeight = 30,
        font = appData.fonts.actionText,
        fontSize = 14,
        columns = morningTimeWheelData
    }) 
    
    M.morningTimeWheel.anchorX = 0.5
    M.morningTimeWheel.x = appData.contentW/2 + 170
    M.morningTimeWheel.y = -3000
    M.settingsMenuGroup:insert( M.morningTimeWheel ) 

    -- Transport Tolerance Wheel

    local morningToleranceWheelData =
    {
        {
            align = "left",
            labelPadding = 0,
            width = 1,
            startIndex = 1,
            labels = { "" }
        },

        {
            align = "center",
            labelPadding = 0,
            width = appData.contentW-1,
            startIndex = 5,
            labels = { 
                "10 min", "15 min", "20 min", "25 min", "30 min", "35 min", "40 min", "45 min", "50 min", "55 min", "60 min"
            }
        }
    }
     
    -- Create the widget
    M.morningToleranceWheel = widget.newPickerWheel(
    {
        x = display.contentCenterX,
        top = 0,
        style = "resizable",
        width = appData.contentW,
        height = appData.screenH,
        rowHeight = 30,
        font = appData.fonts.actionText,
        fontSize = 14,
        columns = morningToleranceWheelData
    }) 
    
    M.morningToleranceWheel.anchorX = 0.5
    M.morningToleranceWheel.x = appData.contentW/2
    M.morningToleranceWheel.y = -3000
    M.settingsMenuGroup:insert( M.morningToleranceWheel ) 

    -- Transport Role Button

    local roleWheelData =
    {
        {
            align = "left",
            labelPadding = 0,
            width = 1,
            startIndex = 1,
            labels = { "" }
        },

        {
            align = "center",
            labelPadding = 0,
            width = appData.contentW-1,
            startIndex = 1,
            labels = { "passenger", "driver" }
        }
    }
    
    -- ---------------------------------------------------------------------------
    -- Afternoon Wheels
    -- ---------------------------------------------------------------------------

    local afternoonTimeWheelData =
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
            width = appData.screenW/2 - 5,
            labelPadding = 0,
            startIndex = 3,
            labels = { 
                "14", "15","16", "17"
            }
        },

        {
            align = "center",
            width = 5,
            labelPadding = 0,
            startIndex = 1,
            labels = { ":" }
        },

        {
            align = "left",
            labelPadding = 0,
            width = appData.screenW/2,
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
    M.afternoonTimeWheel = widget.newPickerWheel(
    {
        x = display.contentCenterX,
        top = 0,
        style = "resizable",
        width = appData.screenW*2,
        height = appData.screenW,
        rowHeight = 30,
        font = appData.fonts.actionText,
        fontSize = 14,
        columns = afternoonTimeWheelData
    }) 
    
    M.afternoonTimeWheel.anchorX = 0.5
    M.afternoonTimeWheel.x = appData.contentW/2 + 170
    M.afternoonTimeWheel.y = -3000
    M.settingsMenuGroup:insert( M.afternoonTimeWheel ) 

    -- Afternoon Tolerance Wheel

    local afternoonToleranceWheelData =
    {
        {
            align = "left",
            labelPadding = 0,
            width = 1,
            startIndex = 1,
            labels = { "" }
        },

        {
            align = "center",
            labelPadding = 0,
            width = appData.contentW-1,
            startIndex = 5,
            labels = { 
                "10 min", "15 min", "20 min", "25 min", "30 min", "35 min", "40 min", "45 min", "50 min", "55 min", "60 min"
            }
        }
    }
     
    -- Create the widget
    M.afternoonToleranceWheel = widget.newPickerWheel(
    {
        x = appData.contentW/2,
        top = 0,
        style = "resizable",
        width = appData.contentW,
        height = appData.contentH,
        rowHeight = 30,
        font = appData.fonts.actionText,
        fontSize = 14,
        columns = afternoonToleranceWheelData
    }) 
    
    M.afternoonToleranceWheel.anchorX = 0.5
    M.afternoonToleranceWheel.x = appData.contentW/2
    M.afternoonToleranceWheel.y = -3000
    M.settingsMenuGroup:insert( M.afternoonToleranceWheel ) 

    -- ----------------------------------------------------------------------------
    -- Role Wheel
    -- ----------------------------------------------------------------------------

    local roleWheelData =
    {
        {
            align = "left",
            labelPadding = 0,
            width = 1,
            startIndex = 1,
            labels = { "" }
        },

        {
            align = "center",
            labelPadding = 0,
            width = appData.contentW,
            startIndex = 1,
            labels = { "passenger", "driver" }
        }
    }

    -- Create the widget
    M.roleWheel = widget.newPickerWheel(
    {
        x = display.contentCenterX,
        top = 0,
        style = "resizable",
        width = appData.contentW,
        height = appData.contentH,
        rowHeight = 30,
        font = appData.fonts.actionText,
        fontSize = 14,
        columns = roleWheelData
    }) 
    
    M.roleWheel.anchorX = 0.5
    M.roleWheel.x = appData.contentW/2
    M.roleWheel.y = -3000
    M.settingsMenuGroup:insert( M.roleWheel ) 

    -- Wheel Button 
    M.wheelButton = widget.newButton(
        {
            left = 0,
            top = 0,
            shape = "roundedRect",
            width = 80,
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
    M.wheelButton.anchorY = 1 
    M.wheelButton.x = appData.contentW - display.screenOriginX - 23
    M.wheelButton.y = appData.contentH - display.screenOriginY*2 - appData.actionMargin
    M.wheelButton.alpha = 0
    M.settingsMenuGroup:insert( M.wheelButton )      
end 
-- ----------------------------------------------------------------------------------------------
-- APP INFO
-- ----------------------------------------------------------------------------------------------
M.showBottomMenu = function(event)
    M.bottomGroup = display.newGroup()

    -- Info Text
    local infoOptions = 
    {
        text = "SammeVei "..appData.system.appVersion,
        width = appData.screenW - appData.margin*2 - appData.actionMargin*2,
        font = appData.fonts.actionText,
        align = "center"
    }

    M.bottomText = display.newText( infoOptions )
    M.bottomText.fill = appData.colors.actionText
 
    M.bottomText.anchorX = 0.5
    M.bottomText.anchorY = 1
    M.bottomText.x = appData.contentW/2
    M.bottomText.y = appData.contentH - display.screenOriginY - 10
    M.bottomText.alpha = 0.5
    M.bottomGroup:insert( M.bottomText )
    
    M.sceneGroup:insert( M.bottomGroup )
end

return M