import QtQuick 2.15
import QtQml 2.15
import QtQuick.Layouts 1.15
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.components as PlasmaComponents
import org.kde.kirigami as Kirigami

Rectangle {
    id: rectangle
    color: "transparent"
    border.width: root.editingLayout ? 1 : 0
    border.color: root.editingLayout ? root.disabledBgColor : "transparent"

    /******
     Small widgets such as UserAvatar use reduced top and bottom margins so their content isn't cut
    *******/
    property bool smallTopMargins: false
    property bool smallBottomMargins: false
    property bool smallLeftMargins: false
    property bool smallRightMargins: false
    /******
     This is used to manage widget background color so we can change the color depending on widget status(Command Run)
    *******/
    property alias customBgColor: cardBg.color


    property bool flat: false

    // Kept for compatibility with layouts that set it; cards are drawn flat in the Breeze style
    property bool shadow: false

    property bool filled:  flat ? false : true

    property bool bordr:  flat ? false : true

    property bool glassEffect: false

    property bool noMargins: false

    property bool roundedWidget: false

    property int cornerRadius: roundedWidget ? height / 2 : root.cardRadius

    // Gap between the visible card and its layout cell, which spaces neighbouring cards apart
    readonly property int gap: Math.round(root.smallSpacing * 0.75)
    property var margins: gap
    default property alias content: dataContainer.data
    radius: cornerRadius

    property bool hovered: false
    property bool showContentOverflowIndicator: false
    // Cards that respond to clicks get a hover highlight
    property bool interactive: true

    signal clicked

    MouseArea {
        id: cardMouseArea
        anchors.fill: cardBg
        enabled: !root.editingLayout
        hoverEnabled: enabled
        cursorShape: rectangle.interactive ? Qt.PointingHandCursor : Qt.ArrowCursor

        onEntered: rectangle.hovered = true;
        onExited: rectangle.hovered = false;

        onClicked: rectangle.clicked()
    }

    Rectangle {
        id: cardBg
        anchors.fill: parent
        anchors.margins: rectangle.gap
        color: !filled ? "transparent"
               : (rectangle.hovered && rectangle.interactive) ? root.cardHoverColor
               : root.cardColor

        border.color: (rectangle.hovered && rectangle.interactive && filled)
                      ? Qt.rgba(Kirigami.Theme.highlightColor.r, Kirigami.Theme.highlightColor.g, Kirigami.Theme.highlightColor.b, 0.6)
                      : root.cardBorderColor
        border.width: !(root.showBorders && bordr) ? 0
                      : (rectangle.hovered && rectangle.interactive && filled) ? 2
                      : 1
        radius: cornerRadius
        z: -1

        Behavior on color { ColorAnimation { duration: Kirigami.Units.shortDuration } }
        Behavior on border.color { ColorAnimation { duration: Kirigami.Units.shortDuration } }
    }

    Item {
        id: dataContainer
        anchors.fill: parent
        anchors.topMargin: noMargins ? -1 : smallTopMargins ? 2 : 5
        anchors.bottomMargin: noMargins ? -1 : smallBottomMargins ? 2 : 5
        anchors.leftMargin: (noMargins || smallLeftMargins) ? -1 : 5
        anchors.rightMargin: (noMargins || smallRightMargins) ? -1 : 5
    }

    Kirigami.Icon {
        id: contentOverflowIndicator
        visible: showContentOverflowIndicator
        source: "go-next-symbolic"
        width: Kirigami.Units.iconSizes.small
        height: width
        opacity: rectangle.hovered ? 0.8 : 0
        anchors.right: cardBg.right
        anchors.rightMargin: root.mediumSpacing
        anchors.verticalCenter: cardBg.verticalCenter

        Behavior on opacity { NumberAnimation { duration: Kirigami.Units.shortDuration } }
    }
}
