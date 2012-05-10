#!/usr/bin/pythonw

import os
from appscript import *
from ftplib import FTP



#  NOTES:
#	   COMPATABILITY
#	   This has only been tested with iPhoto 4 and OS X 10.3 Panther.  Because, this is what I have.
#
#	   SYSTEM SETTINGS
#	   For this script to work you must absolutely "ENABLE ACCESS FOR ASSISTIVE DEVICES" in System Preferences,
#	   Universal access.  The only way photo export works is through GUI scripting, which in turn requires enabling
#	   Assistive Device Access.
#
#	 GALLERY BGCOLOR
#	 The gallery webpage background will use the default one.  I don't yet understand how to change the value of a color_well
#	 UI element, and couldn't figure out how to further GUI-script this by using the 'click' method
#
#	 TEXT COLOR
#	 The above goes for the text color as well.  But why would you want anything but black text anyway?
#
#	 EXPORT FOLDER
#	 Galleries are stored in ~/username/pictures/iphoto_webgallery/yourgalleryname/
#	 This is semi-hardcoded in, on account of me being lazy.
#
#	   VARIABLES TO SET
#	   There are some variables you need to set at the bottom of this file.	 You had best do so ;)
#
#	   ABOUT THE PAUSE
#	   There is an up to 30-second pause after you export photos.  This is by design, so be patient.  Read the code
#	   comments for more details.

def getAlbumName():

    #  Gets name of currently selected album
    #  No error checking, if non-album item is selected, will crash.

    selection = app('iPhoto.app').selection.get()
    myAlbum = selection[0]
    return myAlbum.name.get()


def replaceSpaces(someString):

    #  The gallery directory name is based on the photo album name.  Album name with spaces fine.  Directories with spaces baaad (at least to unix).
    #  This function replaces spaces with underscores

    fixedString = someString.replace(' ', '_')
    return fixedString


def makeGalleryDir(albumName):

    #  Create folders for galleries to exported to

    #  If the root webgallery folder does not exist, create it

    try:
	os.mkdir("%s/pictures/iphoto_webgallery" % homeFolder )
    except:
	pass


    #  Create the new gallery folder
    try:
	os.mkdir("%s/pictures/iphoto_webgallery/%s" % (homeFolder, replaceSpaces(albumName)))

    #  If the gallery exists assume that you are re-publishing a gallery.  Delete old gallery folder, and re-create folder.
    except OSError:
	import shutil
	shutil.rmtree("%s/pictures/iphoto_webgallery/%s" % (homeFolder, replaceSpaces(albumName)))
	os.mkdir("%s/pictures/iphoto_webgallery/%s" % (homeFolder, replaceSpaces(albumName)))


