require 'pietr/interpreter'
require 'pietr/image'
require 'pietr/color'
require 'pietr/ops'
require 'byebug'

module Pietr
  def self.run
    image = Pietr::Image.new("assets/piet_factorial.png")
    interpreter = Pietr::Interpreter.new(image)
    interpreter.run
  end
end