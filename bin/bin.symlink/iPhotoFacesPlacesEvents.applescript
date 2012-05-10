property mainLanguage : "de"
property faceDB : "sqlite3 ~/Pictures/iPhoto\\ Library/face.db "
property iPhotoMainDB : "sqlite3 ~/Pictures/iPhoto\\ Library/iPhotoMain.db "
property two32 : 2 ^ 32

tell application id "com.apple.iphoto"
	set input to selection
	
	repeat with currentPhoto in input
		return my getFaces(currentPhoto)
	end repeat
end tell

on getFaces(thePhoto)
	tell application id "com.apple.iphoto"
		if (class of thePhoto = photo) then
			set photoID to ((id of thePhoto) - two32) as integer
		else
			return missing value
		end if
	end tell
	
	--unused key_image_key and face positioning
	set faces to do shell script faceDB & "'SELECT fc.name, fc.full_name, fc.email, fc.key_image_key, det.topLeftX, det.topLeftY, det.topRightX, det.topRightY, det.bottomLeftX, det.bottomLeftY, det.bottomRightX, det.bottomRightY FROM face_name AS fc LEFT JOIN detected_face AS det ON fc.face_key = det.face_key WHERE det.image_key = " & photoID & ";'"
	set faces to every paragraph in faces
	
	set resultRecord to {}
	
	repeat with currentFace in faces
		set AppleScript's text item delimiters to "|"
		set temp to every text item in currentFace
		set AppleScript's text item delimiters to ""
		
		set tempRecord to {faceName:_testEmpty(item 1 in temp), fullName:_testEmpty(item 2 in temp), eMail:_testEmpty(item 3 in temp)}
		
		--eliminate unnamed faces
		if (faceName in tempRecord ­ missing value) then
			set end of resultRecord to tempRecord
		end if
	end repeat
	
	return resultRecord
end getFaces

on getEventFromPhoto(thePhoto)
	tell application id "com.apple.iphoto"
		if (class of thePhoto = photo) then
			set photoID to ((id of thePhoto) - two32) as integer
		else
			return missing value
		end if
	end tell
	
	return do shell script iPhotoMainDB & "'SELECT event FROM SqPhotoInfo WHERE primaryKey = " & photoID & ";'"
end getEventFromPhoto

on getPhotosFromEvent(theEvent)
	set idList to do shell script iPhotoMainDB & "'SELECT primaryKey FROM SqPhotoInfo WHERE event = " & theEvent & ";'"
	set idList to every paragraph in idList
	set photoList to {}
	
	tell application id "com.apple.iphoto"
		repeat with currentID in idList
			set end of photoList to photo id (currentID + two32)
		end repeat
	end tell
	return photoList
	
end getPhotosFromEvent

on getInfoForEvent(theEvent)
	set resultRecord to {keyPhoto:missing value, eventName:missing value, comment:missing value}
	set infos to do shell script iPhotoMainDB & "'SELECT keyPhotoKey, name, comment FROM SqEvent WHERE primaryKey = " & theEvent & ";'"
	
	set AppleScript's text item delimiters to "|"
	set infos to every text item in infos
	set AppleScript's text item delimiters to ""
	
	set keyPhoto in resultRecord to my _testEmpty(item 1 in infos)
	set eventName in resultRecord to my _testEmpty(item 2 in infos)
	set comment in resultRecord to my _testEmpty(item 3 in infos)
	
	tell application id "com.apple.iphoto"
		set keyPhoto in resultRecord to photo id ((keyPhoto in resultRecord) + two32)
	end tell
	
	return resultRecord
end getInfoForEvent

on getGPSForPhoto(thePhoto)
	tell application id "com.apple.iphoto"
		if (class of thePhoto = photo) then
			set photoID to ((id of thePhoto) - two32) as integer
		else
			return missing value
		end if
	end tell
	
	set resultRecord to {latitude:missing value, longitude:missing value}
	set gpsLocation to do shell script iPhotoMainDB & "'SELECT gpsLatitude, gpsLongitude FROM SqPhotoInfo WHERE primaryKey = " & photoID & ";'"
	
	set AppleScript's text item delimiters to "|"
	set gpsLocation to every text item in gpsLocation
	set AppleScript's text item delimiters to ""
	
	set latitude in resultRecord to my _string2Real(item 1 in gpsLocation)
	set longitude in resultRecord to my _string2Real(item 2 in gpsLocation)
	
	return resultRecord
end getGPSForPhoto

