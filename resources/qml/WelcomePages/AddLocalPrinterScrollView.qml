// Copyright (c) 2019 Ultimaker B.V.
// Cura is released under the terms of the LGPLv3 or higher.

import QtQuick 2.10
import QtQuick.Controls 2.3

import UM 1.3 as UM
import Cura 1.1 as Cura


//
// 这是用于添加（本地）打印机的滚动视图小部件。 该滚动视图显示了一个列表视图，其中打印机分为3类：“ Ultimaker”，“ Custom”和“ Other”。
//
Item
{
    id: base

    // 本地机器列表中当前选择的机器。
    property var currentItem: (machineList.currentIndex >= 0)
                              ? machineList.model.getItem(machineList.currentIndex)
                              : null
    // 当前活动（扩展）的节/类别，其中节/类别是本地计算机项的分组。
    property string currentSection: "Ultimaker B.V."
    // 默认情况下（显示此列表时），我们始终展开“ Ultimaker”部分。
    property var preferredCategories: {
        "Ultimaker B.V.": -2,
        "Custom": -1
    }

    // 用户可编辑的打印机名称
    property alias printerName: printerNameTextField.text
    property alias isPrinterNameValid: printerNameTextField.acceptableInput

    onCurrentItemChanged:
    {
        printerName = currentItem == null ? "" : currentItem.name
    }

    //更新排在第一位的机器目录
    function updateCurrentItemUponSectionChange()
    {
        // 在本节中找到第一台机器
        for (var i = 0; i < machineList.count; i++)
        {
            var item = machineList.model.getItem(i)
            if (item.section == base.currentSection)
            {
                machineList.currentIndex = i
                break
            }
        }
    }

    //获取机器名字
    function getMachineName()
    {
        return machineList.model.getItem(machineList.currentIndex) != undefined ? machineList.model.getItem(machineList.currentIndex).name : "";
    }

    //
    function getMachineMetaDataEntry(key)
    {
        var metadata = machineList.model.getItem(machineList.currentIndex) != undefined ? machineList.model.getItem(machineList.currentIndex).metadata : undefined;
        if (metadata)
        {
            return metadata[key];
        }
        return undefined;
    }

    //附加信号处理程序
    Component.onCompleted:
    {
        updateCurrentItemUponSectionChange()
    }

    Row
    {
        id: localPrinterSelectionItem
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top

        // ScrollView + ListView for selecting a local printer to add
        Cura.ScrollView
        {
            id: scrollView

            height: childrenHeight
            width: Math.floor(parent.width * 0.55) // 对浮点数向下取整

            ListView
            {
                id: machineList

                // CURA-6793
                // 启用缓冲区似乎会导致空白项目问题。 启用缓冲区后，如果ListView的单个项的可见性发生动态变化，则ListView不会重绘自身。
                // cacheBuffer的默认值取决于平台，因此我们在此处明确禁用它。
                cacheBuffer: 0
                boundsBehavior: Flickable.StopAtBounds // 禁止首尾滑动
                flickDeceleration: 20000  // To prevent the flicking behavior.
                //数据模型
                model: UM.DefinitionContainersModel
                {
                    id: machineDefinitionsModel
                    filter: { "visible": true , "manufacturer": "Dazzle"}
                    sectionProperty: "manufacturer"
                    preferredSections: preferredCategories
                }

                section.property: "section"
                section.delegate: sectionHeader
                delegate: machineButton
            }

            Component
            {
                id: sectionHeader

                Button
                {
                    id: button
                    width: ListView.view.width
                    height: UM.Theme.getSize("action_button").height
                    text: section

                    property bool isActive: base.currentSection == section

                    background: Rectangle
                    {
                        anchors.fill: parent
                        color: isActive ? UM.Theme.getColor("setting_control_highlight") : "transparent"
                    }

                    contentItem: Item
                    {
                        width: childrenRect.width
                        height: UM.Theme.getSize("action_button").height

                        UM.RecolorImage
                        {
                            id: arrow
                            anchors.left: parent.left
                            width: UM.Theme.getSize("standard_arrow").width
                            height: UM.Theme.getSize("standard_arrow").height
                            sourceSize.width: width
                            sourceSize.height: height
                            color: UM.Theme.getColor("text")
                            source: base.currentSection == section ? UM.Theme.getIcon("arrow_bottom") : UM.Theme.getIcon("arrow_right")
                        }

                        Label
                        {
                            id: label
                            anchors.left: arrow.right
                            anchors.leftMargin: UM.Theme.getSize("default_margin").width
                            verticalAlignment: Text.AlignVCenter
                            text: button.text
                            font: UM.Theme.getFont("default_bold")
                            color: UM.Theme.getColor("text")
                            renderType: Text.NativeRendering
                        }
                    }

                    onClicked:
                    {
                        base.currentSection = section
                        base.updateCurrentItemUponSectionChange()
                    }
                }
            }

            Component
            {
                id: machineButton

                Cura.RadioButton
                {
                    id: radioButton
                    anchors.left: parent.left
                    anchors.leftMargin: UM.Theme.getSize("standard_list_lineheight").width
                    anchors.right: parent.right
                    anchors.rightMargin: UM.Theme.getSize("default_margin").width
                    height: visible ? UM.Theme.getSize("standard_list_lineheight").height : 0

                    checked: ListView.view.currentIndex == index
                    text: name
                    visible: base.currentSection == section
                    onClicked: ListView.view.currentIndex = index
                }
            }
        }

        // Vertical line
        Rectangle
        {
            id: verticalLine
            anchors.top: parent.top
            height: childrenHeight - UM.Theme.getSize("default_lining").height
            width: UM.Theme.getSize("default_lining").height
            color: UM.Theme.getColor("lining")
        }

        // User-editable printer name row
        Column
        {
            width: Math.floor(parent.width * 0.52)

            spacing: UM.Theme.getSize("default_margin").width
            padding: UM.Theme.getSize("default_margin").width

            Label
            {
                width: parent.width
                wrapMode: Text.WordWrap
                text: base.getMachineName()
                color: UM.Theme.getColor("primary_button")
                font: UM.Theme.getFont("huge")
                elide: Text.ElideRight
            }

            Grid
            {
                width: parent.width
                columns: 2
                rowSpacing: UM.Theme.getSize("default_lining").height
                columnSpacing: UM.Theme.getSize("default_margin").width

                verticalItemAlignment: Grid.AlignVCenter

                Label
                {
                    id: manufacturerLabel
                    text: catalog.i18nc("@label", "Manufacturer")
                    font: UM.Theme.getFont("default")
                    color: UM.Theme.getColor("text")
                    renderType: Text.NativeRendering
                }
                Label
                {
                    text: base.getMachineMetaDataEntry("manufacturer")
                    width: parent.width - manufacturerLabel.width
                    font: UM.Theme.getFont("default")
                    color: UM.Theme.getColor("text")
                    renderType: Text.NativeRendering
                    wrapMode: Text.WordWrap
                }
                Label
                {
                    id: profileAuthorLabel
                    text: catalog.i18nc("@label", "Profile author")
                    font: UM.Theme.getFont("default")
                    color: UM.Theme.getColor("text")
                    renderType: Text.NativeRendering
                }
                Label
                {
                    text: base.getMachineMetaDataEntry("author")
                    width: parent.width - profileAuthorLabel.width
                    font: UM.Theme.getFont("default")
                    color: UM.Theme.getColor("text")
                    renderType: Text.NativeRendering
                    wrapMode: Text.WordWrap
                }

                Label
                {
                    id: printerNameLabel
                    text: catalog.i18nc("@label", "Printer name")
                    font: UM.Theme.getFont("default")
                    color: UM.Theme.getColor("text")
                    renderType: Text.NativeRendering
                }

                Cura.TextField
                {
                    id: printerNameTextField
                    placeholderText: catalog.i18nc("@text", "Please name your printer")
                    width: 80
                    maximumLength: 40
                    validator: RegExpValidator
                    {
                        regExp: printerNameTextField.machineNameValidator.machineNameRegex
                    }
                    property var machineNameValidator: Cura.MachineNameValidator { }
                }
            }
        }


    }
}
