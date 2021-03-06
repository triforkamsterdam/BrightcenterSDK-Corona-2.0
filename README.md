BrightcenterSDK-Corona 2.0
=======================

This SDK makes it easier to communicate with Brightcenter. It uses an appswitch to retrieve the student that is logged in.

###Register your appUrl
When you register or edit an assessment you can change your appUrl. your appUrl needs to be the same as your CFBundleURLSchemes. If you register your appUrl you can generate a test link on: www.brightcenter.nl/dashboard/createSdkUrl . There you can select your app and a student and your link will be generated. If you open this link on a device or simulator your app will be opened.
When the BrightcenterApp is finished it'll open your app in the same way. 

### Download the project
To use this SDK you need to download this project. You'll need to at least include  brightcenterController.lua into your own project by just adding them to your project folder.

### Use the SDK
To use the sdk you need to include the following line of code:
```lua
controller = require("brightcenterController")
```
before you do anything with the controller you should set controller.sceneToGoTo and controller.appUrl.
controller.sceneToGoTo is the scene you want to load after the appswitch is made. controller.appUrl has to be the bundlescheme of your app as seen in your build.settings. IMPORTANT!: you'll need to change your CFBundleURLSchemes to something unique that corresponds to your app, otherwise it won't work.

the controller has everything you need to post results to the server, retrieve students and retrieve results.
If you open the app using the link, the student will automatically be loaded into the controller
You can acces it by using controller.student.firstName for example.

### Get the results of a student
To get the results of a student you can use the following:
```lua
controller.loadResults([assessmentId], [callbackfunction])
```
The callback function is called when the results are finished loading. In this callback or after it you can acces the results by doing the following:

```lua
controller.results[1].score --the score
controller.results[1].questionId -- the id of the question
controller.results[1].attempts --the number of attempts
controller.results[1].duration --the duration in seconds
controller.results[1].completionStatus -- the completion, can either be "COMPLETED" or "INCOMPLETE"
```
Note that also these calls should be made in a callback function.

### Post the result of a student
To post a result of a student you can use the following function:
```lua
controller.postResult(assessmentId, questionId, score, duration, completionStatus)
```
This method returns a string if something went wrong, so you can print the function for error checking.

-`assessmentId` should be a string

-`questionId` should be a string

-`score` should be an integer

-`duration` should be the duration in seconds as an integer

-`completionStatus` should be either "COMPLETED" or "INCOMPLETE", you can use controller.completionStatusComplete and controller.completionStatusIncomplete to make sure you send the right values

###Opening the BrightcenterApp
To add the brightcenter button to your screen, call the following piece of code:
```lua
buttonGroup = controller.createBrightcenterButton(system.orientation, "assessmentId")
```
To handle orientation change you can add the following to your orientation change event:

```lua
if( storyboard.getCurrentSceneName( ) == "REPLACEWITHYOURCURRENTSCENENAME") then
	display.remove( buttonGroup )
	buttonGroup = controller.createBrightcenterButton(e.type, "123-456-789")
end
```
For working examples see the demo code.

###sidenotes

-To use the appswitch add the following to your build.settings:
```
iphone = {
		plist = {
			UIApplicationExitsOnSuspend = false,
			CFBundleURLTypes ={ 
				{
					CFBundleURLSchemes = {
						"yourschemename",
					}
				}
			}
		}
	}
```

-To have internet acces on Android use the following in `build.settings`:
```
settings =
{
   android =
   {
      usesPermissions =
      {
         "android.permission.INTERNET",
      },
   },
}
```

-for questions, create an issue with the issue tracker on www.brightcenter.nl/dashboard

-You can check the other files for examples, the files have a working demo!




