import QtQuick 2.4
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.2
import QtQuick.Controls.Styles 1.4
import QtQuick.LocalStorage 2.0
import QtWebView 1.1

import de.bibuweb.mnotes 1.0
import "OneNote.js" as OneNote


ColumnLayout {

    spacing: 0
    property alias noteStack: noteStack


    MSGraph{
        id: mslogin
        clientId: "0006d636-2cd2-47fd-b506-5239c842a064"
        scope: "wl.signin office.onenote wl.offline_access"
        onOpenBrowser: {
            msLogin.url = url
           // console.log("Request URL"+url)
        }

        onCloseBrowser: {
            console.log("Browser to close")

        }

        onLinkedChanged: {
            listHeader.actionlogin.visible = true


        }
        onLinkingSucceeded: {
            listHeader.actionlogin.visible = false
          //  noteStack.pop()

            console.log("Notestack: "+noteStack.depth)
            noteStack.pop()

            OneNote.getPages(token)

        }
    }

    MSOneNoteApi{
        id: msoneNoteApi
        authenticator: mslogin

        Component.onCompleted: {
            if(mslogin.linked)
                mslogin.unlink();
        }
    }

    ActionElement{
        id: listHeader
        actionlogin.visible:  mslogin.linked ? false:true

        onBackButtonClicked: {
        /** put code for handling data here **/
            isNote = false;
            noteTitel = "New Note";
            noteStack.pop()
        }

        onLoginClicked: {
            noteStack.push(msLogin)
                mslogin.link()
        }

    }


    StackView{
        id: noteStack
        initialItem: listview
        implicitWidth: notesApp.width-3
        implicitHeight: notesApp.height - listHeader.height - toolbar.height - btnHeight
        Item {
            id: listview
            Rectangle{

                anchors.fill: parent
                color: "#eeec52"
                ListView {

                    anchors.fill: parent
                    model: notesModel
                    // delegate: Elements {}
                    delegate: liste
                }
            }
        }
        Item {
            id: msLogin
            property url url: ""

            WebView {
                anchors.fill: parent
                url: msLogin.url
                onLoadingChanged: {

                    if (url.toString().indexOf("code=M") !== -1)
                        mslogin.redirected(url)
                    //console.log("URLChanged: "+ url)

                }

            }
        }

        onCurrentItemChanged: {
            stackIndex = noteStack.depth
        }

    }
   Component.onCompleted: {oneNoteStack = noteStack} //make noteStack visible in OneNote.js
   Component.onDestruction:  {
       mslogin.unlink();
   }
}
