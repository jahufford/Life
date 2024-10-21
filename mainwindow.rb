require './gameboardviewer.rb'
require './lifewidget_ui.rb'
require './piecescontainer.rb'
require './helpdialog.rb'
class Clipboard
  attr_accessor :item
  def initialize
    @item = nil
  end  
  def has_item?
    not @item.nil?
  end
end
$clipboard = Clipboard.new

class MyMainWindow < Qt::MainWindow
	slots 'copy_to_clipboard(QVariant)'
	def initialize parent=nil
		super		
    setWindowTitle "LifeBuilder"
    @filename = ""
    
    setup_menubar    
    new_game
    size = Qt::Size.new(800, 650)
    size = size.expandedTo(minimumSizeHint)
    resize size    
	end
	
	def setup_menubar
	  game = menuBar.addMenu "&Game"
	  new_action = Qt::Action.new "&New", self
	  open_action = Qt::Action.new "&Open", self
	  save_action = Qt::Action.new "&Save", self
	  saveas_action = Qt::Action.new "Save as", self
	  quit_action = Qt::Action.new "&Quit", self
	  
	  game.addAction new_action
	  game.addAction open_action
	  game.addAction save_action
	  game.addAction saveas_action	  
	  game.addAction quit_action
	  
	  help = menuBar.addMenu "&Help"
	  help_action = Qt::Action.new "Help", self
	  about_action = Qt::Action.new "About", self
	  
	  help.addAction help_action
	  help.addAction about_action
	  
	  new_action.connect(SIGNAL :triggered) do
	    new_game
	  end
	  
	  open_action.connect(SIGNAL :triggered) do
  	  filename = Qt::FileDialog::getOpenFileName self, "Open"
  	  unless filename.nil?
    	  @filename = filename
    	  File.open @filename, "r" do |f|
    	    @life_mainboard.load_grid Marshal.load(f)
    	    pieces = Marshal.load(f)
    	    unless pieces.nil?
    	      @pieces.load_pieces pieces
    	    end
    	  end
    	end
	  end
	  
	  save_action.connect(SIGNAL :triggered) do
      save_mainboard
    end
	  
	  saveas_action.connect(SIGNAL :triggered) do      
      save_mainboard true
    end
    
	  quit_action.connect(SIGNAL :triggered) do
	    Qt::Application.instance.quit
	  end
	  
	  help_action.connect(SIGNAL :triggered) do
	    help_dialog = HelpDialog.new self
      help_dialog.exec	    
	  end
	  
	  about_action.connect(SIGNAL :triggered) do
	    Qt::MessageBox.information( self, "About","LifeBuilder, Joe Hufford. 2013")
	  end	 
	end
	
	def save_mainboard ask=false	  
	  if ask or @filename.empty?
	    filename = Qt::FileDialog::getSaveFileName self, "Save as"
	    if filename.nil?
	      return
	    end
	    @filename = filename
	  end
	  statusBar.showMessage "Saving...", 1000
	  File.open @filename,"w" do |f|
      Marshal.dump @life_mainboard.get_grid, f
      Marshal.dump @pieces.get_pieces, f
    end
  end

	def new_game
    hlay = Qt::HBoxLayout .new
    @life_mainboard = LifeWidget.new self, 100, 100, 500, 400      
    hlay.addWidget @life_mainboard
    @pieces = PiecesContainer.new "  Pieces", self
    hlay.addWidget @pieces
    setCentralWidget Qt::Widget.new
    centralWidget.setLayout hlay
	end
	def keyPressEvent event
	  if event.key == Qt::Key_S and event.modifiers == Qt::ControlModifier
	    save_mainboard
	  end
	end
end
