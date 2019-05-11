import QtQuick 2.0
import QtQuick.LocalStorage 2.0
import "squarik.js" as Logic

Rectangle {
    id: screen
    width: 480
    height: 800
    color: view.window
    Component.onCompleted: {
        Logic.setBestText();
        //Logic.startNewGame(canvas.maxLevel);
    }
    Settings {
        id: view
    }
    Item {
        id: levelRow
        anchors.left: parent.left
        anchors.right: newGameButton.left
        anchors.verticalCenter: newGameButton.verticalCenter
        anchors.margins: view.margin
        Row {
            anchors.centerIn: parent
            spacing: view.margin * 2
            Button {
                text: '<<'
                enabled: canvas.newGameLevel > 4
                onClicked: {
                    canvas.newGameLevel--;
                    newGameButton.enabled = true;
                    if (canvas.newGameLevel < 4)
                        canvas.newGameLevel = 4;
                }
            }
            Text {
                anchors.verticalCenter: parent.verticalCenter
                color: view.buttonText
                font.pointSize: view.fontSize
                text: canvas.newGameLevel
            }
            Button {
                text: '>>'
                enabled: canvas.newGameLevel < canvas.maxLevel
                onClicked: {
                    canvas.newGameLevel++;
                    newGameButton.enabled = true;
                    if (canvas.newGameLevel > 9)
                        canvas.newGameLevel = 9;
                }
            }
        }
    }
    Button {
        id: newGameButton
        anchors.top: parent.top
        anchors.right: helpButton.left
        text: 'New game'
        //waiting: shuffleTimer.interval
        //enabled: false
        onClicked: {
            dialog.close();
            enabled = false;
            Logic.startNewGame(canvas.newGameLevel);
        }
    }
    Button {
        id: helpButton
        anchors.top: parent.top
        anchors.right: parent.right
        text: '?'
        onClicked: {
            enabled = false;
            var text = 'Slide rows and columns to bunch squares of each color in separate column.'
            if (canvas.level < 9 && canvas.level === Logic.readMaxLevel())
                text += '\nTo unlock next level solve this puzzle 5 times.'
            dialog.show(text);
        }
    }
    Text {
        id: bestText
        anchors.top: newGameButton.bottom
        anchors.horizontalCenter: levelRow.horizontalCenter
        anchors.margins: view.margin
        font.pointSize: view.fontSize / 2
        color: view.buttonText
        text: 'Unsolved'
    }
    Text {
        id: currentText
        anchors.top: newGameButton.bottom
        anchors.horizontalCenter: newGameButton.horizontalCenter
        anchors.margins: view.margin
        font.pointSize: view.fontSize / 2
        color: view.buttonText
        text: 'Current game: ' + canvas.score + ' turns'
    }

    Item {
        id: canvas
        property int newGameLevel: 4
        property int level: maxLevel
        property int maxLevel: Logic.readMaxLevel()
        property int score: 0
        property bool gameIsRunning: false
        property int blockSize: Math.floor(maxWidth / level)
        property int maxWidth: (maxHeight > parent.width ? parent.width : maxHeight) - view.margin * 2
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: bestText.bottom
        anchors.margins: view.margin * 2
        width: blockSize * level
        property int maxHeight: parent.height - y - view.margin * 4 - (view.ads ? adsHeight : 0)
        property int adsHeight: screen.width * 50 / 320
        property int nrows: Math.floor(maxHeight / blockSize)
        property bool movingSquares: false
        height: nrows * blockSize
        clip: true
        onNewGameLevelChanged: Logic.setBestText()
        MouseArea {
            anchors.fill: parent
            onPressed: Logic.handlePress(mouse.x, mouse.y)
            onReleased: Logic.handleRelease(mouse.x, mouse.y)
        }
        Timer {
            id: shuffleTimer
            //triggeredOnStart: true
            interval: 150
            onTriggered: Logic.shuffle()
            repeat: true
        }
    }
    Dialog {
        id: dialog
        anchors.centerIn: parent
        z: 100
        //onOpened: canvas.gameIsRunning = false
        onClosed: {
            helpButton.enabled = true;
        }
    }
}
