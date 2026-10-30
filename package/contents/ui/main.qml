import QtQuick 2.15
import QtQuick.Controls 2.15
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import "js/colorType.js" as ColorType
import org.kde.kirigami as Kirigami
import org.kde.kitemmodels as KItemModels
import org.kde.plasma.plasma5support as Plasma5Support
import org.kde.notificationmanager as NotificationManager

PlasmoidItem {
    id: root
    
    clip: true

    // PROPERTIES
    property bool animations: plasmoid.configuration.animations
    property bool showBorders: Plasmoid.configuration.showBorders
    property var animationDuration: Kirigami.Units.veryShortDuration

    property bool preferChangeGlobalTheme: Plasmoid.configuration.preferChangeGlobalTheme
    property string generalLightTheme: preferChangeGlobalTheme ? Plasmoid.configuration.lightGlobalTheme : Plasmoid.configuration.lightTheme
    property string generalDarkTheme: preferChangeGlobalTheme ? Plasmoid.configuration.darkGlobalTheme : Plasmoid.configuration.darkTheme

    property var scale: Plasmoid.configuration.scale * 1 / 100
    property int fullRepWidth: { 
        switch (plasmoid.configuration.layout) {
            case 0: return 420 * scale;
            case 3: return 330 * scale;
            case 4: return 330 * scale; //custom/
            default: return 380 * scale
        }
    }
    property int fullRepHeight: 380 * scale
    property int sectionHeight: 180 * scale

    property int largeSpacing: Kirigami.Units.largeSpacing * scale
    property int mediumSpacing: Kirigami.Units.mediumSpacing * scale
    property int smallSpacing: Kirigami.Units.smallSpacing * scale

    property int buttonMargin: 4 * scale
    property int buttonHeight: 48 * scale

    // Font sizes follow the system font, so the widget matches the rest of Plasma
    readonly property real defaultFontPixelSize: Kirigami.Theme.defaultFont.pixelSize > 0
        ? Kirigami.Theme.defaultFont.pixelSize : Kirigami.Theme.defaultFont.pointSize * 4 / 3
    readonly property real smallFontPixelSize: Kirigami.Theme.smallFont.pixelSize > 0
        ? Kirigami.Theme.smallFont.pixelSize : Kirigami.Theme.smallFont.pointSize * 4 / 3
    property int largeFontSize: Math.round(defaultFontPixelSize * 1.15 * scale)
    property int mediumFontSize: Math.round(defaultFontPixelSize * scale)
    property int smallFontSize: Math.round(smallFontPixelSize * scale)

    property int itemSpacing: 8

    // Shape shared by every card, button and slider
    readonly property int cardRadius: Kirigami.Units.cornerRadius * 2
    readonly property int controlRadius: Kirigami.Units.cornerRadius

    // COlors variables
    property color themeBgColor: Kirigami.Theme.backgroundColor
    property color themeHighlightColor: Kirigami.Theme.highlightColor
    property bool isDarkTheme: ColorType.isDark(themeBgColor)
    property color disabledBgColor: isDarkTheme ? Qt.rgba(255, 255, 255, 0.15) : Qt.rgba(0, 0, 0, 0.15)
    property color redColor: Kirigami.Theme.negativeTextColor

    // Card surfaces are a light tint of the text color over the popup background,
    // the same way Breeze draws grouped frames
    property color cardColor: Qt.rgba(Kirigami.Theme.textColor.r, Kirigami.Theme.textColor.g, Kirigami.Theme.textColor.b,
                                      isDarkTheme ? 0.055 : 0.04)
    property color cardHoverColor: Qt.rgba(Kirigami.Theme.textColor.r, Kirigami.Theme.textColor.g, Kirigami.Theme.textColor.b,
                                           isDarkTheme ? 0.09 : 0.07)
    property color cardBorderColor: Qt.rgba(Kirigami.Theme.textColor.r, Kirigami.Theme.textColor.g, Kirigami.Theme.textColor.b,
                                            isDarkTheme ? 0.07 : 0.1)
    property color wellColor: Qt.rgba(Kirigami.Theme.textColor.r, Kirigami.Theme.textColor.g, Kirigami.Theme.textColor.b, 0.1)
    
    // Main Icon
     Plasmoid.icon: Plasmoid.configuration.useCustomButtonImage ? Plasmoid.configuration.customButtonImage : Plasmoid.configuration.icon
    
    // Components
    property bool showKDEConnect: Plasmoid.configuration.showKDEConnect
    property bool showNightLight: Plasmoid.configuration.showNightLight
    property bool showColorSwitcher: Plasmoid.configuration.showColorSwitcher
    property bool showDnd: Plasmoid.configuration.showDnd
    property bool showVolume: Plasmoid.configuration.showVolume
    property bool showBrightness: Plasmoid.configuration.showBrightness
    property bool showMediaPlayer: Plasmoid.configuration.showMediaPlayer
    property bool showAvatar: Plasmoid.configuration.showAvatar
    property bool showBattery: Plasmoid.configuration.showBattery
    property bool showSessionActions: Plasmoid.configuration.showSessionActions
    property bool showScreenshot: Plasmoid.configuration.showScreenshot
    property bool showCmd1: Plasmoid.configuration.showCmd1
    property bool showCmd2: Plasmoid.configuration.showCmd2
    property bool showPercentage: Plasmoid.configuration.showPercentage
    
    property string cmdRun1: Plasmoid.configuration.cmdRun1
    property string cmdTitle1: Plasmoid.configuration.cmdTitle1
    property string cmdIcon1: Plasmoid.configuration.cmdIcon1
    property string cmdRun2: Plasmoid.configuration.cmdRun2
    property string cmdTitle2: Plasmoid.configuration.cmdTitle2
    property string cmdIcon2: Plasmoid.configuration.cmdIcon2

    property bool volume_widget_flat: Plasmoid.configuration.volume_widget_flat
    property bool volume_widget_title: Plasmoid.configuration.volume_widget_title
    property bool volume_widget_thin: Plasmoid.configuration.volume_widget_thin
    property bool brightness_widget_flat: Plasmoid.configuration.brightness_widget_flat
    property bool brightness_widget_title: Plasmoid.configuration.brightness_widget_title
    property bool brightness_widget_thin: Plasmoid.configuration.brightness_widget_thin

    property bool useSystemColorsOnToggles: Plasmoid.configuration.useSystemColorsOnToggles
    property bool useSystemColorsOnSliders: Plasmoid.configuration.useSystemColorsOnSliders
    property color toggleButtonsColor: Plasmoid.configuration.toggleButtonsColor
    property color toggleButtonsIconColor: Plasmoid.configuration.toggleButtonsIconColor
    property color slidersColor: Plasmoid.configuration.slidersColor
    property bool usePlasmaSliders: Plasmoid.configuration.usePlasmaSliders

    property bool hideWidgetBeforeScreenshot: Plasmoid.configuration.hideWidgetOnScreenshot
    property string screenshotCommand: Plasmoid.configuration.screenshotCommand

    property bool editingLayout: false

    // Enables quick action(triggering action when clicking icon) on Quick toggle buttons
    property bool enableQuickActions: Plasmoid.configuration.enableQuickActions

    readonly property var layouts: {
        "Default": 0, 
        "ControlCenter": 1,
        "Flat": 2,
        "Tahoe": 3,
        "Custom": 4
    }

    readonly property bool inPanel: (Plasmoid.location === PlasmaCore.Types.TopEdge
        || Plasmoid.location === PlasmaCore.Types.RightEdge
        || Plasmoid.location === PlasmaCore.Types.BottomEdge
        || Plasmoid.location === PlasmaCore.Types.LeftEdge)

    property int plasmaVersion

    Plasma5Support.DataSource {
        id: executable
        engine: "executable"
        connectedSources: ["plasmashell -v"]
        onNewData: (sourceName, data) => {
            if(data["exit code"] == 0){
                plasmaVersion = data.stdout.split(" ")[1].split(".")[1];
            }
            disconnectSource(connectedSources)
        }
    }
    
    // NOTIFICATIONS
    // Creating a notifications model registers Plasma's notification server inside plasmashell,
    // so this widget receives every notification and lists them without showing any popups.
    property alias notificationSettings: notificationSettings
    property alias notificationModel: notificationModel
    // Notifications that arrived since the notification list was last viewed. Plasma's own unread
    // count only covers popups that timed out unseen, which never happens without popups.
    property int unreadNotifications: 0
    property date notificationsSeenAt: new Date(0)

    function countUnreadNotifications() {
        let unread = 0;
        for (let i = 0; i < notificationModel.count; ++i) {
            const idx = notificationModel.index(i, 0);
            const updated = notificationModel.data(idx, NotificationManager.Notifications.UpdatedRole);
            const time = updated && !isNaN(updated.getTime()) ? updated
                       : notificationModel.data(idx, NotificationManager.Notifications.CreatedRole);
            if (time && time > notificationsSeenAt) {
                ++unread;
            }
        }
        unreadNotifications = unread;
    }

    function markNotificationsSeen() {
        notificationsSeenAt = new Date();
        notificationModel.lastRead = notificationsSeenAt;
        countUnreadNotifications();
    }

    Connections {
        target: notificationModel
        function onCountChanged() { Qt.callLater(root.countUnreadNotifications); }
        function onDataChanged() { Qt.callLater(root.countUnreadNotifications); }
    }

    NotificationManager.Settings {
        id: notificationSettings
    }

    NotificationManager.Notifications {
        id: notificationModel
        showNotifications: true
        showJobs: false
        showExpired: true
        showDismissed: true
        showAddedDuringInhibition: true
        groupMode: NotificationManager.Notifications.GroupDisabled
        sortMode: NotificationManager.Notifications.SortByDate
        sortOrder: Qt.DescendingOrder
        urgencies: NotificationManager.Notifications.CriticalUrgency
                   | NotificationManager.Notifications.NormalUrgency
                   | (notificationSettings.lowPriorityHistory ? NotificationManager.Notifications.LowUrgency : 0)
        // This list stands in for popups, so it follows the per-app "Show popups" setting
        blacklistedDesktopEntries: notificationSettings.popupBlacklistedApplications
        blacklistedNotifyRcNames: notificationSettings.popupBlacklistedServices
    }

    // Stand-in for the popup lifecycle. With no popups this list is where notifications get acted on,
    // so they stay live (actions included) until dismissed. Only an app-requested timeout expires one,
    // which keeps it listed without actions, and transient ones (e.g. OSD-style messages) are closed.
    NotificationManager.Notifications {
        id: pendingNotifications
        showNotifications: true
        showJobs: false
        showExpired: false
        showDismissed: false
        groupMode: NotificationManager.Notifications.GroupDisabled
    }

    Instantiator {
        model: pendingNotifications
        delegate: Timer {
            required property int index
            required property var model
            interval: model.timeout > 0 ? model.timeout : notificationSettings.popupTimeout
            running: !model.resident && (model.timeout > 0 || model.transient)
            onTriggered: {
                const idx = pendingNotifications.index(index, 0);
                if (model.transient) {
                    pendingNotifications.close(idx);
                } else {
                    pendingNotifications.expire(idx);
                }
            }
        }
    }

    switchHeight: fullRepWidth
    switchWidth: fullRepWidth
    preferredRepresentation: inPanel ? Plasmoid.compactRepresentation : Plasmoid.fullRepresentation
    fullRepresentation: FullRepresentation { }
    compactRepresentation: CompactRepresentation {}

    Plasmoid.contextualActions: [
        PlasmaCore.Action {
            text: i18n("Edit Layout")
            icon.name: "document-edit-symbolic"
            visible: (Plasmoid.immutability !== PlasmaCore.Types.SystemImmutable) 
                     && Plasmoid.configuration.layout == layouts.Custom
            onTriggered: root.editingLayout = true
        }
    ]
}
