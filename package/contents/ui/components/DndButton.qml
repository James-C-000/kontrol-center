import QtQml 2.15
import QtQuick 2.15
import QtQuick.Layouts 1.15
import "../lib" as Lib
import "../js/funcs.js" as Funcs
import org.kde.notificationmanager as NotificationManager
import org.kde.kirigami as Kirigami

// Notifications tile: the icon toggles Do Not Disturb, the rest opens the notification list
Lib.CardButton {
    id: notificationsBtn
    readonly property bool shown: root.showDnd
    visible: shown
    Layout.fillWidth: true
    Layout.fillHeight: true
    showContentOverflowIndicator: isLongButton

    // Used by Funcs.checkInhibition()/toggleDnd()
    property var notificationSettings: root.notificationSettings
    readonly property bool inhibited: Funcs.checkInhibition()
    readonly property int count: root.notificationModel.count
    readonly property int unread: root.unreadNotifications

    heading: isLongButton ? i18n("Notifications") : ""
    title: {
        if (isLongButton) {
            if (inhibited) {
                return i18n("Do Not Disturb");
            }
            if (unread > 0) {
                return i18np("%1 new", "%1 new", unread);
            }
            return count > 0 ? i18np("%1 notification", "%1 notifications", count) : i18n("No notifications");
        }
        return inhibited ? i18n("Do Not Disturb") : i18n("Notifications");
    }

    onClicked: fullRep.togglePage(fullRep.defaultInitialWidth, 400, notificationsPage)

    Lib.Icon {
        id: dndIcon
        anchors.fill: parent
        source: notificationsBtn.inhibited ? "notifications-disabled-symbolic"
              : notificationsBtn.unread > 0 ? "notification-active-symbolic"
              : "notification-inactive-symbolic"
        selected: notificationsBtn.inhibited
        enableQuickAction: root.enableQuickActions
        onQuickActionTriggered: Funcs.toggleDnd()

        Kirigami.Badge {
            visible: notificationsBtn.unread > 0
            text: notificationsBtn.unread > 99 ? "99+" : notificationsBtn.unread
            // Sit on the corner of the icon well
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.rightMargin: Math.max(0, (parent.width - Math.min(parent.width, parent.height)) / 2) - width / 3
            anchors.topMargin: Math.max(0, (parent.height - Math.min(parent.width, parent.height)) / 2) - height / 3
        }
    }
}
