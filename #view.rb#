module Rhack

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

end
