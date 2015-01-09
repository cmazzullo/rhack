# -*- coding: utf-8 -*-
require 'singleton'

module Rhack

  class Entity
    include Comparable
    attr_reader :x_pos, :y_pos, :display_char, :priority

    NoClip = :noclip
    Substantial = :substantial
    Stackable = :stackable
    Background = :background

    def initialize x_pos, y_pos, win_width, win_height
      @x_pos, @y_pos = x_pos, y_pos
      @win_width, @win_height = win_width, win_height
      @priority = Stackable
      @display_char = '.'
    end

    def <=> other
      return 0 if @priority == other.priority
      return 1 if other.priority == Background
      return -1 if other.priority == NoClip
      return 1 if @priority == NoClip
      return 1 if @priority == Substantial
      -1
    end
  end

  class MoveArbiter
    include Singleton

    def set_map map
      @map = map
    end

    def legal_space? x, y, entity
      case entity.priority
        when Entity::Background
        False
        when Entity::NoClip
        True
        when Entity::Stackable
        True
      when Entity::Substantial
        occupants = @map.get_entities x, y
        ! occupants.any? { |occupant|
          occupant.priority == Entity::Substantial
        }
      end
    end
  end

  class Moveable < Entity
    def move_to x_new, y_new
      if MoveArbiter.instance.legal_space? x_new, y_new, self
        @x_pos, @y_pos = x_new, y_new
      end
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
      @priority = Substantial
      @display_char = '@'
    end
  end

  class Impassible < Entity
    def initialize x_pos, y_pos, win_width, win_height
      super
      @priority = Substantial
    end
  end

  class Wall < Impassible
    def initialize x_pos, y_pos, win_width, win_height
      super
      @display_char = '|'
    end
  end
end
