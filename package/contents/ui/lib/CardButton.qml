import QtQuick 2.15
import QtQuick.Layouts 1.15

import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.components as PlasmaComponents
import org.kde.kirigami as Kirigami

Card {
    id: cardButton
    default property alias content: icon.data
    property alias title: title.text
    property alias heading: heading.text
    property bool isLongButton: false // Used in ControlCenter layout
    property bool shouldStickIconSize: false // This property avoids disproportional icon size when not using Lib.Icon
    property bool fullSizeIcon: grid.small && !showTitle && !shouldStickIconSize // Used in 'Tahoe' and 'Custom Layout' 
    property bool showTitle: true
    
    GridLayout {
        id: grid
        anchors.fill: parent
        property bool small: width < root.fullRepWidth/3
        anchors.margins: fullSizeIcon ? 0 : small ? root.smallSpacing : isLongButton ? root.mediumSpacing : root.largeSpacing
        rows: small ? 2 : 2
        columns: small ? 1 : 2
        columnSpacing: small ? 0 : root.largeSpacing
        rowSpacing: 0

        Item {
            id: icon
            Layout.preferredHeight: (parent.small && plasmoid.configuration.layout == 1) ? parent.height/1.8 
                                    : fullSizeIcon ? parent.height - root.largeSpacing
                                    : parent.small ? Math.min(parent.height/1.9, parent.width - root.largeSpacing)
                                    : isLongButton ? parent.height 
                                    : Math.min(parent.height - root.largeSpacing, Kirigami.Units.iconSizes.huge * root.scale * 0.75)
            Layout.preferredWidth: Layout.preferredHeight
            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
            Layout.rowSpan: 2
        }
        PlasmaComponents.Label {
            id: heading
            Layout.fillWidth: true
            Layout.fillHeight: true
            
            font.pixelSize: root.mediumFontSize
            font.weight: Font.DemiBold
            elide: Text.ElideRight
            visible: !parent.small && text
            Layout.rowSpan: (isLongButton && !showTitle) ? 2 : 1
            horizontalAlignment: Qt.AlignLeft
            verticalAlignment: showTitle ? Qt.AlignBottom : Qt.AlignVCenter
        }
        PlasmaComponents.Label {
            id: title
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.margins:  (parent.small || !heading.visible) ? root.smallSpacing : 1
            Layout.rowSpan: heading.visible ? 1 : 2
            font.pixelSize: heading.visible ? root.smallFontSize : root.mediumFontSize
            font.weight: heading.visible ? Font.Normal : Font.DemiBold
            opacity: heading.visible ? 0.7 : 1
            horizontalAlignment: parent.small ? Qt.AlignHCenter : Qt.AlignLeft
            verticalAlignment: !heading.visible ? Qt.AlignVCenter : Qt.AlignTop
            wrapMode: Text.WordWrap
            elide: (plasmoid.configuration.layout == 1 && !isLongButton) ? Text.ElideNone : Text.ElideRight
            visible: text && showTitle
        }
    }
}
