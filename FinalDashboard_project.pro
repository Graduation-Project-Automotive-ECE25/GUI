QT += core gui quick qml serialport

# You can make your code fail to compile if it uses deprecated APIs.
# Uncomment the following line to disable all APIs deprecated before Qt 6.0.0
# DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000

SOURCES += \
    GeoLocationHandler.cpp \
    backend.cpp \
    main.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH += $$PWD/qml
QML_DESIGNER_IMPORT_PATH += $$PWD/qml

# Include serialport in HEADERS
HEADERS += \
    GeoLocationHandler.h \
    backend.h

# Deployment rules
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target
