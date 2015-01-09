# user_context.rb
#
# Author::  Kyle Mullins

require_relative 'key_constants'
require_relative 'quit_context'

module Rhack
	class UserContext
		def initialize player
			@player = player
			@actions = {
					'q' => :quit,
					Left => :move_left,
					Right => :move_right,
					Up => :move_up,
					Down => :move_down
			}
		end

		def process input
			action = @actions[input]
			action.nil? ? self : send(action)
		end

		private

		def quit
			QuitContext.new
		end

		def move_left
			@player.move -1, 0
			self
		end

		def move_right
			@player.move 1, 0
			self
		end

		def move_up
			@player.move 0, -1
			self
		end

		def move_down
			@player.move 0, 1
			self
		end
	end
end
