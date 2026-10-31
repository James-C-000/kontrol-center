import QtQml 2.15
import QtQuick 2.15
import QtQuick.Layouts 1.15

import org.kde.kdeconnect as KdeConnect
import org.kde.plasma.core as PlasmaCore
import org.kde.kirigami as Kirigami

import "../lib" as Lib
import "../js/funcs.js" as Funcs

Lib.CardButton {
    readonly property bool shown: root.showKDEConnect
    visible: shown
    Layout.fillWidth: true
    Layout.fillHeight: true
    title: i18n("KDE Connect")
    Lib.Icon {
        anchors.fill: parent
        source: "kdeconnect-tray"
    }
    onClicked: KdeConnect.OpenConfig.openConfiguration();
}