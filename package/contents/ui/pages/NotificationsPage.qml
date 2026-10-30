import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

import org.kde.kirigami as Kirigami
import org.kde.plasma.components as PlasmaComponents
import org.kde.plasma.extras as PlasmaExtras
import org.kde.kcmutils as KCMUtils
import org.kde.notificationmanager as NotificationManager

import "../js/funcs.js" as Funcs
import "components/notifications" as NotificationComponents

PageTemplate {
    id: notificationsPage

    sectionTitle: i18n("Notifications")

    // Used by Funcs.checkInhibition()/toggleDnd()
    property var notificationSettings: root.notificationSettings
    readonly property bool inhibited: Funcs.checkInhibition()
    readonly property var notificationModel: root.notificationModel

    property date now: new Date()

    // Viewing the list (and leaving it, for anything that arrived meanwhile) clears the unread badge
    onShownChanged: root.markNotificationsSeen()

    Timer {
        interval: 60000
        repeat: true
        running: notificationsPage.visible
        triggeredOnStart: true
        onTriggered: notificationsPage.now = new Date()
    }

    function clearAll() {
        for (let i = notificationModel.count - 1; i >= 0; --i) {
            notificationModel.close(notificationModel.index(i, 0));
        }
    }

    extraHeaderItems: RowLayout {
        anchors.fill: parent
        spacing: 0

        Item { Layout.fillWidth: true }

        PlasmaComponents.ToolButton {
            icon.name: "notifications-disabled-symbolic"
            text: i18n("Do Not Disturb")
            display: AbstractButton.IconOnly
            checkable: true
            checked: notificationsPage.inhibited
            onClicked: Funcs.toggleDnd()

            PlasmaComponents.ToolTip.text: text
            PlasmaComponents.ToolTip.visible: hovered
            PlasmaComponents.ToolTip.delay: Kirigami.Units.toolTipDelay
        }

        PlasmaComponents.ToolButton {
            icon.name: "edit-clear-history-symbolic"
            text: i18n("Clear All Notifications")
            display: AbstractButton.IconOnly
            enabled: notificationsPage.notificationModel.count > 0
            onClicked: notificationsPage.clearAll()

            PlasmaComponents.ToolTip.text: text
            PlasmaComponents.ToolTip.visible: hovered
            PlasmaComponents.ToolTip.delay: Kirigami.Units.toolTipDelay
        }

        PlasmaComponents.ToolButton {
            icon.name: "configure-symbolic"
            text: i18n("Configure Notifications…")
            display: AbstractButton.IconOnly
            onClicked: {
                KCMUtils.KCMLauncher.openSystemSettings("kcm_notifications");
                root.expanded = false;
            }

            PlasmaComponents.ToolTip.text: text
            PlasmaComponents.ToolTip.visible: hovered
            PlasmaComponents.ToolTip.delay: Kirigami.Units.toolTipDelay
        }
    }

    PlasmaComponents.ScrollView {
        id: scrollView
        anchors.fill: parent
        anchors.topMargin: root.smallSpacing
        PlasmaComponents.ScrollBar.horizontal.policy: PlasmaComponents.ScrollBar.AlwaysOff

        contentItem: ListView {
            id: listView
            model: notificationsPage.notificationModel
            spacing: root.smallSpacing
            clip: true
            boundsBehavior: Flickable.StopAtBounds
            // Leave room for the scrollbar so it doesn't cover the cards
            rightMargin: scrollView.PlasmaComponents.ScrollBar.vertical.visible ? scrollView.PlasmaComponents.ScrollBar.vertical.width : 0

            delegate: NotificationComponents.NotificationItem {
                width: listView.width - listView.rightMargin
                now: notificationsPage.now
            }

            add: Transition {
                NumberAnimation { property: "opacity"; from: 0; to: 1; duration: Kirigami.Units.longDuration }
            }
            remove: Transition {
                NumberAnimation { property: "opacity"; to: 0; duration: Kirigami.Units.shortDuration }
            }
            displaced: Transition {
                NumberAnimation { property: "y"; duration: Kirigami.Units.longDuration; easing.type: Easing.OutCubic }
            }

            PlasmaExtras.PlaceholderMessage {
                anchors.centerIn: parent
                width: parent.width - Kirigami.Units.gridUnit * 4
                visible: listView.count === 0
                iconName: notificationsPage.inhibited ? "notifications-disabled" : "notifications"
                text: i18n("No notifications")
                explanation: notificationsPage.inhibited ? i18n("Do Not Disturb is on") : ""
            }
        }
    }
}
