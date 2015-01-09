require_relative 'key_constants'
require 'curses'
include Curses

class CursesUI
  def initialize win_width, win_height, border_size
    @win_width = win_width
    @win_height = win_height
    @border_size = border_size
    @key_hash = Hash.new do |hash, key|
      key
    end
    @key_hash[KEY_LEFT] = Rhack::Left
    @key_hash[KEY_RIGHT] = Rhack::Right
    @key_hash[KEY_UP] = Rhack::Up
    @key_hash[KEY_DOWN] = Rhack::Down
    init_window
  end

  def get_user_input
    char = @win.getch
    @key_hash[char]
  end

  def render_array view_box
    @win.setpos @border_size, @border_size
    view_box.each { |row|
      row.each { |col| @win.addch col }
      @win.setpos @win.cury + 1, @border_size
    }
  end

  def cleanup
    @win.close
  end

  private
  def init_window
    Curses::init_screen # initializes a screen the size of the terminal
    height = @win_height + 2*@border_size
    width = @win_width + 2*@border_size
    @win = Window.new height, width, 0, 0
    @win.box(?|, ?-)
    @win.keypad true
    noecho
  end
end
