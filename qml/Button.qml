import QtQuick 2.0

Rectangle {
    id: button
    anchors.margins: view.margin
    width: label.width + view.margin * 2
    height: label.height + view.margin * 2
    radius: view.margin
    color: view.button
    border.color: view.border
    border.width: view.margin / 3
    property string text
    property bool enabled: true
    //property int waiting: 0
    signal clicked
//    Timer {
//        id: timer
//        interval: waiting
//        onTriggered: mouseArea.enabled = true
//    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        enabled: parent.enabled
        onClicked: {
            parent.clicked();
//            if (waiting > 0) {
//                enabled = false;
//                timer.start();
//            }
        }
    }
    Text {
        id: label
        text: parent.text
        anchors.centerIn: parent
        color: mouseArea.enabled ? view.buttonText : view.inactiveText
        font.pointSize: view.fontSize
    }
}