def exportGalleryGUI():

    #  Main function for exporting photos out of iPhoto
    #  Unfortunately there is no scripting interface for exporting photos, so some crazy GUI scripting is in order.
    #  This has only been tested in iPhoto 4, and will most definetly break in anything else.

    #  App object
    n = app('System Events.app').processes['iPhoto']

    #  Bring iPhoto to focus
    app('iPhoto').activate()

    #  Get unix-friendly album name
    albumName = replaceSpaces(getAlbumName())

    #  File --> Export
    app('System Events').click(app('System Events').application_processes[u'iPhoto'].menu_bars[1].menu_bar_items[u'File'].menus[u'File'].menu_items[u'Export\u2026'])

    #  Export --> Web Page Tab
    #  This weird syntax is required because the click command is kinda sketchy otherwise
    app('System Events').click(app('System Events').processes['iPhoto'].windows['Export Photos'].tab_groups[1].radio_buttons['Web Page'])

    #  Set maximum thumbnail size
    n.windows['Export Photos'].tab_groups[1].groups[1].groups[2].text_fields[1].value.set(thmbMaxWidth)
    n.windows['Export Photos'].tab_groups[1].groups[1].groups[2].text_fields[2].value.set(thmbMaxHeight)

    #  Set maximum image size
    n.windows['Export Photos'].tab_groups[1].groups[1].groups[1].text_fields[2].value.set(imgMaxWidth)
    n.windows['Export Photos'].tab_groups[1].groups[1].groups[1].text_fields[1].value.set(imgMaxHeight)

    #  Show/Hide image titles
    thmbShowTitle = n.windows['Export Photos'].tab_groups[1].groups[1].groups[2].checkboxes['Show title'].value.get()
    imgShowTitle = n.windows['Export Photos'].tab_groups[1].groups[1].groups[1].checkboxes['Show title'].value.get()

    #	Once again, have you to use the ugly syntax and an if-check instead of just setting things directly
    #	through the object.	 Not sure why the normal value.set() method doesn't work.

    if thmbShowTitle == 0:
	app('System Events').click(app('System Events').processes['iPhoto'].windows['Export Photos'].tab_groups[1].groups[1].groups[2].checkboxes['Show title'])

    if imgShowTitle == 0:
	app('System Events').click(app('System Events').processes['iPhoto'].windows['Export Photos'].tab_groups[1].groups[1].groups[1].checkboxes['Show title'])

    #  Click the 'color' radio-button, in case 'image background' was on at last'
    app('System Events').click(app('System Events').application_processes[u'iPhoto'].windows['Export Photos'].tab_groups[1].groups[1].groups[3].radio_groups[1])

    #  Click export button
    app('System Events').click(app('System Events').processes['iPhoto'].windows['Export Photos'].lists[1].buttons['Export'])

    #  Make folder for gallery (~/pictures/iphoto_webgallery/my_gallery_name)
    makeGalleryDir(albumName)

    #  Open the Go To pop-up window, type in the folder directory  Click the Go To Button.  Hit OK button.
    n.keystroke('/%s/%s/pictures/iphoto_webgallery/%s' % (homeFolderSplit[1],homeFolderSplit[2],albumName))

    import time
    time.sleep(.5)  #  The keyboard input is slow, so we have to wait or the next GUI command will out-run the previous

    app('System Events').click(app('System Events').application_processes[u'iPhoto'].windows['Go To Folder'].buttons['Goto'])
    app('System Events').click(app('System Events').application_processes[u'iPhoto'].windows['Export Photos'].sheets[1].buttons['OK'])


def FTPConnect(address):

    #  Connect to FTP host, return FTP object for further operations

    ftp = FTP(address)
    ftp.login(userName, passWord)
    return ftp

def FTPMakeRemoteFolders(ftp):

    #  Try to create gallery folders on remote FTP.
    #  If the folders exist, assume user wants to republish web-gallery,
    #  call FTPDeleteFiles() in order to clean out old folders before
    #  uploading new images.

    try:
	ftp.mkd('%s/%s' % (remoteWebRoot, albumName))
	ftp.mkd('%s/%s/%s-Images' % (remoteWebRoot, albumName, albumName))
	ftp.mkd('%s/%s/%s-Pages' % (remoteWebRoot, albumName, albumName))
	ftp.mkd('%s/%s/%s-Thumbnails' % (remoteWebRoot, albumName, albumName))

    except:
	FTPDeleteFiles()


def FTPDeleteFiles():

    #  Delete all the files on the remote gallery FTP folders.	Under the assumption
    #  That user wants to re-publish files.	 Should be called by the FTPMakeRemoteFolders() function

    try:
	#  Delete the remote html index file
	ftp.delete('%s/%s/%s.html' % (remoteWebRoot, albumName, albumName))
	ftp.delete('%s/%s/Page1.html' % (remoteWebRoot, albumName))
	ftp.delete('%s/%s/Page2.html' % (remoteWebRoot, albumName))
	ftp.delete('%s/%s/Page3.html' % (remoteWebRoot, albumName))

    except:
	pass

    try:
	#  Delete all files in the remote images folder
	imagesFiles = ftp.nlst('%s/%s/%s-Images' % (remoteWebRoot, albumName, albumName))

	for filename in imagesFiles:
	    ftp.delete(filename)

    except:
	pass

    try:
	#  Delete all files in the remote thumbnails folder
	thumbnailsFiles = ftp.nlst('%s/%s/%s-Thumbnails' % (remoteWebRoot, albumName, albumName))

	for filename in thumbnailsFiles:
	    ftp.delete(filename)

    except:
	pass

    try:
	#  Delete all files in the remote pages folder

	pagesFiles = ftp.nlst('%s/%s/%s-Pages' % (remoteWebRoot, albumName, albumName))

	for filename in pagesFiles:
	    ftp.delete(filename)

    except:
	pass




