module Pietr
  ##
  # The color class is responsible for converting the
  # color in the image into something that can be used
  # to compute the shade and hue difference between two
  # colors.
  # 
  # Note that the shade and hue 'wrap around'
  # i.e. Light -> Medium -> Dark -> Light
  # So the difference between Dark to Medium is 2 'darker'

  class Color

    ##
    # Operates on Pietr color codes from the #color_code method
    # Returns the shade difference between two colors
    #
    # Shade is encoded in the ones place
    # 1 - Light, 2 - Medium, 3 - Dark
    # i.e. Color code of 21 is a light yellow
    def self.shade_difference(current_color, next_color)
      current_shade = current_color % 10
      next_shade = next_color % 10
      if current_shade > next_shade
        shade = (current_shade - (next_shade + 3)).abs
      else
        shade = (next_shade - current_shade)
      end

      shade
    end

    ##
    # Operates on Pietr color codes
    # Returns the hue difference between two colors
    #
    # Hue is encoded in the tens place
    # 1 - Red, 2 - Yellow, 3 - Green ...
    # i.e. Color code of 21 is a light yellow, 22 is yellow
    def self.hue_difference(current_color, next_color)
      current_hue = current_color / 10
      next_hue = next_color / 10
      if current_hue > next_hue
        hue = (current_hue - (next_hue + 6)).abs
      else
        hue = (next_hue - current_hue)
      end

      hue
    end

    ##
    # Returns the color code given a color hex value
    # The tens place has the hue encoded
    # The ones place has the shade encoded
    def self.color_code(color)
      case color
      when "#ffc0c0ff" # light red
        11
      when "#ffffc0ff" # light yellow
        21
      when "#c0ffc0ff" # light green
        31
      when "#c0ffffff" # light cyan
        41
      when "#c0c0ffff" # light blue
        51
      when "#ffc0ffff" # light magenta
        61
      when "#ff0000ff" # red
        12
      when "#ffff00ff" # yellow
        22
      when "#00ff00ff" # green
        32
      when "#00ffffff" # cyan
        42
      when "#0000ffff" # blue
        52
      when "#ff00ffff" # magenta
        62
      when "#c00000ff" # dark red
        13
      when "#c0c000ff" # dark yellow
        23
      when "#00c000ff" # dark green
        33
      when "#00c0c0ff" # dark cyan
        43
      when "#0000c0ff" # dark blue
        53
      when "#c000c0ff" # dark magenta
        63
      when "#ffffffff" # white
        1
      when "#000000ff" # black
        0
      else # if color not found return 0
        0
      end
    end
  end
end