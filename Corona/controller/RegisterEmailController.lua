local sceneName = RegisterEmailController

-- Include
local view = require("view.RegisterEmailView")
local model = require("model.RegisterEmailModel")

local composer = require( "composer" )
local widget = require( "widget" )
local appData = require( "misc.appData" )
local utils = require( "misc.luaUtils" )

composer.recycleOnSceneChange = false
local registrationStarted
local t1
local alertHandler

-- -------------------------------------------------------------------
-- FIELDS
-- -------------------------------------------------------------------


-- cancel login
local cancelRegistration = function()
    composer.removeScene("controller.RegisterEmailController", appData.transitionRightOptions)
    composer.gotoScene("controller.WelcomeController", appData.transitionRightOptions)
end


-- email field
local emailFieldListener = function(event)
    if ( event.phase == "ended" or event.phase == "submitted" ) then
       
    end
end

-- password field 1
local passwordField1Listener = function(event)
    if ( event.phase == "began" ) then
        view.passwordField1.isSecure = true
    elseif ( event.phase == "ended" or event.phase == "submitted" ) then

    end
end

-- password field 2
local passwordField2Listener = function(event)
    if ( event.phase == "began" ) then
        view.passwordField2.isSecure = true
    elseif ( event.phase == "ended" or event.phase == "submitted" ) then

    end
end

-- -------------------------------------------------------------------
-- AUTH
-- -------------------------------------------------------------------
-- finishAuth
local finishAuth = function( event )
    print(event.response)
    local data = appData.json.decode(event.response)

    if data.user == nil then
        registrationStarted = false

        local alert = native.showAlert( 
            "Feil under registrering", 
            "Det synes å være et problem med forbindelsen din. ".. 
            "Vi kunne ikke koble deg til våre servere. ".. 
            "Vennligst sjekk innstillinger din.", 
            { "OK", "" },
             alertHandler) 

        return true
    end    

    -- remove fields
    if view.emailField ~= nil then
      display.remove( view.emailField )
      view.emailField = nil
    end

    if view.passwordField1 ~= nil then
      display.remove( view.passwordField1 )
      view.passwordField1 = nil
    end

    if view.passwordField2 ~= nil then
      display.remove( view.passwordField2 )
      view.passwordField2 = nil
    end

    -- store data
    appData.user.id = data.user.id
    appData.user.userID = data.user.user_id


    -- save user
    -- model.saveUser()
    
    -- store tokens
    appData.session.accessToken = data.token.accessToken
    appData.session.refreshToken = data.token.refreshToken

    -- save refresh token
    model.saveRefreshToken()
    
    -- go to next scene
    composer.removeScene("controller.RegisterEmailController", appData.transitionLeftOptions)
    composer.gotoScene("controller.PhoneController", appData.transitionLeftOptions)   
end

-- loginUser
local loginUser = function( event )
    print(event.response)
    local result

    if event.response ~= nil then
        result = appData.json.decode(event.response) 
    end
        
    if result == nil then
        local alert = native.showAlert( 
            "",
            "Ooops... det synes å være et problem med forbindelsen din. ".. 
            "Vi kunne ikke koble deg til våre servere. ".. 
            "Vennligst sjekk innstillinger din.",
            { "OK", "" },
            alertHandler 
            )

        return true    
    end

    if result.success == true then
      --prepare data
        local url = "https://api.sammevei.no/api/1/auth/login" 

        local headers = {}
        headers["Content-Type"] = "application/x-www-form-urlencoded"
          
        local params = {}
        params.headers = headers
        params.body = 
            'username='..
            utils.urlEncode(appData.user.userName)..
            '&'..
            'password='..
            utils.urlEncode(appData.user.passWord)..
            '&'..
            'permanent=true'

        -- send request
        network.request( url, "POST", finishAuth, params)

        print("logging user!")
        -- native.setActivityIndicator( false )
    else
        local alert = native.showAlert( 
            "Feil under registrering", 
            "Det finnes allerede en konto for "..view.emailField.text, 
            { "OK", "" },
             alertHandler)
    end    
end

-- Go to Login screen
local logIn = function()
    -- go to next scene
    native.setKeyboardFocus( nil )
    composer.removeScene("controller.RegisterEmailController")
    composer.gotoScene("controller.LoginEmailController")  
end

alertHandler = function()
    registrationStarted = false
end 

