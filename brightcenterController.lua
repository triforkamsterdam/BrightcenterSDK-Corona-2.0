--This file gives you the possibility to connect with Brightcenter. It uses an appswitch to login a student.
--for testing purposes you can also generate a link on www.brightcenter.nl/dashboard/createSdkUrl
--before calling functions on this controller make sure you have set the controller.sceneToGoTo and the controller.appUrl
local controller = {}

local storyboard = require "storyboard"
local mime=require("mime")
local json = require("json")
local baseUrl = "http://www.brightcenter.nl/dashboard/api"

controller.cookie = ""
controller.student = {}
controller.results = {}
controller.student.personId = ""
controller.student.firstName = ""
controller.student.lastName = ""
controller.sceneToGoTo = ""
controller.appUrl = ""

controller.completionStatusCompleted = "COMPLETED"
controller.completionStatusIncomplete = "INCOMPLETE"

--this function extracts the student from the incoming url
local function getStudentFromUrl(url)
	local data = string.gsub( url, ".*//data/", "")
	data = string.gsub( data, "/cookie/.*", "")
	data = mime.unb64(data)
	data = json.decode(data)
	return data
end

--This function extracts the cookie from the incoming url
local function getCookieFromUrl(url)
	local cookie = url 
	cookie = string.gsub(cookie, ".*://data/.*/cookie/", "")
	return cookie
end

--this function opens the brightcenter app
local function openBrightcenterApp()
	if(controller.appUrl == "") then
		return "Error: AppUrl cannot be empty"
	end
	system.openURL( "brightcenterApp://protocolName/" .. controller.appUrl )
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
		local student = controller.getStudentFromUrl(event.url)
		local cookie = controller.getCookieFromUrl(event.url)
		controller.cookie = cookie
		controller.student = student	
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

return controller