import QtQml 2.15
import QtQuick 2.15
import QtQuick.Layouts 1.15

import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasma5support as Plasma5Support
import org.kde.kirigami as Kirigami

import "../lib" as Lib
import "../js/funcs.js" as Funcs

Lib.CardButton {
    id: cmdRunButton
    Layout.fillWidth: true
    Layout.fillHeight: true
    property string icon;
    property string command;
    
    function exec(cmd) {
        executable.connectSource(cmd)
    }
    
    Lib.Icon {
        anchors.fill: parent
        source: icon
    }
    
    Timer {
        id: timer
        interval: 1500; 
        onTriggered: {
            cmdRunButton.customBgColor = "transparent";
        }
    }
    
    Plasma5Support.DataSource {
        id: executable
        engine: "executable"
        connectedSources: []

        onNewData: (sourceName, data) => {
            disconnectSource(sourceName)
            if(data["exit code"] == 0){
                timer.running = false;
                timer.restart();
                cmdRunButton.customBgColor = Kirigami.Theme.positiveTextColor;
                timer.running = true;
                
            } else {
                cmdRunButton.customBgColor = Kirigami.Theme.negativeTextColor;
                timer.running = true;
            }
        }
    }
    
    onClicked: {
        exec(command)
    }
}