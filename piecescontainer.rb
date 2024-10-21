require 'Qt'
class PiecesContainer < Qt::Widget
  attr_accessor :mode, :dropbox
  def initialize title, parent=nil
    super parent
    @title = Qt::Label.new title
    @pieces = []
    @top_border = 5
    @row = @top_border
    @left_border = 5
    @col = @left_border
    @piece_size = 80
    @col_width = @piece_size + 10
    @row_height = @piece_size + 10    
    @num_cols = 2
    @view_y = 0    
    setMinimumSize 220,100    
    setMaximumWidth 220
    layout = Qt::GridLayout.new self
    layout.addWidget @title, 0, 0, 1,2, Qt::AlignLeft
    @dropbox = Qt::Frame.new{
      setFrameStyle Qt::Frame::Panel      
      setSizePolicy  Qt::SizePolicy::MinimumExpanding,  Qt::SizePolicy::MinimumExpanding      
      setMouseTracking true
    }    
    @dropbox.installEventFilter self  
    layout.addWidget @dropbox, 1, 0, 1, 1
    @vertical_scrollbar = Qt::ScrollBar.new Qt::Vertical, self
    @vertical_scrollbar.connect(SIGNAL('valueChanged(int)')) do |val|
      @dropbox.scroll 0, @view_y - val
      @view_y = val
    end
    layout.addWidget @vertical_scrollbar, 1,1
    setLayout layout
    @mode = :none
  end
  def get_pieces
    pieces = @pieces.map{ |elem| elem.grid}
  end
  def load_pieces pieces
    pieces.each do |raw_piece|
      add_piece Piece.new(raw_piece, @piece_size, @dropbox)
    end
    update
  end
  def add_piece piece
    @pieces << piece    
    add_piece_to_grid piece
  end
  def add_piece_to_grid piece
    piece.move @col, @row-@view_y
    @col += @col_width
    if @col > @num_cols*@col_width
      @col = @left_border
      @row += @row_height
    end    
  end
  def delete_piece piece
    piece.hide
    @pieces.delete piece
    # tidy up grid, basically reset it
    @col = @left_border
    @row = @top_border
    @pieces.each do |piece|
      add_piece_to_grid piece
    end
  end
  def enterEvent event
     setFocus(Qt::MouseFocusReason)   
  end
  def keyPressEvent event    
    if event.key == Qt::Key_Escape
      @floater.hide unless @floater.nil?
      @floater = nil
      @mode = :none
    end
  end
  def eventFilter obj, event
    if obj == @dropbox      
      case event.type
        when Qt::Event::Enter
          if $clipboard.has_item?
            @mode = :new_piece_hover          
            @floater = Piece.new $clipboard.item, @piece_size, @dropbox            
            @floater.update
           $clipboard.item = nil
          end
        when Qt::Event::Leave
          if @mode == :new_piece_hover or @mode == :piece_hover
            $clipboard.item = @floater.grid
            @floater.hide          
            @floater = nil
            @mode = :none            
            update
          end
        when Qt::Event::MouseMove
          if @mode == :new_piece_hover or @mode == :piece_hover
            @floater.move event.pos.x, event.pos.y
            @floater.update
            update
          end
        when Qt::Event::MouseButtonPress
          if event.button == Qt::LeftButton
            if @mode == :new_piece_hover
              
              add_piece @floater            
              @floater.floating = false
              @floater = nil     
              @mode = :none
              $clipboard.item = nil
              update
            else
              # see if clicked existing piece
              piece = @pieces.select{ |piece| piece.underMouse } #return array
              unless piece.empty?
                @floater = Piece.new piece[0].grid, @piece_size, @dropbox
                @floater.move event.pos.x, event.pos.y
                @floater.show              
                @mode = :piece_hover
              end
            end
          elsif event.button == Qt::RightButton
            unless @mode != :none
              show_context_menu event.pos
            end
          end
        when Qt::Event::Wheel          
          delta = event.delta/120
          @view_y -= delta
          if @view_y < 0
            @view_y = 0
            return
          end
          @dropbox.scroll 0, delta
          @vertical_scrollbar.setValue @view_y
      end      
    end
  end
  def show_context_menu pos    
    point = mapToGlobal(pos)
    menu = Qt::Menu.new self
    piece = @pieces.select{ |piece| piece.underMouse } #return array
    unless piece.empty?
      piece = piece[0]
      delete_action = Qt::Action.new "Delete", self
      menu.addAction delete_action      
    end    
    return if menu.isEmpty
    
    selected_item = menu.exec point
    if selected_item == delete_action
      delete_piece piece
    end
  end
end


class Piece < Qt::Widget
  attr_accessor :grid, :floating
  def initialize grid, size, parent=nil #parent will be @dropbox
    super parent
    @grid = grid    
    xs = @grid.map{|elem| elem[0]}
    ys = @grid.map{|elem| elem[1]}
    @grid_w = xs.max - xs.min
    @grid_h = ys.max - ys.min
    @cell_size = (size*1.0 / ([@grid_w,@grid_h].max+1))
    setFixedSize size, size
    setMouseTracking true
    @floating = true   
    show 
  end
  
  def paintEvent event
    painter = Qt::Painter.new self    
    painter.setPen Qt::SolidLine
    if [@grid_w,@grid_h].max < 25
      #vertical lines
      for x in (0..(width/@cell_size)-1)
        painter.drawLine x*@cell_size,0,x*@cell_size,height
      end
      #horizontal lines
      for y in (0..(height/@cell_size)-1)
        painter.drawLine 0, y*@cell_size,width,y*@cell_size
      end
      color = Qt::green
    else
      color = Qt::Color.new 0,150,0
    end
    painter.drawRect 0, 0, width-1, height-1
    painter.setPen Qt::NoPen
    @grid.each do |cell|
      painter.fillRect cell[0]*@cell_size+1, cell[1]*@cell_size+1, @cell_size-1, @cell_size-1, color 
    end
    painter.end
  end
end