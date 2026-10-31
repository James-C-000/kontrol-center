import QtQml 2.15
import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.0
import "../components" as Components
import "components/Default" as LayoutComponents 

ColumnLayout {
    id: wrapper

    anchors.fill: parent
    anchors.margins: 1
    spacing: 1

    RowLayout {
        id: header
        spacing: 1
        Layout.fillWidth: true
        Layout.preferredHeight: root.sectionHeight/3.3
        anchors.margins: 1
        visible: header.children.length > 0
        
        Components.UserAvatar{
            id: avatar
            isLongButton: true
            smallTopMargins: true
            smallBottomMargins: true
        }
        // Without the avatar, the battery (or failing that the session actions) fills the row
        Components.Battery {
            id: mainBatteryWidget
            Layout.fillWidth: !avatar.shown
            Layout.preferredWidth: header.Layout.preferredHeight * 1.7
            Layout.maximumWidth: avatar.shown ? Layout.preferredWidth : Number.POSITIVE_INFINITY
        }
        Components.SystemActions{
            Layout.fillWidth: !avatar.shown && !mainBatteryWidget.shown
            Layout.preferredWidth: header.Layout.preferredHeight
            Layout.maximumWidth: Layout.fillWidth ? Number.POSITIVE_INFINITY : Layout.preferredWidth
        }
    }

    RowLayout {
        id: sectionA

        spacing: 1
        anchors.margins: 1

        Layout.preferredHeight: root.sectionHeight
        Layout.maximumHeight: root.sectionHeight
        
        // Network, Bluetooth and Settings Button
        LayoutComponents.SectionQuickToggleButtons{}

        // Screen controls section
        LayoutComponents.SectionScreenControls{}
    }

    Components.Volume{
        Layout.preferredHeight: root.sectionHeight / (root.volume_widget_title ? 2 : 2.8)
    }
    Components.MediaPlayer{
        Layout.preferredHeight: root.sectionHeight/2
    }
}