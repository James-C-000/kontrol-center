import QtQuick 2.15
import QtQuick.Layouts 1.15
//import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.components as PlasmaComponents
import org.kde.plasma.plasma5support as Plasma5Support
import org.kde.kirigami as Kirigami
import Qt5Compat.GraphicalEffects

import org.kde.plasma.private.mpris as Mpris

import "../lib" as Lib

Lib.Card {
    id: mediaPlayer
    readonly property bool shown: root.showMediaPlayer
    visible: shown
    property bool small: width < (root.fullRepWidth / 4)*3 
    property bool isLongButton: true
    Layout.fillWidth: true
    Layout.fillHeight: true

    GridLayout {
        anchors.fill: parent
        anchors.margins: root.largeSpacing
        columnSpacing: root.largeSpacing

        rows: small ? 4 : 1
        columns: small? 1 : 3

        Image {
            id: audioThumb
            fillMode: Image.PreserveAspectCrop
            source: mediaPlayerPage.albumArt || "../../assets/music.svg"
            Layout.fillHeight: true
            Layout.preferredWidth: height
            Layout.rowSpan: small ? 2 : 1
            enabled: mediaPlayerPage.track || (mediaPlayerPage.playbackStatus > Mpris.PlaybackStatus.Stopped) ? true : false

            ColorOverlay {
                visible: !mediaPlayerPage.albumArt && audioThumb.enabled
                anchors.fill: audioThumb
                source: audioThumb
                color: Kirigami.Theme.textColor
            }

            layer.enabled: true
            layer.effect: OpacityMask {
                maskSource: Item {
                    width: audioThumb.width
                    height: audioThumb.height
                    Rectangle {
                        anchors.centerIn: parent
                        width: audioThumb.adapt ? audioThumb.width : Math.min(audioThumb.width, audioThumb.height)
                        height: audioThumb.adapt ? audioThumb.height : width
                        radius: root.controlRadius * 1.5
                    }
                }
            }
        }
        ColumnLayout {
            id: mediaNameWrapper
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter
            spacing: 0

            PlasmaComponents.Label {
                id: audioTitle
                Layout.fillWidth: true
                font.weight: Font.DemiBold
                font.pixelSize: root.mediumFontSize
                enabled: mediaPlayerPage.track || (mediaPlayerPage.playbackStatus > Mpris.PlaybackStatus.Stopped) ? true : false
                elide: Text.ElideRight
                text: mediaPlayerPage.track ? mediaPlayerPage.track : (mediaPlayerPage.playbackStatus > Mpris.PlaybackStatus.Stopped) ? i18n("No title") : i18n("No media playing")
            }
            PlasmaComponents.Label {
                id: audioArtist
                Layout.fillWidth: true
                font.pixelSize: root.smallFontSize
                opacity: 0.7
                visible: text.length > 0
                text: mediaPlayerPage.artist
                elide: Text.ElideRight
            }
        }
        RowLayout {
            id: audioControls
            Layout.alignment: small ? Qt.AlignHCenter : Qt.AlignRight
            Layout.fillWidth: false
            spacing: 0

            PlasmaComponents.ToolButton {
                id: previousButton
                icon.width: Kirigami.Units.iconSizes.smallMedium * root.scale
                icon.height: Kirigami.Units.iconSizes.smallMedium * root.scale
                icon.name: "media-skip-backward"
                enabled: mediaPlayerPage.canGoPrevious
                onClicked: {
                    //seekSlider.value = 0    // Let the media start from beginning. Bug 362473
                    mediaPlayerPage.previous()
                }
            }

            PlasmaComponents.ToolButton { // Pause/Play
                id: playPauseButton

                icon.width: Kirigami.Units.iconSizes.smallMedium * root.scale
                icon.height: Kirigami.Units.iconSizes.smallMedium * root.scale

                Layout.alignment: Qt.AlignVCenter
                enabled: mediaPlayerPage.isPlaying ? mediaPlayerPage.canPause : mediaPlayerPage.canPlay
                icon.name: mediaPlayerPage.isPlaying ? "media-playback-pause" : "media-playback-start"

                onClicked: mediaPlayerPage.togglePlaying()
            }


            PlasmaComponents.ToolButton {
                id: nextButton
                icon.width: Kirigami.Units.iconSizes.smallMedium * root.scale
                icon.height: Kirigami.Units.iconSizes.smallMedium * root.scale
                icon.name: "media-skip-forward"
                enabled: mediaPlayerPage.canGoNext
                onClicked: {
                    //seekSlider.value = 0    // Let the media start from beginning. Bug 362473
                    mediaPlayerPage.next()
                }
            }
        }
    }

    onClicked: {
        fullRep.togglePage(fullRep.defaultInitialWidth, fullRep.defaultInitialHeight, mediaPlayerPage);
    }
}
