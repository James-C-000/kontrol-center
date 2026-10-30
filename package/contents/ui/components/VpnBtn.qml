import QtQml 2.15
import QtQuick 2.15
import QtQuick.Layouts 1.15

import org.kde.plasma.networkmanagement as PlasmaNM
import org.kde.kitemmodels as KItemModels

import "../lib" as Lib

Lib.CardButton {
    id: vpnBtn

    // NetworkManager::ConnectionSettings::WireGuard, which PlasmaNM.Enums doesn't expose
    readonly property int wireGuardType: 19

    // One entry per VPN connection (WireGuard included), newest first
    property var vpns: []
    readonly property var activeVpn: vpns.find(vpn => vpn.state === PlasmaNM.Enums.Activated) ?? null
    readonly property var busyVpn: vpns.find(vpn => vpn.state === PlasmaNM.Enums.Activating
                                                    || vpn.state === PlasmaNM.Enums.Deactivating) ?? null

    visible: vpns.length > 0
    Layout.fillWidth: true
    Layout.fillHeight: true
    showContentOverflowIndicator: isLongButton

    heading: isLongButton ? i18n("VPN") : ""
    title: busyVpn ? (busyVpn.state === PlasmaNM.Enums.Activating ? i18n("Connecting…") : i18n("Disconnecting…"))
         : activeVpn ? activeVpn.name
         : isLongButton ? i18n("Not connected") : i18n("VPN")

    function refresh() {
        const list = [];
        for (let i = 0; i < vpnInstantiator.count; ++i) {
            const item = vpnInstantiator.objectAt(i);
            if (item) {
                list.push({ name: item.name, state: item.state, timestamp: item.timestamp,
                            path: item.path, device: item.device, specific: item.specific });
            }
        }
        list.sort((a, b) => b.timestamp - a.timestamp);
        vpns = list;
    }

    function toggle() {
        const handler = networkPage.handler;
        if (activeVpn) {
            handler.deactivateConnection(activeVpn.path, activeVpn.device);
        } else if (busyVpn) {
            handler.deactivateConnection(busyVpn.path, busyVpn.device);
        } else if (vpns.length > 0) {
            handler.activateConnection(vpns[0].path, vpns[0].device, vpns[0].specific);
        }
    }

    Instantiator {
        id: vpnInstantiator
        model: KItemModels.KSortFilterProxyModel {
            sourceModel: networkPage.appletProxyModel
            filterRowCallback: (sourceRow, sourceParent) => {
                const idx = sourceModel.index(sourceRow, 0, sourceParent);
                const type = sourceModel.data(idx, PlasmaNM.NetworkModel.TypeRole);
                return type === PlasmaNM.Enums.Vpn || type === vpnBtn.wireGuardType;
            }
        }
        delegate: QtObject {
            required property var model
            readonly property string name: model.ItemUniqueName
            readonly property int state: model.ConnectionState
            readonly property real timestamp: model.TimeStamp ? new Date(model.TimeStamp).getTime() || 0 : 0
            readonly property string path: model.ConnectionPath
            readonly property string device: model.DevicePath
            readonly property string specific: model.SpecificPath

            onStateChanged: Qt.callLater(vpnBtn.refresh)
            onNameChanged: Qt.callLater(vpnBtn.refresh)
        }
        onObjectAdded: Qt.callLater(vpnBtn.refresh)
        onObjectRemoved: Qt.callLater(vpnBtn.refresh)
    }

    Lib.Icon {
        anchors.fill: parent
        source: "network-vpn-symbolic"
        selected: vpnBtn.activeVpn !== null
        enableQuickAction: root.enableQuickActions
        onQuickActionTriggered: vpnBtn.toggle()
    }

    onClicked: fullRep.togglePage(fullRep.defaultInitialWidth, 400, networkPage);
}
