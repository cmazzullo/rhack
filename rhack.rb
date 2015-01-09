require_relative 'entities'
require_relative 'key_constants'
require_relative 'map'
require_relative 'view'
require_relative 'curses_ui'

include Rhack

win_width = 20
win_height = 10
border_size = 1 # width of the border

ui = CursesUI.new win_width, win_height, border_size

# Make a map, view and player for this session
map = Map.new win_width, win_height
player = Player.new 1, 1, win_width, win_height
map.add_entity player

v = View.new win_width, win_height, 0, 0
a = v.get_area map

ui.render_array a

# Main loop

loop do
  char = ui.get_user_input

  case char
  when ?q
    break
  when Left
    player.move -1, 0
  when Up
    player.move 0, -1
  when Down
    player.move 0, 1
  when Right
    player.move 1, 0
  else
    next
  end

  a = v.get_area map
  ui.render_array a
end

ui.cleanup
