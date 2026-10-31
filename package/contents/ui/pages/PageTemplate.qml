import QtQuick 2.15
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.15
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.components as PlasmaComponents
import org.kde.plasma.components as PlasmaComponents3
import org.kde.plasma.networkmanagement as PlasmaNM
import org.kde.ksvg as KSvg
import "../lib" as Lib
import org.kde.plasma.extras as PlasmaExtras
import org.kde.kirigami as Kirigami


Lib.Card {
    id: page

    // PROPERTIES
    Layout.preferredWidth: root.fullRepWidth
    Layout.preferredHeight: wrapper.implicitHeight
    Layout.minimumWidth: Layout.preferredWidth
    Layout.maximumWidth: Layout.preferredWidth
    Layout.minimumHeight: Layout.preferredHeight
    Layout.maximumHeight: Layout.preferredHeight
    clip: true
    flat: true
    noMargins: true

    property int headerHeight
    property string sectionTitle
    property bool customHeader: false
    property alias extraHeaderItems: extraHeaderItems.data

    default property alias content: dataContainer.data

    anchors.fill: parent
    z: 999

    property bool shown: false
    states: [
        State {
            name: "show"; when: shown
            PropertyChanges { target: page; opacity: 1 }
            PropertyChanges { target: page; visible: true }
        },

        State {
            name: "hide"; when: !shown
            PropertyChanges { target: page; opacity: 0 }
            PropertyChanges { target: page; visible: false }
        }
    ]

    transitions: Transition {
        PropertyAnimation { target: page; property: "opacity"; easing.type: Easing.InOutQuad ; duration: 10}
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: root.smallSpacing
        anchors.margins: 5

        RowLayout {
            id: headerActions

            Layout.fillWidth: true
            visible: !customHeader
            z: page.z+1
            PlasmaComponents.ToolButton {
                Layout.preferredHeight: root.largeFontSize * 2.5
                Layout.preferredWidth: Layout.preferredHeight
                icon.name: mirrored ? "go-next-symbolic" : "go-previous-symbolic"
                display: AbstractButton.IconOnly
                icon.width: Kirigami.Units.iconSizes.smallMedium * root.scale
                icon.height: Kirigami.Units.iconSizes.smallMedium * root.scale
                text: i18n("Back")
                onClicked: fullRep.togglePage();
            }

            // A Label, not a Kirigami.Heading: Heading sets its own point size, which clashes with pixelSize
            PlasmaComponents.Label {
                text: page.sectionTitle
                elide: Text.ElideRight
                font.pixelSize: root.largeFontSize * 1.1
                font.weight: Font.DemiBold
            }

            Item {
                id: extraHeaderItems
                Layout.fillWidth: true
                Layout.preferredHeight: root.largeFontSize * 2.5
                visible: extraHeaderItems
            }

        }

        KSvg.SvgItem {
            id: separatorLine
            visible: !customHeader
            z: 4
            elementId: "horizontal-line"
            Layout.fillWidth: true
            Layout.preferredHeight: root.scale

            svg: KSvg.Svg {
                imagePath: "widgets/line"
            }

        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            id: dataContainer
        }

    }

    Component.onCompleted: {
        page.headerHeight = headerActions.height + separatorLine.height;
    }

}
