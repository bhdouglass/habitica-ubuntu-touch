import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Web 0.2
import com.canonical.Oxide 1.0 as Oxide

MainView {
    id: root
    objectName: 'mainView'
    applicationName: 'habitica.bhdouglass'

    automaticOrientation: true
    anchorToKeyboard: true

    width: units.gu(50)
    height: units.gu(75)

    Page {
        id: page
        anchors {
            fill: parent
            bottom: parent.bottom
        }
        width: parent.width
        height: parent.height

        header: PageHeader {
            id: header
            visible: false
        }

        WebContext {
            id: webcontext
            userAgent: 'Mozilla/5.0 (Linux; Android 5.0; Nexus 5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/38.0.2125.102 Mobile Safari/537.36 Ubuntu Touch Webapp'
            userScripts: [
                Oxide.UserScript {
                    context: 'oxide://main-world'
                    emulateGreasemonkey: true
                    url: Qt.resolvedUrl('inject.js')
                }
            ]
        }

        WebView {
            id: webview
            anchors {
                top: parent.top
                bottom: parent.bottom
            }
            width: parent.width
            height: parent.height

            context: webcontext
            url: 'https://habitica.com/'
            preferences.localStorageEnabled: true
            preferences.appCacheEnabled: true

            function navigationRequestedDelegate(request) {
                var url = request.url.toString();
                var isvalid = false;

                if (!url.match('(http|https)://habitica.com/(.*)')) {
                    Qt.openUrlExternally(url);
                    request.action = Oxide.NavigationRequest.ActionReject;
                }
            }

            Component.onCompleted: {
                preferences.localStorageEnabled = true;
            }
        }

        ProgressBar {
            height: units.dp(3)
            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
            }

            showProgressPercentage: false
            value: (webview.loadProgress / 100)
            visible: (webview.loading && !webview.lastLoadStopped)
        }
    }

    Connections {
        target: UriHandler
        onOpened: {
            webview.url = uris[0];
        }
    }

    Component.onCompleted: {
        if (Qt.application.arguments[1] && Qt.application.arguments[1].indexOf('habitica.com') >= 0) {
            webview.url = Qt.application.arguments[1];
        }
    }
}
