module Pietr
  ##
  # This is the main interpreter class that stores the state
  # for the system as well as the main processing loop
  class Interpreter
    attr_accessor :stack
    attr_reader :size

    def initialize(image)
      @image = image
      @current_color = image.color(0, 0)
      @size = 0
      @cc = :left
      @dp = :right
      @stack = []
    end

    def run
      failed_attempts = 0
      failed_white_attempts = 0
      x = 0
      y = 0
      loop do
        if $DEBUG
          dx, dy = move_direction(x, y)
          next_color = @image.color(dx, dy)
          puts "X: #{x+1}, Y: #{y+1}, NX: #{dx+1}, NY: #{dy+1}, CR: #{@current_color}, NC: #{next_color}, STACK: #{@stack.reverse}, DP: #{@dp}, CC: #{@cc}"
        end
        # If white just sail through until we hit another color
        if @current_color == 1
          x_next, y_next = move_direction(x, y)

          # If in white and hit boundary or black then step through dp
          if restricted?(x_next, y_next)
            toggle_cc
            step_dp
            failed_white_attempts += 1
          else
            x = x_next
            y = y_next
            @current_color = @image.color(x, y)
            failed_attempts = 0
            failed_white_attempts = 0
          end

          break if failed_white_attempts == 4
        else
          @size = 0
          temp_x = x
          temp_y = y
          x, y, @size = block_fill(x, y)
          # puts "CURR: #{temp_x+1}, #{temp_y+1}, NEXT: #{x+1}, #{y+1}"
          x_next, y_next = move_direction(x, y)
          # If we are hitting the edge or a black codel try another direction
          if restricted?(x_next, y_next)
            update_movement(failed_attempts)
            failed_attempts += 1
          else # here we move into the next color block after processing the action
            next_color = @image.color(x_next, y_next)
            process_action(@current_color, next_color)
            x = x_next
            y = y_next
            @current_color = next_color
            failed_attempts = 0
            failed_white_attempts = 0
          end

          break if failed_attempts == 8
        end
      end
    end

    def process_action(current_color, next_color)
      if next_color != 1
        hue = Pietr::Color.hue_difference(current_color, next_color)
        shade = Pietr::Color.shade_difference(current_color, next_color)
        Pietr::Ops.perform_action(self, hue, shade)
      end
    end

    def update_movement(attempts)
      if attempts % 2 == 0
        toggle_cc
      else
        @dp = step_dp
      end
    end

    def move_direction(x, y)
      x_next = x
      y_next = y
      case @dp
      when :right
        x_next = x + 1
      when :down
        y_next = y + 1
      when :left
        x_next = x - 1
      when :up
        y_next = y - 1
      end

      [x_next, y_next]
    end

    def step_dp
      case @dp
      when :right
        @dp = :down
      when :down
        @dp = :left
      when :left
        @dp = :up
      when :up
        @dp = :right
      end
    end

    def step_dp_counterclockwise
      case @dp
      when :right
        @dp = :up
      when :down
        @dp = :right
      when :left
        @dp = :down
      when :up
        @dp = :left
      end
    end

    def restricted?(x, y)
      out_of_bounds?(x, y) || @image.color(x, y) == 0
    end

    def out_of_bounds?(x, y)
      x > @image.width - 1 || y > @image.height - 1 || x < 0 || y < 0
    end

    def toggle_cc
      @cc == :right ? @cc = :left : @cc = :right
    end

    # Gets the index of the codel we are moving from and the size of the
    # current color block, start max values at the index we are starting
    # from, and change them depending on the dp and cc
    def block_fill(x, y)
      marked = Array.new(@image.height) { Array.new(@image.width) }
      find_block_info_recursive(marked, 0, @dp, @cc, x, y, x, y)
    end

    def find_block_info_recursive(marked, size, dp, cc, x, y, mx, my)
      # puts "#{'-'*size}X: #{x}, Y: #{y}, MX: #{mx}, MY: #{my}, DP: #{dp}, CC: #{cc}"
      # Don't go out of bounds
      if x >= 0 && y >= 0 && y <= @image.height-1 && x <= @image.width-1
        value = @image.color(x, y)
      end

      if @current_color == value && marked[y][x] == nil
        marked[y][x] = true #"marks" the value as already checked
        size += 1 #get the size of the color block
        # puts "#{x+1}, #{y+1}, #{mx+1}, #{my+1}, #{dp}, #{cc}" if x >= 6 && @current_color == 13
        mx, my, size = find_block_info_recursive(marked, size, dp, cc, x+1, y, mx, my)
        mx, my, size = find_block_info_recursive(marked, size, dp, cc, x-1, y, mx, my)
        mx, my, size = find_block_info_recursive(marked, size, dp, cc, x, y+1, mx, my)
        mx, my, size = find_block_info_recursive(marked, size, dp, cc, x, y-1, mx, my)


        if dp == :right
          # Choose rightmost
          if x > mx
            mx = x
            my = y
          elsif x == mx
            if cc == :left # choose the uppermost
              my = y if y < my
            elsif cc == :right # choose the lowermost
              my = y if y > my
            end
          end
        elsif dp == :down
          # Choose farthest down
          if y > my
            mx = x
            my = y
          elsif y == my
            if cc == :left # choose the rightmost
              mx = x if x > mx
            elsif cc == :right # choose the leftmost
              mx = x if x < mx
            end
          end
        elsif dp == :left
          # Choose leftmost
          if x < mx
            mx = x
            my = y
          elsif x == mx            
            if cc == :left # choose the lowermost
              my = y if y > my
            elsif cc == :right # choose the uppermost
              my = y if y < my
            end
          end
        elsif dp == :up
          # Choose farthest up
          if y < my
            mx = x
            my = y
          elsif y == my
            if cc == :left # choose the leftmost
              mx = x if x < mx
            elsif cc == :right # choose the rightmost
              mx = x if x > mx
            end
          end
        end
      end
      [mx, my, size]
    end

  end
end