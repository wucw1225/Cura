// Copyright (c) 2019 Ultimaker B.V.
// Cura is released under the terms of the LGPLv3 or higher.

import QtQuick 2.10
import QtQuick.Controls 2.3

import UM 1.3 as UM
import Cura 1.1 as Cura


//
// 此项是一个向导面板，在顶部包含一个进度条，在进度条之下包含一个内容区域。
//
Item
{
    id: base

    clip: true // 当元素的子项超出父项范围后会自动裁剪

    property var currentItem: (model == null) ? null : model.getItem(model.currentPageIndex) // 当前页的内容
    property var model: null // 模型(WeIcomePagesModel.py)

    // 便利的属性
    property var progressValue: model == null ? 0 : model.currentProgress // 当前进度
    property string pageUrl: currentItem == null ? "" : currentItem.page_url // 当前页面的URL

    property alias progressBarVisible: progressBar.visible //属性别名
    property alias backgroundColor: panelBackground.color  //属性别名

    signal showNextPage()
    signal showPreviousPage()
    signal goToPage(string page_id)  // 按给定的page_id转到特定页面。
    signal endWizard()

    // 调用模型(WeIcomePagesModel)中的相应函数
    onShowNextPage: model.goToNextPage()
    onShowPreviousPage: model.goToPreviousPage()
    onGoToPage: model.goToPage(page_id)
    onEndWizard: model.atEnd()

    Rectangle  // 面板背景
    {
        id: panelBackground
        anchors.fill: parent
        radius: UM.Theme.getSize("default_radius").width
        color: UM.Theme.getColor("main_background")

        UM.ProgressBar
        {
            id: progressBar
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right

            height: UM.Theme.getSize("progressbar").height

            value: base.progressValue
        }

        Loader
        {
            id: contentLoader
            anchors
            {
                margins: UM.Theme.getSize("wide_margin").width
                bottomMargin: UM.Theme.getSize("default_margin").width
                top: progressBar.bottom
                bottom: parent.bottom
                left: parent.left
                right: parent.right
            }
            source: base.pageUrl
            active: base.visible
        }
    }
}
