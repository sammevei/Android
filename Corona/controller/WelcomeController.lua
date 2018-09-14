local sceneName = LoginEmailController

-- Include
local view = require("view.WelcomeView")
local model = require("model.WelcomeModel")

local composer = require( "composer" )
local widget = require( "widget" )
local appData = require( "misc.appData" )
local utils = require( "misc.luaUtils" )

-- Functions
-- Register Functions
local openPrivacy = function()
    system.openURL( "http://www.sammevei.no/privacy/" )
end    

local openTOS = function()
    system.openURL( "http://www.sammevei.no/terms/" )
end 

local clicked = false
local loginUser = function()
    print("going to login 1")
    if clicked == false then
        print("going to login 2")
        clicked = true
        composer.removeScene("controller.WelcomeController", appData.transitionOptions)
        composer.gotoScene("controller.LoginEmailController", appData.transitionOptions) 
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
    composer.removeScene("controller.LoginEmailController")
end
 
 
-- show()
function scene:show( event )
 
    view.sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        composer.removeScene("controller.LoginEmailController")
        -- Code here runs when the scene is still off screen (but is about to come on screen)
        view.showBackground()
        view.showInfo()
        -- view.showFields()
        -- view.showForgot()
        view.showButtons()
        view.showTOS()
        view.showFooter()
        view.showInstructions()

        -- Add Listeners
        --[[
        view.loginEmailField:addEventListener( "userInput", emailFieldListener )
        view.loginPasswordField:addEventListener( "userInput", loginPasswordFieldListener )
        view.newUserButton:addEventListener( "touch", registerUser )
        view.loginButton:addEventListener( "touch", loginUser )
        view.forgotButton:addEventListener( "tap", forgotPassword )
        --]]

        view.emailLogin:addEventListener( "tap", loginUser )
        view.button1:addEventListener( "tap", openTOS ) 
        view.button2:addEventListener( "tap", openPrivacy )

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
    --[[
        if view.loginEmailField ~= nil then           
            display.remove( view.loginEmailField )
            view.loginEmailField = nil
            print("email removed")
        end  

        if view.loginPasswordField ~= nil then
          display.remove( view.loginPasswordField )
          view.loginPasswordField = nil
          print("password removed")
        end
    --]]         
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