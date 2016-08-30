require 'chunky_png'

module Pietr
  ##
  # The image class is where all of the image processing
  # functions and utilities for the interpreter go.
  #
  # Outputs an error if it can't open the input file
  class Image
    def initialize(filename)
      @image = ChunkyPNG::Image.from_file(filename)
    end

    def height
      @image.height
    end

    def width
      @image.width
    end

    ##
    # Returns a Pietr useable color code
    def color(x, y)
      Pietr::Color.color_code(ChunkyPNG::Color.to_hex(@image[x, y]))
    rescue Exception
      -1
    end
  end
end