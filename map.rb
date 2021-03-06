module Rhack

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

    def get_entities x, y
      @entities.select { |entity|
        entity.y_pos == y && entity.x_pos == x
      }
    end

    def flatten
      map_ary = Array.new(@y_size) { Array.new(@x_size) { @blank_char } }
      @entities.sort{|a, b| a <=> b }.each{|entity|
        map_ary[entity.y_pos][entity.x_pos] = entity.display_char
      }
      map_ary
    end
  end

end
