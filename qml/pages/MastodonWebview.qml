import QtQuick 2.4
import QtQuick.Layouts 1.1
import Ubuntu.Components 1.3
import Ubuntu.Web 0.2
import "../components"

Page {
    id: page
    width: parent.width
    height: parent.height

    header: Rectangle {
        color: UbuntuColors.orange
        width: parent.width
        height: units.gu(0)
    }

    Component {
        id: pickerComponent
        PickerDialog {}
    }

    Rectangle {
        anchors.fillIn: parent
        visible: webView.visible
    }

    WebView {
        id: webView
        width: parent.width
        height: parent.height
        visible: false
        onLoadProgressChanged: {
            if ( loadProgress === 1000 ) visible = true
        }
        anchors.fill: parent
        url: instance.indexOf("http") != -1 ? instance : "https://" + instance
        preferences.localStorageEnabled: true
        preferences.allowFileAccessFromFileUrls: true
        preferences.allowUniversalAccessFromFileUrls: true
        preferences.appCacheEnabled: true
        preferences.javascriptCanAccessClipboard: true
        filePicker: pickerComponent

        // Open external URL's in the browser and not in the app
        onNavigationRequested: {
            console.log ( request.url, ("" + request.url).indexOf ( instance ) !== -1 )
            if ( ("" + request.url).indexOf ( instance ) !== -1 ) {
                request.action = 0
            } else {
                request.action = 1
                Qt.openUrlExternally( request.url )
            }
        }
    }

}
