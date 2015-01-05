# Map and view - the environment

class View
  def initialize x_size, y_size, x_offset, y_offset
    @x_size = x_size
    @y_size = y_size
    @x_offset = x_offset
    @y_offset = y_offset
  end

  def get_area map
    v = map.flatten[@y_offset..(@y_offset + @y_size -1)]
    v.collect {|row| row[@x_offset..(@x_offset + @x_size -1)]}
  end

  def set_pos x, y
    @x_offset = x
    @y_offset = y
  end

  def move x_inc, y_inc
    set_pos @x_offset + x_inc, @y_offset + y_inc
  end
end

class Map
  def initialize x_size, y_size, blank_char = ' '
    @x_size, @y_size = x_size, y_size
    @blank_char = blank_char
    @entities = []
  end

  def add_entity entity
    @entities << entity
  end

  def remove_entity entity
    @entities.remove(entity)
  end

  def flatten
    map_ary = Array.new(@y_size) { Array.new(@x_size) { @blank_char } }
    @entities.sort{|a, b| a.precedence <=> b.precedence }.each{|entity|
      map_ary[entity.y_pos][entity.x_pos] = entity.display_char
    }
    map_ary
  end
end

# Entities - objects in the game

class Entity
  attr_reader :x_pos, :y_pos, :display_char, :precedence

  def initialize x_pos, y_pos, win_width, win_height
    @x_pos, @y_pos = x_pos, y_pos
    @win_width, @win_height = win_width, win_height
    @precedence = 0
    @display_char = '.'
  end
end

class Moveable < Entity
  def move_to x_new, y_new
    @x_pos, @y_pos = x_new, y_new
  end

  def move x_off, y_off
    new_x = (@x_pos + x_off) % @win_width
    new_y = (@y_pos + y_off) % @win_height
    move_to(new_x, new_y)
  end
end

class Player < Moveable
  def initialize x_pos, y_pos, win_width, win_height
    super
    @precedence = 5
    @display_char = '@'
  end
end

class Floor < Entity
end

class Wall < Entity
end

# Curses stuff

require 'curses'
include Curses

def render_array window, a, offset
  window.setpos offset, offset
  a.each { |row|
    row.each { |col| window.addch col }
    window.setpos window.cury + 1, offset
  }
end

# Make an empty window

win_width = 20
win_height = 10
offset = 1 # width of the border

init_screen # initializes a screen the size of the terminal
w = Window.new win_height + 2*offset, win_width + 2*offset, 0, 0
w.box(?|, ?-)
w.keypad true

# Make a map, view and player for this session

map = Map.new win_width, win_height
player = Player.new 1, 1, win_width, win_height
map.add_entity player

v = View.new win_width, win_height, 0, 0
a = v.get_area map

render_array w, a, offset
noecho

# Main loop

loop do
  char = w.getch

  case char
  when ?q
    break
  when KEY_LEFT
    player.move -1, 0
  when KEY_UP
    player.move 0, -1
  when KEY_DOWN
    player.move 0, 1
  when KEY_RIGHT
    player.move 1, 0
  else
    next
  end

  a = v.get_area map
  render_array w, a, offset
end

w.close
