# [함수](@id man-functions)

함수는 인자를 받아 값을 리턴하는 오브젝트이다. 줄리아에서 정의하는 함수는 실행 상황에 영향을 받는다는 점에서 수학적 정의에 따른 함수와는 다르다. 아래는 줄리아에서 함수는 정의하는 가장 기본적인 방법이다:

```jldoctest
julia> function f(x,y)
           x + y
       end
f (generic function with 1 method)
```
아래와 같이 함수를 정의하는 방법도 있다:
```jldoctest fofxy
julia> f(x,y) = x + y
f (generic function with 1 method)
```
위처럼 "할당 형식(assignment form)"으로 선언할 경우 복합 표현이더라도 한줄로 표현해야 한다([복합 표현을 자세하고 알고 싶다면?](@ref man-compound-expressions)). 이렇게 함수를 표현하는 경우는 줄리아에 흔한 일이고, 때론 코드 가독성을 높여준다.

다른 언어처럼 괄호를 통해 함수 인자를 전달한다:

```jldoctest fofxy
julia> f(2,3)
5
```
괄호가 없는 `f`는 함수 오브젝트로써 하나의 값으로 취급할 수 있다:

```jldoctest fofxy
julia> g = f;

julia> g(2,3)
5
```
함수의 이름은 유니코드라면 무엇이든지 가능하다:

```jldoctest
julia> ∑(x,y) = x + y
∑ (generic function with 1 method)

julia> ∑(2, 3)
5
```

## 인자 전달 방식
함수에 인자를 줄 때 줄리아는 "공유를 통한 전달([pass-by-sharing](https://en.wikipedia.org/wiki/Evaluation_strategy#Call_by_sharing))"을 한다. 이 말은 즉슨, 오브젝트를 복사하지 않고 공유한다는 뜻이다. 전달된 인자는 함수 안에 있는 변수에 할당되고, 함수 안의 변수는 단지 그 오브젝트를 가리킬 뿐이다. `Array`와 같은 mutable 오브젝트가 함수 안에서 변하면, 함수 밖에서도 그 변화를 볼 수 있다. 이런 방식은 Scheme, Python, Ruby, Perl 그리고 대부분의 Lisp와 같은 동적언어가 채택한 방식이다.

## 반환값
함수가 반환하는 값은 암묵적으로 가장 마지막으로 계산된 값이다. 이전의 예제 함수 `f`에서는 `x+y`의 값이 반환될 것이다. 다른 프로그래밍 언어처럼 `return`과 리턴값이 명시적으로 선언될 경우, 함수는 즉시 종료되고 `return`앞에 있는 식을 계산하고 반환할 것이다:

```julia
function g(x,y)
    return x * y
    x + y
end
```
직접 테스트해보자:

```jldoctest
julia> f(x,y) = x + y
f (generic function with 1 method)

julia> function g(x,y)
           return x * y
           x + y
       end
g (generic function with 1 method)

julia> f(2,3)
5

julia> g(2,3)
6
```
함수 `g`에서 `x+y`는 절대 실행되지 않기 때문에, 이 부분을 빼고 `x*y`만 남겨놔도 똑같이 작동한다.
`return`을 직접 선언하는 방식은 조건문과 같이 코드의 흐름을 바꾸는 구문과 사용했을 대 빛을 발한다. 아래에 직각 삼각형에서 밑변 `x`와 높이 `y`가 주어졌을 때 빗변의 길이는 구하는 예제로 확인할 수 있다. 아래 함수는 overflow를 없애기 위해 조건문을 사용했다:

```jldoctest
julia> function hypot(x,y)
           x = abs(x)
           y = abs(y)
           if x > y
               r = y/x
               return x*sqrt(1+r*r)
           end
           if y == 0
               return zero(x)
           end
           r = x/y
           return y*sqrt(1+r*r)
       end
hypot (generic function with 1 method)

julia> hypot(3, 4)
5.0
```
위 함수는 경우에 따라 세가지 방법으로 값을 반환한다. 마지막은 `return`은 생략해도 된다.

반환값의 타입은 `::`로 명시할 수 있으며, 이경우 반환값이 자동 형변환된다.

```jldoctest
julia> function g(x, y)::Int8
           return x * y
       end;

julia> typeof(g(1, 2))
Int8
```

위 함수는 `x`와 `y`의 타입에 상관없이 반환값은 `Int8`로 정해져있다. 타입에 대해 자세히 알고 싶다면 
[타입 선언](@ref)을 참고하자.

