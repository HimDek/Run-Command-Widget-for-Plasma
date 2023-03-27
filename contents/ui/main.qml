/*
    SPDX-FileCopyrightText: 2023 Himprakash Deka <himprakashd@gmail.com>

    SPDX-License-Identifier: GPL-2.0-or-later
 */
import QtQuick 2.6
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.0

import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.extras 2.0 as PlasmaExtras
import org.kde.plasma.components 2.0 as PlasmaComponents

import org.kde.kquickcontrolsaddons 2.0

Item {
    id: root

    property bool inPanel: plasmoid.location === PlasmaCore.Types.TopEdge
        || plasmoid.location === PlasmaCore.Types.RightEdge
        || plasmoid.location === PlasmaCore.Types.BottomEdge
        || plasmoid.location === PlasmaCore.Types.LeftEdge
    property bool vertical: plasmoid.formFactor === PlasmaCore.Types.Vertical


    PlasmaCore.DataSource {
        id: execute
        engine: "executable"
        connectedSources: []
        onNewData: disconnectSource(sourceName)

        function run(command) {
            execute.connectSource(command)
        }
    }

    Plasmoid.preferredRepresentation: plasmoid.compactRepresentation
    Plasmoid.icon: plasmoid.configuration.icon
    Plasmoid.fullRepresentation: null
    Plasmoid.compactRepresentation: MouseArea {
        id: compactRoot

        Layout.minimumWidth: {
            if (!root.inPanel) {
                return (buttonIcon.visible ? parent.height : 0) + (label.visible ? label.implicitWidth + parent.height/4 : 0);
            }

            if (root.vertical) {
                return -1;
            } else {
                return (buttonIcon.visible ? Math.min(PlasmaCore.Units.iconSizeHints.panel, parent.height) : 0) + (label.visible ? label.implicitWidth + parent.height/4 : 0);
            }
        }

        Layout.maximumWidth: {
            if (!root.inPanel) {
                return (buttonIcon.visible ? parent.height : 0) + (label.visible ? label.implicitWidth + parent.height/4 : 0);
            }

            if (root.vertical) {
                return PlasmaCore.Units.iconSizeHints.panel;
            } else {
                return (buttonIcon.visible ? Math.min(PlasmaCore.Units.iconSizeHints.panel, parent.height) : 0) + (label.visible ? label.implicitWidth + parent.height/4 : 0);
            }
        }

        Layout.minimumHeight: {
            if (!root.inPanel) {
                return -1;
            }

            if (root.vertical) {
                return (buttonIcon.visible ? Math.min(PlasmaCore.Units.iconSizeHints.panel, parent.width) : 0) + (label.visible ? label.implicitHeight : 0);
            } else {
                return -1;
            }
        }

        Layout.maximumHeight: {
            if (!root.inPanel) {
                return -1;
            }

            if (root.vertical) {
                return (buttonIcon.visible ? Math.min(PlasmaCore.Units.iconSizeHints.panel, parent.width) : 0) + (label.visible ? label.implicitHeight : 0);
            } else {
                return PlasmaCore.Units.iconSizeHints.panel;
            }
        }
        
        onClicked: {
                runCommand()
            }

        DropArea {
            id: compactDragArea
            anchors.fill: parent
        }

        Row {
            height: parent.height
            anchors.centerIn: parent

            PlasmaCore.IconItem {
                id: buttonIcon
                visible: plasmoid.configuration.show == 0 || plasmoid.configuration.show == 2 ? true : false

                height: parent.height
                width: buttonIcon.visible ? parent.height : 0

                source: plasmoid.icon
                active: parent.containsMouse || compactDragArea.containsDrag
                smooth: true
            }
        
            Label{
                id: label
                visible: plasmoid.configuration.show

                height: parent.height
                width: (label.visible ? label.implicitWidth + parent.height/4 : 0)

                text: plasmoid.configuration.label
                color: theme.textColor
                horizontalAlignment: buttonIcon.visible ? Text.AlignHLeft : Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: theme.defaultFont.pixelSize
            }
        }
    }

    function runCommand() {
        execute.run(plasmoid.configuration.command)
    }
}
