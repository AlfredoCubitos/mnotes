TEMPLATE = app

QT += qml quick widgets webview quickcontrols2


SOURCES += main.cpp \
    mnoteshandler.cpp \
    mnotesconfig.cpp \
    mnotesnetwork.cpp \
    msonenoteapi.cpp

RESOURCES += qml.qrc

INCLUDEPATH += ./OAuth

RC_ICONS = notes.ico

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH = "."

# Core O2
include(./OAuth/src.pri)

# Default rules for deployment.
include(deployment.pri)

HEADERS += \
    mnoteshandler.h \
    mnotesconfig.h \
    mnotesnetwork.h \
    msonenoteapi.h

