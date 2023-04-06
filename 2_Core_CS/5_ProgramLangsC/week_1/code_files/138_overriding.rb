# Programming Languages, Dan Grossman
# Section 7: Overriding and Dynamic Dispatch

class Point
  attr_accessor :x, :y

  def initialize(x,y)
    @x = x
    @y = y
  end
  def distFromOrigin
    Math.sqrt(@x * @x  + @y * @y) # uses instance variables directly
  end
  def distFromOrigin2
    Math.sqrt(x * x + y * y) # uses getter methods
  end

end



# design question: "Is a 3D-point a 2D-point?"
# [arguably poor style here, especially in statically typed OOP languages]
class ThreeDPoint < Point
  attr_accessor :z

  def initialize(x,y,z)
    super(x,y)
    @z = z
  end
=begin
  `super(x,y)` calls the `initialize` method of the superclass `Point`, passing
  in the arguments `x` and `y`.

  This initializes the `@x` and `@y` instance variables of the `ThreeDPoint`
  object with the values of `x` and `y`.

  `super` without arguments would have called the `initialize` method of the
  superclass without passing any arguments.
=end

  def distFromOrigin
    d = super
    Math.sqrt(d * d + @z * @z)
  end

  def distFromOrigin2
    d = super
    Math.sqrt(d * d + z * z)
  end
=begin
   In the context of the `ThreeDPoint` class, `d = super` invokes the `distFromOrigin`
   method defined in the parent `Point` class, and assigns its return value to the
   local variable `d`.

   This allows the `ThreeDPoint` class to reuse the functionality of the `distFromOrigin`
   method defined in the parent class, while also adding additional functionality specific
   to the `ThreeDPoint` class.

   so `super` calls method of the superclass class with the same
   method name where `super` called.
=end
end



class PolarPoint < Point
  # Interesting: by not calling super constructor, no x and y instance vars
  # In Java/C#/Smalltalk would just have unused x and y fields
  def initialize(r,theta)
    @r = r
    @theta = theta
  end

  def x
    @r * Math.cos(@theta)
  end

  def y
    @r * Math.sin(@theta)
  end

  def x= a
    b = y # avoids multiple calls to y method
    @theta = Math.atan2(b, a)
    @r = Math.sqrt(a*a + b*b)
    self
  end

  def y= b
    a = x # avoid multiple calls to y method
    @theta = Math.atan2(b, a)
    @r = Math.sqrt(a*a + b*b)
    self
  end

  def distFromOrigin # must override since inherited method does wrong thing
    @r
  end

  # inherited distFromOrigin2 already works!!

end



# three point example
pp = ThreeDPoint.new(3,4,5)
puts pp.x
puts pp.y
puts pp.z
puts pp.distFromOrigin

puts

# the key example
pp = PolarPoint.new(4,Math::PI/4)
puts pp.x
puts pp.y
puts pp.distFromOrigin2
