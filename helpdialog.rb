require 'Qt'
class HelpDialog < Qt::Dialog
  def initialize parent
    super
    setWindowTitle "Help"
    help_text = Qt::Label.new <<-HELPTEXT
      <center><h3>The Game of Life</h3></center>
      <p>This is the classic Conway's game of life. Set up your initial pattern by filling
       in cells and then press run and see what evolves! There's only a few simples rules.
       <ol>
           <li>A living cell with fewer than 2 neighbors dies from loneliness</li>
           <li>A living cell with more than 3 neighbors dies from overcrowding</li>
           <li>An empty cell with exactly 3 neighbors becomes a live cell.
       </ol>
       The main game board is on the left. If you find a configuration that you like,
       you can copy and paste it into the pieces box. Click on pieces and then paste them onto a gameboard.
       The universe wraps around on both the sides and the top and bottom. Cells painted red lets you know you're
       seeing a part of the universe that has wrapped around
       </p>
      <hr>
      <center>Top Controls</center>
      <p>
      <table>
       <tr>
        <td align=left width=33%>Run</td><td> Runs the current game board</td>
       </tr>
      <tr>
        <td align=left>Restart</td><td>Returns the game board to how it was before run was pressed. Lets you replay a configuration</td>
      </tr>
      <tr>
       <td align=left>Step</td><td>Steps one generation</td>
      </tr>
      <tr>
       <td align=left>Back</td><td>Steps back one generation</td>
      </tr>
      <tr>
       <td align=left>Undo/Back</td><td>Back/Undo must be enable before you can use it. The buffer depth is the number of steps back you can do</td>
      </tr>
      <tr>
       <td align=left>Clear</td><td>Clears the board and leaves you with a Gosper glider to start with</td>
      </tr>
      </table>           
      </p>
      <hr>
      <center>Keyboard and Mouse Controls</center>
      <p>
      <table>
       <tr>
        <td align=left width=33%>Left Click</td><td>Fills in cells. Hold down to fill in multiple cells</td>
       </tr>
       <tr>
        <td align=left>Right Click</td><td>Erases cells. Hold down to erase multiple cells</td>
       </tr>
       <tr>
        <td align=left>R</td><td>runs the current game board</td>
       </tr>
       <tr>
        <td align=left>S</td><td>Pauses game</td>
       </tr>
       <tr>
        <td align=left>Ctrl + S</td><td>Save the game boads and the pieces box</td>
       </tr>
       <tr>
        <td align=left>Middle Click + Drag</td><td>Moves the grid</td>
       </tr>
       <tr>
        <td align=left>Middle Scroll</td><td>Zooms the boards in and out</td>
       </tr>
       <tr>
        <td align=left>Shift/Ctrl + Left Click + Drag</td><td>Draw selection box. Escape to cancel</td>
       </tr>
       <tr>
        <td align=left>C</td><td>Copy selection box. Left Click to paste. Mulitple Left Clicks will paste multiple times. Ecape exits copy mode</td>
       </tr>
       <tr>
        <td align=left>X</td><td>Cut/Move the selection box</td>
       </tr>
       <tr>
        <td align=left>D/Delete</td><td>Delete selection</td>
       </tr>
       <tr>
        <td align=left>Right Click while moving or copying</td><td>Rotates selection to the left</td>
       </tr>
       <tr>
        <td align=left>Shift/Ctrl + Right Click while moving or copying</td><td>Rotate selection to the right</td>
       </tr>
       <tr>
        <td align=left>Middle Click while moving or copying</td><td>Flip selection horizontally</td>
       </tr>
       <tr>
        <td align=left>Shift/Ctrl + Middle Click while moving or copying</td><td>Flip selection vertically</td>
       </tr>
      </table>
      </p>
    HELPTEXT
        
    help_text.setWordWrap true
            
    done_pb = Qt::PushButton.new "done"
    done_pb.setDefault true
    done_pb.connect(SIGNAL :clicked){done(0)}
    vl = Qt::VBoxLayout.new do
      addWidget help_text
      h = Qt::HBoxLayout.new
      h.addStretch
      h.addWidget done_pb
      addLayout h
      #addWidget done_pb
    end
    setLayout vl
    resize sizeHint
  end  
end