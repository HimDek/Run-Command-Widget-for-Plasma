/*
    SPDX-FileCopyrightText: 2013 David Edmundson <davidedmundson@kde.org>
    SPDX-FileCopyrightText: 2021 Mikel Johnson <mikel5764@gmail.com>
    SPDX-FileCopyrightText: 2023 Himprakash Deka <himprakashd@gmail.com>

    SPDX-License-Identifier: GPL-2.0-or-later
*/

import QtQuick 2.15
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.5
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.kquickcontrolsaddons 2.0 as KQuickAddons
import org.kde.kirigami 2.5 as Kirigami

ColumnLayout {

    property string cfg_icon: plasmoid.configuration.icon
    property alias cfg_command: command.text
    property alias cfg_label: label.text
    property int cfg_show: plasmoid.configuration.show

    Kirigami.FormLayout {
        Button {
            id: iconButton

            Kirigami.FormData.label: i18n("Icon:")

            implicitWidth: previewFrame.width + PlasmaCore.Units.smallSpacing * 2
            implicitHeight: previewFrame.height + PlasmaCore.Units.smallSpacing * 2

            KQuickAddons.IconDialog {
                id: iconDialog
                onIconNameChanged: cfg_icon = iconName || "new-command-alarm"
            }

            onPressed: iconMenu.opened ? iconMenu.close() : iconMenu.open()

            PlasmaCore.FrameSvgItem {
                id: previewFrame
                anchors.centerIn: parent
                imagePath: plasmoid.location === PlasmaCore.Types.Vertical || plasmoid.location === PlasmaCore.Types.Horizontal
                        ? "widgets/panel-background" : "widgets/background"
                width: PlasmaCore.Units.iconSizes.large + fixedMargins.left + fixedMargins.right
                height: PlasmaCore.Units.iconSizes.large + fixedMargins.top + fixedMargins.bottom

                PlasmaCore.IconItem {
                    anchors.centerIn: parent
                    width: PlasmaCore.Units.iconSizes.large
                    height: width
                    source: cfg_icon
                }
            }

            Menu {
                id: iconMenu

                // Appear below the button
                y: +parent.height

                MenuItem {
                    text: i18nc("@item:inmenu Open icon chooser dialog", "Choose…")
                    icon.name: "document-open-folder"
                    onClicked: iconDialog.open()
                }
                MenuItem {
                    text: i18nc("@item:inmenu Reset icon to default", "Clear Icon")
                    icon.name: "edit-clear"
                    onClicked: cfg_icon = "new-command-alarm"
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true

            Kirigami.FormData.label: i18n("Label:")

            TextField{
                id: label
            }
        }

        RadioButton {
            id: showIcon
            Kirigami.FormData.label: i18n("Show:")
            text: i18nc("Part of a sentence: 'Show icon only'", "Icon")
            ButtonGroup.group: showGroup
            property int index: 0
            checked: plasmoid.configuration.show == index
        }

        RadioButton {
            id: showLabel
            text: i18nc("Part of a sentence: 'Show label only'", "Label")
            ButtonGroup.group: showGroup
            property int index: 1
            checked: plasmoid.configuration.show == index
        }

        RadioButton {
            id: showBoth
            text: i18nc("Part of a sentence: 'Show both icon and label'", "Both")
            ButtonGroup.group: showGroup
            property int index: 2
            checked: plasmoid.configuration.show == index
        }

        Item {
            Kirigami.FormData.isSection: true
        }

        RowLayout {
            Layout.fillWidth: true

            Kirigami.FormData.label: i18n("Command:")

            TextField{
                id: command
            }
        }
    }

    ButtonGroup {
        id: showGroup
        onCheckedButtonChanged: {
            if (checkedButton) {
                cfg_show = checkedButton.index
            }
        }
    }

    Item {
        Layout.fillHeight: true
    }
}
