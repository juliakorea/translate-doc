# 복소수와 유리수

Julia에서는 복소수와 유리수를 표현할 수 있고 [산술 연산과 기본 함수](@ref)를 모두 지원한다.
[Conversion and Promotion](@ref conversion-and-promotion)으로 연산 결과가 수학적으로 예측한 것과 최대한 비슷하게 나오게 했다.

## 복소수

전역 상수 [`im`](@ref)는 -1의 루트값으로, 복소수의 허수부 *i*옆에 붙어있다.
(수학자는 `i`로 쓰고 공학자는 `j` 쓰지만, 이 이름은 인덱싱할 때 자주 사용하므로 전역 상수의 이름으로 채택되지 않았다.)
Julia는 [계수와 변수 사이에 곱셈 기호를 생략하는 것](@ref man-numeric-literal-coefficients)을 허용하기 때문에 수학적 표기법을 그대로 사용할 수 있다:

```jldoctest
julia> 1+2im
1 + 2im
```

복소수는 산술 연산을 지원한다:

```jldoctest
julia> (1 + 2im)*(2 - 3im)
8 + 1im

julia> (1 + 2im)/(1 - 2im)
-0.6 + 0.8im

julia> (1 + 2im) + (1 - 2im)
2 + 0im

julia> (-3 + 2im) - (5 - 1im)
-8 + 3im

julia> (-1 + 2im)^2
-3 - 4im

julia> (-1 + 2im)^2.5
2.729624464784009 - 6.9606644595719im

julia> (-1 + 2im)^(1 + 1im)
-0.27910381075826657 + 0.08708053414102428im

julia> 3(2 - 5im)
6 - 15im

julia> 3(2 - 5im)^2
-63 - 60im

julia> 3(2 - 5im)^-1.0
0.20689655172413796 + 0.5172413793103449im
```

타입 자동 치환을 지원하기 때문에 계산 결과가 수학적으로 예상한 것과 동일하다:

```jldoctest
julia> 2(1 - 1im)
2 - 2im

julia> (2 + 3im) - 1
1 + 3im

julia> (1 + 2im) + 0.5
1.5 + 2.0im

julia> (2 + 3im) - 0.5im
2.0 + 2.5im

julia> 0.75(1 + 2im)
0.75 + 1.5im

julia> (2 + 3im) / 2
1.0 + 1.5im

julia> (1 - 3im) / (2 + 2im)
-0.5 - 1.0im

julia> 2im^2
-2 + 0im

julia> 1 + 3/4im
1.0 - 0.75im
```

리터럴 계수가 나눗셈보다 중요도가 높으므로 `3/4im == 3/(4*im) == -(3/4*im)`가 되는 걸 볼 수 있다.

복소수를 다루기 위한 기본 함수가 제공된다:

```jldoctest
julia> z = 1 + 2im
1 + 2im

julia> real(1 + 2im) # real part of z
1

julia> imag(1 + 2im) # imaginary part of z
2

julia> conj(1 + 2im) # complex conjugate of z
1 - 2im

julia> abs(1 + 2im) # absolute value of z
2.23606797749979

julia> abs2(1 + 2im) # squared absolute value
5

julia> angle(1 + 2im) # phase angle in radians
1.1071487177940904
```

여기서 [`abs`](@ref)는 일반적으로 아는 복소수의 절댓값을 반환하고, [`abs2`](@ref)는 복소수 절댓값의 제곱값, [`angle`](@ref)은 복소수의 각도를 라디안으로 반환한다.


[기본 함수](@ref)는 복소수에서 잘 정의되어 있다:

```jldoctest
julia> sqrt(1im)
0.7071067811865476 + 0.7071067811865475im

julia> sqrt(1 + 2im)
1.272019649514069 + 0.7861513777574233im

julia> cos(1 + 2im)
2.0327230070196656 - 3.0518977991518im

julia> exp(1 + 2im)
-1.1312043837568135 + 2.4717266720048188im

julia> sinh(1 + 2im)
-0.4890562590412937 + 1.4031192506220405im
```

수리 계산을 하는 함수에 실수 인자가 들어오면 실수를 반환하고 복소수가 들어오면 복소수를 반환한다. 이런 특성 때문에 [`sqrt`](@ref)는 `-1`이 들어올 때와 `-1 + 0im` 이 들어올 때 `-1 == -1 + 0im` 이어도 결과가 다르게 나오는 걸 확인할 수 있다.

