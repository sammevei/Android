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
        text = "VELKOMMEN",
        width = appData.contentW,
        font = appData.fonts.titleText,
        align = "center"
    }

    M.welcomeText = display.newText( infoOptions )
    M.welcomeText.fill = appData.colors.actionText

    M.welcomeText.anchorX = 0.5
    M.welcomeText.anchorY = 0
    M.welcomeText.x = appData.contentW/2
    M.welcomeText.y = display.screenOriginY + 120
    M.sceneGroup:insert( M.welcomeText )
end

-- Info
M.showInstructions = function(event)
    local instructionsOptions = 
    {
        text = "Noen få steg igjen til første samkjøring!",
        width = appData.contentW,
        font = appData.fonts.actionText,
        align = "center"
    }

    M.instructionsText = display.newText( instructionsOptions )
    M.instructionsText.fill = appData.colors.actionText

    M.instructionsText.anchorX = 0.5
    M.instructionsText.anchorY = 0
    M.instructionsText.x = appData.contentW/2
    M.instructionsText.y = appData.contentH/2
    M.sceneGroup:insert( M.instructionsText )
end


-- buttons
M.showButtons = function(event)

    -- EMAIL
    -- email background
     M.emailLogin = display.newGroup()
     M.emailLogin.x = 0  
     M.emailLogin.y = appData.contentH/2 +30 + 10 
     M.sceneGroup:insert( M.emailLogin )

     M.emailBackground = display.newRoundedRect(
        appData.contentW/2, 
        0, 
        appData.screenW - appData.margin*2 - appData.actionMargin*2, 
        30, 
        appData.actionCorner*3 
    ) 

    M.emailLogin:insert( M.emailBackground ) 

    -- email icon
    M.emailIcon = display.newImageRect( "images/email.png", 25, 25 )
    M.emailIcon.anchorX = 0
    M.emailIcon.anchorY = 0.5
    M.emailIcon.x = display.screenOriginX + appData.actionMargin*2
    M.emailIcon.y = 0
    M.emailIcon.alpha = 1
    M.emailLogin:insert( M.emailIcon )  

    -- email text
    local emailOptions = 
    {
        text = "Logg inn med e-postadresse",
        width = 320,
        font = appData.fonts.actionText,
        align = "left"
    }

    
    M.forgotText = display.newText( emailOptions )
    M.forgotText.fill = appData.colors.actionComment

    M.forgotText.anchorX = 0
    M.forgotText.anchorY = 1
    M.forgotText.x = display.screenOriginX + appData.actionMargin*2 + 25 + 10
    M.forgotText.y = 7
    M.forgotText.alpha = 1
    M.emailLogin:insert( M.forgotText )
end 

-- Terms of Service, Privacy
M.showTOS = function()
    local tosOptions = 
    {
        text = "Ved å logge inn aksepterer du våre brukervilkår og regler for personvern",
        width = 280,
        font = appData.fonts.actionText,
        align = "left"
    }

    M.tos = display.newImageRect( "images/tos.png", 1242/4.8, 140/4.8 )
    M.tos.anchorX = 0
    M.tos.anchorY = 0
    M.tos.x = display.screenOriginX + appData.actionMargin + appData.margin
    M.tos.y = appData.contentH/2 + 65
    M.tos.alpha = 0.7
    M.sceneGroup:insert( M.tos )

    M.button1 = display.newImageRect( "images/white.png", 63, 20 )
    M.button1.anchorX = 0
    M.button1.anchorY = 0
    M.button1.x = display.screenOriginX + appData.actionMargin + appData.margin + 172
    M.button1.y = appData.contentH/2 + 65
    M.button1.alpha = 0.01
    M.sceneGroup:insert( M.button1 )

    M.button2 = display.newImageRect( "images/white.png", 63, 20 )
    M.button2.anchorX = 0
    M.button2.anchorY = 0
    M.button2.x = display.screenOriginX + appData.actionMargin + appData.margin + 40
    M.button2.y = appData.contentH/2 + 80
    M.button2.alpha = 0.01
    M.sceneGroup:insert( M.button2 )
end

-- Footer
M.showFooter = function()
    M.footerGroup = display.newGroup()

    -- Info Text
    local footerOptions = 
    {
        text = "SammeVei",
        width = appData.screenW - appData.margin*2 - appData.actionMargin*2,
        font = appData.fonts.actionText,
        align = "center"
    }

    M.footerText = display.newText( footerOptions )
    M.footerText.fill = appData.colors.actionText
 
    M.footerText.anchorX = 0.5
    M.footerText.anchorY = 1
    M.footerText.x = appData.contentW/2
    M.footerText.y = appData.contentH - display.screenOriginY - 10
    M.footerText.alpha = 1
    M.footerGroup:insert( M.footerText )
    
    M.sceneGroup:insert( M.footerGroup )
end

return M