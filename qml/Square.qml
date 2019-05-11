import QtQuick 2.0

Rectangle {
    id: square
    width: parent.blockSize
    height: width
    //visible: x > -width && y > -height && x < canvas.width && y < canvas.height
    property int type: 0
    //property int n: 0
    color: {
        switch (type) {
        case 0:
            '#DF9862';
            break;
        case 1:
            '#774795';
            break;
        case 2:
            '#21399C';
            break;
        case 3:
            '#3C8984';
            break;
        case 4:
            '#CCF098';
            break;
        case 5:
            '#C11362';
            break;
        case 6:
            '#85D315';
            break;
        case 7:
            '#FFFFFF';
            break;
        case 8:
            '#000000';
            break;
        default:
            'white';
            break;
        }
    }
    border.width: view.margin / 2
    border.color: view.border
    Behavior on x {
        enabled: visible
        SequentialAnimation {
            PropertyAction { target: canvas; property: "movingSquares"; value: true }
            NumberAnimation {
                property: 'x'
                easing.type: Easing.InOutQuart
                duration: canvas.gameIsRunning ? 300 : shuffleTimer.interval
            }
            PropertyAction { target: canvas; property: "movingSquares"; value: false }
        }
    }
    Behavior on y {
        enabled: visible
        SequentialAnimation {
            PropertyAction { target: canvas; property: "movingSquares"; value: true }
            NumberAnimation {
                property: 'y'
                easing.type: Easing.InOutQuart
                duration: canvas.gameIsRunning ? 300 : shuffleTimer.interval
            }
            PropertyAction { target: canvas; property: "movingSquares"; value: false }
        }
    }
//    Text {
//        anchors.centerIn: parent
//        text: parent.n
//        color: 'black'
//        font.pointSize: 40
//    }
}
