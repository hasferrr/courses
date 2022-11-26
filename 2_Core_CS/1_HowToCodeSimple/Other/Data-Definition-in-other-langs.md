Examples of data definitions in very different languages/paradigms:

In Racket:

```bash
; data definition
(define-struct movie (title budget year))

; calling the constructor to create data
(define spam (movie "spam" 10000 2022))

; calling getter methods
(movie-title spam)  ; "spam"
(movie-budget spam) ; 10000
(movie-year spam)   ; 2022
```

In C:

```c
// data definition
typedef struct movie {
    char *title;
    int budget;
    int year;
} movie;

// example of creating a data
movie spam;
spam.title = "spam"; // getting/setting
spam.budget = 10000;
spam.year = 2022;
```

In Python:

```py
class Movie:
    # constructor
    def __init__(self, title: str, budget: int, year: int):
        self.title = title
        self.budget = budget
        self.year = year

# creating a data
spam = Movie("spam", 10000, 2022)

# using getters
spam.budget # 10000
```

In Java:

```java
public class Movie {
    // fields
    private String title;
    private int budget;
    private int year;

    // constructor
    public Movie(String title, int budget, int year) {
        this.title = title;
        this.budget = budget;
        this.year = year;
    }
    // getter methods
    public String getTitle() {
        return title;
    }
    // and more...
}
```

In Scala (halfway between Java & SML/Haskell):

```scala
// data definition AND constructor
case class Movie(title: String, budget: Int, year: Int)

// creating data
val spam = Movie("spam", 10000, 2022)

// using getters
spam.year // 2022


In SML (similar in Haskell):

type movie = {
    title : string,
    budget: int,
    year  : int
}

(* creating a data *)
val spam: movie = {title = "spam", budget = 10000, year = 2022}

(* using getters *)
#budget spam (* 10000 *)
```