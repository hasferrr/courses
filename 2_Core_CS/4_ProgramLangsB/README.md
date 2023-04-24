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

## Additional Notes

### Soundness and Completeness

#### Sound

In programming languages, a **sound** type system is one that ensures that the program never encounters type errors at runtime. This means that every operation that the program performs on a value is a valid operation for that value's type.

**Soundness** refers to the ability of a type system *to prevent runtime errors in a program*. A sound type system ensures that if a program typechecks without any errors, it will never encounter a type-related error during runtime. In other words, **soundness** guarantees that the type system is able to catch all type errors at compile-time, and no type errors will occur during runtime.

#### Complete

A **complete** type system is one that ensures that every program that passes type checking is well-behaved, i.e., it will terminate and not exhibit any unexpected behavior at runtime.

**Completeness**, on the other hand, refers to the ability of a type system *to classify all valid programs correctly*. A **complete** type system ensures that every valid program will be accepted by the typechecker, and that no valid program will be rejected by the typechecker due to a limitation or error in the type system.

#### Summary

In other words, a **sound** type system prevents type errors, while a **complete** type system prevents runtime errors. A type system that is both sound and complete is ideal, as it provides the highest level of assurance that a program will behave correctly.

In summary, a **sound** type system guarantees that programs will not crash due to type errors at runtime, while a **complete** type system guarantees that all valid programs will be accepted by the typechecker.
