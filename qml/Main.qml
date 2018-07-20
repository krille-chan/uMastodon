import QtQuick 2.4
import QtQuick.Layouts 1.1
import Ubuntu.Components 1.3
import Qt.labs.settings 1.0
import "token.js" as Token
import "components"
import "pages"

MainView {
    id: root
    objectName: 'mainView'
    applicationName: 'umastodon.christianpauly'
    automaticOrientation: true

    width: units.gu(45)
    height: units.gu(75)

    readonly property var version: "1.3"

    property var instance: "mastodon.social"
    property var token: Token.token

    // automatically anchor items to keyboard that are anchored to the bottom
    anchorToKeyboard: true

    PageStack {
        id: mainStack
    }

    Settings {
        id: settings
        property var instance
    }

    Component.onCompleted: {
        if ( settings.instance ) {
            mainStack.push(Qt.resolvedUrl("./pages/MastodonWebview.qml"))
        }
        else {
            mainStack.push(Qt.resolvedUrl("./pages/InstancePicker.qml"))
        }
    }
}
