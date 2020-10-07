import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12

Window {
    visible: true
    width: 640
    height: 480
    title: qsTr("DragDropGriedView")


    Button{
        id: addButton
        text: qsTr("Populate")

        anchors{
            left: parent.left
            right: parent.right
            top: parent.top
        }
        height:  50

        onClicked: populate()
    }

    function getRandomInt(max) {
      return Math.floor(Math.random() * Math.floor(max));
    }

    function addComponent() {
        var c = ("#%1%2%3").arg( getRandomInt(99) ).arg(getRandomInt(99)).arg(getRandomInt(99))
        myModel.append({"colorProp": c, "gridId" :myModel.count + 1 , "dummy":false})
    }

    function populate() {
        myModel.clear()
        for(var i = 0; i < 30; i++) {
            if(Math.random() > 0.5) {
                addComponent()
            } else {
                myModel.append({"colorProp": "#FFFFFF", "gridId" :myModel.count + 1 , "dummy":true})
            }
        }
    }

    ListModel {
            id: myModel
        }

    GridView{
        id: grid
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            top: addButton.bottom
        }
        cellWidth: 120
        cellHeight: 120

        interactive: false


        model: myModel

        delegate: GridViewComponent{}

    }
    MouseArea {
        property int currentId: -1 // Original position in model
        property int newIndex // Current Position in model
        property int index: grid.indexAt(mouseX, mouseY) // Item underneath cursor

        id: loc
        anchors.fill: grid
        onPressAndHold:{
            if(!myModel.get(index).dummy)
                currentId = myModel.get(newIndex = index).gridId
        }
        onReleased: currentId = -1
        onPositionChanged: {
            if (currentId !== -1 && index !== -1 && index !== newIndex)
                myModel.move(newIndex, newIndex = index, 1)
        }
    }
}
