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

function setStudentLabels(student)
	firstNameText.text = student.firstName
	lastNameText.text = student.lastName
	idText.text = student.personId
end



local function openBCApp()
	controller.openBrightcenterApp("987-654-321")
end
local brightcenterBeforeSequence = openBCApp
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

function scene:createScene( event )
   local group = self.view
--   if connector.username ~= nil then
--   		print( "create screen!" .. connector.username )
--   end

end
scene:addEventListener( "createScene", scene )

function scene:willEnterScene( event )
  	group = self.view
  	createStudentLabels(group)

  	display.setDefault( "background", 1);
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

	group:insert(brightcenterbutton)
	group:insert(postResultButton)

 	print("will enter!")
end
scene:addEventListener( "willEnterScene", scene )

function scene:didExitScene( event )
	print( "did exit scene" )
	storyboard.purgeScene( "BCTestScene" )
end
scene:addEventListener( "didExitScene", scene )

return scene