on getGPSForEvent(theEvent)
	set resultRecord to {latitude:missing value, longitude:missing value}
	set gpsLocation to do shell script iPhotoMainDB & "'SELECT locationLatitude, locationLongitude FROM SqEvent WHERE primaryKey = " & theEvent & ";'"
	
	set AppleScript's text item delimiters to "|"
	set gpsLocation to every text item in gpsLocation
	set AppleScript's text item delimiters to ""
	
	set latitude in resultRecord to my _string2Real(item 1 in gpsLocation)
	set longitude in resultRecord to my _string2Real(item 2 in gpsLocation)
	
	return resultRecord
end getGPSForEvent

on getCustomPlaceForPhoto(thePhoto)
	tell application id "com.apple.iphoto"
		if (class of thePhoto = photo) then
			set photoID to ((id of thePhoto) - two32) as integer
		else
			return missing value
		end if
	end tell
	
	set resultRecord to {latitude:missing value, longitude:missing value, placeName:missing value, placeDescription:missing value}
	set customPlace to do shell script iPhotoMainDB & "'SELECT up.latitude, up.longitude, up.name, up.description FROM SqUserPlace AS up LEFT JOIN SqPhotoInfo AS pi ON up.primaryKey = pi.namedPlace WHERE pi.primaryKey = " & photoID & ";'"
	
	if (customPlace = "") then
		return resultRecord
	end if
	
	set AppleScript's text item delimiters to "|"
	set customPlace to every text item in customPlace
	set AppleScript's text item delimiters to ""
	
	set latitude in resultRecord to my _string2Real(item 1 in customPlace)
	set longitude in resultRecord to my _string2Real(item 2 in customPlace)
	set placeName in resultRecord to my _testEmpty(item 3 in customPlace)
	set placeDescription in resultRecord to my _testEmpty(item 4 in customPlace)
	
	return resultRecord
end getCustomPlaceForPhoto

on getCustomPlaceForEvent(theEvent)
	set resultRecord to {latitude:missing value, longitude:missing value, placeName:missing value, placeDescription:missing value}
	set customPlace to do shell script iPhotoMainDB & "'SELECT up.latitude, up.longitude, up.name, up.description FROM SqUserPlace AS up LEFT JOIN SqEvent AS e ON up.primaryKey = e.namedPlace WHERE e.primaryKey = " & theEvent & ";'"
	
	if (customPlace = "") then
		return resultRecord
	end if
	
	set AppleScript's text item delimiters to "|"
	set customPlace to every text item in customPlace
	set AppleScript's text item delimiters to ""
	
	set latitude in resultRecord to my _string2Real(item 1 in customPlace)
	set longitude in resultRecord to my _string2Real(item 2 in customPlace)
	set placeName in resultRecord to my _testEmpty(item 3 in customPlace)
	set placeDescription in resultRecord to my _testEmpty(item 4 in customPlace)
	
	return resultRecord
end getCustomPlaceForEvent

