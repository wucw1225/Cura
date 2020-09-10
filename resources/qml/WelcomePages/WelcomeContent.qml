// Copyright (c) 2019 Ultimaker B.V.
// Cura is released under the terms of the LGPLv3 or higher.

import QtQuick 2.10
import QtQuick.Controls 2.3

import UM 1.3 as UM
import Cura 1.1 as Cura


//
// This component contains the content for the "Welcome" page of the welcome on-boarding process.
//
Item
{
    UM.I18nCatalog { id: catalog; name: "cura" }

    Column  // 垂直排列items并将所有items放在中间
    {
        anchors.centerIn: parent
        width: parent.width
        spacing: 2 * UM.Theme.getSize("wide_margin").height

        Label
        {
            id: titleLabel
            anchors.horizontalCenter: parent.horizontalCenter
            horizontalAlignment: Text.AlignHCenter
            //wucw
            text: catalog.i18nc("@label", "Welcome to DFStarter")
            //text: catalog.i18nc("@label", "Welcome to Ultimaker Cura")
            color: UM.Theme.getColor("primary_button")
            font: UM.Theme.getFont("huge")
            renderType: Text.NativeRendering
        }

        Image
        {
            id: curaImage
            anchors.horizontalCenter: parent.horizontalCenter
            source: UM.Theme.getImage("first_run_welcome_cura") // 更换图标
            width: 160
            height: 80
            fillMode: Image.PreserveAspectFit // 按比例缩放不裁剪
            sourceSize.width: width
            sourceSize.height: height
        }

        Label
        {
            id: textLabel
            anchors.horizontalCenter: parent.horizontalCenter
            horizontalAlignment: Text.AlignHCenter
            //wucw
            text: catalog.i18nc("@text", "Please follow these steps to set up\nDFStarter. This will only take a few moments.")
            //text: catalog.i18nc("@text", "Please follow these steps to set up\nUltimaker Cura. This will only take a few moments.")
            font: UM.Theme.getFont("medium")
            color: UM.Theme.getColor("text")
            renderType: Text.NativeRendering
        }

        Cura.PrimaryButton
        {
            id: getStartedButton
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.margins: UM.Theme.getSize("wide_margin").width
            text: catalog.i18nc("@button", "Get started")
            onClicked: base.showNextPage()
        }
    }
}
