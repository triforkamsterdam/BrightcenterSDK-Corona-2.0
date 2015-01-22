module(..., package.seeall)

local storyboard = require "storyboard"
storyboard.purgeOnSceneChange = true
local widget = require( "widget" )
local scene = storyboard.newScene()
local controller = require("brightcenterController")
local group = {}
local firstNameText = {}
local lastNameText = {}
local idText = {}
local buttonGroup = {}

local brightcenterbutton
local postResultButton

function createStudentLabels(group)
	firstNameText = display.newText("First name", 200, 200, native.systemFont, 16)
	lastNameText = display.newText("Last name", 300, 200, native.systemFont, 16)
	idText = display.newText("person Id", 500, 200, native.systemFont, 16)
	
	firstNameText:setFillColor( black )
	lastNameText:setFillColor( black )
	idText:setFillColor( black )

	group:insert(firstNameText)
	group:insert(lastNameText)
	group:insert(idText)
end

local function openBCApp()
	print("openeing")
	controller.openBrightcenterApp("987-654-321")
end
local brightcenterBeforeSequence = openBCApp

local function onOrientationChange(e)

	if( storyboard.getCurrentSceneName( ) == "BCTestScene") then
		print( "orientation changed " .. e.type)
		print( display.actualContentHeight )
		print( display.actualContentWidth )
		display.remove( buttonGroup )
		buttonGroup = controller.createBrightcenterButton(e.type, "123-456-789")
	end
end

Runtime:addEventListener( "orientation", onOrientationChange )

function setStudentLabels(student)
	firstNameText.text = student.firstName
	lastNameText.text = student.lastName
	idText.text = student.personId
end

local postResult = controller.postResult

controller.sceneToGoTo = "BCTestSceneAfterPick"
controller.appUrl = "brightcenterAppClientCorona"


local function handlePostButtonEvent(event)
	if("ended" == event.phase) then
		print("enter scene2")
		local options =
						{
						    effect = "slideLeft",
						    time = 500,
						}
		storyboard.gotoScene("BCTestSceneAfterPick",  options)
	
	end
end

local function handleUrlTestEvent(event)
	print("handleurl")
	if("ended" == event.phase) then
		print("handle url:")
		controller.handleUrl("testapp://?data=eyJsYXN0TmFtZSI6IkJvbm5pPz9yPz8/Pz8/P1x1MDA5OT9cdTAwOTc/XHUwMDkzPz8/Pz8/Pz8/Pz9cdTAwOTM/Pz9cdTAwOERvIiwicGVyc29uSWQiOiI1MmIzMGI0YjMwMDQ3Y2Y5ZGVkOThjNzUiLCJmaXJzdE5hbWUiOiJNYXgifQ**&cookie=50B8AEB465A7A87FA696A1D53B7ECD94&assessmentId=a0f6c519-8bdc-4345-9443-0b22ecfc3809 ")
	end
end

function scene:createScene( event )
   local group = self.view
--   if connector.username ~= nil then
--   		print( "create screen!" .. connector.username )
--   end

end
scene:addEventListener( "createScene", scene )

function scene:willEnterScene( event )
	display.setStatusBar( display.HiddenStatusBar )
	display.setDefault("background", 0.5, 0.5, 0.5)
  	group = self.view
  	createStudentLabels(group)
  	buttonGroup = controller.createBrightcenterButton(system.orientation, "123-456-789")

   	brightcenterbutton = widget.newButton{
		label = "Open brightcenter app!",
		emboss = true,
		fontSize = 20,
		onRelease = brightcenterBeforeSequence,
		x = 300,
		y = 300
	}

	postResultButton = widget.newButton{
		label = "next Scene",
		emboss = true,
		fontSize = 20,
		onEvent = handlePostButtonEvent,
		x = 300,
		y = 500
	}

	postResultButton = widget.newButton{
		label = "handle url test",
		emboss = true,
		fontSize = 20,
		onEvent = handleUrlTestEvent,
		x = 300,
		y = 600
	}

	group:insert(brightcenterbutton)
	group:insert(postResultButton)

 	print("will enter!")
end
scene:addEventListener( "willEnterScene", scene )

function scene:didExitScene( event )
	print( "did exit scene" )
	storyboard.purgeScene( "BCTestScene" )
	display.remove( buttonGroup )
end
scene:addEventListener( "didExitScene", scene )

return scene
