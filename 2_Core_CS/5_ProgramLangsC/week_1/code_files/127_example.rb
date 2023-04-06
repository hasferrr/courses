# Programming Languages, Dan Grossman
# Section 7: A Longer Example

class MyRational


  def initialize(num,den=1) # second argument has a default
    if den == 0
      raise "MyRational received an inappropriate argument"
    elsif den < 0 # notice non-english word elsif
      @num = - num # fields created when you assign to them
      @den = - den
    else
      @num = num # semicolons optional to separate expressions on different lines
      @den = den
    end
    reduce # i.e., self.reduce() but private so must write reduce or reduce()
  end



  def to_s 
    ans = @num.to_s
    if @den != 1 # everything true except false _and_ nil objects
      ans += "/"
      ans += @den.to_s 
    end
    ans
  end
=begin
  <================== NOTES ==================>

  (1) what does `ans = @num.to_s` do? we use to_s method to the number?

  Yes, you are correct. In the to_s method of the MyRational class in Ruby,
  the @num.to_s call converts the @num instance variable (which holds the numerator
  of the rational number) to a string using the to_s method. The resulting string is
  then concatenated with other strings to form the final output string that represents
  the rational number.

  In Ruby, the to_s method is defined on many built-in classes, including Integer,
  Float, and Rational. Calling to_s on an instance of one of these classes returns
  a string representation of the value.


  (2) so which object.to_s that i call dependent to the object right? for example:
  - if i call `123.to_s` i will use to_s from built-in classes in Ruby,
  - but if i call `my_rational.to_s` and my_rational is an instance of MyRational class,
    so i will call to_s belongs to MyRational class

  That's correct! When you call to_s on an object in Ruby, it will use the to_s method
  that belongs to the class of the object. If the class of the object does not define
  its own to_s method, it will use the default to_s method inherited from Ruby's built-in
  classes.
=end



  def to_s2 # using some unimportant syntax and a slightly different algorithm
    dens = ""
    dens = "/" + @den.to_s if @den != 1
    @num.to_s + dens
  end



  def to_s3 # using things like Racket's quasiquote and unquote
    "#{@num}#{if @den==1 then "" else "/" + @den.to_s end}"
  end



  def add! r # mutate self in-place
    a = r.num # only works b/c of protected methods below
    b = r.den # only works b/c of protected methods below
    c = @num
    d = @den
    @num = (a * d) + (b * c)
    @den = b * d
    reduce
    self # convenient for stringing calls
  end
=begin
  <================== NOTES ==================>

  (1) what does `r.num` do (in `add! method`)?

  r.num retrieves the value of the @num instance variable of the r object,
  which is an instance of the MyRational class.

  In the add! method, `r` is a parameter that represents another instance of the
  MyRational class. By calling `r.num`, the value of the `@num` instance variable
  of that instance is retrieved and assigned to the local variable `a`.

  see protected `num` and `den` methods below


  (2) why not just `a = @num?`

  In the add! method of the MyRational class, `a` is being set to the numerator
  of the `r` object, which is an instance of MyRational. The `num` method is being called
  on the `r` object to get its numerator.

  If a were set to @num, it would be getting the numerator of the current instance
  of MyRational, not the numerator of the `r` object. This would not be correct if `r`
  represents a different rational number than the current instance of MyRational.


  ------> so that variable `a` is get the value `@num` from object from add! method
=end



  # a functional addition, so we can write r1.+ r2 to make a new rational
  # and built-in syntactic sugar will work: can write r1 + r2
  def + r
    ans = MyRational.new(@num,@den)
    ans.add! r
    ans
  end



protected
  # there is very common sugar for this (attr_reader)
  # the better way:
  # attr_reader :num, :den
  # protected :num, :den
  # we do not want these methods public, but we cannot make them private
  # because of the add! method above
  def num
    @num
  end
  def den
    @den
  end



private
  def gcd(x,y) # recursive method calls work as expected
    if x == y
      x
    elsif x < y
      gcd(x,y-x)
    else
      gcd(y,x)
    end
  end



  def reduce
    if @num == 0
      @den = 1
    else
      d = gcd(@num.abs, @den) # notice method call on number
      @num = @num / d
      @den = @den / d
    end
  end
end



# can have a top-level method (just part of Object class) for testing, etc.
#def use_rationals
  r1 = MyRational.new(3,4)
  r2 = r1 + r1 + MyRational.new(-5,2)
  puts r2.to_s
  (r2.add! r1).add! (MyRational.new(1,-4))
  puts r2.to_s
  puts r2.to_s2
  puts r2.to_s3
#end
