module Pietr
  ##
  # Contains all the methods that can be used in Piet
  class Ops
    class << self
      def perform_action(interpreter, hue, shade)
        method_table = [
          [nil, :push, :pop],
          [:add, :subtract, :multiply],
          [:divide, :mod, :not],
          [:greater, :pointer, :switch],
          [:duplicate, :roll, :in_number],
          [:in_char, :out, :out]
        ]

        method = method_table[hue][shade]
        if $DEBUG
          puts "METHOD: #{method}"
        end
        self.send(method, interpreter) if method
      end

      def push(interpreter)
        stack = interpreter.stack
        stack.push(interpreter.size)
      end

      def pop(interpreter)
        stack = interpreter.stack
        stack.pop
        stack
      end

      def add(interpreter)
        stack = interpreter.stack
        a = stack.pop
        b = stack.pop
        stack.push(a+b)
      end

      def subtract(interpreter)
        stack = interpreter.stack
        a = stack.pop
        b = stack.pop
        stack.push(b-a) if a && b
      end

      def multiply(interpreter)
        stack = interpreter.stack
        a = stack.pop
        b = stack.pop
        stack.push(a*b) if a && b
      end

      # maybe catch divide by zero
      def divide(interpreter)
        stack = interpreter.stack
        a = stack.pop
        b = stack.pop
        stack.push(b/a) if a && b
      end

      # maybe catch divide by zero
      def mod(interpreter)
        stack = interpreter.stack
        a = stack.pop
        b = stack.pop
        stack.push(b%a) if a && b
      end

      def not(interpreter)
        stack = interpreter.stack
        a = stack.pop
        a == 0 ? stack.push(1) : stack.push(0)
      end

      def greater(interpreter)
        stack = interpreter.stack
        a = stack.pop
        b = stack.pop
        b > a ? stack.push(1) : stack.push(0)
      end

      def pointer(interpreter)
        stack = interpreter.stack
        a = stack.pop
        if a > 0
          (1..a).each { interpreter.step_dp }
        else
          (1..a.abs).each { interpreter.step_dp_counterclockwise } 
        end
      end

      def switch(interpreter)
        stack = interpreter.stack
        a = stack.pop
        (1..a.abs).each { interpreter.toggle_cc }
      end

      def duplicate(interpreter)
        stack = interpreter.stack
        a = stack.last
        stack.push(a) if a
      end

      def roll(interpreter)
        stack = interpreter.stack
        rolls = stack.pop
        depth = stack.pop
        (1..rolls.abs).each do
          if rolls > 0
            a = stack.pop
            stack.insert(-depth, a)
          else
            a = stack.delete_at(-depth)
            stack.push(a)
          end
        end
        stack
      end

      def in_number(interpreter)
        stack = interpreter.stack
        print "Enter a Number: "
        a = gets.chomp
        a = a.strip
        stack.push(a.to_i) if !a.empty?
      end

      def in_char(interpreter)
        stack = interpreter.stack
        print "Enter a Char: "
        a = gets.chomp
        a = a.strip
        stack.push(a[0]) if !a.empty?
      end

      def out(interpreter)
        stack = interpreter.stack
        puts stack.pop if !stack.last.nil?
      end
    end
  end
end