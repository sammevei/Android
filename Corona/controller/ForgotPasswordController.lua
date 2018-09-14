local sceneName = ForgotPasswordController

-- Include
local view = require("view.ForgotPasswordView")
local model = require("model.ForgotPasswordModel")

local composer = require( "composer" )
local widget = require( "widget" )
local appData = require( "misc.appData" )
local utils = require( "misc.luaUtils" )

local cancel = function()
    composer.removeScene("controller.ForgotPasswordController", appData.transitionRightOptions)
    composer.gotoScene("controller.LoginEmailController", appData.transitionRightOptions)
end


local finishNewPassword = function(event)
    print("password------------password")
    print(event.response)
    local data = appData.json.decode(event.response)
    composer.removeScene("controller.ForgotPasswordController", appData.transitionRightOptions)
    composer.gotoScene("controller.LoginEmailController", appData.transitionRightOptions)
end

local newPassword = function()

    if view.passwordField1.text == view.passwordField2.text 
    and view.passwordField1.text ~= nil
    and view.passwordField1.text ~= ""    
    then

        --prepare data
        local url = "https://api.sammevei.no/api/1/auth/reset" 

        local headers = {}
        headers["Content-Type"] = "application/x-www-form-urlencoded"
           
        local params = {}
        params.headers = headers
        params.body = 'username='..utils.urlEncode(view.emailField.text)
            ..'&pin='..utils.urlEncode(view.pinField.text) 
            ..'&password='..utils.urlEncode(view.passwordField1.text) 

        -- send request
        network.request( url, "POST", finishNewPassword, params)

        print("submitting new password!")
    else
        print("not there yet")
        --[[  
        -- show alert
        local alert = native.showAlert( 
            "Error",
            "Passwords don't match. Try again, please", 
            { "OK", "" }
            ) 
        --]]         
    end    
end    


-- email field
local passwordField1Listener = function(event)
    if ( event.phase == "ended" or event.phase == "submitted" ) then
        -- newPassword()
    end
end

local passwordField2Listener = function(event)
    if ( event.phase == "ended" or event.phase == "submitted" ) then
        -- newPassword()
    end
end


-- --------------------------------------------------------------------------------- --

local finishPin = function( event )
    print("pin------------pin")
    print(event.response)
    local data = appData.json.decode(event.response)

    if data == nil then

        -- show alert
        local alert = native.showAlert( 
            "",
            "Ooops... det synes å være et problem med forbindelsen din. ".. 
            "Vi kunne ikke koble deg til våre servere. ".. 
            "Vennligst sjekk innstillinger din.",
            { "OK", "" }
            )

        return true
    end     

    if data.success == true then 
        view.passwordFieldBackground1.x = appData.contentW/2
        view.passwordField1.x = appData.contentW/2 
        view.passwordFieldBackground1.alpha = 1
        view.passwordField1.alpha = 1 

        view.passwordFieldBackground2.x = appData.contentW/2
        view.passwordField2.x = appData.contentW/2 
        view.passwordFieldBackground2.alpha = 1
        view.passwordField2.alpha = 1 

        view.updateButton.alpha = 1

        view.instructionsText.alpha = 0

        view.pinField.x = 3000
        view.pinFieldBackground.x = 3000
    end       
end


local fillPin = function()

    --prepare data
    local url = "https://api.sammevei.no/api/1/auth/verify" 

    local headers = {}
    headers["Content-Type"] = "application/x-www-form-urlencoded"
       
    local params = {}
    params.headers = headers
    params.body = 'username='..utils.urlEncode(view.emailField.text)
        ..'&pin='..utils.urlEncode(view.pinField.text) 

    
    -- send request
    network.request( url, "PUT", finishPin, params)

    -- make PIN field visible
    view.pinFieldBackground.alpha = 1
    view.pinField.alpha = 1
    view.instructionsText.alpha = 1

    print("submitting pin!") 

end

-- email field
local pinFieldListener = function(event)
    if ( event.phase == "ended" or event.phase == "submitted" ) then
        fillPin()
    end
end

-- finish password restore -------------------------------------------------------------
local finishPasswordRestore = function( event )
    print(event.response)

    local data = appData.json.decode(event.response)
    if data == nil then

        -- show alert
        local alert = native.showAlert( 
            "",
            "Ooops... det synes å være et problem med forbindelsen din. ".. 
            "Vi kunne ikke koble deg til våre servere. ".. 
            "Vennligst sjekk innstillinger din.",
            { "OK", "" }
            )

        composer.removeScene("controller.ForgotPasswordController")
        composer.gotoScene("controller.RegisterEmailController")        
        return true
    end       
end

-- request password restore
local requestPasswordRestore = function()

      --prepare data
        local url = "https://api.sammevei.no/api/1/auth/restore" 

        local headers = {}
        headers["Content-Type"] = "application/x-www-form-urlencoded"
        headers["Authorization"] = "Bearer "..appData.session.accessToken
          
          
        local params = {}
        params.headers = headers
        params.body = 'username='..utils.urlEncode(view.emailField.text)
        
        -- send request
        network.request( url, "POST", finishPasswordRestore, params)

        -- make PIN field visible
        view.pinFieldBackground.alpha = 1
        view.pinField.alpha = 1
        view.instructionsText.alpha = 1

        print("requesting password restore!")   
end

-- email field
local emailFieldListener = function(event)
    if ( event.phase == "ended" or event.phase == "submitted" ) then
        requestPasswordRestore()
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
    view.showButtons()

    print("FORGOT CREATED")
end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
 
        -- Add Listeners
        view.emailField:addEventListener( "userInput", emailFieldListener )
        view.pinField:addEventListener( "userInput", pinFieldListener )
        view.passwordField1:addEventListener( "userInput", passwordField1Listener )
        view.passwordField2:addEventListener( "userInput", passwordField2Listener )
        view.cancelButton:addEventListener( "tap", cancel )
        view.updateButton:addEventListener( "tap", newPassword )

        print("FORGOT WILL SHOW")

    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
        composer.removeHidden()
 
    end
end
 
 
-- hide()
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
        print("FORGOT WILL HIDE")   
 
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen

        if view.emailField ~= nil then
          display.remove( view.emailField )
          view.emailField = nil
          print("forgot email removed")
        end

        if view.pinField ~= nil then
          display.remove( view.pinField )
          view.pinField = nil
          print("forgot pin removed")
        end 

        if view.passwordField1 ~= nil then
          display.remove( view.passwordField1 )
          view.passwordField1 = nil
          print("forgot password 1 removed")
        end  

        if view.passwordField2 ~= nil then
          display.remove( view.passwordField2 )
          view.passwordField2 = nil
          print("forgot password 2 removed")
        end  

        print("FORGOT DID HIDE")      
 
    end
end
 
 
-- destroy()
function scene:destroy( event )
 
    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view

        if view.emailField ~= nil then
          display.remove( view.emailField )
          view.emailField = nil
          print("forgot email removed")
        end

        if view.pinField ~= nil then
          display.remove( view.pinField )
          view.pinField = nil
          print("forgot pin removed")
        end 

        if view.passwordField1 ~= nil then
          display.remove( view.passwordField1 )
          view.passwordField1 = nil
          print("forgot password 1 removed")
        end 

        if view.passwordField2 ~= nil then
          display.remove( view.passwordField2 )
          view.passwordField2 = nil
          print("forgot password 2 removed")
        end 

        print("FORGOT DESTROYED")
 
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