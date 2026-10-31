import QtQuick 2.15
import QtQuick.Layouts 1.15
import org.kde.plasma.core as PlasmaCore
import org.kde.kirigami as Kirigami


Item
{
    id: iconItem
    property color sourceColor
    property alias source: icon.source
    property alias selected: icon.selected
    property bool fullSizeIcon : false
    property bool customIcon: false
    property bool enableQuickAction: false

    signal quickActionTriggered

    property color highlightColor: root.useSystemColorsOnToggles ? root.themeHighlightColor : root.toggleButtonsColor
    property color iconColor: root.useSystemColorsOnToggles ?  Kirigami.Theme.highlightedTextColor : root.toggleButtonsIconColor

    // Round cards (Tahoe layout) get a round well to match
    readonly property bool round: {
        for (let item = parent; item; item = item.parent) {
            if (item.roundedWidget !== undefined) {
                return item.roundedWidget;
            }
        }
        return false;
    }

    Rectangle {
        id: rect
        // Rounded square well, centered in whatever space the layout gives us
        width: Math.min(parent.width, parent.height)
        height: width
        anchors.centerIn: parent
        radius: iconItem.round ? width / 2 : root.cardRadius
        color: {
            const base = icon.selected ? highlightColor : sourceColor.valid ? sourceColor : root.wellColor;
            return mouseArea.containsMouse ? Qt.lighter(base, root.isDarkTheme ? 1.25 : 1.08) : base;
        }

        Behavior on color { ColorAnimation { duration: Kirigami.Units.shortDuration } }

        Kirigami.Icon {
            id: icon
            anchors.centerIn: parent
            width: Math.round(parent.width * (fullSizeIcon ? 0.5 : 0.64))
            height: width
            selected: false
            isMask: customIcon
            color: selected ? iconColor : Kirigami.Theme.textColor
        }
    }

    MouseArea {
        id: mouseArea
        enabled: !root.editingLayout && enableQuickAction
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        anchors.fill: rect

        onClicked: quickActionTriggered()
    }
}
