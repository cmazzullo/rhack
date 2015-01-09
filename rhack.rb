require_relative 'entities'
require_relative 'key_constants'
require_relative 'map'
require_relative 'view'
require_relative 'curses_ui'
require_relative 'user_context'
require_relative 'quit_context'
include Rhack

win_width = 20
win_height = 10
border_size = 1

ui = CursesUI.new win_width, win_height, border_size

# Make a map, view and player for this session
map = Map.new win_width, win_height
player = Player.new 1, 1, win_width, win_height
map.add_entity player

v = View.new win_width, win_height, 0, 0
context = UserContext.new player

loop do # Main loop
  a = v.get_area map
  ui.render_array a
  char = ui.get_user_input

  context = context.process char
  break if context.class == QuitContext
end

ui.cleanup
