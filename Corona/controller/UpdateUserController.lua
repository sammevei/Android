local sceneName = RegisterController

-- Include
local view = require("view.UpdateUserView")
local model = require("model.UpdateUserModel")

local composer = require( "composer" )
local widget = require( "widget" )
local appData = require( "misc.appData" )
local utils = require( "misc.luaUtils" )

-- Register Functions
-- email field
local firstNameFieldListener = function(event)
    if ( event.phase == "ended" or event.phase == "submitted" ) then
       
    end
end

-- password field
local middleNameFieldListener = function(event)
    if ( event.phase == "ended" or event.phase == "submitted" ) then

    end
end

-- password field
local lastNameFieldListener = function(event)
    if ( event.phase == "ended" or event.phase == "submitted" ) then

    end
end

-- finishAuth
local userUpdated = function( event )
    print(event.response)

    -- remove fields
    if view.firstNameField ~= nil then
      display.remove( view.firstNameField )
      view.firstNameField = nil
    end

    if view.middleNameField ~= nil then
      display.remove( view.middleNameField )
      view.middleNameField = nil
    end

    if view.lastNameField ~= nil then
      display.remove( view.lastNameField )
      view.lastNameField = nil
    end  

    -- save user data
    -- model.saveUser()

    -- go to next scene
    composer.removeScene("controller.UpdateUserController") 
    composer.gotoScene("controller.PhoneController")
end

-- update user
local updateUser = function( event )
    if ( event.phase == "ended" ) then
        print("updating user")
        model.addNames(view.firstNameField.text, view.middleNameField.text, view.lastNameField.text)

        --prepare data
        local url = "https://api.sammevei.no/api/1/users/current" 

        local headers = {}
        headers["Content-Type"] = "application/x-www-form-urlencoded"
        headers["Authorization"] = "Bearer "..appData.session.accessToken
          
        local params = {}
        params.headers = headers
        params.body = 
            'firstname='..
            utils.urlEncode(appData.user.firstName)..
            '&'..
            'middlename='..
            utils.urlEncode(appData.user.middleName)..
            '&'..
            'lastname='..
            utils.urlEncode(appData.user.lastName)..
            '&'..
            'email='..
            utils.urlEncode(appData.user.eMail)

        -- send request
        network.request( url, "PUT", userUpdated, params)
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

    -- Show Fields
    view.showFields()

    -- Register Button
    view.showUpdateButton()

    -- Add Listeners
    view.firstNameField:addEventListener( "userInput", firstNameFieldListener )
    view.middleNameField:addEventListener( "userInput", middleNameFieldListener )
    view.lastNameField:addEventListener( "userInput", lastNameFieldListener )
    view.updateButton:addEventListener( "touch", updateUser )
end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen

 
    end
end
 
 
-- hide()
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
 
    end
end
 
 
-- destroy()
function scene:destroy( event )
 
    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view

    if view.firstNameField ~= nil then
      display.remove( view.firstNameField )
      view.firstNameField = nil
    end

    if view.middleNameField ~= nil then
      display.remove( view.middleNameField )
      view.middleNameField = nil
    end

    if view.lastNameField ~= nil then
      display.remove( view.lastNameField )
      view.lastNameField = nil
    end        
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