on getLocationForPhoto(thePhoto)
	tell application id "com.apple.iphoto"
		if (class of thePhoto = photo) then
			set photoID to ((id of thePhoto) - two32) as integer
		else
			return missing value
		end if
	end tell
	
	set lang to mainLanguage
	set resultRecord to {ocean:missing value, country:missing value, province:missing value, county:missing value, city:missing value, neighborhood:missing value, aoi:missing value, poi:missing value}
	set theLocation to do shell script iPhotoMainDB & "'SELECT pn1.string, pn2.string, pn3.string, pn4.string, pn5.string, pn6.string, pn7.string, pn8.string FROM SqPhotoInfo AS pi LEFT JOIN SqPlaceName AS pn1 ON pi.ocean = pn1.place AND pn1.language = \"" & lang & "\" LEFT JOIN SqPlaceName AS pn2 ON pi.country = pn2.place AND pn2.language = \"" & lang & "\" LEFT JOIN SqPlaceName AS pn3 ON pi.province = pn3.place AND pn3.language = \"" & lang & "\" LEFT JOIN SqPlaceName AS pn4 ON pi.county = pn4.place AND pn4.language = \"" & lang & "\" LEFT JOIN SqPlaceName AS pn5 ON pi.city = pn5.place AND pn5.language = \"" & lang & "\" LEFT JOIN SqPlaceName AS pn6 ON pi.neighborhood = pn6.place AND pn6.language = \"" & lang & "\" LEFT JOIN SqPlaceName AS pn7 ON pi.aoi = pn7.place AND pn7.language = \"" & lang & "\" LEFT JOIN SqPlaceName AS pn8 ON pi.poi = pn8.place AND pn8.language = \"" & lang & "\" WHERE pi.primaryKey = " & photoID & " LIMIT 1;'"
	
	set AppleScript's text item delimiters to "|"
	set theLocation to every text item in theLocation
	set AppleScript's text item delimiters to ""
	
	set ocean in resultRecord to my _testEmpty(item 1 in theLocation)
	set country in resultRecord to my _testEmpty(item 2 in theLocation)
	set province in resultRecord to my _testEmpty(item 3 in theLocation)
	set county in resultRecord to my _testEmpty(item 4 in theLocation)
	set city in resultRecord to my _testEmpty(item 5 in theLocation)
	set neighborhood in resultRecord to my _testEmpty(item 6 in theLocation)
	set aoi in resultRecord to my _testEmpty(item 7 in theLocation)
	set poi in resultRecord to my _testEmpty(item 8 in theLocation)
	
	--fallback for items that are not available in mainLanguage
	set lang to "en"
	set theLocation to do shell script iPhotoMainDB & "'SELECT pn1.string, pn2.string, pn3.string, pn4.string, pn5.string, pn6.string, pn7.string, pn8.string FROM SqPhotoInfo AS pi LEFT JOIN SqPlaceName AS pn1 ON pi.ocean = pn1.place AND pn1.language = \"" & lang & "\" LEFT JOIN SqPlaceName AS pn2 ON pi.country = pn2.place AND pn2.language = \"" & lang & "\" LEFT JOIN SqPlaceName AS pn3 ON pi.province = pn3.place AND pn3.language = \"" & lang & "\" LEFT JOIN SqPlaceName AS pn4 ON pi.county = pn4.place AND pn4.language = \"" & lang & "\" LEFT JOIN SqPlaceName AS pn5 ON pi.city = pn5.place AND pn5.language = \"" & lang & "\" LEFT JOIN SqPlaceName AS pn6 ON pi.neighborhood = pn6.place AND pn6.language = \"" & lang & "\" LEFT JOIN SqPlaceName AS pn7 ON pi.aoi = pn7.place AND pn7.language = \"" & lang & "\" LEFT JOIN SqPlaceName AS pn8 ON pi.poi = pn8.place AND pn8.language = \"" & lang & "\" WHERE pi.primaryKey = " & photoID & " LIMIT 1;'"
	
	set AppleScript's text item delimiters to "|"
	set theLocation to every text item in theLocation
	set AppleScript's text item delimiters to ""
	
	if (ocean in resultRecord = missing value) then
		set ocean in resultRecord to my _testEmpty(item 1 in theLocation)
	end if
	
	if (country in resultRecord = missing value) then
		set country in resultRecord to my _testEmpty(item 2 in theLocation)
	end if
	
	if (province in resultRecord = missing value) then
		set province in resultRecord to my _testEmpty(item 3 in theLocation)
	end if
	
	if (county in resultRecord = missing value) then
		set county in resultRecord to my _testEmpty(item 4 in theLocation)
	end if
	
	if (city in resultRecord = missing value) then
		set city in resultRecord to my _testEmpty(item 5 in theLocation)
	end if
	
	if (neighborhood in resultRecord = missing value) then
		set neighborhood in resultRecord to my _testEmpty(item 6 in theLocation)
	end if
	
	if (aoi in resultRecord = missing value) then
		set aoi in resultRecord to my _testEmpty(item 7 in theLocation)
	end if
	
	if (poi in resultRecord = missing value) then
		set poi in resultRecord to my _testEmpty(item 8 in theLocation)
	end if
	
	return resultRecord
end getLocationForPhoto

