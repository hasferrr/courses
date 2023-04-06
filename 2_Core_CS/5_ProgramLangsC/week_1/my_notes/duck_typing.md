# Duck typing

## Definition

Duck typing is a concept in programming that focuses on the behavior of an object rather than its type or class. In duck typing, an object's suitability is determined by whether it "quacks like a duck" - that is, whether it supports the methods and properties required by the current context.

For example, in Ruby, you can use duck typing when working with collections. You don't care what type of collection it is, as long as it responds to the methods you want to call on it, such as `each` and `map`. This allows for more flexible and dynamic programming, as you can work with objects that may not be part of a specific class hierarchy, but still behave in the expected way.

Duck typing is often contrasted with static typing, where variables have a specific data type assigned to them at compile time, and the type of an object is fixed at creation time.

## Example

Let's say we have two classes, `Duck` and `Person`, and both classes have a `quack` method. In duck typing, if an object `obj` responds to the `quack` method, then it is considered a duck, regardless of its actual class. This means that both `Duck` objects and `Person` objects can be treated as ducks, as long as they have a `quack` method.

```ruby
class Duck
  def quack
    puts "Quack!"
  end
end

class Person
  def quack
    puts "I'm quacking like a duck!"
  end
end

def make_it_quack(duck)
  duck.quack
end

donald = Duck.new
john = Person.new

make_it_quack(donald) # Output: Quack!
make_it_quack(john)   # Output: I'm quacking like a duck!

```

In the above example, both `Duck` and `Person` have a `quack` method, so they can both be passed as an argument to `make_it_quack` method. The method `make_it_quack` does not care what the actual class of the object is, as long as it responds to the `quack` method. This is an example of duck typing.
