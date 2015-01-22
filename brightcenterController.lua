--This file gives you the possibility to connect with Brightcenter. It uses an appswitch to login a student.
--for testing purposes you can also generate a link on www.brightcenter.nl/dashboard/createSdkUrl
--before calling functions on this controller make sure you have set the controller.sceneToGoTo and the controller.appUrl
local controller = {}

local storyboard = require "storyboard"
local mime=require("mime")
local json = require("json")
local widget = require( "widget" )
local baseUrl = "https://www.brightcenter.nl/dashboard/api"

controller.cookie = ""
controller.student = {}
controller.results = {}
controller.student.personId = ""
controller.student.firstName = ""
controller.student.lastName = ""
controller.sceneToGoTo = ""
controller.appUrl = ""
controller.assessmentIdFromUrl = ""

controller.completionStatusCompleted = "COMPLETED"
controller.completionStatusIncomplete = "INCOMPLETE"

local function handleUrl(url)
	controller.cookie = controller.getCookieFromUrl(url)
	controller.student = controller.getStudentFromUrl(url)
	controller.assessmentIdFromUrl = controller.getAssessmentIdFromUrl(url)	
end


--this function extracts the student from the incoming url
local function getStudentFromUrl(url)
	local data = string.gsub( url, ".*data=", "")
	data = string.gsub( data, "&cookie=.*", "")
	data = string.gsub(data, "*", "=")
	data = mime.unb64(data)
	data = json.decode(data)
	print( "student: " .. data.firstName .. " " .. data.lastName )
	return data
end

--This function extracts the cookie from the incoming url
local function getCookieFromUrl(url)
	local cookie = url 
	cookie = string.gsub(cookie, ".*&cookie=", "")
	cookie = string.gsub(cookie, "&assessmentId.*", "")
	print("cookie: " .. cookie)
	return cookie
end

local function getAssessmentIdFromUrl(url)
	local assessmentId = string.gsub(url, ".*&assessmentId=", "")
	print("assessmentId: " .. assessmentId)
	return assessmentId
end

--this function opens the brightcenter app
local function openBrightcenterApp(assessmentId)
	if(controller.appUrl == "") then
		return "Error: AppUrl cannot be empty"
	end
	if(assessmentId == nil)then
		assessmentId = ""
	end
	system.openURL( "brightcenterApp://?protocolName=" .. controller.appUrl .. "&assessmentId=" .. assessmentId  )
end

--creates an brightcenterbutton
function createBrightcenterButton(orientation, assessmentId)
	local posX = 0
	local posY = 0
	local x = 0
	local y = 0
	if(orientation == "landscapeLeft") then
		x = display.contentWidth - 25
		y = 50
		posX = display.contentWidth - 55
		posY = 55
	end

	if(orientation == "landscapeRight") then
		x = 25
		y = display.contentHeight
		posX = 55
		posY = display.contentHeight - 55
	end

	if(orientation == "portrait") then
		x = display.contentWidth - 25
		y = display.contentHeight
		posX = display.contentWidth - 55
		posY = display.contentHeight - 55
	end

	if(orientation == "portraitUpsideDown") then
		x = 25
		y = 55
		posX = 55 
		posY = 55
	end

	local function action()
		controller.openBrightcenterApp(assessmentId)
	end
	local buttonGroup = display.newGroup()
	local button = widget.newButton{
		label = "",
		x = x,
		y = y,
		shape = "roundedRect",
		width = 240,
		height = 240,
		cornerRadius = 120,
		fillColor = { default={ 1, 1, 1, 0.01 }, over={ 1, 0.1, 0.7, 0 } },
		onEvent = action
	}

	local outerCircle = display.newCircle( x, y - 25, 120 )
	outerCircle:setFillColor( 1 )
	local circle = display.newCircle( posX, posY, 40 )
	circle:setFillColor( 244 / 255, 126 / 255, 43 / 255)
	local circle1 = display.newCircle( posX, posY, 30 )
	circle1:setFillColor( 1 )
	local circle2 = display.newCircle( posX, posY, 20 )
	circle2:setFillColor( 244 / 255, 126 / 255, 0.43 / 255 )
	local circle3 = display.newCircle( posX, posY, 10 )
	circle3:setFillColor( 1 )
	buttonGroup:insert(outerCircle)
	buttonGroup:insert(circle)
	buttonGroup:insert(circle1)
	buttonGroup:insert(circle2)
	buttonGroup:insert(circle3)
	buttonGroup:insert(button)
	return buttonGroup
end


--This function can be used to post a result using a cookie
local function postResult(assessmentId, questionId, score, duration, completionStatus)
	if(controller.cookie == "") then
		return "error: cookie cannot be nil, are you sure a student is picked"
	end
	if(score == nil) then
		return "error: value score cannot be nil"
	end
	if(duration == nil) then
		return "error: value duration cannot be nil"
	end
	if (completionStatus == nil) then
		return "error: value completionStatus cannot be nil"
	end
	if(assessmentId == nil) then
		return "error: value assessmentId cannot be nil"
	end
	if(controller.student.personId == nil) then
		return "error: value studentId cannot be nil, are you sure a student is picked?"
	end
	if (questionId == nil) then
		return "error: value questionId cannot be nil"
	end
	
	--callback: print response, only prints when there is a error
	function networkLisenerPostResult(event)
		print(event.response)
	end

	--set the right headers
	local headers = {}
	headers["Content-Type"] = "application/json"
	headers["Cookie"] = "JSESSIONID=" .. controller.cookie

	--set the params
	local params = {}
	params.headers = headers

	--encode values to json
	local jsonTable = {}
	jsonTable["score"] = score
	jsonTable["duration"] = duration
	jsonTable["completionStatus"] = completionStatus
	local encodedTable = json.encode(jsonTable)
	params.body = encodedTable

	--network call
	local resultUrl = baseUrl .. "/assessment/" .. assessmentId .. "/student/" .. controller.student.personId .. "/assessmentItemResult/" .. questionId
	network.request( resultUrl, "POST", networkLisenerPostResult, params)

end

--[[
Loads the results of a student for an assessment and puts them in a global variable called results
--]]
function loadResults(assessmentId, customCallBack)
	--callback: gets the results and puts them in a variable.
	function networkListenerGetResults(event)
		if ( event.isError ) then
			print "something went wrong with fetching the results"
		else
			local string = json.decode(event.response)
			controller.results = string
			customCallBack()
		end
	end
	--set the headers
	local headers = {}
	headers["Cookie"] = "JSESSIONID=" .. controller.cookie

	--set the params
	local params = {}
	params.headers = headers

	--network call
	local resultUrl = baseUrl .. "/assessment/" .. assessmentId .. "/students/" .. controller.student.personId .. "/assessmentItemResult"
	network.request( resultUrl, "GET", networkListenerGetResults, params)
end

--register for a systemevent when the application is launched it sets all the variables needed to use the controller
local function onSystemEvent( event )
	if event.type == "applicationOpen" and event.url then
		handleUrl(event.url)
		storyboard.gotoScene(controller.sceneToGoTo)
	end
end
Runtime:addEventListener( "system", onSystemEvent )

--create tables for the functions
controller.getStudentFromUrl = getStudentFromUrl
controller.openBrightcenterApp = openBrightcenterApp
controller.postResult = postResult
controller.getCookieFromUrl = getCookieFromUrl
controller.loadResults = loadResults
controller.getAssessmentIdFromUrl = getAssessmentIdFromUrl
controller.createBrightcenterButton = createBrightcenterButton
controller.handleUrl = handleUrl

return controller