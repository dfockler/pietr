require 'test_helper'

class TestColor < Minitest::Test
  def test_color_code
    assert_equal(Pietr::Color.color_code("#ff0000ff"), 12)
  end

  def test_bad_color_code
    assert_equal(Pietr::Color.color_code("#aa22ffff"), 0)
  end

  def test_black_color_code
    assert_equal(Pietr::Color.color_code("#000000ff"), 0)
  end

  def test_white_color_code
    assert_equal(Pietr::Color.color_code("#ffffffff"), 1)
  end

  def test_hue_difference
    assert_equal(Pietr::Color.hue_difference(11, 43), 3)
  end

  def test_shade_difference
    assert_equal(Pietr::Color.shade_difference(11, 43), 2)
  end

  def test_hue_wraparound_difference
    assert_equal(Pietr::Color.hue_difference(53, 12), 2)
  end

  def test_shade_wraparound_difference
    assert_equal(Pietr::Color.shade_difference(13, 12), 2)
  end
end