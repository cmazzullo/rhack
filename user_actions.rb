module Rhack
  Actions = {
  when Left
    player.move -1, 0
  when Up
    player.move 0, -1
  when Down
    player.move 0, 1
  when Right
    player.move 1, 0

end
