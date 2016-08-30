require_relative './test_helper'

class TestImage < Minitest::Test
  def setup
    @image = Pietr::Image.new("assets/euclid_clint.png")
  end

  def test_init
    assert @image
  end

  def test_width
    assert_equal(@image.width, 10)
  end

  def test_height
    assert_equal(@image.height, 10)
  end

  def test_xy_color
    assert_equal(@image.color(0, 0), 12)
  end
end