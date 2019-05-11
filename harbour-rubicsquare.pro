# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = harbour-rubicsquare

CONFIG += sailfishapp

SOURCES += src/harbour-rubicsquare.cpp

OTHER_FILES += rpm/harbour-rubicsquare.changes.in \
    rpm/harbour-rubicsquare.spec \
    rpm/harbour-rubicsquare.yaml \
    harbour-rubicsquare.desktop \
    qml/harbour-rubicsquare.qml
#    qml/squarik.js \
#    qml/Square.qml \
#    qml/Squarik.qml \
#    qml/Dialog.qml \
#    qml/Button.qml \
#    qml/Settings.qml \
#    qml/cover/CoverPage.qml
# to disable building translations every time, comment out the
# following CONFIG line
# CONFIG += sailfishapp_i18n

# German translation is enabled as an example. If you aren't
# planning to localize your app, remember to comment out the
# following TRANSLATIONS line. And also do not forget to
# modify the localized app name in the the .desktop file.
# TRANSLATIONS += translations/harbour-rubicsquare-de.ts

RESOURCES += \
    qml/qml.qrc

