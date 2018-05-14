import QtQuick 2.4
import QtQuick.Layouts 1.1
import Ubuntu.Components 1.3
import Ubuntu.Web 0.2


Page {
    id: mastodonWebviewPage
    anchors.fill: parent

    header: PageHeader {
        id: header
        title: i18n.tr('Loading ') + instance + " ..."
        StyleHints {
            foregroundColor: "white"
            backgroundColor: "#393f4f"
        }
    }

    ActivityIndicator {
        id: indicator
        anchors.centerIn: parent
        running: true
        visible: running
    }

    Timer {
        interval: 1000
        repeat: false
        running: true
        onTriggered: {
            mainStack.clear ()
            mainStack.push ( Qt.resolvedUrl("./MastodonWebview.qml") )
        }
    }

    Button {
        anchors.bottom: parent.bottom
        anchors.bottomMargin: height
        anchors.horizontalCenter: parent.horizontalCenter
        text: "Choose another Instance"
        onClicked: {
            db.transaction(
                function(tx) {
                    tx.executeSql('DELETE FROM Url')
                    mainStack.clear ()
                    mainStack.push (Qt.resolvedUrl("./InstancePicker.qml"))
                }
            )
        }
    }
}
