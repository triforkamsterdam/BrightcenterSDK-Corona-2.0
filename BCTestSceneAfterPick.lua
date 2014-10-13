module(..., package.seeall)

local storyboard = require "storyboard"
storyboard.purgeOnSceneChange = true
local widget = require( "widget" )
local scene = storyboard.newScene()
local controller = require("brightcenterController")
local group = {}
local cookieLabel = {}
local studentIdLabel = {}
local firstNameLabel = {}

local brightcenterbutton
local postResultButton
local group

local function callback()
        print(controller.results[1].score .. " " .. controller.results[1].duration)
end

local callbackvar = callback


local function postResult()
    print(controller.postResult(controller.assessmentIdFromUrl, "T", 5, 10, controller.completionStatusCompleted))
    print(controller.postResult(controller.assessmentIdFromUrl, "K", 2, 10, controller.completionStatusIncomplete))
    controller.loadResults(controller.assessmentIdFromUrl, callbackvar)
    print("AssessmentId from url: " .. controller.assessmentIdFromUrl)
end

local function openBCAppWithoutAssessment()
    controller.openBrightcenterApp("")
end


local function openBCApp()
    controller.openBrightcenterApp("987-654-321")
end
local buttonClicked = openBCApp
local postResultButtonClicked = postResult
local loadAppWithoutAssessmentButtonClicked = openBCAppWithoutAssessment


function scene:createScene( event )
    group = self.view
    print("create scene after student select")
    cookieLabel = display.newText("Cookie: ", 200, 200, native.systemFont, 16)
    studentIdLabel = display.newText("StudentId: ", 200, 300, native.systemFont, 16)
    firstNameLabel = display.newText("First Name: ", 200, 400, native.systemFont, 16)

    local brightcenterbutton = widget.newButton{
        label = "Open brightcenter app!",
        emboss = true,
        fontSize = 20,
        onRelease = buttonClicked,
        x = 300,
        y = 600
    }

    local postResultButton = widget.newButton{
        label = "post result",
        emboss = true,
        fontSize = 20,
        onRelease = postResultButtonClicked,
        x = 300,
        y = 700
    }

    local loadWithoutAssessmentButton = widget.newButton{
        label = "load without assessment",
        emboss = true,
        fontSize = 20,
        onRelease = loadAppWithoutAssessmentButtonClicked,
        x = 300,
        y = 800
    }


    cookieLabel:setFillColor( black )
    studentIdLabel:setFillColor( black )
    firstNameLabel:setFillColor( black )
    
    group:insert(cookieLabel)
    group:insert(studentIdLabel)
    group:insert( firstNameLabel )
    group:insert( brightcenterbutton) 
    group:insert( postResultButton)
end
scene:addEventListener( "createScene", scene )

function scene:willEnterScene( event )
    print("will enter scene after student select")
    display.setDefault( "background", 1);
    cookieLabel.text = "cookie: " .. controller.cookie
    studentIdLabel.text = "studentId: " .. controller.student.personId
    firstNameLabel.text = "First Name: " .. controller.student.firstName  	
end
scene:addEventListener( "willEnterScene", scene )

function scene:didExitScene( event )

end
scene:addEventListener( "didExitScene", scene )

return scene
