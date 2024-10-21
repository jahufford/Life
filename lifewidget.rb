require './lifewidget_ui.rb'
require 'Qt'

class LifeWidget < Qt::Widget
  slots 'change_speed(int)','compute_next_generation()','on_runB_clicked()',
           'on_restartB_clicked()','on_stepB_clicked()',
           'on_backB_clicked()'
  attr_accessor :ui, :back_enabled
  def initialize(parent=nil, gridw=100, gridh=100,gbv_w=200,gbv_h=200)
                         # grid width and height, gameboard_viewer width and height in pixels
    super parent
    @ui = Ui_LifeWidget.new
    @ui.setupUi(self)
    @timer = Qt::Timer.new(self)  
    @speed = 100
    @gridw = gridw
    @gridh = gridh
    init_grids

    @ui.gameboard_viewer.init @grid 
    @ui.horizontal_scrollbar.setMinimum(0)
    @ui.horizontal_scrollbar.setMaximum(200)
    @ui.horizontal_scrollbar.setValue 0
    @ui.vertical_scrollbar.setMinimum(0)
    @ui.vertical_scrollbar.setMaximum(100)
    @ui.vertical_scrollbar.setValue 0
    @ui.universe_sizeL.setText "#{@gridw}x#{@gridh}"
    
    connect(@ui.zoom_slider,SIGNAL('valueChanged(int)'),@ui.gameboard_viewer, SLOT('change_zoom(int)'))    
    connect(@ui.horizontal_scrollbar,SIGNAL('valueChanged(int)'),@ui.gameboard_viewer,SLOT('change_x_offset(int)'))
    connect(@ui.vertical_scrollbar,SIGNAL('valueChanged(int)'),@ui.gameboard_viewer,SLOT('change_y_offset(int)'))
    connect(@ui.speed_slider,SIGNAL('valueChanged(int)'),self, SLOT('change_speed(int)'))    
    @ui.gameboard_viewer.connect(SIGNAL 'zoomChanged(int)') do |val|
      @ui.zoom_slider.setValue(val)
    end
    @ui.clearB.connect(SIGNAL :clicked) do      
      init_grids
      load_grid @grid     
    end
    @ui.gameboard_viewer.setMinimumSize gbv_w,gbv_h    
		connect(@timer,SIGNAL('timeout()'),self,SLOT('compute_next_generation()'))
    @running = false    
    @ticks = Time.now
    
    @cells_to_add = Array.new
    @cells_to_delete =Array.new
    @back_enabled = false # whether you can can step back to previous generations
    @ui.backCB.connect(SIGNAL 'stateChanged(int)') do |state|
      if state == Qt::Checked
        @back_enabled = true
        @ui.backB.setEnabled true
      else
        @back_enabled = false
        @ui.backB.setEnabled false
      end
    end    
    @back_buffer_size = 30
    @ui.back_buffer_depthSB.connect(SIGNAL 'valueChanged(int)') do |val|
      @back_buffer_size = val
    end 
    @last_paint_time = Time.now
  end
  def init_grids #new grid and cleared history buffer
    @grid = Array.new    
    @grid = (0..(@gridh-1)).to_a.map{|row| row=(0..(@gridw-1)).to_a.map{|x| x = 0}}
    @generation = 0
    @previous_grid = deep_copy_matrix @grid #each time run is pressed, it saves the grid, so you can rerun a setup
    @previous_generation = 0
    @grid[10][9] = 1
    @grid[11][8] = 1
    @grid[10][10] = 1
    @grid[11][10] = 1
    @grid[12][10] = 1

    @grids = Array.new
  end
  def load_grid grid
    @grid = grid
    @ui.gameboard_viewer.set_grid @grid
    @ui.gameboard_viewer.update
  end
    
  def change_speed speed
    @speed = 200 - speed
    @timer.setInterval(@speed)
  end
  def run
    @previous_generation = @generation
    @previous_grid = deep_copy_matrix @grid
    @running = true
    @timer.start(@speed)
    @ui.runB.setText("Pause")
  end
  def stop
    @running = false
    @timer.stop
    @ui.runB.setText("Run")
    @ui.gameboard_viewer.update
  end
  def on_runB_clicked    
    if @running
      stop
    else
      run
    end
  end
  def get_grid
    stop
    @grid
  end
  def on_stepB_clicked
    compute_next_generation
  end
  def on_backB_clicked
    unless @grids.empty?
      @grid = @grids.pop
      @ui.gameboard_viewer.grid = @grid
      @ui.gameboard_viewer.update
    end
  end  
  def push_grid
    old_grid = deep_copy_matrix @grid    
    @grids << old_grid
    if @grids.length > @back_buffer_size
      @grids.shift #get rid of the oldest one
    end
  end
  def compute_next_generation
    push_grid if @back_enabled
    @generation += 1
    @ui.generationL.setText(@generation.to_s)
    @cells_to_add.clear
    @cells_to_delete.clear
    row = 0
    col = 0 
    0.upto(@gridh-1) do |row|
      0.upto(@gridw-1) do |col|
        num_neighbors = number_of_neighbors(row,col)
        if @grid[row][col] == 1
          if num_neighbors < 2 or num_neighbors > 3
            @cells_to_delete << [row,col]
          end
        else
          if num_neighbors == 3
            @cells_to_add << [row,col]
          end          
        end
        col += 1
      end
      row += 1
    end
          
    @cells_to_add.each do |row,col|
      @grid[row][col] = 1;
    end
    @cells_to_delete.each do |row, col|
      @grid[row][col] = 0;
    end

    dt = Time.now - @last_paint_time
    if dt > 1/30 #paint at a max of 30 frames /sec
      @ui.gameboard_viewer.update
      @last_paint_time = Time.now
    end
  end
  def number_of_neighbors(row,col)
    count = 0   
    for r in (row-1)..(row+1)
      for c in (col-1)..(col+1)
        unless r==row and c==col
          count += 1 if @grid[r % @gridh][c % @gridw] == 1
        end
      end
    end
    count
  end 
  def keyPressEvent event
    if event.key == Qt::Key_R
      run
    elsif event.key == Qt::Key_S and event.modifiers == Qt::NoModifier
      stop
    else
      event.ignore
    end
  end
  def on_restartB_clicked
    @grid = @previous_grid
    @ui.gameboard_viewer.grid = @grid
    @ui.gameboard_viewer.update
  end    
end
