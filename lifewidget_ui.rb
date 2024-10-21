=begin
** Form generated from reading ui file 'lifewidget.ui'
**
** Created: Thu Feb 7 17:20:46 2013
**      by: Qt User Interface Compiler version 4.7.0
**
** WARNING! All changes made in this file will be lost when recompiling ui file!
=end

class Ui_LifeWidget
    attr_reader :gridLayout_2
    attr_reader :gridLayout
    attr_reader :runB
    attr_reader :stepB
    attr_reader :verticalLayout
    attr_reader :label
    attr_reader :zoom_slider
    attr_reader :label_2
    attr_reader :speed_slider
    attr_reader :label_4
    attr_reader :backCB
    attr_reader :label_6
    attr_reader :universe_sizeL
    attr_reader :horizontalSpacer
    attr_reader :restartB
    attr_reader :backB
    attr_reader :label_5
    attr_reader :back_buffer_depthSB
    attr_reader :clearB
    attr_reader :label_3
    attr_reader :generationL
    attr_reader :gameboard_viewer
    attr_reader :vertical_scrollbar
    attr_reader :horizontal_scrollbar

    def setupUi(lifeWidget)
    if lifeWidget.objectName.nil?
        lifeWidget.objectName = "lifeWidget"
    end
    lifeWidget.resize(738, 589)
    @sizePolicy = Qt::SizePolicy.new(Qt::SizePolicy::MinimumExpanding, Qt::SizePolicy::Preferred)
    @sizePolicy.setHorizontalStretch(0)
    @sizePolicy.setVerticalStretch(0)
    @sizePolicy.heightForWidth = lifeWidget.sizePolicy.hasHeightForWidth
    lifeWidget.sizePolicy = @sizePolicy
    @gridLayout_2 = Qt::GridLayout.new(lifeWidget)
    @gridLayout_2.objectName = "gridLayout_2"
    @gridLayout = Qt::GridLayout.new()
    @gridLayout.objectName = "gridLayout"
    @runB = Qt::PushButton.new(lifeWidget)
    @runB.objectName = "runB"
    @sizePolicy1 = Qt::SizePolicy.new(Qt::SizePolicy::Maximum, Qt::SizePolicy::Fixed)
    @sizePolicy1.setHorizontalStretch(0)
    @sizePolicy1.setVerticalStretch(0)
    @sizePolicy1.heightForWidth = @runB.sizePolicy.hasHeightForWidth
    @runB.sizePolicy = @sizePolicy1

    @gridLayout.addWidget(@runB, 0, 0, 2, 1)

    @stepB = Qt::PushButton.new(lifeWidget)
    @stepB.objectName = "stepB"

    @gridLayout.addWidget(@stepB, 0, 1, 2, 1)

    @verticalLayout = Qt::VBoxLayout.new()
    @verticalLayout.objectName = "verticalLayout"
    @label = Qt::Label.new(lifeWidget)
    @label.objectName = "label"
    @label.alignment = Qt::AlignCenter

    @verticalLayout.addWidget(@label)

    @zoom_slider = Qt::Slider.new(lifeWidget)
    @zoom_slider.objectName = "zoom_slider"
    @sizePolicy2 = Qt::SizePolicy.new(Qt::SizePolicy::Preferred, Qt::SizePolicy::Fixed)
    @sizePolicy2.setHorizontalStretch(0)
    @sizePolicy2.setVerticalStretch(0)
    @sizePolicy2.heightForWidth = @zoom_slider.sizePolicy.hasHeightForWidth
    @zoom_slider.sizePolicy = @sizePolicy2
    @zoom_slider.minimumSize = Qt::Size.new(50, 0)
    @zoom_slider.minimum = 10
    @zoom_slider.sliderPosition = 50
    @zoom_slider.orientation = Qt::Horizontal

    @verticalLayout.addWidget(@zoom_slider)

    @label_2 = Qt::Label.new(lifeWidget)
    @label_2.objectName = "label_2"
    @label_2.alignment = Qt::AlignCenter

    @verticalLayout.addWidget(@label_2)

    @speed_slider = Qt::Slider.new(lifeWidget)
    @speed_slider.objectName = "speed_slider"
    @sizePolicy2.heightForWidth = @speed_slider.sizePolicy.hasHeightForWidth
    @speed_slider.sizePolicy = @sizePolicy2
    @speed_slider.minimum = 1
    @speed_slider.maximum = 200
    @speed_slider.sliderPosition = 50
    @speed_slider.orientation = Qt::Horizontal

    @verticalLayout.addWidget(@speed_slider)


    @gridLayout.addLayout(@verticalLayout, 0, 2, 4, 1)

    @label_4 = Qt::Label.new(lifeWidget)
    @label_4.objectName = "label_4"
    @label_4.layoutDirection = Qt::LeftToRight

    @gridLayout.addWidget(@label_4, 0, 3, 1, 1)

    @backCB = Qt::CheckBox.new(lifeWidget)
    @backCB.objectName = "backCB"
    @backCB.layoutDirection = Qt::LeftToRight

    @gridLayout.addWidget(@backCB, 0, 4, 1, 1)

    @label_6 = Qt::Label.new(lifeWidget)
    @label_6.objectName = "label_6"

    @gridLayout.addWidget(@label_6, 0, 5, 1, 1)

    @universe_sizeL = Qt::Label.new(lifeWidget)
    @universe_sizeL.objectName = "universe_sizeL"
    @universe_sizeL.layoutDirection = Qt::RightToLeft
    @universe_sizeL.alignment = Qt::AlignCenter

    @gridLayout.addWidget(@universe_sizeL, 1, 5, 2, 1)

    @horizontalSpacer = Qt::SpacerItem.new(40, 20, Qt::SizePolicy::Expanding, Qt::SizePolicy::Minimum)

    @gridLayout.addItem(@horizontalSpacer, 1, 6, 2, 1)

    @restartB = Qt::PushButton.new(lifeWidget)
    @restartB.objectName = "restartB"
    @sizePolicy3 = Qt::SizePolicy.new(Qt::SizePolicy::Fixed, Qt::SizePolicy::Fixed)
    @sizePolicy3.setHorizontalStretch(0)
    @sizePolicy3.setVerticalStretch(0)
    @sizePolicy3.heightForWidth = @restartB.sizePolicy.hasHeightForWidth
    @restartB.sizePolicy = @sizePolicy3

    @gridLayout.addWidget(@restartB, 2, 0, 1, 1)

    @backB = Qt::PushButton.new(lifeWidget)
    @backB.objectName = "backB"
    @backB.enabled = false
    @backB.flat = false

    @gridLayout.addWidget(@backB, 2, 1, 1, 1)

    @label_5 = Qt::Label.new(lifeWidget)
    @label_5.objectName = "label_5"
    @label_5.layoutDirection = Qt::LeftToRight
    @label_5.alignment = Qt::AlignRight|Qt::AlignTrailing|Qt::AlignVCenter

    @gridLayout.addWidget(@label_5, 2, 3, 1, 1)

    @back_buffer_depthSB = Qt::SpinBox.new(lifeWidget)
    @back_buffer_depthSB.objectName = "back_buffer_depthSB"
    @back_buffer_depthSB.autoFillBackground = false
    @back_buffer_depthSB.value = 20

    @gridLayout.addWidget(@back_buffer_depthSB, 2, 4, 1, 1)

    @clearB = Qt::PushButton.new(lifeWidget)
    @clearB.objectName = "clearB"

    @gridLayout.addWidget(@clearB, 3, 0, 1, 1)

    @label_3 = Qt::Label.new(lifeWidget)
    @label_3.objectName = "label_3"
    @label_3.layoutDirection = Qt::RightToLeft
    @label_3.alignment = Qt::AlignRight|Qt::AlignTrailing|Qt::AlignVCenter

    @gridLayout.addWidget(@label_3, 3, 3, 1, 1)

    @generationL = Qt::Label.new(lifeWidget)
    @generationL.objectName = "generationL"
    @generationL.alignment = Qt::AlignLeading|Qt::AlignLeft|Qt::AlignVCenter

    @gridLayout.addWidget(@generationL, 3, 4, 1, 1)


    @gridLayout_2.addLayout(@gridLayout, 0, 0, 1, 2)

    @gameboard_viewer = GameBoardViewer.new(lifeWidget)
    @gameboard_viewer.objectName = "gameboard_viewer"
    @sizePolicy4 = Qt::SizePolicy.new(Qt::SizePolicy::Preferred, Qt::SizePolicy::MinimumExpanding)
    @sizePolicy4.setHorizontalStretch(0)
    @sizePolicy4.setVerticalStretch(0)
    @sizePolicy4.heightForWidth = @gameboard_viewer.sizePolicy.hasHeightForWidth
    @gameboard_viewer.sizePolicy = @sizePolicy4
    @gameboard_viewer.minimumSize = Qt::Size.new(400, 400)

    @gridLayout_2.addWidget(@gameboard_viewer, 1, 0, 1, 1)

    @vertical_scrollbar = Qt::ScrollBar.new(lifeWidget)
    @vertical_scrollbar.objectName = "vertical_scrollbar"
    @vertical_scrollbar.maximum = 300
    @vertical_scrollbar.orientation = Qt::Vertical

    @gridLayout_2.addWidget(@vertical_scrollbar, 1, 1, 1, 1)

    @horizontal_scrollbar = Qt::ScrollBar.new(lifeWidget)
    @horizontal_scrollbar.objectName = "horizontal_scrollbar"
    @horizontal_scrollbar.maximum = 300
    @horizontal_scrollbar.orientation = Qt::Horizontal

    @gridLayout_2.addWidget(@horizontal_scrollbar, 2, 0, 1, 1)


    retranslateUi(lifeWidget)

    Qt::MetaObject.connectSlotsByName(lifeWidget)
    end # setupUi

    def setup_ui(lifeWidget)
        setupUi(lifeWidget)
    end

    def retranslateUi(lifeWidget)
    @runB.text = Qt::Application.translate("LifeWidget", "Run", nil, Qt::Application::UnicodeUTF8)
    @stepB.toolTip = Qt::Application.translate("LifeWidget", "Step foward one generation", nil, Qt::Application::UnicodeUTF8)
    @stepB.text = Qt::Application.translate("LifeWidget", "Step", nil, Qt::Application::UnicodeUTF8)
    @label.text = Qt::Application.translate("LifeWidget", "Zoom", nil, Qt::Application::UnicodeUTF8)
    @label_2.text = Qt::Application.translate("LifeWidget", "Speed", nil, Qt::Application::UnicodeUTF8)
    @label_4.text = Qt::Application.translate("LifeWidget", "Enable Undo", nil, Qt::Application::UnicodeUTF8)
    @backCB.text = ''
    @label_6.text = Qt::Application.translate("LifeWidget", "Universe Size", nil, Qt::Application::UnicodeUTF8)
    @universe_sizeL.text = Qt::Application.translate("LifeWidget", "TextLabel", nil, Qt::Application::UnicodeUTF8)
    @restartB.toolTip = Qt::Application.translate("LifeWidget", "Reset the board to how it was when 'Run' was last clicked", nil, Qt::Application::UnicodeUTF8)
    @restartB.text = Qt::Application.translate("LifeWidget", "  Restart  ", nil, Qt::Application::UnicodeUTF8)
    @backB.toolTip = Qt::Application.translate("LifeWidget", "Step back one generation or undo last copy/move", nil, Qt::Application::UnicodeUTF8)
    @backB.text = Qt::Application.translate("LifeWidget", "Back/Undo", nil, Qt::Application::UnicodeUTF8)
    @label_5.text = Qt::Application.translate("LifeWidget", "Buffer Depth", nil, Qt::Application::UnicodeUTF8)
    @clearB.text = Qt::Application.translate("LifeWidget", "Clear", nil, Qt::Application::UnicodeUTF8)
    @label_3.text = Qt::Application.translate("LifeWidget", "Generation", nil, Qt::Application::UnicodeUTF8)
    @generationL.text = Qt::Application.translate("LifeWidget", "0", nil, Qt::Application::UnicodeUTF8)
    end # retranslateUi

    def retranslate_ui(lifeWidget)
        retranslateUi(lifeWidget)
    end

end

module Ui
    class LifeWidget < Ui_LifeWidget
    end
end  # module Ui