on getLocationForEvent(theEvent)
	set lang to mainLanguage
	set resultRecord to {ocean:missing value, country:missing value, province:missing value, county:missing value, city:missing value, neighborhood:missing value, aoi:missing value, poi:missing value}
	set theLocation to do shell script iPhotoMainDB & "'SELECT pn1.string, pn2.string, pn3.string, pn4.string, pn5.string, pn6.string, pn7.string, pn8.string FROM SqEvent AS e LEFT JOIN SqPlaceName AS pn1 ON e.ocean = pn1.place AND pn1.language = \"" & lang & "\" LEFT JOIN SqPlaceName AS pn2 ON e.country = pn2.place AND pn2.language = \"" & lang & "\" LEFT JOIN SqPlaceName AS pn3 ON e.province = pn3.place AND pn3.language = \"" & lang & "\" LEFT JOIN SqPlaceName AS pn4 ON e.county = pn4.place AND pn4.language = \"" & lang & "\" LEFT JOIN SqPlaceName AS pn5 ON e.city = pn5.place AND pn5.language = \"" & lang & "\" LEFT JOIN SqPlaceName AS pn6 ON e.neighborhood = pn6.place AND pn6.language = \"" & lang & "\" LEFT JOIN SqPlaceName AS pn7 ON e.aoi = pn7.place AND pn7.language = \"" & lang & "\" LEFT JOIN SqPlaceName AS pn8 ON e.poi = pn8.place AND pn8.language = \"" & lang & "\" WHERE e.primaryKey = " & theEvent & " LIMIT 1;'"
	
	set AppleScript's text item delimiters to "|"
	set theLocation to every text item in theLocation
	set AppleScript's text item delimiters to ""
	
	set ocean in resultRecord to my _testEmpty(item 1 in theLocation)
	set country in resultRecord to my _testEmpty(item 2 in theLocation)
	set province in resultRecord to my _testEmpty(item 3 in theLocation)
	set county in resultRecord to my _testEmpty(item 4 in theLocation)
	set city in resultRecord to my _testEmpty(item 5 in theLocation)
	set neighborhood in resultRecord to my _testEmpty(item 6 in theLocation)
	set aoi in resultRecord to my _testEmpty(item 7 in theLocation)
	set poi in resultRecord to my _testEmpty(item 8 in theLocation)
	
	--fallback for items that are not available in mainLanguage
	set lang to "en"
	set theLocation to do shell script iPhotoMainDB & "'SELECT pn1.string, pn2.string, pn3.string, pn4.string, pn5.string, pn6.string, pn7.string, pn8.string FROM SqEvent AS e LEFT JOIN SqPlaceName AS pn1 ON e.ocean = pn1.place AND pn1.language = \"" & lang & "\" LEFT JOIN SqPlaceName AS pn2 ON e.country = pn2.place AND pn2.language = \"" & lang & "\" LEFT JOIN SqPlaceName AS pn3 ON e.province = pn3.place AND pn3.language = \"" & lang & "\" LEFT JOIN SqPlaceName AS pn4 ON e.county = pn4.place AND pn4.language = \"" & lang & "\" LEFT JOIN SqPlaceName AS pn5 ON e.city = pn5.place AND pn5.language = \"" & lang & "\" LEFT JOIN SqPlaceName AS pn6 ON e.neighborhood = pn6.place AND pn6.language = \"" & lang & "\" LEFT JOIN SqPlaceName AS pn7 ON e.aoi = pn7.place AND pn7.language = \"" & lang & "\" LEFT JOIN SqPlaceName AS pn8 ON e.poi = pn8.place AND pn8.language = \"" & lang & "\" WHERE e.primaryKey = " & theEvent & " LIMIT 1;'"
	
	set AppleScript's text item delimiters to "|"
	set theLocation to every text item in theLocation
	set AppleScript's text item delimiters to ""
	
	if (ocean in resultRecord = missing value) then
		set ocean in resultRecord to my _testEmpty(item 1 in theLocation)
	end if
	
	if (country in resultRecord = missing value) then
		set country in resultRecord to my _testEmpty(item 2 in theLocation)
	end if
	
	if (province in resultRecord = missing value) then
		set province in resultRecord to my _testEmpty(item 3 in theLocation)
	end if
	
	if (county in resultRecord = missing value) then
		set county in resultRecord to my _testEmpty(item 4 in theLocation)
	end if
	
	if (city in resultRecord = missing value) then
		set city in resultRecord to my _testEmpty(item 5 in theLocation)
	end if
	
	if (neighborhood in resultRecord = missing value) then
		set neighborhood in resultRecord to my _testEmpty(item 6 in theLocation)
	end if
	
	if (aoi in resultRecord = missing value) then
		set aoi in resultRecord to my _testEmpty(item 7 in theLocation)
	end if
	
	if (poi in resultRecord = missing value) then
		set poi in resultRecord to my _testEmpty(item 8 in theLocation)
	end if
	
	return resultRecord
end getLocationForEvent

on _testEmpty(entryString)
	if (entryString = "") then
		return missing value
	else
		return entryString
	end if
end _testEmpty

on _string2Real(numberString)
	set test to 1.3 as string
	
	if (test contains ",") then
		set AppleScript's text item delimiters to "."
		set resultingReal to every text item in numberString
		set AppleScript's text item delimiters to ","
		set resultingReal to resultingReal as string
		set AppleScript's text item delimiters to ""
	end if
	
	set resultingReal to resultingReal as real
	
	if (resultingReal > 3.4E+38) then
		return missing value
	else
		return resultingReal
	end if
end _string2Real
