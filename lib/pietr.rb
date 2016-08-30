require 'pietr/interpreter'
require 'pietr/image'
require 'pietr/color'
require 'pietr/ops'

module Pietr
  def self.run(filename)
    image = Pietr::Image.new(filename)
    interpreter = Pietr::Interpreter.new(image)
    interpreter.run
  end
end