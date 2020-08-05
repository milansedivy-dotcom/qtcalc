import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.12

Window {
    id: root
    visible: true
    width: 640
    height: 480
    minimumHeight: 480
    minimumWidth: 640
    title: qsTr("QtCalculator")

    signal keyPressed(string keySent)

    TextField {
        visible: true
        id: calcInput
        height: 100
        anchors {
            right: parent.right
            left: parent.left
            top: parent.top
            topMargin: 20
            leftMargin: 20
            rightMargin: 20
        }
        text: ""
        onEditingFinished: {
              _backEnd.setExprInput(text)
           }
        Connections {
            target: root
            onKeyPressed: {
            if (keySent === "=") {
                calcInput.editingFinished();
                calcInput.text = _backEnd.resolveExpr();
            }
            else
                calcInput.text += keySent;
            }
       }
    }

    TabView {
        width: 500
        height: 400
        anchors {
            top: calcInput.bottom
            bottom: parent.bottom
            right: parent.right
            left: parent.left
            topMargin: 10
        }

        Tab {
            id: basicCalculatorTab

            title: "Basic"

                Item {
                    id: basicCalculatorView
                    visible: true
                    width: 400
                    height: 480

                    signal keyPressed(string keySent)
                    onKeyPressed: console.log(keySent)

                    RowLayout {
                        id: topRowKeyPad
                        anchors {
                            top: parent.top
                            right: columnKeyPad.right
                            topMargin: 20
                        }


                        Button {
                            text: qsTr("/")
                            onClicked: root.keyPressed(qsTr("/"))
                        }

                        Button {
                            text: qsTr("*")
                            onClicked: root.keyPressed(qsTr("*"))
                        }

                        Button {
                            text: qsTr("-")
                            onClicked: root.keyPressed(qsTr("-"))
                        }

/*
                        Component.onCompleted: {
                        function createObject(item) {
                            var topRowKeys = component.createObject(topRowKeyPad, {
                                                                        text: qsTr("%1").arg(item),
                                                                        onClicked: root.keyPressed(qsTr("%1").arg(item))
                                                                    })

                        }

                        let operators = ["%", "/", "x", "-"];
                        var component = Qt.createComponent("button.qml");
                            operators.forEach(createObject)
                        }
*/
                    }

                    GridLayout {
                        visible: true
                        id: keyPad
                        columns: 3

                        anchors {
                            top: topRowKeyPad.bottom
                            left: parent.left
                            leftMargin: 20
                            topMargin: 10
                        }


                        Button {
                            text: qsTr("7")
                            onClicked: root.keyPressed(qsTr("7"))
                        }

                        Button {
                            text: qsTr("8")
                            onClicked: root.keyPressed(qsTr("8"))
                        }

                        Button {
                            text: qsTr("9")
                            onClicked: root.keyPressed(qsTr("9"))
                        }
                        Button {
                            text: qsTr("4")
                            onClicked: root.keyPressed(qsTr("4"))
                        }

                        Button {
                            text: qsTr("5")
                            onClicked: root.keyPressed(qsTr("5"))
                        }

                        Button {
                            text: qsTr("6")
                            onClicked: root.keyPressed(qsTr("6"))
                        }
                        Button {
                            text: qsTr("1")
                            onClicked: root.keyPressed(qsTr("1"))
                        }

                        Button {
                            text: qsTr("2")
                            onClicked: root.keyPressed(qsTr("2"))
                        }

                        Button {
                            text: qsTr("3")
                            onClicked: root.keyPressed(qsTr("3"))
                        }


                        Button {
                            text: qsTr("0")
                            onClicked: root.keyPressed(qsTr("0"))
                        }


                        Button {
                            text: qsTr("(")
                            onClicked: root.keyPressed(qsTr("("))
                        }

                        Button {
                            text: qsTr(")")
                            onClicked: root.keyPressed(qsTr(")"))
                        }

                        /*
                        Component.onCompleted: {
                            var component = Qt.createComponent("button.qml")
                            var j = 2;
                            for(var i = 9; i >= 1; i--) {
                                var numPadKeys = component.createObject(keyPad, {
                                                                            text: qsTr("%1").arg(i-j),
                                                                            onClicked: root.keyPressed(qsTr("%1").arg(i-j))
                                                                        });
                                if (j < 0)
                                    j = 2;
                                else
                                    j -=2;
                            }
                            var numPadZero = component.createObject(keyPad, {
                                                                        text: qsTr("0"),
                                                                        onClicked: root.keyPressed(qsTr("0"))
                                                                    });
                            var numPadPoint = component.createObject(keyPad, {
                                                                         text: qsTr(","),
                                                                         onClicked: root.keyPressed(qsTr("0"))
                                                                     });
                        }
                        */
                    }

                    GridLayout {
                        visible: true
                        id: columnKeyPad
                        columns: 1

                        anchors {
                            top: topRowKeyPad.bottom
                            left: keyPad.right
                            topMargin: 10
                            leftMargin: 5
                        }

                        Button {
                            text: qsTr("+")
                            onClicked: root.keyPressed(qsTr("+"))
                        }

                        Button {
                            text: qsTr("=")
                            onClicked: {
                                root.keyPressed("=");
                            }
                        }
                        Button {
                            text: qsTr(".")
                            onClicked: {
                                root.keyPressed(".");
                            }
                        }

                    }
                }




                /*     var component
                component = Qt.createComponent("basic_calculator_tab.qml");

                function createPadObject() {
                    component.createObject(basicCalculatorView, {
                                               onKeyPressed: console.log("some key was pressed")
                                           })
                }

                if (component.status === Component.Ready) {
                   createPadObject();
                } else {
                   component.statusChanged.connect(createPadObject);
                }

            }
*/
        }

        Tab {

            title: "Scientific"

                Item {
                    visible: true
                    width: 400
                    height: 480

                    RowLayout {
                        id: sciTopRow
                        anchors {
                            top: parent.top
                            right: sciColumnKeyPad.right
                            topMargin: 20
                        }


                        Button {
                            text: qsTr("/")
                            onClicked: root.keyPressed(qsTr("/"))
                        }

                        Button {
                            text: qsTr("*")
                            onClicked: root.keyPressed(qsTr("*"))
                        }

                        Button {
                            text: qsTr("-")
                            onClicked: root.keyPressed(qsTr("-"))
                        }

                    }

                    GridLayout {
                        visible: true
                        id: sciKeyPad
                        columns: 3

                        anchors {
                            top: sciTopRow.bottom
                            left: parent.left
                            leftMargin: 20
                            topMargin: 10
                        }


                        Button {
                            text: qsTr("7")
                            onClicked: root.keyPressed(qsTr("7"))
                        }

                        Button {
                            text: qsTr("8")
                            onClicked: root.keyPressed(qsTr("8"))
                        }

                        Button {
                            text: qsTr("9")
                            onClicked: root.keyPressed(qsTr("9"))
                        }
                        Button {
                            text: qsTr("4")
                            onClicked: root.keyPressed(qsTr("4"))
                        }

                        Button {
                            text: qsTr("5")
                            onClicked: root.keyPressed(qsTr("5"))
                        }

                        Button {
                            text: qsTr("6")
                            onClicked: root.keyPressed(qsTr("6"))
                        }
                        Button {
                            text: qsTr("1")
                            onClicked: root.keyPressed(qsTr("1"))
                        }

                        Button {
                            text: qsTr("2")
                            onClicked: root.keyPressed(qsTr("2"))
                        }

                        Button {
                            text: qsTr("3")
                            onClicked: root.keyPressed(qsTr("3"))
                        }


                        Button {
                            text: qsTr("0")
                            onClicked: root.keyPressed(qsTr("0"))
                        }

                        Button {
                            text: qsTr("(")
                            onClicked: root.keyPressed(qsTr("("))
                        }

                        Button {
                            text: qsTr(")")
                            onClicked: root.keyPressed(qsTr(")"))
                        }

                    }

                    GridLayout {
                        id: sciColumnKeyPad
                        visible: true
                        columns: 1

                        anchors {
                            top: sciTopRow.bottom
                            left: sciKeyPad.right
                            topMargin: 10
                            leftMargin: 5
                        }

                        Button {
                            text: qsTr("+")
                            onClicked: root.keyPressed(qsTr("+"))
                        }

                        Button {
                            text: qsTr("=")
                            onClicked: {
                                root.keyPressed("=");
                            }
                        }
                        Button {
                            text: qsTr(".")
                            onClicked: {
                                root.keyPressed(".");
                            }
                        }
                }
                    GridLayout {
                        id: specialsKeyPad
                        visible: true
                        columns: 2

                        anchors {
                            top: sciTopRow.bottom
                            right: parent.right
                            topMargin: 10
                            rightMargin: 20
                        }

                        Button {
                            text: qsTr("cos")
                            onClicked: root.keyPressed(qsTr("cos"))
                        }

                        Button {
                            text: qsTr("sin")
                            onClicked: {
                                root.keyPressed("sin");
                            }
                        }
                        Button {
                            text: qsTr("tg")
                            onClicked: {
                                root.keyPressed("tg");
                            }
                        }
                        Button {
                            text: qsTr("cotg")
                            onClicked: root.keyPressed("cotg");
                        }
                        Button {
                            text: qsTr("log")
                            onClicked: root.keyPressed("log");
                        }
                        Button {
                            text: qsTr("^")
                            onClicked: root.keyPressed("^");
                        }
                }


        }

        }
    }

}
