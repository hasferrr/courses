# Object-Oriented Programming

## Class

### instance variables

```ruby
class Person
  def initialize(name, age)
    @name = name
    @age = age
    @is_adult = age >= 18
  end

  def name
    @name
  end

  def age
    @age
  end

  def is_adult
    @is_adult
  end
end

person1 = Person.new("John", 25)
person2 = Person.new("Jane", 17)

puts person1.name    # Output: John
puts person2.name    # Output: Jane

puts person1.age     # Output: 25
puts person2.age     # Output: 17

puts person1.is_adult    # Output: true
puts person2.is_adult    # Output: false
```

### class variables

```ruby
class Person
  @@total_people = 0

  def initialize(name, age)
    @name = name
    @age = age
    @@total_people += 1
  end

  def name
    @name
  end

  def age
    @age
  end

  def self.total_people
    @@total_people
  end
end

person1 = Person.new("John", 25)
person2 = Person.new("Jane", 17)

puts Person.total_people    # Output: 2
```

### class constant

```ruby
class Triangle
  PI = 3.14 # <--- class constant

  def initialize(base, height)
    @base = base
    @height = height
  end

  def area
    0.5 * @base * @height
  end

  def perimeter
    2 * @base + 2 * Math.sqrt((0.5 * @base)**2 + @height**2)
  end
end

triangle = Triangle.new(5, 8)
puts "Area: #{triangle.area}"             # Output: Area: 20.0
puts "Perimeter: #{triangle.perimeter}"   # Output: Perimeter: 22.806757512619347
puts "PI: #{Triangle::PI}"                # Output: PI: 3.14

```

### class methods

No, you cannot call a class method `my_class_method` on an instance of the `MyClass` class in Ruby. Class methods are defined on the class itself, and are not associated with any particular instance of the class.

```ruby
class MyClass
  def self.my_class_method
    puts "This is a class method"
  end
end

MyClass.my_class_method   # Output: This is a class method
```

## Public, Protected, Private

- private method hanya bisa dipanggil di kelas di dalam class, tidak di luar class, dan tidak pula di-subclass-nya.
- protected berarti private, tetapi bisa dipanggil di subclass-nya
- public berarti protected, tetapi bisa dipanggil di luar class

Yes, that's correct! To summarize:

- private methods can only be called within the class where they are defined, and not from outside the class or its subclasses.
- protected methods are similar to private methods, but can be called from within the class and its subclasses.
- public methods can be called from anywhere, including outside the class.

## Block

### `yield` keyword

In Ruby, `yield` is a keyword used to call the block that was passed to a method. It allows the method to call the block one or more times, passing arguments to the block if necessary.

Here's an example of a method that takes a block and uses `yield` to call the block:

```ruby
def my_method
  puts "Start of method"
  yield("Hello", 123)
  puts "End of method"
end

my_method do |message, num|
  puts "The message is #{message}, the number is #{num}"
end
```

In this example, `my_method` takes a block and uses `yield` to call it with the arguments `"Hello"` and `123`. When you call `my_method` and pass in a block, Ruby executes the block with the arguments provided by `yield`.

The output of this code would be:

```txt
Start of method
The message is Hello, the number is 123
End of method
```

Note that `yield` can only be used within a method that takes a block as an argument. If you try to use `yield` outside of such a method, you'll get an error.

## lambda, call, Proc

```ruby
a = [3,5,7,9]
c = a.map {|x| lambda {|y| x >= y} }
```

### what does `lambda` do?

In the given code, `lambda` creates an anonymous function for each element `x` of the array `a`, which takes an argument `y` and returns a boolean indicating whether `x` is greater than or equal to `y`.

Here's a breakdown of the code:

- `a.map` creates a new array by applying the block to each element of the array.
- `{|x| lambda {|y| x >= y} }` is a block that takes an argument `x` and returns a lambda function that takes an argument `y` and returns `x >= y`.
- So `c` ends up being an array of four lambda functions, where `c[0]` returns `true` if its argument is less than or equal to `3`, `c[1]` returns `true` if its argument is less than or equal to `5`, and so on.

### can you give me example that calls `c[0]` function?

```ruby
a = [3, 5, 7, 9]
c = a.map { |x| lambda { |y| x >= y } }

result = c[0].call(4)

puts result # prints false
```

In this example, we first create an array `a` with four elements, and then create a new array `c` using the `map` method. The `map` method takes a block, which in this case is a lambda that takes an argument `y` and returns whether `x >= y`, where `x` is the current element of `a` .

To call the lambda at index 0 of `c`, we can use the call method on that lambda object, passing in the argument `4`. This will return true, since `3 >= 4` is `false`, but `5 >= 4` is `true`. Finally, we print the result using `puts`.

### what is `call` method?

In Ruby, the `call` method is used to invoke a `Proc` object. A `Proc` object is an instance of the `Proc` class and represents a block of code that has been bound to a set of local variables.

The `call` method is called on a `Proc` object and executes the code inside the `Proc` object. It can take arguments, which can be accessed inside the `Proc` using the special variable `|args|`.

Here's an example of using the `call` method with a `Proc` object:

```ruby
# define a Proc object that multiplies a number by 2
multiply_by_2 = Proc.new {|x| x * 2}

# call the Proc object with an argument
result = multiply_by_2.call(5)
puts result # prints 10
```

In this example, the `Proc` object `multiply_by_2` takes an argument `x` and returns `x * 2`. We can call the `Proc` object using the `call` method and passing in an argument `5`. The result of calling the `Proc` is assigned to the result variable and then printed out.

Yes, that's correct! In Ruby, `Procs` are first-class functions (first-class closures), which means they can be assigned to variables, passed as arguments to methods, and returned as values from methods, just like any other data type.

Yes, in Ruby, a `lambda` is an object of the `Proc` class. Both `Proc` and `lambda` are ways to define anonymous functions in Ruby, but they have some differences in behavior, such as how they handle the return statement and the number of arguments they expect. However, both `Proc` and `lambda` objects can be called and passed around like any other objects in Ruby.

## Dynamic Dispatch

Call `self.m2()` in method `m1` defined in class `C` can resolve to a method `m2` defined in a **subclass** of `C`.

```ruby
class C
  def m1
    self.m2
  end
  def m2
    puts "Method m2 defined in class C"
  end
end

class D < C
  def m2
    puts "Method m2 defined in class D"
  end
end

obj = D.new
obj.m1
```

So when we run the code, the output is:

```txt
Method m2 defined in class D
```
