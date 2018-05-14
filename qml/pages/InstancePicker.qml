import QtQuick 2.4
import QtQuick.Layouts 1.1
import Ubuntu.Components 1.3

Page {
    id: instancePickerPage
    anchors.fill: parent
    Component.onCompleted: getSample ()

    /* Load list of Mastodon Instances from https://instances.social
    * The Response is in format:
    * { id, name, added_at, updated_at, checked_at, uptime, up, dead, version,
    * ipv6, https_score, https_rank, obs_score, obs_rank, users, statuses,
    * connections, open_registrations, info { short_description, full_description,
    *      topic, languages[], other_languages_accepted, federates_with,
    *      prhobited_content[], categories[]}, thumbnail, active_users }
    */
    function getSample () {

        var http = new XMLHttpRequest();
        var data = "?" +
        "sort_by=connections&" +
        "sort_order=desc&" +
        "count=20"

        http.open("GET", "https://instances.social/api/1.0/instances/list" + data, true);
        http.setRequestHeader('Content-type', 'application/json; charset=utf-8')
        http.setRequestHeader('Authorization', 'Bearer ' + token);
        http.onreadystatechange = function() {
            if (http.readyState === XMLHttpRequest.DONE) {
                var response = JSON.parse(http.responseText)
                instanceList.writeInList ( response.instances )
            }
        }
        http.send();
    }


    function search () {
        var str = customInstanceInput.displayText.toLowerCase()
        var http = new XMLHttpRequest();
        var data = "?" +
        "q=" + str + "&" +
        "count=20"
        instanceList.children = ""
        loading.visible = true

        http.open("GET", "https://instances.social/api/1.0/instances/search" + data, true);
        http.setRequestHeader('Content-type', 'application/json; charset=utf-8')
        http.setRequestHeader('Authorization', 'Bearer ' + token);
        http.onreadystatechange = function() {
            if (http.readyState === XMLHttpRequest.DONE) {
                loading.visible = false
                var response = JSON.parse(http.responseText)
                response.instances.push ({id: "custom", name: str})
                instanceList.writeInList ( response.instances )
            }
            else {
                console.log ( http.responseText )
            }
        }

        http.send();
    }



    header: PageHeader {
        id: header
        title: i18n.tr('Choose a Mastodon instance')
        StyleHints {
            foregroundColor: "white"
            backgroundColor: "#393f4f"
        }
        trailingActionBar {
            actions: [
            Action {
                text: i18n.tr("Info")
                iconName: "info"
                onTriggered: {
                    mainStack.push(Qt.resolvedUrl("./Info.qml"))
                }
            },
            Action {
                iconName: "search"
                onTriggered: {
                    if ( customInstanceInput.displayText == "" ) {
                        customInstanceInput.focus = true
                    }
                    else search ()
                }
            }
            ]
        }
    }

    ActivityIndicator {
        id: loading
        visible: true
        running: true
        anchors.centerIn: parent
    }


    TextField {
        id: customInstanceInput
        anchors.top: header.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: height
        width: parent.width - height
        placeholderText: i18n.tr("Search or enter a custom address")
        Keys.onReturnPressed: search ()
    }

    ScrollView {
        id: scrollView
        width: parent.width
        height: parent.height - header.height - 3*customInstanceInput.height
        anchors.top: customInstanceInput.bottom
        anchors.topMargin: customInstanceInput.height
        contentItem: Column {
            id: instanceList
            width: root.width

            // Write a list of instances to the ListView
            function writeInList ( list ) {
                instanceList.children = ""
                loading.visible = false
                for ( var i = 0; i < list.length; i++ ) {
                    var item = Qt.createComponent("../components/InstanceItem.qml")
                    item.createObject(this, {
                        "text": list[i].name,
                        "description": list[i].info != null ? list[i].info.short_description : "",
                        "long_description": list[i].info != null ? list[i].info.long_description : "",
                        "iconSource":  list[i].thumbnail != null ? list[i].thumbnail : "../../assets/logo.svg"
                    })
                }
            }
        }
    }

}