## Operators Are Functions

In Julia, most operators are just functions with support for special syntax. (The exceptions are
operators with special evaluation semantics like `&&` and `||`. These operators cannot be functions
since [Short-Circuit Evaluation](@ref) requires that their operands are not evaluated before evaluation
of the operator.) Accordingly, you can also apply them using parenthesized argument lists, just
as you would any other function:

```jldoctest
julia> 1 + 2 + 3
6

julia> +(1,2,3)
6
```

The infix form is exactly equivalent to the function application form -- in fact the former is
parsed to produce the function call internally. This also means that you can assign and pass around
operators such as [`+`](@ref) and [`*`](@ref) just like you would with other function values:

```jldoctest
julia> f = +;

julia> f(1,2,3)
6
```

Under the name `f`, the function does not support infix notation, however.

## Operators With Special Names

A few special expressions correspond to calls to functions with non-obvious names. These are:

| Expression        | Calls                   |
|:----------------- |:----------------------- |
| `[A B C ...]`     | [`hcat`](@ref)          |
| `[A; B; C; ...]`  | [`vcat`](@ref)          |
| `[A B; C D; ...]` | [`hvcat`](@ref)         |
| `A'`              | [`adjoint`](@ref)       |
| `A[i]`            | [`getindex`](@ref)      |
| `A[i] = x`        | [`setindex!`](@ref)     |
| `A.n`             | [`getproperty`](@ref Base.getproperty) |
| `A.n = x`         | [`setproperty!`](@ref Base.setproperty!) |

## [Anonymous Functions](@id man-anonymous-functions)

