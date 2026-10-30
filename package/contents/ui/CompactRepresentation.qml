import QtQml 2.15
import QtQuick 2.15
import QtQuick.Layouts 1.15
//import QtGraphicalEffects 1.0

import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.workspace.components as WorkspaceComponents
import org.kde.kirigami as Kirigami
Item {
    id: compactRep
    
    readonly property bool useCustomButtonImage: (Plasmoid.configuration.useCustomButtonImage && Plasmoid.configuration.customButtonImage.length != 0)
    
    RowLayout {
        anchors.fill: parent
        
        Kirigami.Icon {
            id: compactIcon
            Layout.fillWidth: true
            Layout.fillHeight: true
            source: useCustomButtonImage ? Plasmoid.configuration.customButtonImage : Plasmoid.configuration.icon
            active: mouseArea.containsMouse
            smooth: true
            
            MouseArea {
                id: mouseArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    root.expanded = !root.expanded
                }
            }
        }
    }

    // Unread notification count, the same badge Plasma's notification applet uses
    WorkspaceComponents.BadgeOverlay {
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        visible: root.unreadNotifications > 0
        text: root.unreadNotifications > 99 ? "99+" : root.unreadNotifications
        icon: compactIcon
    }
}
