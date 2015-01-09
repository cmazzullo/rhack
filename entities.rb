module Rhack

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

end