-- register user
registrationStarted = false
local registerUser = function( event )
    if ( event.phase == "began" ) then

        view.registerButton.alpha = 0.7

    elseif ( event.phase == "ended" and registrationStarted == false) then

        registrationStarted = true

        transition.to( event.target, { time = 250, alpha = 0.1 })
        transition.to( event.target, { delay = 500, time = 500, alpha = 1 } )
        native.setKeyboardFocus( nil )

        -- validate email
        if (view.emailField.text:match("[A-Za-z0-9%.%%%+%-]+@[A-Za-z0-9%.%%%+%-]+%.%w%w%w?%w?")) then

        else
            local alert = native.showAlert( 
                "", 
                "Bruk en gyldig e-post, takk.", 
                { "OK", "" }, 
                alertHandler 
            )
        
            return true
        end

        -- validate password
        if string.len(view.passwordField1.text) < 1 then
            print("INVALID PASSWORD")
            local alert = native.showAlert( 
                "", 
                "Velg et nytt passord, takk.", 
                { "OK", "" }, 
                alertHandler 
            ) 

            return true  
        else
            -- print("VALID PASSWORD")
            -- return true
        end    

        if view.passwordField1.text ~= view.passwordField2.text then
            print("PASSWORDS DON't MATCH")
            local alert = native.showAlert( 
                "", 
                "Passord er ikke det samme, prøv igjen.", 
                { "OK", "" }, 
                alertHandler 
            ) 

            return true  
        else
            -- print("VALID PASSWORD")
            -- return true
        end 

    
        print("registering user")
        model.defineUser(view.emailField.text, view.passwordField1.text)

        --prepare data
        local url = "https://api.sammevei.no/api/1/auth/register" 

        local headers = {}
        headers["Content-Type"] = "application/x-www-form-urlencoded"
        -- headers["X-API-Key"] = "13b6ac91a2"
          
        local params = {}
        params.headers = headers
        params.body = 
            'username='..
            utils.urlEncode(appData.user.userName)..
            '&'..
            'password='..
            utils.urlEncode(appData.user.passWord)

        -- send request
        network.request( url, "POST", loginUser, params)

        view.registerButton.alpha = 1

        -- hode keyboard
        native.setKeyboardFocus( nil )

        return true

        -- native.setActivityIndicator( true )
    end    
end

-- -----------------------------------------------------------------------------------
-- Scene components
-- -----------------------------------------------------------------------------------
local scene = composer.newScene()

-- create()
function scene:create( event )
    appData.restart = true
 
    view.sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen

    -- Show background
    view.showBackground()

    -- Show TOS
    -- view.showTOS()

    -- Show Info
    view.showInfo()

    -- Show Fields
    view.showFields()

    -- Show Login
    -- view.showLogin()

    -- Register Button
    view.showRegisterButton()

    print("register created")

    -- Add Listeners
    view.emailField:addEventListener( "userInput", emailFieldListener )
    view.passwordField1:addEventListener( "userInput", passwordField1Listener )
    view.passwordField2:addEventListener( "userInput", passwordField2Listener )
    view.registerButton:addEventListener( "touch", registerUser )
    -- view.button1:addEventListener( "tap", openTOS ) 
    -- view.button2:addEventListener( "tap", openPrivacy )
    -- view.button1:addEventListener( "tap", openTOS ) 
    view.cancelButton:addEventListener( "tap", cancelRegistration ) 

    print("listeners added") 
end
 
 
-- show()
function scene:show( event )
 
    view.sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        print("register will show")
        -- Code here runs when the scene is still off screen (but is about to come on screen)
 
        -- start timers
        t1 = timer.performWithDelay( 1000, alertHandler, -1 )

    elseif ( phase == "did" ) then
        print("register did show")
        -- Code here runs when the scene is entirely on screen

        -- composer.removeHidden()

    end
end
 
 
-- hide()
function scene:hide( event )
 
    view.sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        print("register will hide")
        -- Code here runs when the scene is on screen (but is about to go off screen)
 
    elseif ( phase == "did" ) then
        print("register did hide")
        -- Code here runs immediately after the scene goes entirely off screen
 
    end
end
 
 
-- destroy()
function scene:destroy( event )

    print("register was destroyed")
 
    view.sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view

    timer.cancel(t1)

    if view.emailField ~= nil then
      display.remove( view.emailField )
      view.emailField = nil
      print("register email removed")
    end

    if view.passwordField1 ~= nil then
      display.remove( view.passwordField1 )
      view.passwordField1 = nil
      print("register password 1 removed")
    end

    if view.passwordField2 ~= nil then
      display.remove( view.passwordField2 )
      view.passwordField2 = nil
      print("register password 2 removed")
    end

    print("destroyed")
end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------
 
return scene