def FTPUploadFolder(ftp, subFolder):

    #  Uploads all files in given gallery sub-folder of which there are three:
    #  myalbum-Images, myalbum-Pages, myalbum-Thumbnails

    #  Get a list of all files in local gallery subFolder
    fileListing = os.listdir('%s/%s-%s' % (localGalleryDir, albumName, subFolder))

    #  Loop through file list and upload files
    for filename in fileListing:

	remoteFileName = (remoteWebRoot + albumName + "/" + albumName + "-" + subFolder + "/" + filename)
	localFileName  = (localGalleryDir + "/" + albumName + "-" + subFolder + "/" + filename)

	#  Use extension object to determine file extension, send in ascii or binary accordingly
	ext = os.path.splitext(filename)[1]

	print 'Uploading file ' + filename + "..."

	if ext in (".txt", ".htm", ".html"):
	    ftp.storlines("STOR " + remoteFileName, open(localFileName, "rb"))

	else:
	    ftp.storbinary("STOR " + remoteFileName, open(localFileName, "rb"), 1024)

def FTPUploadIndex(ftp):

    #  Upload files in gallery main folder

    fileListing = os.listdir('%s' % (localGalleryDir))

    for filename in fileListing:

	ext = os.path.splitext(filename)[1]
	if ext in (".txt", ".htm", ".html"):

	    remoteFileName = (remoteWebRoot + "/" + albumName + "/" + filename)
	    localFileName  = (localGalleryDir + "/" + filename)

	    print 'Uploading file ' + filename + "..."
	    ftp.storlines("STOR " + remoteFileName, open(localFileName, "rb"))


def albumLink(albumName, albumRootURL):

    #  Generate text-edit window with link for pasting into a blog post

    albumURL =	albumRootURL + albumName + "/" + albumName + ".html"

    albumURLMessage = ("""

    ***GOOD DEAL***

    Your photo album \"%s\" has been posted successfully to the web!  Paste the following code into your weblog post:

    <a href=\"%s\">%s</a>


    Don't lose that code!

    """ % (albumName, albumURL, albumName))

    textedit = app('TextEdit.app') # get an application object for TextEdit

    # tell application "TextEdit" to activate
    textedit.activate()

    # tell application "TextEdit" to make new document at end of documents
    textedit.documents.end.make(new=k.document)

    # tell application "TextEdit" to set text of document 1 to "Hello World\n"
    textedit.documents[1].text.set(albumURLMessage)


# Main program flow

#  Change these variables as needed
albumName = replaceSpaces(getAlbumName())


thmbMaxWidth  = '240'
thmbMaxHeight = '180'
imgMaxWidth   = '640'
imgMaxHeight  = '480'

homeFolder	  = os.environ["HOME"]
homeFolderSplit	 = homeFolder.split("/") #  A hacky variable needed because of GUI scripting stuff

#  FTP Connection variables
ftpSite	    =  'ftp.yourhostingiste.com'
userName	= 'myUserName'
passWord	= 'myPassWord'
remoteWebRoot	= '/public_html/myblog/albums/'	 #  Don't forget trailing slash
localGalleryDir = os.environ["HOME"] + "/pictures/iphoto_webgallery/" + albumName  # Please don't edit this one for now

#  Weblog info
albumRootURL   = 'http://www.mygreatwebsite.com/myblog/albums/'	 #  Your public albums root folder via the web

#  Other options
showLinkCode   =  True	#  Set this to 'false' (w/ no quotes) to skip the final step that display weblog link code

exportGalleryGUI()

print 'Sleeping for 30 seconds while GUI catches up'
import time
time.sleep(30)

ftp = FTPConnect(ftpSite)
FTPMakeRemoteFolders(ftp)
FTPUploadFolder(ftp, 'Pages')
FTPUploadFolder(ftp, 'Images')
FTPUploadFolder(ftp, 'Thumbnails')
FTPUploadIndex(ftp)
if showLinkCode == True: albumLink(albumName, albumRootURL)












