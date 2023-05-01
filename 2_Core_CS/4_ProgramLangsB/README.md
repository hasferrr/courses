# Programming Languages B

## Materials

Slides and Lecture Notes

### Notes

- [section5sum.pdf](week_1/PDF/section5sum.pdf)
- [section6sum.pdf](week_2/PDF/section6sum.pdf)
- [section7sum.pdf](week_3/PDF/section7sum.pdf)

### Slides

- [week1_combined_slides_PLB.pdf](week_1/slides/week1_combined_slides_PLB.pdf)
- [week2_combined_slides_PLB.pdf](week_2/slides/week2_combined_slides_PLB.pdf)
- [week3_combined_slides_PLB.pdf](week_3/slides/week3_combined_slides_PLB.pdf)

## My Notes (Week 1)

### Delayed evaluation, Eager evaluation

For each language construct, the semantics specifies when subexpressions get evaluated. In ML, Racket, Java, C:

- Function arguments are **eager** (call-by-value) = Evaluated once before calling the function
- Conditional branches are **not eager**

This is why:

```racket
(define (my-if-bad x y z) (if x y z))
```

is a function that cannot be used wherever you use an if-expression; the rules for evaluating subexpressions are fundamentally different.

For example, this function would never terminate since every call makes a recursive call:

```racket
(define (factorial-wrong x)
    (my-if-bad (= x 0)
               1
               (* x (factorial-wrong (- x 1)))))
```

The function `factorial-wrong` never terminates because of the way the `my-if-bad` function evaluates its subexpressions.

In the definition of `my-if-bad`, the `if` expression has three subexpressions: `x`, `y`, and `z`. The evaluation of these subexpressions is **eager**, which means that all three subexpressions are evaluated before the `if` expression decides which one to return.

In the case of `(factorial-wrong (- x 1))`, the `(- x 1)` subexpression is evaluated ***before*** the `if` expression decides whether to evaluate `1` or `(* x (factorial-wrong (- x 1)))`. This means that `factorial-wrong` is **called** with an argument of `(- x 1)` **before** the **`if` expression decides** whether to return `1` or continue with the recursion.

Since `factorial-wrong` is called with a decreasing argument on every recursive call, it will eventually reach the base case of `x = 0`. ***However***, since `my-if-bad` evaluates all subexpressions ***eagerly***, the recursive call with the decreasing argument will always happen before the base case is reached. This leads to an infinite recursion, causing `factorial-wrong` to never terminate.

> so `my-if-bad` evaluate `y` and `z` first before its evaluate `if`?

Yes, that's correct. In the definition of `my-if-bad`, both the `y` and `z` expressions are ***eagerly evaluated*** before the `if` expression is evaluated. This means that both branches of the `if` expression are evaluated, regardless of the outcome of the test expression `x`.

For example, if we call `(my-if-bad (= 1 2) 3 4)`, the expression `(= 1 2)` evaluates to `false`, but both the `3` and `4` expressions are eagerly evaluated before the `if` expression returns `4`. This is not efficient, since it can lead to unnecessary computation of expressions that are not needed.

> And then `factorial-wrong` will evaluate `(* x (factorial-wrong (- x 1)))` continuously because that is what it **needs to evaluate first**, even if x has reached 0.

Yes, that's correct. In the `factorial-wrong` function, the expression `(* x (factorial-wrong (- x 1)))` is ***eagerly evaluated*** before the `if` expression is evaluated. This means that even if `x` is eventually reduced to `0`, the expression `(* x (factorial-wrong (- x 1)))` ***will keep being evaluated*** with decreasing values of `x`, leading to infinite recursion.

This is a consequence of the fact that `my-if-bad` eagerly evaluates both the `true` and `false` branches of the `if` expression, rather than short-circuiting to evaluate only the necessary branch.

***Solution*** : using a zero-argument function to **delay evaluation (thunk)**, see *"Introduction to Delayed Evaluation and Thunks"* section in [section5sum.pdf](week_1/PDF/section5sum.pdf)

## My Notes (Week 3)

### Soundness and Completeness

#### Soundness

In programming languages, a **sound** type system is one that ensures that the program never encounters type errors at runtime. This means that every operation that the program performs on a value is a valid operation for that value's type.

**Soundness** refers to the ability of a type system *to prevent runtime errors in a program*. A sound type system ensures that if a program typechecks without any errors, it will never encounter a type-related error during runtime. In other words, **soundness** guarantees that the type system is able to catch all type errors at compile-time, and no type errors will occur during runtime.

#### Completeness

A **complete** type system is one that ensures that every program that passes type checking is well-behaved, i.e., it will terminate and not exhibit any unexpected behavior at runtime.

**Completeness**, refers to the ability of a type system *to classify all valid programs correctly*. A **complete** type system ensures that every valid program will be accepted by the typechecker, and that no valid program will be rejected by the typechecker due to a limitation or error in the type system.

#### Summary

In other words, a **sound** type system prevents type errors, while a **complete** type system prevents runtime errors. A type system that is both sound and complete is ideal, as it provides the highest level of assurance that a program will behave correctly.

In summary, a **sound** type system guarantees that programs will not crash due to type errors at runtime, while a **complete** type system guarantees that all valid programs will be accepted by the typechecker.

X we wish to prevent:

A type system is considered "sound" if it **never accepts/prevent** a program that, when run with some input, **produces behavior or errors** described as "X". This means that no errors are caused by a program that is accepted by the type system (prevent what they claim to prevent).

On the other hand, a type system is considered "complete" if it **never rejects/let** a program that will **not produce behavior or errors** described as "X", regardless of the input used.