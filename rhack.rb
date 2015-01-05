require 'curses'
include Curses

def render_array window, a, offset
  window.setpos offset, offset
  a.each { |row|
    row.each { |col| window.addch col }
    window.setpos window.cury + 1, offset
  }
end

init_screen

x = 3
y = 2
# box
offset = 1
w = Window.new y+2, x+2, 0, 0
w.box(?|, ?-)
# map = [[?1, ?2, ?p, ?4], [?4, ?5, ?6, ?7], [?4, ?5, ?6, ?7], [?4, ?5, ?6, ?7]]
w.keypad true

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

class Entity
  attr_reader :x_pos, :y_pos, :display_char, :precedence

  def initialize x_pos, y_pos
    @x_pos, @y_pos = x_pos, y_pos
    @precedence = 0
    @display_char = '.'
  end
end

class Moveable < Entity
  def move_to x_new, y_new
    @x_pos, @y_pos = x_new, y_new
  end

  def move x_off, y_off
    move_to(@x_pos + x_off, @y_pos + y_off)
  end
end

class Player < Moveable
  def initialize x_pos, y_pos
    super

    @precedence = 5
    @display_char = '@'
  end
end

class Floor < Entity
end

class Wall < Entity
end

map = Map.new 6, 6
player = Player.new 1, 1
map.add_entity player

v = View.new x, y, 0, 0
a = v.get_area map

render_array w, a, offset
# Array.new 5 { Array.new 3 }
noecho

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
