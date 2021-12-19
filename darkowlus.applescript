## @file darkowlus.applescript
## Automatically darkens macOS appearance and desktop picture in the nighttime.
## To create an application from this script, open this script in Script-Editor,
## set your location, and export the modified script as stay-open application.
## @author Ralf Quast
## @date 2021
## @copyright GPL
global myLocation, myDir, initialized, darkened, dawnTime, duskTime

on run
	set myLocation to "53.3 10.0" -- Hamburg, Germany
	set dawnTime to "07:00:00"
	set duskTime to "19:00:00"
	
	tell application "Finder"
		set myDir to POSIX path of (container of (path to me) as alias)
	end tell
	
	set initialized to false
	set darkened to false
end run

on idle
	try
		set duskTime to do shell script myDir & "dusk " & myLocation
		set dawnTime to do shell script myDir & "dawn " & myLocation
	on error
		-- ignore, use previous dusk and dawn times
	end try
	
	set dusk to date duskTime
	set dawn to date dawnTime
	set now to current date
	
	if (now comes after dawn) and (now comes before dusk) then
		if darkened or not initialized then
			set initialized to true
			tell application "System Events"
				tell appearance preferences
					set dark mode to false
				end tell
			end tell
			tell application "Finder"
				try
					set desktop picture to POSIX file (myDir & "Daytime.jpg")
				end try
			end tell
			set darkened to false
		end if
	else
		if not darkened or not initialized then
			set initialized to true
			tell application "System Events"
				tell appearance preferences
					set dark mode to true
				end tell
			end tell
			tell application "Finder"
				try
					set desktop picture to POSIX file (myDir & "Nighttime.jpg")
				end try
			end tell
			set darkened to true
		end if
	end if
	return 600 -- no matter what, simply wait 10 minutes
end idle

on quit
	continue quit
end quit
