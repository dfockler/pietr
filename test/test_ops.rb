require_relative './test_helper'

class InterpreterStub
  attr_accessor :stack, :size, :dp, :cc

  def initialize(stack, size, dp, cc)
    @stack = stack
    @size = size
    @dp = dp
    @cc = cc
  end
end

class TestOps < Minitest::Test
  def setup
    @interpreter = InterpreterStub.new([1, 2, 3], 12, :left, :right)
  end

  def test_push
    assert_equal(Pietr::Ops.push(@interpreter), [1, 2, 3, 12]) 
  end

  def test_pop
    assert_equal(Pietr::Ops.pop(@interpreter), [1, 2]) 
  end

  def test_add
    assert_equal(Pietr::Ops.add(@interpreter), [1, 5]) 
  end

  def test_subtract
    assert_equal(Pietr::Ops.subtract(@interpreter), [1, -1])
  end

  def test_multiply
    assert_equal(Pietr::Ops.multiply(@interpreter), [1, 6])
  end

  def test_divide
    assert_equal(Pietr::Ops.divide(@interpreter), [1, 0])
  end

  def test_mod
    assert_equal(Pietr::Ops.mod(@interpreter), [1, 2])
  end

  def test_not_zero
    assert_equal(Pietr::Ops.not(@interpreter), [1, 2, 0])
  end

  def test_not_one
    @interpreter.stack = [1, 2, 0]
    assert_equal(Pietr::Ops.not(@interpreter), [1, 2, 1])
  end

  def test_greater_false
    assert_equal(Pietr::Ops.greater(@interpreter), [1, 0])
  end

  def test_greater_true
    @interpreter.stack = [1, 2, 1]
    assert_equal(Pietr::Ops.greater(@interpreter), [1, 1])
  end

  def test_pointer
    # assert_equal(Pietr::Ops.pointer(@interpreter), [1, 5])
  end

  def test_switch
    # assert_equal(Pietr::Ops.switch(@interpreter), [1, 2, 3])
  end

  def test_duplicate
    assert_equal(Pietr::Ops.duplicate(@interpreter), [1, 2, 3, 3])
  end

  def test_roll_normal
    @interpreter.stack = [1, 2, 3, 2, 2]
    assert_equal([1, 2, 3], Pietr::Ops.roll(@interpreter))
  end

  def test_roll_backwards
    @interpreter.stack = [1, 2, 3, 2, -1]
    assert_equal([1, 3, 2], Pietr::Ops.roll(@interpreter))
  end
end