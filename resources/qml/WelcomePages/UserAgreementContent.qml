// Copyright (c) 2019 Ultimaker B.V.
// Cura is released under the terms of the LGPLv3 or higher.

import QtQuick 2.10
import QtQuick.Controls 2.3

import UM 1.3 as UM
import Cura 1.1 as Cura

//
// This component contains the content for the "User Agreement" page of the welcome on-boarding process.
//
Item
{
    UM.I18nCatalog { id: catalog; name: "cura" }

    Label
    {
        id: titleLabel
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        horizontalAlignment: Text.AlignHCenter
        text: catalog.i18nc("@label", "User Agreement")
        color: UM.Theme.getColor("primary_button")
        font: UM.Theme.getFont("huge")
        renderType: Text.NativeRendering
    }

    Label
    {
        id: disclaimerLineLabel
        anchors
        {
            top: titleLabel.bottom
            topMargin: UM.Theme.getSize("wide_margin").height
            left: parent.left
            right: parent.right
        }

        text: "<p><b>Dazzle免责声明</b></p>"
            + "<p>1、本软件用于我司FDM部分型号设备的操作，不对其它能用本软件控制的设备打印质量和安全进行保证。</p>"
            + "<p>2、设备使用前需要学习操作方法。</p>"
            + "<p>3、设备由很多的运动部件组成，部分运动部件裸露在外，有一定的风险造成人身或物品的损伤，我司不对设备使用过程承担安全保证。</p>"
            + "<p>4、设备在使用过程中不要用手、物品阻挡机器部件的运动。</p>"
            + "<p>5、未成年人在无成年人陪护的情况下不得使用设备。</p>"
        textFormat: Text.RichText
        wrapMode: Text.WordWrap
        font: UM.Theme.getFont("medium")
        color: UM.Theme.getColor("text")
        renderType: Text.NativeRendering
    }

    Cura.PrimaryButton
    {
        id: agreeButton
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        text: catalog.i18nc("@button", "Agree")
        onClicked:
        {
            CuraApplication.writeToLog("i", "User accepted the User-Agreement.")
            CuraApplication.setNeedToShowUserAgreement(false)
            base.showNextPage()
        }
    }

    Cura.SecondaryButton
    {
        id: declineButton
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        text: catalog.i18nc("@button", "Decline and close")
        onClicked:
        {
            CuraApplication.writeToLog("i", "User declined the User Agreement.")
            CuraApplication.closeApplication() // NOTE: Hard exit, don't use if anything needs to be saved!
        }
    }
}
