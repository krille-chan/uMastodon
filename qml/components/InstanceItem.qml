import QtQuick 2.4
import QtQuick.Layouts 1.1
import Ubuntu.Components 1.3
import QtQuick.LocalStorage 2.0
import com.canonical.Oxide 1.19 as Oxide

ListItem {
    id: task

    property var text: ""
    property var description: ""
    property var long_description: ""
    property var iconSource: "../../assets/enter.svg"

    //height: layout.height

    onClicked: {
        // Create the database if it doesn't already exist
        db.transaction(
            function(tx) {
                tx.executeSql('DELETE FROM Url')

                tx.executeSql('INSERT INTO Url VALUES("' + text + '")')
            }
        )

        instance = text
        mainStack.push (Qt.resolvedUrl("../pages/Loading.qml"))
    }

    ListItemLayout {
        id: layout
        title.text: text
        subtitle.text: description
        summary.text: long_description
        Image {
            id: icon
            source: iconSource
            width: units.gu(4)
            height: units.gu(4)
            SlotsLayout.position: SlotsLayout.Leading;
            anchors.verticalCenter: parent.verticalCenter
            visible: false
            onStatusChanged: if (status == Image.Ready) visible = true
        }
        ActivityIndicator {
            id: indicator
            width: units.gu(4)
            SlotsLayout.position: SlotsLayout.Leading;
            anchors.verticalCenter: parent.verticalCenter
            running: !icon.visible
            visible: running
        }

    }
}
