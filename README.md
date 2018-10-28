# MNotes

## Multinotes tracker for Linux and Android
### one app for various notes

Read and/or write notes from multiple locations
Each location has its own tab button

With this actual version you can fully manage your Notes
in a Next-/Owncloud

New:
* Flapak version available, please try it 

Note:
* MNotes is currently in an alpha version
* login data are stored unencrypted
* Before click on OwnCloud tab you have to configure your connection!

Note on Own-/Nexcloud:
* notes in Next-/Owncloud are using the first line as a title.
So titles can be changed by editing the first line in your note

### Compiling for Android

If you want to run this App on Android, you have to install openSSL first as descriped [here](http://doc.qt.io/qt-5/opensslsupport.html)
I followed [this example](https://www.ip6.li/node/52) to compile libssl.
To configure I used `./Configure shared -fPIC -fPIE -pie android-armv7` and left off the last 3 lines
With the `shared` option the libs were installed in the source directory.

**New Features in this version:**
---------------------------------

* OnenNote feature removed
* compatible with Qt 5.10


**Old Versions**
---------------------------------

* drag'n drop enabled in Listview (states currently not saved)

-----------------------------

* Read, write, add, update and delete notes from Next-/Owncloud

-----------------------------

* Read and write notes locally
* Read notes from Next-/Owncloud
* Read notes from O365/OneNote 

-------------------------
Now using Qt 5.9
fixed some issues

-------------------------
Switched from QtQuick.Controls 1.4 to QtQuick.Controls 2.0 so this compiles also for Android
Now Webview works also on Android 4.2.2

MNotes now give you access to MS OneNote.
In this version its a readonly access.


The UI has also changed, so that it is easier to make a port to a mobile device.

This version needs Qt >= 5.7 to run

 
