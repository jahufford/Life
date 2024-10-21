require 'Qt'
require './mainwindow.rb'

def deep_copy_matrix matrix
  #deep copy of an array of arrays, dup'ing won't cut it
  cp = []
  matrix.each do |row|
    cp << row.dup
  end
  cp
end

app = Qt::Application.new(ARGV)

mainWindow = MyMainWindow.new
mainWindow.show

app.exec()
