/****************************************************************************
**
** Copyright (C) 2011 Nokia Corporation and/or its subsidiary(-ies).
** All rights reserved.
** Contact: Nokia Corporation (qt-info@nokia.com)
**
** This file is part of the QtDeclarative module of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:LGPL$
** GNU Lesser General Public License Usage
** This file may be used under the terms of the GNU Lesser General Public
** License version 2.1 as published by the Free Software Foundation and
** appearing in the file LICENSE.LGPL included in the packaging of this
** file. Please review the following information to ensure the GNU Lesser
** General Public License version 2.1 requirements will be met:
** http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html.
**
** In addition, as a special exception, Nokia gives you certain additional
** rights. These rights are described in the Nokia Qt LGPL Exception
** version 1.1, included in the file LGPL_EXCEPTION.txt in this package.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU General
** Public License version 3.0 as published by the Free Software Foundation
** and appearing in the file LICENSE.GPL included in the packaging of this
** file. Please review the following information to ensure the GNU General
** Public License version 3.0 requirements will be met:
** http://www.gnu.org/copyleft/gpl.html.
**
** Other Usage
** Alternatively, this file may be used in accordance with the terms and
** conditions contained in a signed written agreement between you and Nokia.
**
**
**
**
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.0

Rectangle {
    id: page
    width: dialogText.paintedWidth + view.margin * 2 > screen.width
           ? screen.width - view.margin * 2 : dialogText.paintedWidth + view.margin * 2
    height: dialogText.height + view.margin * 2
    color: "white"
    border.width: view.margin / 5
    opacity: 0
    visible: opacity > 0
    signal opened
    signal closed
    function close() {
        if(page.opacity == 0)
            return; //already closed
        page.closed();
        page.opacity = 0;
    }

    function show(txt) {
        page.opened()
        dialogText.text = txt
        page.opacity = 0.8
    }

    Behavior on opacity {
        NumberAnimation { duration: 500 }
    }

    Text {
        id: dialogText
        anchors.centerIn: parent
        width: screen.width - view.margin * 2
        text: "Hello World!"
        font.pointSize: view.fontSize
        wrapMode: Text.WordWrap
        horizontalAlignment: Text.AlignHCenter
    }

    MouseArea {
        anchors.fill: parent
        onClicked: parent.close()
    }
}

