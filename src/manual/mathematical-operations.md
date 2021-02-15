# 산술 연산과 기본 함수

Julia가 제공하는 숫자형 타입은 산술 연산자와 비트 연산자, 다양한 수학적 함수를 지원한다.

## 산술 연산자

다음 [산술 연산자](https://ko.wikipedia.org/wiki/%EC%82%B0%EC%88%A0#%EC%82%AC%EC%B9%99%EC%97%B0%EC%82%B0)들은 모든 숫자형 타입에 사용할 수 있다:

| 표현식      | 이름            | 설명                                    |
|:---------- |:-------------- |:-------------------------------------- |
| `+x`       | 단항 덧셈       | 항등 연산                                |
| `-x`       | 단항 뺄셈       | 덧셈의 역원 반환                          |
| `x + y`    | 덧셈           | 일반적인 덧셈                             |
| `x - y`    | 곱셈           | 일반적인 뺄셈                             |
| `x * y`    | 곱셈           | 일반적인 곱셈                             |
| `x / y`    | 나눗셈          | 일반적인 나눗셈                           |
| `x ÷ y`    | 정수 나눗셈(몫)  | `x / y`의 몫 반환                        |
| `x \ y`    | 역 나눗셈       | `y / x`와 동일                           |
| `x ^ y`    | 제곱           | `x` 의 `y`제곱을 반환                     |
| `x % y`    | 나머지         | `rem(x,y)`와 동일(나머지를 반환)            |


[`Bool`](@ref) 타입에 대한 부정 연산도 가능하다:

| 표현식      | 이름      | 설명                                     |
|:---------- |:-------- |:---------------------------------------- |
| `!x`       | 부정 연산 | `true`를 `false`로 바꾸거나 혹은 그 반대     |

줄리아의 타입 치환 시스템은 산술 연산이 자연스럽게 작동하게 한다.
자세한 것은 [Conversion and Promotion](@ref conversion-and-promotion)을 참고하라.

산술 연산자를 활용한 간단한 예제다:

```jldoctest
julia> 1 + 2 + 3
6

julia> 1 - 2
-1

julia> 3*2/12
0.5
```

(일반적으로 근처 다른 연산자보다 먼저 적용되는 경우 간격을 밀접하게 두는 경우가 있다.
예를 들어 `x`를 음수로 먼저 변환하고 `2`를 반환하는 코드는 편의상 `-x + 2`로 쓴다)

## 비트 연산자

[비트 연산자](https://ko.wikipedia.org/wiki/%EB%B9%84%ED%8A%B8_%EC%97%B0%EC%82%B0)는 모든 기본 정수형 타입을 지원한다:

| Expression | Name                                                                     |
|:---------- |:------------------------------------------------------------------------ |
| `~x`       | 비트 부정                                                                 |
| `x & y`    | 비트 and 연산                                                             |
| `x \| y`   | 비트 or 연산                                                              |
| `x ⊻ y`    | 비트 xor 연산 (exclusive or)                                              |
| `x >>> y`  | [logical shift](https://en.wikipedia.org/wiki/Logical_shift) right       |
| `x >> y`   | [arithmetic shift](https://en.wikipedia.org/wiki/Arithmetic_shift) right |
| `x << y`   | logical/arithmetic shift left                                            |

비트 연산자를 활용한 간단한 예제다:

```jldoctest
julia> ~123
-124

julia> 123 & 234
106

julia> 123 | 234
251

julia> 123 ⊻ 234
145

julia> xor(123, 234)
145

julia> ~UInt32(123)
0xffffff84

julia> ~UInt8(123)
0x84
```

## 업데이트 연산자

산술 연산자와 비트 연산자는 그에 대응하는 업데이트 연산자가 있습니다.
업데이트 연산자는 변수의 값과 새롭게 제시된 피연산자로 계산한 후 결과를 다시 해당 변수에 저장합니다.
업데이트 연산자는 기존 연산자 기호 우측에 `=`를 붙임으로써 만들 수 있습니다.
예를 들어 `x += 3`는 `x = x + 3`와 같은 의미가 됩니다:

```jldoctest
julia> x = 1
1

julia> x += 3
4

julia> x
4
```

각 산술/비트 연산자에 대응하는 업데이트 연산자는 아래와 같습니다:

```
+=  -=  *=  /=  \=  ÷=  %=  ^=  &=  |=  ⊻=  >>>=  >>=  <<=
```

!!! note
    Julia는 상황에 따라 타입을 바꾸기 때문에, 업데이트 연산자가 변수의 타입을 바꿀 수 있다.

    ```jldoctest
    julia> x = 0x01; typeof(x)
    UInt8

    julia> x *= 2 # Same as x = x * 2
    2

    julia> typeof(x)
    Int64
    ```

## [배열에서의 연산("dot" 연산자)](@id man-dot-operators)

`^`와 같은 모든 이진 연산자는 배열의 원소별 연산을 위한 "dot" 연산자 `.^`가 있다.
따라서 `[1,2,3]`의 모든 원소를 세제곱 하고 싶다면 `[1,2,3] ^ 3`이 아니라 `[1,2,3] .^ 3`로 작성해야 한다.
`!`같은 단항 연산자도 사용할 수 있다(`.!`).

```jldoctest
julia> [1,2,3] .^ 3
3-element Array{Int64,1}:
  1
  8
 27

julia> .![true,false,true]
3-element BitArray{1}:
 0
 1
 0
```

보다 구체적으로, `a .^ b`는 `(^).(a,b)`로 해석되고, 여기서 [`.`](@ref man-vectorized)은 [broadcast](@ref Broadcasting) 연산을 한다: broadcast 연산은 배열과 스칼라, 배열과 배열(모양이 달라도 됨)을 원소별 연산이 가능하게 같은 모양의 배열로 "적절히" 바꿔준다(예를 들어 row 벡터와 column 백터가 들어오면 행렬을 생성한다).
또한 "dot" 연산자는 근처 다른 "dot" 연산자와 결합하여 반복문을 한번만 돌리도록 설계되었다.
만약 `2 .* A.^2 .+ sin.(A)`(혹은 [`@.`](@ref @__dot__) macro)을 사용하여 `@. 2A^2 + sin(A)`를 계산한다면, Julia는 `A`의 모든 원소에 대해 `2a^2 + sin(a)`를 계산한다.
`f.(g.(x))`같은 nested dot 호출도 이런 최적화가 일어나기 때문에 `x .+ 3 .* x.^2`와 `(+).(x, (*).(3, (^).(x, 2)))`같은 함수 꼴로 사용해도 성능상 차이가 발생하지 않는다.

나아가서, *제자리에 두는* 융합된 대입 연산 `.=`에 대해 
`a .+= b` (or `@. a += b`)와 같은 "dot" 업데이트 연산자들은 `a .= a .+ b`로 구문분석된다(are parsed). 

([dot 문법 문서](@ref man-vectorized)을 참고하라).

dot 연산자는 사용자 정의 연산자에서도 활용할 수 있다.
예를 들어 `⊗(A,B) = kron(A,B)`를 정의했다면 `[A,B] .⊗ [C,D]`은 `[A⊗C, B⊗D]`를 계산한다.

dot 연산자를 숫자형 리터럴과 혼용하는 것은 해석의 모호성을 야기할 수 있다.
예를 들어 `1.+x`은 `1. + x`인지 `1 .+ x`인지 확실하지 않다.
따라서 이런 문법은 지원하지 않으며, 불가피하게 사용할 시 여백으로 문법을 명확히 해야한다.

## 비교 연산

모든 기본 숫자형 타입은 비교연산을 지원한다(복소수 예외):

| 연산자                        | 설명                      |
|:---------------------------- |:------------------------ |
| [`==`](@ref)                 | 상등                     |
| [`!=`](@ref), [`≠`](@ref !=) | 상등 부정                 |
| [`<`](@ref)                  | 작다                     |
| [`<=`](@ref), [`≤`](@ref <=) | 작거나 같다               |
| [`>`](@ref)                  | 크다                     |
| [`>=`](@ref), [`≥`](@ref >=) | 크거나 같다               |

아래 예제로 사용법을 볼 수 있다:

```jldoctest
julia> 1 == 1
true

julia> 1 == 2
false

julia> 1 != 2
true

julia> 1 == 1.0
true

julia> 1 < 2
true

julia> 1.0 > 3
false

julia> 1 >= 1.0
true

julia> -1 <= 1
true

julia> -1 <= -1
true

julia> -1 <= -2
false

julia> 3 < -0.5
false
```

정수에서 비교연산은 같은 위치의 비트를 비교하는 방식으로 이뤄진다.
반면 실수는 [IEEE 754 standard](https://ko.wikipedia.org/wiki/IEEE_754)의 규칙에 따라 비교한다:

  * 유한한 수는 일반적인 방식으로 이뤄진다.
  * +0과 -0은 서로 같다.
  * `Inf` 는 `NaN`와 자신을 제외한 수보다 크고, 자기 자신과는 같다.
  * `Inf` 는 `NaN`와 자신을 제외한 수보다 작고, 자기 자신과는 같다.
  * `NaN` 는 자신을 포함한 그 어떤 수와 같지 않고, 크지도 않고, 작지도 않다.

마지막 규칙은 다른 규칙보다 극단적이라, 실제 계산에서 예상치 못한 결과를 야기할 수 있다:

```jldoctest
julia> NaN == NaN
false

julia> NaN != NaN
true

julia> NaN < NaN
false

julia> NaN > NaN
false
```

이러한 문제는 특히 [배열](@ref man-multi-dim-arrays)을 다룰 때 골머리를 썩게 할 것이다:

```jldoctest
julia> [1 NaN] == [1 NaN]
false
```

Julia는 해시값처럼 특수한 값에도 비교연산을 사용할 수 있도록 함수를 지원한다:

| 함수                     | 반환값이 참인 조건          |
|:----------------------- |:------------------------- |
| [`isequal(x, y)`](@ref) | `x`와 `y` 가 같은 때       |
| [`isfinite(x)`](@ref)   | `x`가 유한한 수일 대        |
| [`isinf(x)`](@ref)      | `x`가 무한한 수일 때        |
| [`isnan(x)`](@ref)      | `x`가 숫자가 아닐 때        |

[`isequal`](@ref)에서 `NaN`이 서로 같다고 나온다:

```jldoctest
julia> isequal(NaN, NaN)
true

julia> isequal([1 NaN], [1 NaN])
true

julia> isequal(NaN, NaN32)
true
```

`isequal`은 +0과 -0을 구분할 때도 사용할 수 있다:

```jldoctest
julia> -0.0 == 0.0
true

julia> isequal(-0.0, 0.0)
false
```

정수의 signed나 unsigned 혹은 실수 사이의 비교연산은 까다롭습니다.
Julia는 타입 충돌 없이 이런 것들이 잘 작동하게 보장합니다.

서로 다른 타입에서 `isequal`을 사용하면 [`==`](@ref)을 호출하게 되어있습니다.
여러분이 나만의 타입에서 동일성을 정의하고 싶다면 [`==`](@ref) method를 정의하면 됩니다.
여기에 [`hash`](@ref) method도 정의하면 `isequal(x,y)`은 `hash(x) == hash(y)`을 반환합니다.

### 비교연산 이어쓰기

대부분의 언어가 지원하지 않지만, [Python의 비교연산 문법](https://en.wikipedia.org/wiki/Python_syntax_and_semantics#Comparison_operators)처럼 비교연산을 이어쓸 수 있다:

```jldoctest
julia> 1 < 2 <= 2 < 3 == 3 > 2 >= 1 == 1 < 3 != 5
true
```

비교연산 이어쓰기는 코드 구성을 깔끔하게 한다.
비교연산 이어쓰기는 `&&`를 사용하여 연산을 한 것과 똑같이 작용하고, 원소별 연산에서는 [`&`](@ref)을 사용한 것과 동일하다.
쉽게 말하면 우리가 수학적으로 예상한 것과 똑같이 나온다는 것이다.
그 예로 `0 .< A .< 1`는 각 원소가 0과 1 사이에 있는지에 대한 참/거짓을 행렬로 반환한다.

Note the evaluation behavior of chained comparisons:

```jldoctest
julia> v(x) = (println(x); x)
v (generic function with 1 method)

julia> v(1) < v(2) <= v(3)
2
1
3
true

julia> v(1) > v(2) <= v(3)
2
1
false
```

첫번째 결과에서 중간값이 한번만 계산됨을 확인할 수 있다.
이를 통해 `v(1) < v(2) && v(2) <= v(3)`로 계산했을 때보다 적은 계산량을 가지고, 비교연산 이어쓰기에서는 기존 프로그래밍 언어와 달리 계산 순서는 미리 예측할 수 없다는 걸 확인할 수 있다.
따라서 비교연산 이어쓰기에서는 계산 순서가 중요한 연산(예시: 입출력)을 하지말자.
이런 부작용을 감안하고 써야한다면 `&&` 연산자를 활용하자. ([Short-Circuit Evaluation](@ref)을 참고하라).

### 기본 함수

Julia는 수치 계산을 위한 함수와 연산자를 전폭적으로 지원한다.
이런 연산은 서로 다른 타입의 숫자(정수, 실수, 유리수 등)가 충돌 없이 수학적인 결과와 맞아 떨어지게끔 되어있다.

이런 함수 모두 [dot 문법](@ref man-vectorized)을 지원한다.
예를 들어 `sin.(A)`는 array의 모든 `A`의 원소의 sin값을 구한다.

## 연산자 우선순위와 결합성

아래 표는 높은 우선 순위부터 낮은 우선순위별로 연산자를 나열하고, [연산자 결합성](https://en.wikipedia.org/wiki/Operator_associativity)을 확인할 수 있다:

| 분류            | 연산자                                                                                             | 결합성                      |
|:-------------- |:------------------------------------------------------------------------------------------------- |:-------------------------- |
| 문법            | `.` followed by `::`                                                                              | 왼쪽                       |
| 제곱            | `^`                                                                                               | 오른쪽                      |
| 단항 연산       | `+ - √`                                                                                           | 오른쪽[^1]                  |
| Bitshifts      | `<< >> >>>`                                                                                       | 왼쪽                       |
| 분수            | `//`                                                                                              | 왼쪽                       |
| 곱셈, 나눗셈     | `* / % & \ ÷`                                                                                     | 왼쪽[^2]                   |
| 덧셈, 뺄셈      | `+ - \| ⊻`                                                                                        | 왼쪽[^2]                   |
| 문법            | `: ..`                                                                                            | 왼쪽                       |
| 문법            | `\|>`                                                                                             | 왼쪽                       |
| 문법            | `<\|`                                                                                             | 오른쪽                      |
| 비교 연산        | `> < >= <= == === != !== <:`                                                                      | 결합성 없음                 |
| 제어 흐름        | `&&` followed by `\|\|` followed by `?`                                                           | 오른쪽                      |
| Pair           | `=>`                                                                                              | 오른쪽                      |
| 할당            | `= += -= *= /= //= \= ^= ÷= %= \|= &= ⊻= <<= >>= >>>=`                                            | 오른쪽                      |

[^1]:
    단항연산자 `+` 와 `-`를 연속해서 사용하는 경우, 업데이트 연산자(`++`)와 구별하기 위해 괄호를 명시적으로 사용해야 한다. 다른 단항 연산자와 같이 사용하는 경우엔 right-associativity 규칙에 따라 구문을 분석한다(예시: `√√-a`를 `√(√(-a))`로 분석).
[^2]:
    The operators `+`, `++` and `*` are non-associative. `a + b + c` is parsed as `+(a, b, c)` not `+(+(a, b), c)`. However, the fallback methods for `+(a, b, c, d...)` and `*(a, b, c, d...)` both default to left-associative evaluation.

모든 Julia 연산자의 우선순위 목록을 보고 싶다면, 다음 파일의 최상단 코드를 참고하라:
[`src/julia-parser.scm`](https://github.com/JuliaLang/julia/blob/master/src/julia-parser.scm)

`Base.operator_precedence`을 통해서도 우선순위를 확인할 수 있다. 반환값이 높을수록 더 우선순위가 더 높다:

```jldoctest
julia> Base.operator_precedence(:+), Base.operator_precedence(:*), Base.operator_precedence(:.)
(11, 13, 17)

julia> Base.operator_precedence(:sin), Base.operator_precedence(:+=), Base.operator_precedence(:(=))  # (Note the necessary parens on `:(=)`)
(0, 1, 1)
```

연산자 결합성 확인은 `Base.operator_associativity`로 확인할 수 있다:

```jldoctest
julia> Base.operator_associativity(:-), Base.operator_associativity(:+), Base.operator_associativity(:^)
(:left, :none, :right)

julia> Base.operator_associativity(:⊗), Base.operator_associativity(:sin), Base.operator_associativity(:→)
(:left, :none, :right)
```

`:sin`의 경우  우선순위가 `0`임을 확인할 수 있는데, `0`은 최하위 우선순위가 아니라 유효하지 않은 연사자를 나타낸다.
이와 비슷한 이유로 이런 연산자는 연산자 결합성이 `:none`임을 볼 수 있다.

## Numerical Conversions

Julia supports three forms of numerical conversion, which differ in their handling of inexact
conversions.

  * 표기법 `T(x)` 또는 `convert(T,x)`는 `x`를 type `T`의 값으로 변환한다.

      * 만약 `T`가 부동 소숫점 type이면, 결과값은 표현할 수 있는 가장 가까운 값으로 나타내며, 이는 양 혹은 음의 무한대도 될 수 있다.
      * 만약 `T`가 정수 type이면, `x`를 `T` type으로 나타낼 수 없을 때, `InexactError`가 발생한다.
  * `x % T` converts an integer `x` to a value of integer type `T` congruent to `x` modulo `2^n`,
    where `n` is the number of bits in `T`. In other words, the binary representation is truncated
    to fit.
  * The [Rounding functions](@ref) take a type `T` as an optional argument. For example, `round(Int,x)`
    is a shorthand for `Int(round(x))`.

The following examples show the different forms.

```jldoctest
julia> Int8(127)
127

julia> Int8(128)
ERROR: InexactError: trunc(Int8, 128)
Stacktrace:
[...]

julia> Int8(127.0)
127

julia> Int8(3.14)
ERROR: InexactError: Int8(3.14)
Stacktrace:
[...]

julia> Int8(128.0)
ERROR: InexactError: Int8(128.0)
Stacktrace:
[...]

julia> 127 % Int8
127

julia> 128 % Int8
-128

julia> round(Int8,127.4)
127

julia> round(Int8,127.6)
ERROR: InexactError: trunc(Int8, 128.0)
Stacktrace:
[...]
```

See [Conversion and Promotion](@ref conversion-and-promotion) for how to define your own conversions and promotions.

### Rounding 함수

| 함수                   | 설명                              | 반환값      |
|:--------------------- |:-------------------------------- |:----------- |
| [`round(x)`](@ref)    | round `x` to the nearest integer | `typeof(x)` |
| [`round(T, x)`](@ref) | round `x` to the nearest integer | `T`         |
| [`floor(x)`](@ref)    | round `x` towards `-Inf`         | `typeof(x)` |
| [`floor(T, x)`](@ref) | round `x` towards `-Inf`         | `T`         |
| [`ceil(x)`](@ref)     | round `x` towards `+Inf`         | `typeof(x)` |
| [`ceil(T, x)`](@ref)  | round `x` towards `+Inf`         | `T`         |
| [`trunc(x)`](@ref)    | round `x` towards zero           | `typeof(x)` |
| [`trunc(T, x)`](@ref) | round `x` towards zero           | `T`         |

### 나눗셈 함수

| 함수                       | 설명                                                                                                      |
|:------------------------- |:--------------------------------------------------------------------------------------------------------- |
| [`div(x,y)`](@ref), `x÷y` | truncated division; quotient rounded towards zero                                                         |
| [`fld(x,y)`](@ref)        | floored division; quotient rounded towards `-Inf`                                                         |
| [`cld(x,y)`](@ref)        | ceiling division; quotient rounded towards `+Inf`                                                         |
| [`rem(x,y)`](@ref)        | remainder; satisfies `x == div(x,y)*y + rem(x,y)`; sign matches `x`                                       |
| [`mod(x,y)`](@ref)        | modulus; satisfies `x == fld(x,y)*y + mod(x,y)`; sign matches `y`                                         |
| [`mod1(x,y)`](@ref)       | `mod` with offset 1; returns `r∈(0,y]` for `y>0` or `r∈[y,0)` for `y<0`, where `mod(r, y) == mod(x, y)`   |
| [`mod2pi(x)`](@ref)       | modulus with respect to 2pi;  `0 <= mod2pi(x)    < 2pi`                                                   |
| [`divrem(x,y)`](@ref)     | returns `(div(x,y),rem(x,y))`                                                                             |
| [`fldmod(x,y)`](@ref)     | returns `(fld(x,y),mod(x,y))`                                                                             |
| [`gcd(x,y...)`](@ref)     | greatest positive common divisor of `x`, `y`,...                                                          |
| [`lcm(x,y...)`](@ref)     | least positive common multiple of `x`, `y`,...                                                            |

### 부호 함수와 절댓값 함수

| 함수                     | 설명                                                       |
|:----------------------- |:---------------------------------------------------------- |
| [`abs(x)`](@ref)        | `x`의 절댓값                                                |
| [`abs2(x)`](@ref)       | `x`절댓값의 제곱                                             |
| [`sign(x)`](@ref)       | `x`의 부호. -1, 0, 혹은 +1를 반환                             |
| [`signbit(x)`](@ref)    | sign bit가 1인지(true) 혹은 0인지(false)인지 반환              |
| [`copysign(x,y)`](@ref) | a value with the magnitude of `x` and the sign of `y`      |
| [`flipsign(x,y)`](@ref) | a value with the magnitude of `x` and the sign of `x*y`    |

### 지수, 로그, 루트 함수

| 함수                      | 설명                                                                        |
|:------------------------ |:-------------------------------------------------------------------------- |
| [`sqrt(x)`](@ref), `√x`  | square root of `x`                                                         |
| [`cbrt(x)`](@ref), `∛x`  | cube root of `x`                                                           |
| [`hypot(x,y)`](@ref)     | hypotenuse of right-angled triangle with other sides of length `x` and `y` |
| [`exp(x)`](@ref)         | natural exponential function at `x`                                        |
| [`expm1(x)`](@ref)       | accurate `exp(x)-1` for `x` near zero                                      |
| [`ldexp(x,n)`](@ref)     | `x*2^n` computed efficiently for integer values of `n`                     |
| [`log(x)`](@ref)         | natural logarithm of `x`                                                   |
| [`log(b,x)`](@ref)       | base `b` logarithm of `x`                                                  |
| [`log2(x)`](@ref)        | base 2 logarithm of `x`                                                    |
| [`log10(x)`](@ref)       | base 10 logarithm of `x`                                                   |
| [`log1p(x)`](@ref)       | accurate `log(1+x)` for `x` near zero                                      |
| [`exponent(x)`](@ref)    | binary exponent of `x`                                                     |
| [`significand(x)`](@ref) | binary significand (a.k.a. mantissa) of a floating-point number `x`        |

For an overview of why functions like [`hypot`](@ref), [`expm1`](@ref), and [`log1p`](@ref)
are necessary and useful, see John D. Cook's excellent pair of blog posts on the subject: [expm1, log1p, erfc](https://www.johndcook.com/blog/2010/06/07/math-library-functions-that-seem-unnecessary/),
and [hypot](https://www.johndcook.com/blog/2010/06/02/whats-so-hard-about-finding-a-hypotenuse/).

### 삼각 함수와 쌍곡선 함수

Julia는 모든 삼각 함수와 쌍곡선 함수를 지원한다:

```
sin    cos    tan    cot    sec    csc
sinh   cosh   tanh   coth   sech   csch
asin   acos   atan   acot   asec   acsc
asinh  acosh  atanh  acoth  asech  acsch
sinc   cosc
```

이 함수들은 인자를 하나만 받지만, 예외적으로 [`atan`](@ref)는 2개를 받을 수 있으며 이는 [`atan2`](https://en.wikipedia.org/wiki/Atan2)에 대응한다.

추가로 [`sinpi(x)`](@ref)와 [`cospi(x)`](@ref)는 [`sin(pi*x)`](@ref), [`cos(pi*x)`](@ref)와 결과는 비슷지만 더 정확한 결과를 산출할 수 있다.

삼각 함수 단위에 호도법(radian)대신 도(°)를 사용하려면 접미사 `d`를 붙인다.
예를 들어 [`sind(x)`](@ref)는 `x`°의 sin값을 구한다.
아래는 접미사 `d`를 사용한 모든 삼각 함수를 나열했다:

```
sind   cosd   tand   cotd   secd   cscd
asind  acosd  atand  acotd  asecd  acscd
```

### 특수 함수

이외에도 다양한 수치 계산용 함수를 패키지로 받을 수 있다
[SpecialFunctions.jl](https://github.com/JuliaMath/SpecialFunctions.jl).
