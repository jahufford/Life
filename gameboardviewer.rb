require 'Qt'
require './lifewidget.rb'
class GameBoardViewer < Qt::Widget
	slots 'change_zoom(int)','change_x_offset(int)','change_y_offset(int)'
	signals 'zoomChanged(int)'
	attr_accessor :grid, :mode, :selection
	def initialize(parent=nil)
		super parent
		@parent = parent
	end
	def init grid
	  @background_color = Qt::Color.new(0,0,255)
	  @piece_color = Qt::Color.new(0,255,0)
    setPalette(Qt::Palette.new(@background_color))
    setAutoFillBackground true
    setMouseTracking true
    @zoom = 50 #initial zoom level
    @cell_size = (0.4*@zoom).floor.to_i
    @offset_x = 0 # this is offset number of cells
    @offset_y = 0
    @ctrl_pressed = false
    @mouse_button = Qt::NoButton
    @last_mouse_pos = []    
    @mode = :none # :drawing, :erasing, :selecting
    @select_pixels = []
    @selection = []
    @selection.extend Selection # add some functions to it, rotate/mirror, min/max etc
    setFocusPolicy Qt::ClickFocus
    setFocus    
    set_grid grid
    setAcceptDrops true
	end
	def set_grid grid
	  @grid = grid
    @grid_h = @grid.length
    @grid_w = @grid[0].length
    update
	end
	def change_zoom(zoom)
    @zoom = zoom
    @cell_size = (0.4*@zoom).floor.to_i
    update
  end
  def change_x_offset(val)
    @offset_x = val
    update
  end
  def change_y_offset(val)
    @offset_y = val
    update
  end
  def resizeEvent event
  end
  def draw_grid painter    
    #vertical lines
    for x in (0..(width/@cell_size))
      painter.drawLine x*@cell_size,0,x*@cell_size,height
    end
    #horizontal lines
    for y in (0..(height/@cell_size))
      painter.drawLine 0, y*@cell_size,width,y*@cell_size
    end
  end
  def paintEvent(event)
    painter = Qt::Painter.new self
    draw_grid painter
    #draw the cells
    viewport_x = (width/@cell_size).ceil
    viewport_y = (height/@cell_size).ceil    
    for y in (@offset_y..(@offset_y+viewport_y))
      for x in (@offset_x..(@offset_x+viewport_x))
        color = @piece_color
        if y >= @grid_h or x>=@grid_h
          color = Qt::red
        end
        if @grid[y%@grid_h][x%@grid_w] == 1
          rectx = (x-@offset_x)*@cell_size
          recty = (y-@offset_y)*@cell_size
          painter.fillRect rectx+1, recty+1, @cell_size-1, @cell_size-1, color
        end    
      end    
    end
    if @mode == :selecting # draw selection box
      color = Qt::Color.new 10,100,100,150
      brush = Qt::Brush.new color
      w = @select_pixels[1][0] - @select_pixels[0][0]
      h = @select_pixels[1][1] - @select_pixels[0][1]
      painter.fillRect @select_pixels[0][0], @select_pixels[0][1], w, h, brush
    elsif @mode == :copying or @mode == :moving  # draw piece along with cursor
      brush = Qt::Brush.new Qt::cyan
      @selection.each do |pos|
        x = @last_mouse_pos[0] + pos[0] - @offset_x
        y = @last_mouse_pos[1] + pos[1] - @offset_y
        painter.fillRect x*@cell_size+1, y*@cell_size+1, @cell_size-1, @cell_size-1, brush
      end
    end
    painter.end
  end
  def win_to_grid winx,winy #converting gameboard pixel coordinates to grid coordianates
    x = (winx / @cell_size + @offset_x) % @grid_w
    y = (winy / @cell_size + @offset_y) % @grid_h
    return x,y
  end
  def insert_selection # pastes selectio into the grid
    @parent.push_grid if @parent.back_enabled
    @selection.each do |pos|
      @grid[pos[1]+@last_mouse_pos[1]][pos[0]+@last_mouse_pos[0]] = 1
    end
    update
  end 
  def mousePressEvent event
    @mouse_button = event.button
    @ctrl_pressed = (event.modifiers!= Qt::NoModifier)
    @last_mouse_pos = win_to_grid event.x, event.y #returns 2 element array
    if @mouse_button == Qt::LeftButton
      case @mode
        when :copying          
          insert_selection
        when :moving          
          insert_selection
        else
          if @ctrl_pressed and @mouse_button == Qt::LeftButton
            @select_pixels[0] = [event.x,event.y]
            @select_pixels[1] = [event.x,event.y]
            @mode = :selecting          
          elsif event.button == Qt::LeftButton
            @mode = :drawing
            pos = win_to_grid event.x,event.y      
            @grid[pos[1]][pos[0]] = 1
           end
          update
      end
    elsif @mouse_button == Qt::RightButton
      if @mode == :copying or @mode == :moving
        #rotate piece
        if @ctrl_pressed #left
          @selection.rotate :left
        else #right
          @selection.rotate :right         
        end
        update        
      else
        @mode = :erasing        
        pos = win_to_grid event.x,event.y
        @grid[pos[1]][pos[0]] = 0
        update
      end
    elsif @mouse_button == Qt::MidButton      
      if @mode == :copying or @mode == :moving
        # mirror the piece
        if @ctrl_pressed
          @selection.mirror :vertical
        else          
          @selection.mirror :horizontal         
        end
        update
      else
        @mode = :scrolling
      end
    end
    update
  end    
  def mouseMoveEvent event   
    grid_pos = win_to_grid event.x, event.y
    case @mode
      when :selecting
        @last_mouse_pos = grid_pos
        @select_pixels[1] = [event.x,event.y]
        update
      when :drawing
        if grid_pos != @last_mouse_pos
          @last_mouse_pos = grid_pos
          @grid[grid_pos[1]][grid_pos[0]] = 1
          update
        end     
      when :erasing
        if grid_pos != @last_mouse_pos
          @last_mouse_pos = grid_pos
          @grid[grid_pos[1]][grid_pos[0]] = 0
          update
       end
      when :scrolling
        if grid_pos != @last_mouse_pos        
          dx = @last_mouse_pos[0] - grid_pos[0]
          dy = @last_mouse_pos[1] - grid_pos[1]
          @offset_x += dx
          @offset_x = 0 if @offset_x < 0
          @offset_y += dy
          @offset_y = 0 if @offset_y < 0
          grid_pos[0] += dx
          grid_pos[1] += dy
          @last_mouse_pos = grid_pos          
          @parent.ui.horizontal_scrollbar.setValue @offset_x
          @parent.ui.vertical_scrollbar.setValue @offset_y
          update
        end
      when :copying
        if grid_pos != @last_mouse_pos
          @last_mouse_pos = grid_pos
          update
        end
      when :moving
        if grid_pos != @last_mouse_pos
          @last_mouse_pos = grid_pos
          update
        end
    end
    @last_mouse_pos = grid_pos
  end  
  def mouseReleaseEvent event
    if event.button == Qt::LeftButton    
      case @mode
        when :selecting
          #make the selection
          @mode = :none      
          # @select_pixels[0] is the upper left corner of selection box
          # @select_pixels[1] is the lower right corner of selection box
          xs = [@select_pixels[0][0], @select_pixels[1][0]]
          select_width = xs.max - xs.min
          ys = [@select_pixels[0][1],@select_pixels[1][1]]
          select_height = ys.max - ys.min
          x = (xs.min/@cell_size).ceil + @offset_x
          y = (ys.min/@cell_size).ceil + @offset_y
          w = (select_width/@cell_size).ceil + 1
          h = (select_height/@cell_size).ceil + 1

          @selection.clear
          for yy in y...y+h
            for xx in x..x+w            
              xx %= @grid_w
              yy %= @grid_h
              if @grid[yy][xx] == 1
                @selection << [xx,yy]
              end
            end
          end         
      when :drawing        
        @mode = :none      
      when :copying        
      when :moving
        @mode = :none        
        update
      else
        @mode = :none
      end
    elsif event.button == Qt::RightButton
      if @mode == :erasing
        @mode = :none
      end
    elsif event.button == Qt::MiddleButton
      if @mode != :copying and @mode != :moving
        @mode = :none
      end
    end
    @mouse_button = false
  end  
  def keyPressEvent event
     if event.key == Qt::Key_Escape
       @mode = :none
       update
     elsif event.key == Qt::Key_C
       #copy
       @mode = :copying
       @selection.adjust
       update
     elsif event.key == Qt::Key_X
       #cut/move
       @mode = :moving
       @selection.each do |pos|
         @grid[pos[1]][pos[0]] = 0
       end
       @selection.adjust
       @selection.mouse_pos = @last_mouse_pos
       update
     elsif event.key == Qt::Key_D or event.key == Qt::Key_Delete
       unless @selection.empty?
         # delete selection
         @selection.each do |elem|
           @grid[elem[1]][elem[0]] = 0
         end
         update
       end
     else
       event.ignore
     end
  end
  def keyReleaseEvent event
    @ctrl_pressed = false
  end
  def enterEvent event   
    setFocus(Qt::MouseFocusReason)    
    if $clipboard.has_item?
      @selection.set deep_copy_matrix($clipboard.item)
      @mode = :moving
      $clipboard.item = nil
      return      
    end
    @mode = :none
  end  
  def leaveEvent event    
    if @mode == :copying or @mode == :moving      
      selection = deep_copy_matrix @selection
      $clipboard.item = selection  
      @selection.clear
      update          
    end
  end
  def wheelEvent event
    val = (event.delta/120).to_i
    @zoom += val
    emit zoomChanged(@zoom)
  end
end


module Selection # adds some functions to a matrix to make code cleaner in a couple spots
  def self.extended base    
    class << base
      attr_accessor :mouse_pos
    end
  end
  def set vals
    clear    
    vals.each do |val|
      self.<< val
    end
  end
  def adjust #resets selection to start at 0,0
    xmin = x_min #can't directly substitue x_max and y_max bellow because the following modifies the array
    ymin = y_min        
    map!{|elem| [elem[0]-xmin,elem[1]-ymin]}
  end
  def rotate direction
    if direction == :left
      map!{ |elem| [-elem[1],elem[0]] }
    else
      map!{ |elem| [elem[1],-elem[0]] }
    end
    #adjust so there's no negative numbers
    adjust
  end  
  def mirror direction
    if direction == :horizontal      
      xmax = x_max        
      map!{|elem| [xmax-elem[0],elem[1]]}
    else
      ymax = y_max
      map!{|elem| [elem[0],ymax-elem[1]]}
    end
  end
  def x_min
    map{|elem| elem[0]}.min
  end
  def x_max
    map{|elem| elem[0]}.max
  end
  def y_min
    map{|elem| elem[1]}.min
  end
  def y_max
    map{|elem| elem[1]}.max
  end
end