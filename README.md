BrightcenterSDK-Corona 2.0
=======================

This SDK makes it easier to communicate with Brightcenter. It uses an appswitch to retrieve the student that is logged in. developers can use www.brightcenter.nl/dashboard/createSdkUrl to create a test link. If you open the generated link in your browser, your app will be openened.
When the BrightcenterApp is finishid it'll open your app in the same way. 

### Download the project
To use this SDK you need to download this project. You'll need to at least include  brightcenterController.lua into your own project by just adding them to your project folder.

### Use the SDK
To use the sdk you need to include the following line of code:
```lua
controller = require("brightcenterController")
```
before you do anything with the controller you should set controller.sceneToGoTo and controller.appUrl.
controller.sceneToGoTo is the scene you want to load after the appswitch is made. controller.appUrl has to be the bundlescheme of your app as seen in your build.settings. IMPORTANT!: you'll need to change your CFBundleURLSchemes to something unique that corresponds to your app, otherwise it won't work.

the controller has everything you need to post results to the server and retrieve students
If you open the app using the link, the student will automatically be loaded into the controller
You can acces it by using controller.student.firstName for example.

### Get the results of a student
To get the results of a student you can use the following:
```lua
controller.loadResults([assessmentId], [callbackfunction])
```

to acces the results you can use the following:
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

-`completionStatus` should be either "COMPLETED" or "INCOMPLETE"

###sidenotes

-To use the appswitch add the following to your build.settings:
```
iphone = {
		plist = {
			UIApplicationExitsOnSuspend = false,
			CFBundleURLTypes ={ 
				{
					CFBundleURLSchemes = {
						"brightcenterAppClientCorona",
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




