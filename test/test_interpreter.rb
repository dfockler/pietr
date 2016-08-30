require_relative './test_helper'

class TestInterpreter < Minitest::Test
  def setup
    image = Pietr::Image.new("assets/euclid_clint.png")
    @interpreter = Pietr::Interpreter.new(image)
  end

  def test_init
    # assert @interpreter
  end
end