import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

import org.kde.kirigami as Kirigami
import org.kde.plasma.components as PlasmaComponents
import org.kde.kquickcontrolsaddons as KQuickAddons
import org.kde.coreaddons as KCoreAddons
import org.kde.notificationmanager as NotificationManager

Rectangle {
    id: notificationItem

    required property int index
    required property var model
    // Shared clock so relative times stay current without a timer per item
    required property date now

    readonly property var notificationModel: root.notificationModel
    readonly property var modelIndex: notificationModel.index(index, 0)
    readonly property date time: model.updated && !isNaN(model.updated.getTime()) ? model.updated : model.created
    readonly property bool hasImage: !imageItem.null
    readonly property string thumbnailIcon: model.iconName && model.iconName !== model.applicationIconName ? model.iconName : ""

    implicitHeight: content.implicitHeight + root.largeSpacing * 2
    radius: root.cardRadius
    color: hoverHandler.hovered && model.hasDefaultAction ? root.cardHoverColor : root.cardColor
    border.width: model.urgency === NotificationManager.Notifications.CriticalUrgency ? 1 : 0
    border.color: Kirigami.Theme.negativeTextColor

    Behavior on color { ColorAnimation { duration: Kirigami.Units.shortDuration } }

    function ageText() {
        if (!time || isNaN(time.getTime())) {
            return "";
        }
        const minutes = Math.floor((now.getTime() - time.getTime()) / 60000);
        if (minutes < 1) {
            return i18nc("Notification was added less than a minute ago", "Just now");
        }
        if (minutes < 60) {
            return i18ncp("Notification was added minutes ago", "%1 min ago", "%1 min ago", minutes);
        }
        return KCoreAddons.Format.formatRelativeDateTime(time, Locale.ShortFormat);
    }

    HoverHandler {
        id: hoverHandler
        cursorShape: notificationItem.model.hasDefaultAction ? Qt.PointingHandCursor : Qt.ArrowCursor
    }

    TapHandler {
        enabled: notificationItem.model.hasDefaultAction
        onTapped: {
            notificationItem.notificationModel.invokeDefaultAction(notificationItem.modelIndex);
            root.expanded = false;
        }
    }

    ColumnLayout {
        id: content
        anchors.fill: parent
        anchors.margins: root.largeSpacing
        spacing: root.smallSpacing

        // App icon, app name and age, with a dismiss button
        RowLayout {
            Layout.fillWidth: true
            spacing: root.smallSpacing

            Kirigami.Icon {
                Layout.preferredWidth: Kirigami.Units.iconSizes.small * root.scale
                Layout.preferredHeight: Layout.preferredWidth
                source: notificationItem.model.applicationIconName || "notification-active-symbolic"
            }

            PlasmaComponents.Label {
                Layout.fillWidth: true
                text: {
                    const app = notificationItem.model.applicationName || i18n("Notification");
                    const origin = notificationItem.model.originName;
                    const age = notificationItem.ageText();
                    return [origin ? i18nc("app name · origin", "%1 · %2", app, origin) : app, age].filter(s => s).join(" · ");
                }
                font.pixelSize: root.smallFontSize
                opacity: 0.7
                elide: Text.ElideRight
                textFormat: Text.PlainText
            }

            PlasmaComponents.ToolButton {
                Layout.preferredWidth: Kirigami.Units.iconSizes.small * root.scale + root.smallSpacing * 2
                Layout.preferredHeight: Layout.preferredWidth
                Layout.topMargin: -root.smallSpacing
                Layout.bottomMargin: -root.smallSpacing
                icon.name: "window-close-symbolic"
                icon.width: Kirigami.Units.iconSizes.small
                icon.height: Kirigami.Units.iconSizes.small
                display: AbstractButton.IconOnly
                text: i18nc("@action:button", "Dismiss")
                visible: notificationItem.model.closable !== false
                opacity: hoverHandler.hovered || activeFocus ? 1 : 0.5
                onClicked: notificationItem.notificationModel.close(notificationItem.modelIndex)

                PlasmaComponents.ToolTip.text: text
                PlasmaComponents.ToolTip.visible: hovered
                PlasmaComponents.ToolTip.delay: Kirigami.Units.toolTipDelay
            }
        }

        // Summary and body, with the notification's image or icon on the right
        RowLayout {
            Layout.fillWidth: true
            spacing: root.largeSpacing

            ColumnLayout {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignTop
                spacing: 2

                PlasmaComponents.Label {
                    Layout.fillWidth: true
                    text: notificationItem.model.summary
                    visible: text.length > 0
                    font.pixelSize: root.mediumFontSize
                    font.weight: Font.DemiBold
                    wrapMode: Text.Wrap
                    maximumLineCount: 2
                    elide: Text.ElideRight
                    textFormat: Text.PlainText
                }

                PlasmaComponents.Label {
                    Layout.fillWidth: true
                    text: notificationItem.model.body
                    visible: text.length > 0
                    font.pixelSize: root.mediumFontSize * 0.95
                    opacity: 0.85
                    wrapMode: Text.Wrap
                    maximumLineCount: 4
                    elide: Text.ElideRight
                    // The server already sanitizes notification markup
                    textFormat: Text.StyledText
                    onLinkActivated: link => Qt.openUrlExternally(link)

                    HoverHandler {
                        cursorShape: parent.hoveredLink ? Qt.PointingHandCursor : undefined
                    }
                }
            }

            KQuickAddons.QImageItem {
                id: imageItem
                Layout.preferredWidth: Kirigami.Units.iconSizes.large * root.scale
                Layout.preferredHeight: Layout.preferredWidth
                Layout.alignment: Qt.AlignTop
                image: notificationItem.model.image
                fillMode: KQuickAddons.QImageItem.PreserveAspectFit
                smooth: true
                visible: notificationItem.hasImage
            }

            Kirigami.Icon {
                Layout.preferredWidth: Kirigami.Units.iconSizes.large * root.scale
                Layout.preferredHeight: Layout.preferredWidth
                Layout.alignment: Qt.AlignTop
                source: notificationItem.thumbnailIcon
                visible: !notificationItem.hasImage && notificationItem.thumbnailIcon !== ""
            }
        }

        // Action buttons supplied by the app
        Flow {
            Layout.fillWidth: true
            Layout.topMargin: root.smallSpacing
            spacing: root.smallSpacing
            visible: actionRepeater.count > 0

            Repeater {
                id: actionRepeater
                model: {
                    const names = notificationItem.model.actionNames || [];
                    const labels = notificationItem.model.actionLabels || [];
                    return names.map((name, i) => ({ name: name, label: labels[i] || name }));
                }

                PlasmaComponents.Button {
                    required property var modelData
                    text: modelData.label
                    onClicked: {
                        notificationItem.notificationModel.invokeAction(notificationItem.modelIndex, modelData.name);
                        root.expanded = false;
                    }
                }
            }
        }
    }
}
