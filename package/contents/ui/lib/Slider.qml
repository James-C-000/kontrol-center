import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.components as PlasmaComponents
import org.kde.kirigami as Kirigami 

Card {
    id: sliderComp
    // Only the arrow button opens the details page, so the card itself isn't a click target
    interactive: false
    signal moved
    signal actionButtonClicked

    property bool pressed: false
    property alias title: title.text
    property alias secondaryTitle: secondaryTitle.text
    property var value: 0
    property bool useIconButton: false
    property string source

    property bool canTogglePage: false

    property bool showTitle: true
    property bool thinSlider: false
    property bool mediumSizeSlider: false

    property int from: 0
    property int to: 100
    property real stepSize: 2

    property color highlightColor: root.useSystemColorsOnSliders ? root.themeHighlightColor : root.slidersColor

    // Helps to play volume feedback while moving with cursor
    Binding { sliderComp.pressed: sliderLoader.item.pressed }

    // Binds slider value whent it's changed by keyboard
    Binding { 
        target: sliderLoader.item
        property: "value"
        value: sliderComp.value
        restoreMode: Binding.RestoreBindingOrValue
    }

    Connections {
        target: sliderLoader.item
        function onMoved() {
            sliderComp.value = sliderLoader.item.value;
            sliderComp.moved();
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: root.largeSpacing
        clip: true
        spacing: 1

        RowLayout {
            Layout.fillHeight: true
            Layout.fillWidth: true
            spacing: 1
            visible: showTitle

            PlasmaComponents.Label {
                id: title
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignLeft
                font.pixelSize: root.mediumFontSize
                font.weight: Font.DemiBold
                elide: Text.ElideRight
            }

            PlasmaComponents.Label {
                id: secondaryTitle
                visible: root.showPercentage
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignRight
                font.pixelSize: root.mediumFontSize
                font.features: { "tnum": 1 }
                opacity: 0.7
                horizontalAlignment: Text.AlignRight
            }


        }
        RowLayout {
            Layout.fillHeight: true
            Layout.fillWidth: true
            spacing: 0

            Kirigami.Icon {
                id: icon
                source: sliderComp.source
                visible: !sliderComp.useIconButton
                Layout.preferredHeight: Kirigami.Units.iconSizes.smallMedium * root.scale
                Layout.preferredWidth: Layout.preferredHeight
                Layout.margins: 0
                Layout.rightMargin: root.smallSpacing
            }
            
            PlasmaComponents.ToolButton {
                id: iconButton
                visible: sliderComp.useIconButton
                icon.name: sliderComp.source
                display: AbstractButton.IconOnly
                text: i18n("Mute")
                icon.width: Kirigami.Units.iconSizes.smallMedium * root.scale
                icon.height: Kirigami.Units.iconSizes.smallMedium * root.scale
                Layout.preferredHeight: root.largeFontSize*2
                Layout.preferredWidth: Layout.preferredHeight
                onClicked: sliderComp.actionButtonClicked()
            }

            Loader {
                id: sliderLoader
                sourceComponent: root.usePlasmaSliders ? plasmaSlider : customSlider
                Layout.fillWidth: true
                Layout.margins: 0

                onLoaded: { sliderLoader.item.value = sliderComp.value; }
            }

            Component {
                id: customSlider

                Slider {
                    id: slider
                    Layout.fillWidth: true
                    Layout.margins: 0
                    from: sliderComp.from
                    to: sliderComp.to
                    stepSize: sliderComp.stepSize
                    snapMode: Slider.SnapAlways

                    background: Rectangle {
                        x: slider.leftPadding
                        y: slider.topPadding + slider.availableHeight / 2 - height / 2
                        implicitWidth: 200
                        implicitHeight: thinSlider ? 6 : mediumSizeSlider ? 10 : 16
                        width: slider.availableWidth
                        height: parent.height
                        radius: height / 2
                        color: root.wellColor
                        border.width: 0

                        Rectangle {
                            id: levelIndicator
                            width: (value - from) / (to - from) * (slider.width - handle.width) + (handle.width)
                            height: parent.height - 2
                            color:  highlightColor
                            radius: height / 2
                            border.width: 0
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    handle: Rectangle {
                        id: handle
                        x: slider.leftPadding + slider.visualPosition * (slider.availableWidth - width)
                        y: slider.topPadding + slider.availableHeight / 2 - height / 2
                        implicitWidth: thinSlider ? 17 : 
                                        (mediumSizeSlider&&(slider.hovered || slider.pressed)) ? levelIndicator.height*3.7 : 
                                        levelIndicator.height
                        implicitHeight: thinSlider ? 17 : 
                                        (mediumSizeSlider&&(slider.hovered || slider.pressed)) ? levelIndicator.height*2.5 :
                                        levelIndicator.height
                        radius: mediumSizeSlider ? 10 : height / 2
                        color: mediumSizeSlider && slider.pressed ? "transparent" : Kirigami.Theme.highlightedTextColor
                        border.color: highlightColor
                        border.width: 2
                        Behavior on implicitWidth {
                            NumberAnimation { duration: 200 }
                        }
                    }

                    WheelHandler {
                        orientation: Qt.Vertical | Qt.Horizontal
                        property int wheelDelta: 0
                        acceptedButtons: Qt.NoButton
                        acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
                        onWheel: wheel => {
                            const lastValue = slider.value
                            // We want a positive delta to increase the slider for up/right scrolling,
                            // independently of the scrolling inversion setting
                            // The x-axis is also inverted (scrolling right produce negative values)
                            const delta = (wheel.angleDelta.y || -wheel.angleDelta.x) * (wheel.inverted ? -1 : 1)
                            wheelDelta += delta;
                            // magic number 120 for common "one click"
                            // See: https://doc.qt.io/qt-6/qml-qtquick-wheelevent.html#angleDelta-prop
                            while (wheelDelta >= 120) {
                                wheelDelta -= 120;
                                slider.increase();
                            }
                            while (wheelDelta <= -120) {
                                wheelDelta += 120;
                                slider.decrease();
                            }
                            if (lastValue !== slider.value) {
                                slider.moved();
                            }
                        }     
                    }
                }

            }

            Component {
                id: plasmaSlider

                PlasmaComponents.Slider {
                    id: slider
                    Layout.fillWidth: true
                    Layout.margins: 0
                    from: sliderComp.from
                    to: sliderComp.to
                    stepSize: sliderComp.stepSize
                    snapMode: Slider.SnapAlways
                }
            }
            
            PlasmaComponents.ToolButton {
                id: openVolumePageButton
                visible: sliderComp.canTogglePage
                icon.name: "go-next-symbolic"
                display: AbstractButton.IconOnly
                text: i18n("Show details")
                icon.width: Kirigami.Units.iconSizes.small * root.scale
                icon.height: Kirigami.Units.iconSizes.small * root.scale
                Layout.preferredHeight: root.largeFontSize*2
                Layout.preferredWidth: Layout.preferredHeight
                onClicked: sliderComp.clicked()
            }
        }
    }
}
