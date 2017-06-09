android-no-sdk {
    target.path = /data/user/qt
    export(target.path)
    INSTALLS += target
} else:android {
    x86 {
        target.path = /libs/x86
    } else: armeabi-v7a {
        target.path = /libs/armeabi-v7a
    } else {
        target.path = /libs/armeabi
    }
    export(target.path)
    INSTALLS += target
} else:unix {

    isEmpty(PREFIX) {
        PREFIX = /usr
    }

    isEmpty(target.path) {
        qnx {
            target.path = /tmp/$${TARGET}/bin
        } else {
            target.path = $${PREFIX}/bin
        }
        export(target.path)
    }
    shortcutfiles.files = mnotes.desktop
    shortcutfiles.path = $$PREFIX/share/applications/
    data.files += images/MNotes-icon.png
    data.path = $$PREFIX/share/pixmaps/

    INSTALLS += shortcutfiles
    INSTALLS += data
    INSTALLS += target
}

export(INSTALLS)
