import QtQuick 2.9
import Ubuntu.Components 1.3

Rectangle {
    anchors.fill: parent
    visible: !webView.visible
    color: "#191b22"

    signal refreshClicked()

    Label {
        id: progressLabel
        color: "white"
        text: i18n.tr('Error while loading ') + settings.instance
        anchors.left: parent.left
        anchors.right: parent.right
        horizontalAlignment: Text.AlignHCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.margins: units.gu(2)
        wrapMode: text.WordWrap
        textSize: Label.Large
    }

    Button {
        anchors.top: progressLabel.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 10
        text: i18n.tr("Refresh page")
        onClicked: refreshClicked()
    }

    Button {
        anchors.bottom: parent.bottom
        anchors.bottomMargin: height
        anchors.horizontalCenter: parent.horizontalCenter
        color: UbuntuColors.red
        text: "Choose another Instance"
        onClicked: {
            mainStack.clear ()
            mainStack.push (Qt.resolvedUrl("../pages/InstancePicker.qml"))
            settings.instance = settings.token = settings.push = undefined
        }
    }
}