Functions in Julia are [first-class objects](https://en.wikipedia.org/wiki/First-class_citizen):
they can be assigned to variables, and called using the standard function call syntax from the
variable they have been assigned to. They can be used as arguments, and they can be returned as
values. They can also be created anonymously, without being given a name, using either of these
syntaxes:

```jldoctest
julia> x -> x^2 + 2x - 1
#1 (generic function with 1 method)

julia> function (x)
           x^2 + 2x - 1
       end
#3 (generic function with 1 method)
```

This creates a function taking one argument `x` and returning the value of the polynomial `x^2 +
2x - 1` at that value. Notice that the result is a generic function, but with a compiler-generated
name based on consecutive numbering.

The primary use for anonymous functions is passing them to functions which take other functions
as arguments. A classic example is [`map`](@ref), which applies a function to each value of
an array and returns a new array containing the resulting values:

```jldoctest
julia> map(round, [1.2,3.5,1.7])
3-element Array{Float64,1}:
 1.0
 4.0
 2.0
```

This is fine if a named function effecting the transform already exists to pass as the first argument
to [`map`](@ref). Often, however, a ready-to-use, named function does not exist. In these
situations, the anonymous function construct allows easy creation of a single-use function object
without needing a name:

```jldoctest
julia> map(x -> x^2 + 2x - 1, [1,3,-1])
3-element Array{Int64,1}:
  2
 14
 -2
```

An anonymous function accepting multiple arguments can be written using the syntax `(x,y,z)->2x+y-z`.
A zero-argument anonymous function is written as `()->3`. The idea of a function with no arguments
may seem strange, but is useful for "delaying" a computation. In this usage, a block of code is
wrapped in a zero-argument function, which is later invoked by calling it as `f`.

## Tuples

Julia has a built-in data structure called a *tuple* that is closely related to function
arguments and return values.
A tuple is a fixed-length container that can hold any values, but cannot be modified
(it is *immutable*).
Tuples are constructed with commas and parentheses, and can be accessed via indexing:

```jldoctest
julia> (1, 1+1)
(1, 2)

julia> (1,)
(1,)

julia> x = (0.0, "hello", 6*7)
(0.0, "hello", 42)

julia> x[2]
"hello"
```

Notice that a length-1 tuple must be written with a comma, `(1,)`, since `(1)` would just
be a parenthesized value.
`()` represents the empty (length-0) tuple.

## Named Tuples

The components of tuples can optionally be named, in which case a *named tuple* is
constructed:

```jldoctest
julia> x = (a=1, b=1+1)
(a = 1, b = 2)

julia> x.a
1
```

Named tuples are very similar to tuples, except that fields can additionally be accessed by name
using dot syntax (`x.a`).

## Multiple Return Values

In Julia, one returns a tuple of values to simulate returning multiple values. However, tuples
can be created and destructured without needing parentheses, thereby providing an illusion that
multiple values are being returned, rather than a single tuple value. For example, the following
function returns a pair of values:

```jldoctest foofunc
julia> function foo(a,b)
           a+b, a*b
       end
foo (generic function with 1 method)
```

If you call it in an interactive session without assigning the return value anywhere, you will
see the tuple returned:

```jldoctest foofunc
julia> foo(2,3)
(5, 6)
```

A typical usage of such a pair of return values, however, extracts each value into a variable.
Julia supports simple tuple "destructuring" that facilitates this:

```jldoctest foofunc
julia> x, y = foo(2,3)
(5, 6)

julia> x
5

julia> y
6
```

You can also return multiple values via an explicit usage of the `return` keyword:

```julia
function foo(a,b)
    return a+b, a*b
end
```

This has the exact same effect as the previous definition of `foo`.

## Argument destructuring

The destructuring feature can also be used within a function argument.
If a function argument name is written as a tuple (e.g. `(x, y)`) instead of just
a symbol, then an assignment `(x, y) = argument` will be inserted for you:

```julia
julia> minmax(x, y) = (y < x) ? (y, x) : (x, y)

julia> range((min, max)) = max - min

julia> range(minmax(10, 2))
8
```

Notice the extra set of parentheses in the definition of `range`.
Without those, `range` would be a two-argument function, and this example would
not work.

## Varargs Functions

It is often convenient to be able to write functions taking an arbitrary number of arguments.
Such functions are traditionally known as "varargs" functions, which is short for "variable number
of arguments". You can define a varargs function by following the last argument with an ellipsis:

```jldoctest barfunc
julia> bar(a,b,x...) = (a,b,x)
bar (generic function with 1 method)
```

The variables `a` and `b` are bound to the first two argument values as usual, and the variable
`x` is bound to an iterable collection of the zero or more values passed to `bar` after its first
two arguments:

```jldoctest barfunc
julia> bar(1,2)
(1, 2, ())

julia> bar(1,2,3)
(1, 2, (3,))

julia> bar(1, 2, 3, 4)
(1, 2, (3, 4))

julia> bar(1,2,3,4,5,6)
(1, 2, (3, 4, 5, 6))
```

In all these cases, `x` is bound to a tuple of the trailing values passed to `bar`.

It is possible to constrain the number of values passed as a variable argument; this will be discussed
later in [Parametrically-constrained Varargs methods](@ref).

On the flip side, it is often handy to "splat" the values contained in an iterable collection
into a function call as individual arguments. To do this, one also uses `...` but in the function
call instead:

```jldoctest barfunc
julia> x = (3, 4)
(3, 4)

julia> bar(1,2,x...)
(1, 2, (3, 4))
```

In this case a tuple of values is spliced into a varargs call precisely where the variable number
of arguments go. This need not be the case, however:

```jldoctest barfunc
julia> x = (2, 3, 4)
(2, 3, 4)

julia> bar(1,x...)
(1, 2, (3, 4))

julia> x = (1, 2, 3, 4)
(1, 2, 3, 4)

julia> bar(x...)
(1, 2, (3, 4))
```

Furthermore, the iterable object splatted into a function call need not be a tuple:

```jldoctest barfunc
julia> x = [3,4]
2-element Array{Int64,1}:
 3
 4

julia> bar(1,2,x...)
(1, 2, (3, 4))

julia> x = [1,2,3,4]
4-element Array{Int64,1}:
 1
 2
 3
 4

julia> bar(x...)
(1, 2, (3, 4))
```

Also, the function that arguments are splatted into need not be a varargs function (although it
often is):

```jldoctest
julia> baz(a,b) = a + b;

julia> args = [1,2]
2-element Array{Int64,1}:
 1
 2

julia> baz(args...)
3

julia> args = [1,2,3]
3-element Array{Int64,1}:
 1
 2
 3

julia> baz(args...)
ERROR: MethodError: no method matching baz(::Int64, ::Int64, ::Int64)
Closest candidates are:
  baz(::Any, ::Any) at none:1
```

As you can see, if the wrong number of elements are in the splatted container, then the function
call will fail, just as it would if too many arguments were given explicitly.

## Optional Arguments

In many cases, function arguments have sensible default values and therefore might not need to
be passed explicitly in every call. For example, the function [`Date(y, [m, d])`](@ref)
from `Dates` module constructs a `Date` type for a given year `y`, month `m` and day `d`.
However, `m` and `d` arguments are optional and their default value is `1`.
This behavior can be expressed concisely as:

```julia
function Date(y::Int64, m::Int64=1, d::Int64=1)
    err = validargs(Date, y, m, d)
    err === nothing || throw(err)
    return Date(UTD(totaldays(y, m, d)))
end
```

Observe, that this definition calls another method of `Date` function that takes one argument
of `UTInstant{Day}` type.

With this definition, the function can be called with either one, two or three arguments, and
`1` is automatically passed when any of the arguments is not specified:

```jldoctest
julia> using Dates

julia> Date(2000, 12, 12)
2000-12-12

julia> Date(2000, 12)
2000-12-01

julia> Date(2000)
2000-01-01
```

Optional arguments are actually just a convenient syntax for writing multiple method definitions
with different numbers of arguments (see [Note on Optional and keyword Arguments](@ref)).
This can be checked for our `Date` function example by calling `methods` function.

## Keyword Arguments

Some functions need a large number of arguments, or have a large number of behaviors. Remembering
how to call such functions can be difficult. Keyword arguments can make these complex interfaces
easier to use and extend by allowing arguments to be identified by name instead of only by position.

For example, consider a function `plot` that plots a line. This function might have many options,
for controlling line style, width, color, and so on. If it accepts keyword arguments, a possible
call might look like `plot(x, y, width=2)`, where we have chosen to specify only line width. Notice
that this serves two purposes. The call is easier to read, since we can label an argument with
its meaning. It also becomes possible to pass any subset of a large number of arguments, in any
order.

Functions with keyword arguments are defined using a semicolon in the signature:

```julia
function plot(x, y; style="solid", width=1, color="black")
    ###
end
```

When the function is called, the semicolon is optional: one can either call `plot(x, y, width=2)`
or `plot(x, y; width=2)`, but the former style is more common. An explicit semicolon is required
only for passing varargs or computed keywords as described below.

Keyword argument default values are evaluated only when necessary (when a corresponding keyword
argument is not passed), and in left-to-right order. Therefore default expressions may refer to
prior keyword arguments.

The types of keyword arguments can be made explicit as follows:

```julia
function f(;x::Int=1)
    ###
end
```

Extra keyword arguments can be collected using `...`, as in varargs functions:

```julia
function f(x; y=0, kwargs...)
    ###
end
```

Inside `f`, `kwargs` will be a key-value iterator over a named tuple. Named
tuples (as well as dictionaries with keys of `Symbol`) can be passed as keyword
arguments using a semicolon in a call, e.g. `f(x, z=1; kwargs...)`.

If a keyword argument is not assigned a default value in the method definition,
then it is *required*: an [`UndefKeywordError`](@ref) exception will be thrown
if the caller does not assign it a value:
```julia
function f(x; y)
    ###
end
f(3, y=5) # ok, y is assigned
f(3)      # throws UndefKeywordError(:y)
```

One can also pass `key => value` expressions after a semicolon. For example, `plot(x, y; :width => 2)`
is equivalent to `plot(x, y, width=2)`. This is useful in situations where the keyword name is computed
at runtime.

The nature of keyword arguments makes it possible to specify the same argument more than once.
For example, in the call `plot(x, y; options..., width=2)` it is possible that the `options` structure
also contains a value for `width`. In such a case the rightmost occurrence takes precedence; in
this example, `width` is certain to have the value `2`. However, explicitly specifying the same keyword
argument multiple times, for example `plot(x, y, width=2, width=3)`, is not allowed and results in
a syntax error.

## Evaluation Scope of Default Values

When optional and keyword argument default expressions are evaluated, only *previous* arguments are in
scope.
For example, given this definition:

```julia
function f(x, a=b, b=1)
    ###
end
```

the `b` in `a=b` refers to a `b` in an outer scope, not the subsequent argument `b`.

## Do-Block Syntax for Function Arguments

Passing functions as arguments to other functions is a powerful technique, but the syntax for
it is not always convenient. Such calls are especially awkward to write when the function argument
requires multiple lines. As an example, consider calling [`map`](@ref) on a function with several
cases:

```julia
map(x->begin
           if x < 0 && iseven(x)
               return 0
           elseif x == 0
               return 1
           else
               return x
           end
       end,
    [A, B, C])
```

Julia provides a reserved word `do` for rewriting this code more clearly:

```julia
map([A, B, C]) do x
    if x < 0 && iseven(x)
        return 0
    elseif x == 0
        return 1
    else
        return x
    end
end
```

The `do x` syntax creates an anonymous function with argument `x` and passes it as the first argument
to [`map`](@ref). Similarly, `do a,b` would create a two-argument anonymous function, and a
plain `do` would declare that what follows is an anonymous function of the form `() -> ...`.

How these arguments are initialized depends on the "outer" function; here, [`map`](@ref) will
sequentially set `x` to `A`, `B`, `C`, calling the anonymous function on each, just as would happen
in the syntax `map(func, [A, B, C])`.

This syntax makes it easier to use functions to effectively extend the language, since calls look
like normal code blocks. There are many possible uses quite different from [`map`](@ref), such
as managing system state. For example, there is a version of [`open`](@ref) that runs code ensuring
that the opened file is eventually closed:

```julia
open("outfile", "w") do io
    write(io, data)
end
```

This is accomplished by the following definition:

```julia
function open(f::Function, args...)
    io = open(args...)
    try
        f(io)
    finally
        close(io)
    end
end
```

Here, [`open`](@ref) first opens the file for writing and then passes the resulting output stream
to the anonymous function you defined in the `do ... end` block. After your function exits, [`open`](@ref)
will make sure that the stream is properly closed, regardless of whether your function exited
normally or threw an exception. (The `try/finally` construct will be described in [Control Flow](@ref).)

With the `do` block syntax, it helps to check the documentation or implementation to know how
the arguments of the user function are initialized.

A `do` block, like any other inner function, can "capture" variables from its
enclosing scope. For example, the variable `data` in the above example of
`open...do` is captured from the outer scope. Captured variables
can create performance challenges as discussed in [performance tips](@ref man-performance-tips).

## Function composition and piping

Functions in Julia can be combined by composing or piping (chaining) them together.

Function composition is when you combine functions together and apply the resulting composition to arguments.
You use the function composition operator (`∘`) to compose the functions, so `(f ∘ g)(args...)` is the same as `f(g(args...))`.

You can type the composition operator at the REPL and suitably-configured editors using `\circ<tab>`.

For example, the `sqrt` and `+` functions can be composed like this:

```jldoctest
julia> (sqrt ∘ +)(3, 6)
3.0
```

This adds the numbers first, then finds the square root of the result.

The next example composes three functions and maps the result over an array of strings:

```jldoctest
julia> map(first ∘ reverse ∘ uppercase, split("you can compose functions like this"))
6-element Array{Char,1}:
 'U'
 'N'
 'E'
 'S'
 'E'
 'S'
```

Function chaining (sometimes called "piping" or "using a pipe" to send data to a subsequent function) is when you apply a function to the previous function's output:

```jldoctest
julia> 1:10 |> sum |> sqrt
7.416198487095663
```

Here, the total produced by `sum` is passed to the `sqrt` function. The equivalent composition would be:

```jldoctest
julia> (sqrt ∘ sum)(1:10)
7.416198487095663
```

The pipe operator can also be used with broadcasting, as `.|>`, to provide a useful combination of the chaining/piping and dot vectorization syntax (described next).

```jldoctest
julia> ["a", "list", "of", "strings"] .|> [uppercase, reverse, titlecase, length]
4-element Array{Any,1}:
  "A"
  "tsil"
  "Of"
 7
```

## [Dot Syntax for Vectorizing Functions](@id man-vectorized)

In technical-computing languages, it is common to have "vectorized" versions of functions, which
simply apply a given function `f(x)` to each element of an array `A` to yield a new array via
`f(A)`. This kind of syntax is convenient for data processing, but in other languages vectorization
is also often required for performance: if loops are slow, the "vectorized" version of a function
can call fast library code written in a low-level language. In Julia, vectorized functions are
*not* required for performance, and indeed it is often beneficial to write your own loops (see
[Performance Tips](@ref man-performance-tips)), but they can still be convenient. Therefore, *any* Julia function
`f` can be applied elementwise to any array (or other collection) with the syntax `f.(A)`.
For example, `sin` can be applied to all elements in the vector `A` like so:

```jldoctest
julia> A = [1.0, 2.0, 3.0]
3-element Array{Float64,1}:
 1.0
 2.0
 3.0

julia> sin.(A)
3-element Array{Float64,1}:
 0.8414709848078965
 0.9092974268256817
 0.1411200080598672
```

Of course, you can omit the dot if you write a specialized "vector" method of `f`, e.g. via `f(A::AbstractArray) = map(f, A)`,
and this is just as efficient as `f.(A)`. But that approach requires you to decide in advance
which functions you want to vectorize.

More generally, `f.(args...)` is actually equivalent to `broadcast(f, args...)`, which allows
you to operate on multiple arrays (even of different shapes), or a mix of arrays and scalars (see
[Broadcasting](@ref)). For example, if you have `f(x,y) = 3x + 4y`, then `f.(pi,A)` will return
a new array consisting of `f(pi,a)` for each `a` in `A`, and `f.(vector1,vector2)` will return
a new vector consisting of `f(vector1[i],vector2[i])` for each index `i` (throwing an exception
if the vectors have different length).

```jldoctest
julia> f(x,y) = 3x + 4y;

julia> A = [1.0, 2.0, 3.0];

julia> B = [4.0, 5.0, 6.0];

julia> f.(pi, A)
3-element Array{Float64,1}:
 13.42477796076938
 17.42477796076938
 21.42477796076938

julia> f.(A, B)
3-element Array{Float64,1}:
 19.0
 26.0
 33.0
```

Moreover, *nested* `f.(args...)` calls are *fused* into a single `broadcast` loop. For example,
`sin.(cos.(X))` is equivalent to `broadcast(x -> sin(cos(x)), X)`, similar to `[sin(cos(x)) for x in X]`:
there is only a single loop over `X`, and a single array is allocated for the result. [In contrast,
`sin(cos(X))` in a typical "vectorized" language would first allocate one temporary array for
`tmp=cos(X)`, and then compute `sin(tmp)` in a separate loop, allocating a second array.] This
loop fusion is not a compiler optimization that may or may not occur, it is a *syntactic guarantee*
whenever nested `f.(args...)` calls are encountered. Technically, the fusion stops as soon as
a "non-dot" function call is encountered; for example, in `sin.(sort(cos.(X)))` the `sin` and `cos`
loops cannot be merged because of the intervening `sort` function.

Finally, the maximum efficiency is typically achieved when the output array of a vectorized operation
is *pre-allocated*, so that repeated calls do not allocate new arrays over and over again for
the results (see [Pre-allocating outputs](@ref)). A convenient syntax for this is `X .= ...`, which
is equivalent to `broadcast!(identity, X, ...)` except that, as above, the `broadcast!` loop is
fused with any nested "dot" calls. For example, `X .= sin.(Y)` is equivalent to `broadcast!(sin, X, Y)`,
overwriting `X` with `sin.(Y)` in-place. If the left-hand side is an array-indexing expression,
e.g. `X[2:end] .= sin.(Y)`, then it translates to `broadcast!` on a `view`, e.g.
`broadcast!(sin, view(X, 2:lastindex(X)), Y)`,
so that the left-hand side is updated in-place.

Since adding dots to many operations and function calls in an expression
can be tedious and lead to code that is difficult to read, the macro
[`@.`](@ref @__dot__) is provided to convert *every* function call,
operation, and assignment in an expression into the "dotted" version.

```jldoctest
julia> Y = [1.0, 2.0, 3.0, 4.0];

julia> X = similar(Y); # pre-allocate output array

julia> @. X = sin(cos(Y)) # equivalent to X .= sin.(cos.(Y))
4-element Array{Float64,1}:
  0.5143952585235492
 -0.4042391538522658
 -0.8360218615377305
 -0.6080830096407656
```

Binary (or unary) operators like `.+` are handled with the same mechanism:
they are equivalent to `broadcast` calls and are fused with other nested "dot" calls.
 `X .+= Y` etcetera is equivalent to `X .= X .+ Y` and results in a fused in-place assignment;
 see also [dot operators](@ref man-dot-operators).

You can also combine dot operations with function chaining using [`|>`](@ref), as in this example:
```jldoctest
julia> [1:5;] .|> [x->x^2, inv, x->2*x, -, isodd]
5-element Array{Real,1}:
    1
    0.5
    6
   -4
 true
```

## Further Reading

We should mention here that this is far from a complete picture of defining functions. Julia has
a sophisticated type system and allows multiple dispatch on argument types. None of the examples
given here provide any type annotations on their arguments, meaning that they are applicable to
all types of arguments. The type system is described in [Types](@ref man-types) and defining a function
in terms of methods chosen by multiple dispatch on run-time argument types is described in [Methods](@ref).