```jldoctest
julia> sqrt(-1)
ERROR: DomainError with -1.0:
sqrt will only return a complex result if called with a complex argument. Try sqrt(Complex(x)).
Stacktrace:
[...]

julia> sqrt(-1 + 0im)
0.0 + 1.0im
```

변수에 저장된 값으로 복소수를 만들 때는 [리터럴 계수 표현법](@ref man-numeric-literal-coefficients)대신 직접적으로 곱셈을 써줘야 한다:

```jldoctest
julia> a = 1; b = 2; a + b*im
1 + 2im
```

하지만 위처럼 복소수를 만드는 것은 추천하지 않는다. [`complex`](@ref)를 사용하는 것이 복소수를 만들 때 효율적이이다.
이렇게 만들면 곱셈과 덧셈 연산자를 사용하지 않는다.

```jldoctest
julia> a = 1; b = 2; complex(a, b)
1 + 2im
```

[특별한 부동 소수점 값들](@ref Special-floating-point-values)에서 소개한 [`Inf`](@ref)과 [`NaN`](@ref)을 복소수에서도 사용할 수 있다:

```jldoctest
julia> 1 + Inf*im
1.0 + Inf*im

julia> 1 + NaN*im
1.0 + NaN*im
```

## 유리수

Julia는 정수의 비로 유리수를 표현한다.
유리수는 [`//`](@ref)연산자로 만들 수 있다:

```jldoctest
julia> 2//3
2//3
```

분모와 분자가 공통 분모를 가지고 있다면, 이들은 자동으로 상쇄된다:

```jldoctest
julia> 6//9
2//3

julia> -4//8
-1//2

julia> 5//-15
-1//3

julia> -4//-12
1//3
```

분자가 분모가 서로인 상태는 유일하며, 두 유리수가 같은지 보려면 각 분자와 분모가 같은지 보면 된다.
유리수의 분자와 분모는 [`numerator`](@ref)와 [`denominator`](@ref)함수로 확인할 수 있다:

```jldoctest
julia> numerator(2//3)
2

julia> denominator(2//3)
3
```

비교연산자는 유리수에 대하여 정의되어 있으므로 분자와 분모를 직접 비교할 일은 적을 것이다:

```jldoctest
julia> 2//3 == 6//9
true

julia> 2//3 == 9//27
false

julia> 3//7 < 1//2
true

julia> 3//4 > 2//3
true

julia> 2//4 + 1//6
2//3

julia> 5//12 - 1//4
1//6

julia> 5//8 * 3//12
5//32

julia> 6//5 / 10//7
21//25
```

유리수는 쉽게 실수형으로 변환할 수 있다:

```jldoctest
julia> float(3//4)
0.75
```

유리수를 실수와 비교할 때는 유리수가 실수로 형 변환을 하고 비교하도록 설계되었다(단, `a == 0`이고 `b == 0`인 경우 제외):

```jldoctest
julia> a = 1; b = 2;

julia> isequal(float(a//b), a/b)
true
```

유리수를 사용하면 무한대를 다음과 같이 정의할 수 있다:

```jldoctest
julia> 5//0
1//0

julia> -3//0
-1//0

julia> typeof(ans)
Rational{Int64}
```

하지만 유리수에서 [`NaN`](@ref)를 정의할 수는 없다:

```jldoctest
julia> 0//0
ERROR: ArgumentError: invalid rational: zero(Int64)//zero(Int64)
Stacktrace:
[...]
```

유리수는 타입 승격 시스템(promotion system)으로 쉽게 다른 타입의 숫자와 상호작용 할 수 있다:

```jldoctest
julia> 3//5 + 1
8//5

julia> 3//5 - 0.5
0.09999999999999998

julia> 2//7 * (1 + 2im)
2//7 + 4//7*im

julia> 2//7 * (1.5 + 2im)
0.42857142857142855 + 0.5714285714285714im

julia> 3//2 / (1 + 2im)
3//10 - 3//5*im

julia> 1//2 + 2im
1//2 + 2//1*im

julia> 1 + 2//3im
1//1 - 2//3*im

julia> 0.5 == 1//2
true

julia> 0.33 == 1//3
false

julia> 0.33 < 1//3
true

julia> 1//3 - 0.33
0.0033333333333332993
```
