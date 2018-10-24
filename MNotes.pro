TEMPLATE = app

QT += qml widgets quickcontrols2 network


SOURCES += main.cpp \
    mnoteshandler.cpp \
    mnotesconfig.cpp \
    mnotesnetwork.cpp

RESOURCES += qml.qrc

RC_ICONS = notes.ico

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH = "."

# Default rules for deployment.
include(deployment.pri)

HEADERS += \
    mnoteshandler.h \
    mnotesconfig.h \
    mnotesnetwork.h

DISTFILES += \
    android/AndroidManifest.xml \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradlew \
    android/res/values/libs.xml \
    android/build.gradle \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew.bat

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android

contains(ANDROID_TARGET_ARCH,armeabi-v7a) {
    ANDROID_EXTRA_LIBS = \
        $$PWD/libs/libcrypto.so \
        $$PWD/libs/libssl.so
}

