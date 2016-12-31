import QtQuick 2.4
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.2
import QtQuick.Controls.Styles 1.4
import QtQuick.LocalStorage 2.0

import "backend.js" as DB
import "view.js" as View

ColumnLayout {

    spacing: 0

    ActionElement{
        id: listHeader
        onBackButtonClicked: {
        /** put code for handling data here **/
        }
    }

   StackView{
        id: stackview
        initialItem: scrollview
         implicitWidth: notesApp.width-3
        width: notesApp.width-3
        implicitHeight: notesApp.height - listHeader.height - toolbar.height - btnHeight

        ScrollView{
            id: scrollview
            implicitHeight: notesApp.height - listHeader.height - toolbar.height
            style: ScrollViewStyle{
                frame: Rectangle{
                    color: "#eeec52"
                    border.color: "#141312"
                }

                scrollBarBackground : Item  {
                    implicitWidth: 14
                    implicitHeight: 26
                }
            }

            ListView {
                id: listview
                model: notesModel
               // delegate: Elements {}
                delegate: liste


            }
            // Stack.onStatusChanged:  console.log("Stackstatus: "+Stack.status )
        }

        onCurrentItemChanged: {
            stackIndex = stackview.depth
        }

    }
   Component.onCompleted: {stack = stackview} //make stackview visible in view.js
}
