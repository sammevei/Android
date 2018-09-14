local sceneName = LoginEmailController

-- Include
local view = require("view.LoginEmailView")
local model = require("model.LoginEmailModel")

local composer = require( "composer" )
local widget = require( "widget" )
local appData = require( "misc.appData" )
local utils = require( "misc.luaUtils" )

-- Login Functions

-- cancel login
local cancelLogin = function()
    composer.removeScene("controller.LoginEmailController", appData.transitionRightOptions)
    composer.gotoScene("controller.WelcomeController", appData.transitionRightOptions)
end

-- Forgot Pasword
local forgotPassword = function()   
    native.setKeyboardFocus( nil )
    composer.removeScene("controller.LoginEmailController", appData.transitionLeftOptions)
    composer.gotoScene("controller.ForgotPasswordController", appData.transitionLeftOptions)
end

-- email field
local emailFieldListener = function(event)
    if ( event.phase == "ended" or event.phase == "submitted" ) then
       
    end
end

-- password field
local loginPasswordFieldListener = function(event)
    if ( event.phase == "began" ) then
        view.loginPasswordField.isSecure = true
    elseif ( event.phase == "ended" or event.phase == "submitted" ) then

    end
end

-- if login failed
local loginFailed = function()
    -- go back to registration
    -- composer.removeScene("controller.LoginEmailController")
    -- composer.gotoScene("controller.RegisterEmailController")
end


-- finishAuth
local finishAuth = function( event )
    print(event.response)

    local data = appData.json.decode(event.response)
    if data == nil then

        -- show alert
        local alert = native.showAlert( 
            "Error",
            "Login problem. Try again, please", 
            { "OK", "" },
            loginFailed 
            )

        -- composer.removeScene("controller.LoginEmailController")
        -- composer.gotoScene("controller.RegisterEmailController")        
        return true
    end    

    if data.success == false then

        -- show alert
        local alert = native.showAlert( 
            "Error",
            data.message, 
            { "OK", "" },
            loginFailed 
            )

    else
        
        -- store data
        appData.user.id = data.user.id
        appData.user.userID = data.user.user_id
        
        -- store tokens
        appData.session.accessToken = data.token.accessToken
        appData.session.refreshToken = data.token.refreshToken

        -- save refresh token
        model.saveRefreshToken()

        -- go to next scene
        composer.removeScene("controller.LoginEmailController")
        composer.gotoScene("controller.IntroController")
        print("WENT TO INTRO ----------- WENT TO INTRO")
    end    
end

-- loginUser
local loginUser = function( event )


    if ( event.phase == "ended" ) then

      -- hide keyboard
      native.setKeyboardFocus( nil )

      --prepare data
        local url = "https://api.sammevei.no/api/1/auth/login" 

        local headers = {}
        headers["Content-Type"] = "application/x-www-form-urlencoded"
          
        local params = {}
        params.headers = headers
        params.body = 
            'username='..
            utils.urlEncode(view.loginEmailField.text)..
            '&'..
            'password='..
            utils.urlEncode(view.loginPasswordField.text)..
            '&'..
            'permanent=true'

        -- send request
        network.request( url, "POST", finishAuth, params)

        print("logging user!")
    end    
end

-- reggister user
local registerUser = function(event)
    if ( event.phase == "ended" ) then
        native.setKeyboardFocus( nil )
        -- composer.removeScene("controller.LoginEmailController")
        composer.gotoScene("controller.RegisterEmailController")
        return true
    end
end
-- -----------------------------------------------------------------------------------
-- Scene components
-- -----------------------------------------------------------------------------------
local scene = composer.newScene()

-- create()
function scene:create( event )
 
    view.sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
    view.showBackground()
    view.showInfo()
    view.showFields()
    view.showForgot()
    view.showButtons()
end
 
 
-- show()
function scene:show( event )
 
    view.sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
        -- Add Listeners
        view.loginEmailField:addEventListener( "userInput", emailFieldListener )
        view.loginPasswordField:addEventListener( "userInput", loginPasswordFieldListener )
        view.newUserButton:addEventListener( "touch", registerUser )
        view.loginButton:addEventListener( "touch", loginUser )
        view.forgotButton:addEventListener( "tap", forgotPassword )
        view.cancelButton:addEventListener( "tap", cancelLogin )

        
        -- Transitions
        transition.to(view.loginEmailField, 
            {transition=easing.outSine, delay = 350,time = 350, alpha = 1}) 
        transition.to(view.loginEmailField, 
            {transition=easing.outSine, delay = 350,time = 5, x = appData.contentW/2}) 

        transition.to(view.loginPasswordField, 
            {transition=easing.outSine, delay = 350,time = 350, alpha = 1}) 
        transition.to(view.loginPasswordField, 
            {transition=easing.outSine, delay = 350,time = 5, x = appData.contentW/2}) 
        
        transition.to(view.emailFieldBackground, 
            {transition=easing.outSine, delay = 20,time = 50, alpha = 1}) 
        transition.to(view.emailFieldBackground, 
            {transition=easing.outSine, delay = 100,time = 50, x = appData.contentW/2}) 
        
        transition.to(view.passwordFieldBackground1, 
            {transition=easing.outSine, delay = 100,time = 50, alpha = 1}) 
        transition.to(view.passwordFieldBackground1, 
            {transition=easing.outSine, delay = 20,time = 50, x = appData.contentW/2}) 

    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
        composer.removeHidden()
 
    end
end
 
 
-- hide()
function scene:hide( event )
 
    view.sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then

        print("----- login will hide")

        if view.loginEmailField ~= nil then           
            display.remove( view.loginEmailField )
            view.loginEmailField = nil
            print("login email removed")
        end  

        if view.loginPasswordField ~= nil then
          display.remove( view.loginPasswordField )
          view.loginPasswordField = nil
          print("login password removed")
        end 
        -- Code here runs when the scene is on screen (but is about to go off screen)

    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
        print("----- login did hide")
    end
end
 
 
-- destroy()
function scene:destroy( event )
 
    view.sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
        
    view.emailFieldBackground.alpha = 0
    view.passwordFieldBackground1.alpha = 0

    view.emailFieldBackground.x = 3000
    view.passwordFieldBackground1.x = 3000

    if view.loginEmailField ~= nil then           
        display.remove( view.loginEmailField )
        view.loginEmailField = nil
        print("login email removed")
    end  

    if view.loginPasswordField ~= nil then
      display.remove( view.loginPasswordField )
      view.loginPasswordField = nil
      print("login password removed")
    end   

    print("----- login destroyed")
 
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