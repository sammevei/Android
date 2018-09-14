local sceneName = PhoneController

-- Include
local view = require("view.PhoneView")
local model = require("model.PhoneModel")

local composer = require( "composer" )
local widget = require( "widget" )
local appData = require( "misc.appData" )
local utils = require( "misc.luaUtils" )

-- New Variables
local phoneText = ""
-- ------------------------------------------------------------------------ --
-- Alert Listener
local onAlertComplete = function( event )
    if ( event.action == "clicked" ) then
        local i = event.index
        if ( i == 1 ) then
            -- Go to back phone screen
            composer.removeScene("controller.VerifyController") 
            composer.gotoScene("controller.PhoneController")

        elseif ( i == 2 ) then
            -- Do nothing
        end
    end
end

-- Finish verification
local phoneVerified = function( event )
    print("-------- P H O N E V E R I F I E D -------")
    print(event.response)

    local result = appData.json.decode(event.response)

    if result.success == nil then
        local alert = native.showAlert( "", "Internett feil. Prøv igjen, takk!", { "OK", "" }, onAlertComplete )        
        return true
    end    

    if result.success == true then

        -- verify field
        if view.verificationField ~= nil then
          display.remove( view.verificationField )
          view.verificationField = nil
        end

        if view.codeField ~= nil then
          display.remove( view.codeField )
          view.codeField = nil
        end

        -- go to next scene
        composer.removeScene("controller.PhoneController", appData.transitionLeftOptions) 
        composer.gotoScene("controller.PlacesController", appData.transitionLeftOptions)

    else 
        local alert = native.showAlert( "", "Ikke riktig pin. Prøv igjen, takk!", { "OK", "" }, onAlertComplete )        
    end    
end

-- Verify CODE
local verifyPhone = function()

    --prepare data
    local url = "https://api.sammevei.no/api/1/users/current/mobiles/verify" 

    local headers = {}
    headers["Content-Type"] = "application/x-www-form-urlencoded"
    headers["Authorization"] = "Bearer "..appData.session.accessToken
      
    local params = {}
    params.headers = headers
    params.body = 
        'country='..
        utils.urlEncode(appData.user.country)..
        '&'..
        'number='..
        utils.urlEncode(appData.user.phoneNumber)..
        '&'..
        'code='..
        utils.urlEncode(view.codeField.text)

    -- send request
    network.request( url, "PUT", phoneVerified, params)   
end

-- Hndle Submit Button
local codeFieldListener = function(event)
    if ( event.phase == "submitted" ) then
        verifyPhone()  
    end
end


-- -----------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------

-- Phone Number Confirmed
local verificationRequested = function( event )
    print("---------------")
    print(event.response)

    view.infoText.alpha = 0.7
    view.codeBackground.alpha = 1
    view.codeField.alpha = 1
end

-- Send Phone Number
local verifyPhone = function(event)

    local country = "+47"
    local number = view.phoneField.text

    -- store data
    appData.user.country = country
    appData.user.phoneNumber = number

    --prepare data
    local url = "https://api.sammevei.no/api/1/users/current/mobiles" 

    local headers = {}
    headers["Content-Type"] = "application/x-www-form-urlencoded"
    headers["Authorization"] = "Bearer "..appData.session.accessToken
      
    local params = {}
    params.headers = headers
    params.body = 
        'country='..
        utils.urlEncode(country)..
        '&'..
        'number='..
        utils.urlEncode(number)

    -- send request
    network.request( url, "POST", verificationRequested, params)   
end

-- Register Functions
local phoneFieldListener = function(event)
    if ( event.phase == "began") then
        print("began")
        phoneText = ""
        event.target.text = ""
    elseif ( event.phase == "editing" and event.newCharacters  ~= nil) then
        
        if event.newCharacters == "0"
            or event.newCharacters == "1"
            or event.newCharacters == "2"
            or event.newCharacters == "3"
            or event.newCharacters == "4"
            or event.newCharacters == "5"
            or event.newCharacters == "6"
            or event.newCharacters == "7"
            or event.newCharacters == "8"
            or event.newCharacters == "9" then

            phoneText = phoneText .. event.newCharacters 
            event.target.text = phoneText
            print("number")
        else
            phoneText = ""
            event.target.text = ""            
            print("deleting")
        end

    elseif ( event.phase == "editing" and event.newCharacters  == nil) or
        ( event.phase == "editing" and event.newCharacters  == "")then
        phoneText = ""
        event.target.text = ""
        print("no new")
    elseif ( event.phase == "ended" ) then 

    elseif ( event.phase == "submitted" ) then
        verifyPhone()
    end
end

-- -----------------------------------------------------------------------------------
-- Scene components
-- -----------------------------------------------------------------------------------
local scene = composer.newScene()

-- create()
function scene:create( event )
    appData.restart = false
 
    view.sceneGroup = self.view

    -- Show background
    view.showBackground()

    -- Show Fields
    view.showFields()

    -- Add Listeners
    view.phoneField:addEventListener( "userInput", phoneFieldListener )
    view.codeField:addEventListener( "userInput", codeFieldListener )
end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        
        -- Code here runs when the scene is still off screen (but is about to come on screen)
        transition.to(view.phoneFieldBackground, 
            {transition=easing.outSine, delay = 20,time = 50, alpha = 1}) 
        transition.to(view.phoneFieldBackground, 
            {transition=easing.outSine, delay = 100,time = 50, x = appData.contentW/2})         

        transition.to(view.phoneField, 
            {transition=easing.outSine, delay = 350, time = 350, alpha = 1}) 
        transition.to(view.phoneField, 
            {transition=easing.outSine, delay = 350, time = 5, x = appData.contentW/2 + 15})

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

    transition.to(view.phoneFieldBackground, 
        {transition=easing.outSine, delay = 0,time = 5, alpha = 0}) 
    transition.to(view.phoneFieldBackground, 
        {transition=easing.outSine, delay = 0,time = 5, x = 3000})         

    transition.to(view.phoneField, 
        {transition=easing.outSine, delay = 0, time = 5, alpha = 0}) 
    transition.to(view.phoneField, 
        {transition=easing.outSine, delay = 0, time = 5, x = 3000}) 


    if view.phoneField ~= nil then
      display.remove( view.phoneField )
      view.phoneField = nil
    end

    if view.codeField ~= nil then
      display.remove( view.codeField )
      view.codeField = nil
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