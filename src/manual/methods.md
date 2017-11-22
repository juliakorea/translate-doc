# 함수

[함수](@ ref man-functions)에서 함수는 인수의 튜플을 반환 값으로 매핑하는 객체이거나 적절한 값을 반환 할 수없는 경우 예외를 throw합니다. 두 가지 정수를 더하는 것은 부동 소수점 수에 정수를 더하는 것과는 다른 두 개의 부동 소수점 수를 더하는 것과는 매우 다릅니다. . 이러한 구현의 차이점에도 불구하고 이러한 작업은 모두 "추가"라는 일반적인 개념에 속합니다. 따라서 Julia에서 이러한 동작은 모두 하나의 객체 인 `+` 함수에 속합니다.

동일한 개념의 여러 구현을 원활하게 사용하기 위해 함수를 한꺼번에 정의 할 필요는 없지만 인수 유형 및 개수의 특정 조합에 특정 동작을 제공함으로써 구분할 수 있습니다. 함수에 대해 가능한 한 행동의 정의를 *메소드* 라고합니다. 지금까지 우리는 하나의 메소드로 정의 된 함수의 예제만을 제시했으며, 모든 유형의 인수에 적용 할 수 있습니다. 그러나 메소드 정의의 서명에는 그 수 이외에 인수의 유형을 표시하기 위해 주석을 달 수 있으며 단일 메소드 정의 이상이 제공 될 수 있습니다. 함수가 특정 튜플의 인수에 적용되면 해당 인수에 적용 할 수있는 가장 구체적인 메서드가 적용됩니다. 따라서 함수의 전반적인 동작은 다양한 메서드 정의의 동작을 패치하는 것입니다. 패치 워크가 잘 설계된 경우, 메소드의 구현이 상당히 다를 수도 있지만, 함수의 외부 동작은 매끄럽고 일관성있게 나타납니다.


함수가 적용될 때 실행할 메소드의 선택은 *dispatch* 라고합니다. Julia는 파견 프로세스가 주어진 인수의 수와 함수의 모든 인수 유형에 따라 함수의 메소드 중 어느 것을 호출 할 것인지 선택할 수 있습니다. 이것은 전통적인 객체 지향 언어와는 다르다. 디스패치는 특별한 인수 구문을 사용하는 첫 번째 인수에만 기반을 두며 종종 인수로 명시 적으로 작성되지 않고 암시된다. [^ 1] 함수의 인수를 모두 사용하여 첫 번째 메서드가 아닌 호출 할 메서드를 선택하는 것이 [다중 디스패치](https://en.wikipedia.org/wiki/Multiple_dispatch)로 알려져 있습니다.
다중 디스패치는 수학적 코드에서 특히 유용합니다. 다른 연산보다 하나의 인수에 "속하는"연산을 인위적으로 판단하는 것은 의미가 없습니다. `x + y` 의 더하기 연산이 `y` 보다 `x` 에 속해 있습니까? 수학 연산자의 구현은 일반적으로 모든 인수의 유형에 따라 다릅니다. 그러나 수학적 작업을 넘어서더라도, 다중 파견은 프로그램을 구조화하고 조직화하는 데있어 유쾌하고 편리한 패러다임입니다.

[^1]:
    예를 들어,`obj.meth(arg1, arg2)` 와 같은 메소드 호출에서 C ++이나 Java에서 객체 obj는 메소드 호출을 "받는다"는 의미가 아니라 `this` 키워드를 통해 메소드에 암묵적으로 전달됩니다. 명시적인 메소드 인수. 현재 `this` 객체가 메소드 호출의 수신자 일 때 `meth (arg1, arg2)` 만 쓰고 `this` 를 수신 객체로 함축하여 생략 할 수 있습니다.

## 메소드 정의

지금까지 우리는 예제에서 제약되지 않은 인자 타입을 가진 하나의 메소드를 가진 함수만을 정의했다. 이러한 함수는 전통적인 동적 유형 지정 언어 에서처럼 작동합니다. 그럼에도 불구하고 우리는 다중 디스패치와 메소드를 의식하지 않고 거의 연속적으로 사용했습니다. 앞서 말한 `+` 함수와 같은 모든 Julia의 표준 함수와 연산자에는 인수 유형과 개수의 다양한 조합을 통해 동작을 정의하는 많은 메소드가 있습니다.

함수를 정의 할 때 [Composite Types](@ref) 섹션에서 소개 한 `::` type-assertion 연산자를 사용하여 적용 할 수있는 매개 변수의 유형을 선택적으로 제한 할 수 있습니다. :

```jldoctest fofxy
julia> f(x::Float64, y::Float64) = 2x + y
f (generic function with 1 method)
```

이 함수 정의는 `x` 와 `y` 가 모두 타입의 값인 호출에만 적용됩니다
[`Float64`](@ref):

```jldoctest fofxy
julia> f(2.0, 3.0)
7.0
```

다른 유형의 인수에 적용하면 [`MethodError`](@ ref) 가됩니다.

```jldoctest fofxy
julia> f(2.0, 3)
ERROR: MethodError: no method matching f(::Float64, ::Int64)
Closest candidates are:
  f(::Float64, !Matched::Float64) at none:1

julia> f(Float32(2.0), 3.0)
ERROR: MethodError: no method matching f(::Float32, ::Float64)
Closest candidates are:
  f(!Matched::Float64, ::Float64) at none:1

julia> f(2.0, "3.0")
ERROR: MethodError: no method matching f(::Float64, ::String)
Closest candidates are:
  f(::Float64, !Matched::Float64) at none:1

julia> f("2.0", "3.0")
ERROR: MethodError: no method matching f(::String, ::String)
```

보시다시피, 인수는 정확히 [`Float64`](@ ref) 유형이어야합니다. 정수 또는 32 비트 부동 소수점 값과 같은 다른 숫자 유형은 자동으로 '64 비트 부동 소수점으로 변환되지 않으며 숫자로 해석되는 문자열도 아닙니다. `Float64` 는 구체적인 타입이고 Julia에서 구체적인 타입을 서브 클래 싱 할 수 없기 때문에, 그러한 정의는 정확히 `Float64` 타입의 인자에만 적용될 수 있습니다. 그러나 선언 된 매개 변수 유형이 추상 인 경우보다 일반적인 메소드를 작성하는 것이 종종 유용 할 수 있습니다.

```jldoctest fofxy
julia> f(x::Number, y::Number) = 2x - y
f (generic function with 2 methods)

julia> f(2.0, 3)
1.0
```

이 메소드 정의는 [`Number`](@ ref) 의 인스턴스 인 모든 인수 쌍에 적용됩니다. 그들은 각각 숫자 값인 한 동일한 유형일 필요는 없습니다. 서로 다른 숫자 타입을 처리하는 문제는 `2x - y` 표현식의 산술 연산에 위임됩니다.

여러 메소드로 함수를 정의하려면 함수의 수와 유형을 여러 번 정의해야합니다. 함수에 대한 첫 번째 메서드 정의는 함수 개체를 만들고 후속 메서드 정의는 기존 함수 개체에 새 메서드를 추가합니다. 인수의 수와 유형과 일치하는 가장 구체적인 메소드 정의는 함수가 적용될 때 실행됩니다. 따라서, 위의 두 메소드 정의는 함께 추상 타입 `Number` 의 모든 인스턴스 쌍에 대해 `f` 에 대한 동작을 정의하지만 [`Float64`](@ref) 쌍에 고유 한 다른 동작을 사용하여 정의됩니다. 값. 인수 중 하나가 64 비트 부동 소수점이지만 다른 하나는 부동 소수점인 경우 `f(Float64, Float64)` 메서드를 호출 할 수 없으며보다 일반적인 `f(Number, Number)` 메서드를 사용해야합니다.

```jldoctest fofxy
julia> f(2.0, 3.0)
7.0

julia> f(2, 3.0)
1.0

julia> f(2.0, 3)
1.0

julia> f(2, 3)
1
```

`2x + y` 정의는 첫 번째 경우에만 사용되는 반면, `2x-y` 정의는 다른 것에 사용됩니다. 자동 주조 또는 함수 인수 변환이 수행되지 않습니다. Julia의 모든 변환은 비 마법적이고 완전히 명시 적입니다. 그러나 [전환 및 판촉](@ ref conversion-and-promotion) 은 충분히 발전된 기술의 영리한 적용이 마법과 구별 될 수 없음을 보여줍니다.[^Clarke61]


숫자가 아닌 값과 2 개보다 적거나 많은 인수의 경우, `f` 함수는 정의되지 않은 채로 남아 있으며, 여전히 [`MethodError`](@ref) 가됩니다 :

```jldoctest fofxy
julia> f("foo", 3)
ERROR: MethodError: no method matching f(::String, ::Int64)
Closest candidates are:
  f(!Matched::Number, ::Number) at none:1

julia> f()
ERROR: MethodError: no method matching f()
Closest candidates are:
  f(!Matched::Float64, !Matched::Float64) at none:1
  f(!Matched::Number, !Matched::Number) at none:1
```

대화 형 세션에서 함수 객체 자체를 입력하면 함수에 어떤 메소드가 있는지 쉽게 알 수 있습니다.

```jldoctest fofxy
julia> f
f (generic function with 2 methods)
```

이 출력은 `f` 가 두 가지 메소드를 가진 함수 객체라는 것을 알려줍니다. 이러한 메소드의 서명이 무엇인지 알아 보려면 [`methods`](@ref) 함수를 사용하십시오.

```julia-repl
julia> methods(f)
# 2 methods for generic function "f":
[1] f(x::Float64, y::Float64) in Main at none:1
[2] f(x::Number, y::Number) in Main at none:1
```

`f` 에는 두 개의 Float64 인수를 취하는 메소드와 `Number` 타입의 인수를 취하는 메소드가 있습니다. 또한 메소드가 정의 된 파일과 행 번호를 표시합니다.이 메소드가 REPL에 정의 되었기 때문에 명백한 행 번호는 `none:1` 입니다.

`::` 를 사용한 타입 선언이 없으면 메소드 매개 변수의 타입은 기본적으로 `Any` 이며, 이는 Julia의 모든 값이 추상 타입 `Any` 의 인스턴스이기 때문에 제약이 없다는 것을 의미합니다. 따라서 `f` 에 대한 catch-all 메소드를 다음과 같이 정의 할 수 있습니다 :

```jldoctest fofxy
julia> f(x,y) = println("Whoa there, Nelly.")
f (generic function with 3 methods)

julia> f("foo", 1)
Whoa there, Nelly.
```


이 catch-all은 한 쌍의 매개 변수 값에 대해 가능한 다른 메서드 정의보다 덜 구체적이므로 다른 메서드 정의가 적용되지 않는 인수 쌍에서만 호출됩니다.

단순한 개념으로 보일지라도, 가치 유형에 대한 다중 파견은 아마도 줄리아 언어의 가장 강력하고 핵심적인 단일 기능 일 것입니다. 핵심 운영에는 일반적으로 수십 가지 방법이 있습니다 :

```julia-repl
julia> methods(+)
# 180 methods for generic function "+":
[1] +(x::Bool, z::Complex{Bool}) in Base at complex.jl:227
[2] +(x::Bool, y::Bool) in Base at bool.jl:89
[3] +(x::Bool) in Base at bool.jl:86
[4] +(x::Bool, y::T) where T<:AbstractFloat in Base at bool.jl:96
[5] +(x::Bool, z::Complex) in Base at complex.jl:234
[6] +(a::Float16, b::Float16) in Base at float.jl:373
[7] +(x::Float32, y::Float32) in Base at float.jl:375
[8] +(x::Float64, y::Float64) in Base at float.jl:376
[9] +(z::Complex{Bool}, x::Bool) in Base at complex.jl:228
[10] +(z::Complex{Bool}, x::Real) in Base at complex.jl:242
[11] +(x::Char, y::Integer) in Base at char.jl:40
[12] +(c::BigInt, x::BigFloat) in Base.MPFR at mpfr.jl:307
[13] +(a::BigInt, b::BigInt, c::BigInt, d::BigInt, e::BigInt) in Base.GMP at gmp.jl:392
[14] +(a::BigInt, b::BigInt, c::BigInt, d::BigInt) in Base.GMP at gmp.jl:391
[15] +(a::BigInt, b::BigInt, c::BigInt) in Base.GMP at gmp.jl:390
[16] +(x::BigInt, y::BigInt) in Base.GMP at gmp.jl:361
[17] +(x::BigInt, c::Union{UInt16, UInt32, UInt64, UInt8}) in Base.GMP at gmp.jl:398
...
[180] +(a, b, c, xs...) in Base at operators.jl:424
```

유연한 파라 메트릭 유형 시스템과의 다중 디스패치 기능을 통해 Julia는 구현 세부 정보에서 분리 된 상위 수준의 알고리즘을 추상적으로 표현할 수 있지만 런타임에 각 사례를 처리 할 수있는 효율적인 특수 코드를 생성 할 수 있습니다.

## [방법 모호성](@ id man-ambiguities)


일부 인수 조합에 적용 할 수있는 고유 한 가장 구체적인 메소드가 없도록 함수 메소드 세트를 정의 할 수 있습니다. :

```jldoctest gofxy
julia> g(x::Float64, y) = 2x + y
g (generic function with 1 method)

julia> g(x, y::Float64) = x + 2y
g (generic function with 2 methods)

julia> g(2.0, 3)
7.0

julia> g(2, 3.0)
8.0

julia> g(2.0, 3.0)
ERROR: MethodError: g(::Float64, ::Float64) is ambiguous. Candidates:
  g(x, y::Float64) in Main at none:1
  g(x::Float64, y) in Main at none:1
Possible fix, define
  g(::Float64, ::Float64)
```

여기서 `g (2.0, 3.0)` 호출은 `g (Float64, Any)` 또는 `g (Any, Float64)` 메소드에 의해 처리 될 수 있으며, 어느 쪽도 더 구체적이지 않습니다. 이런 경우 Julia는 임의로 메서드를 선택하는 것이 아니라 [`MethodError`](@ref) 를 발생시킵니다. 교차 사례의 적절한 방법을 지정하여 메소드 모호성을 피할 수 있습니다. :

```jldoctest gofxy
julia> g(x::Float64, y::Float64) = 2x + 2y
g (generic function with 3 methods)

julia> g(2.0, 3)
7.0

julia> g(2, 3.0)
8.0

julia> g(2.0, 3.0)
10.0
```


일시적인 경우보다 구체적인 방법이 정의 될 때까지 모호성이 존재하기 때문에 모호성을 제거하는 방법을 먼저 정의하는 것이 좋습니다.

보다 복잡한 경우, 방법 모호성 해결 은 디자인의 특정 요소를 포함합니다. 이 주제는 [아래](@ ref man-method-design-ambiguities) 에서 더 자세히 다루어집니다.

## 파라 메 트릭 메소드

메소드 정의는 선택적으로 서명을 한정하는 매개 변수를 가질 수 있습니다.

```jldoctest same_typefunc
julia> same_type(x::T, y::T) where {T} = true
same_type (generic function with 1 method)

julia> same_type(x,y) = false
same_type (generic function with 2 methods)
```


첫 번째 방법은 두 인수가 모두 동일한 구체 유형일 때마다 적용됩니다. 두 번째 방법은 다른 모든 경우를 포괄하는 포괄적인 방식으로 작동합니다. 따라서 전반적으로 두 인수가 같은 유형인지 여부를 확인하는 부울 함수를 정의합니다.

```jldoctest same_typefunc
julia> same_type(1, 2)
true

julia> same_type(1, 2.0)
false

julia> same_type(1.0, 2.0)
true

julia> same_type("foo", 2.0)
false

julia> same_type("foo", "bar")
true

julia> same_type(Int32(1), Int64(2))
false
```


이러한 정의는 형식 서명이 `UnionAll` ([UnionAll Types](@ ref) 참조) 유형인 메소드에 해당합니다.

이러한 종류의 파견에 의한 기능 행동의 정의는 매우 흔하며, 심지어 줄리아에서도 관용적입니다. 메소드 유형 매개 변수는 인수의 유형으로 사용되는 것으로 제한되지 않으며 함수의 본문 또는 본문에 값이있는 모든 위치에서 사용할 수 있습니다. 다음은 메소드 시그니처의 매개 변수 유형 `Vector {T}` 에 대한 유형 매개 변수로 메소드 유형 매개 변수 `T` 가 사용되는 예제입니다.

```jldoctest
julia> myappend(v::Vector{T}, x::T) where {T} = [v..., x]
myappend (한가지 메소드를 가진 일반함수)

julia> myappend([1,2,3],4)
4-element Array{Int64,1}:
 1
 2
 3
 4

julia> myappend([1,2,3],2.5)
ERROR: MethodError : myappend와 일치하는 메서드가 없습니다.(::Array{Int64,1}, ::Float64)
가장 가까운 후보자는:
  myappend(::Array{T,1}, !Matched::T) where T at none:1

julia> myappend([1.0,2.0,3.0],4.0)
4-element Array{Float64,1}:
 1.0
 2.0
 3.0
 4.0

julia> myappend([1.0,2.0,3.0],4)
ERROR : MethodError : myappend와 일치하는 메서드가 없습니다.(::Array{Float64,1}, ::Int64)
가장 가까운 후보자는:
  myappend(::Array{T,1}, !Matched::T) where T at none:1
```


보시다시피, 첨부 된 요소의 유형은 추가되는 벡터의 요소 유형과 일치해야합니다. 그렇지 않으면 [`MethodError`](@ ref) 가 발생합니다. 다음 예제에서는 메서드 유형 매개 변수 `T` 가 반환 값으로 사용됩니다.

```jldoctest
julia> mytypeof(x::T) where {T} = T
mytypeof (한가지 메소드를 가진 일반함수)

julia> mytypeof(1)
Int64

julia> mytypeof(1.0)
Float64
```


타입 선언에 타입 파라미터에 하위 타입 제약 조건을 넣을 수있는 것처럼 ([파라 메트릭 타입](@ ref) 참조), 메소드의 타입 파라미터를 제한 할 수도 있습니다 :

```jldoctest
julia> same_type_numeric(x::T, y::T) where {T<:Number} = true
same_type_numeric (한가지 메소드를 가진 일반함수)

julia> same_type_numeric(x::Number, y::Number) = false
same_type_numeric (두가지 메소드를 가진 일반함수s)

julia> same_type_numeric(1, 2)
true

julia> same_type_numeric(1, 2.0)
false

julia> same_type_numeric(1.0, 2.0)
true

julia> same_type_numeric("foo", 2.0)
ERROR: MethodError : same_type_numeric과 일치하는 메서드가 없습니다.(::String, ::Float64)
가장 가까운 후보자는:
  same_type_numeric(!Matched::T<:Number, ::T<:Number) where T<:Number at none:1
  same_type_numeric(!Matched::Number, ::Number) at none:1

julia> same_type_numeric("foo", "bar")
ERROR: MethodError: same_type_numeric과 일치하는 메서드가 없습니다.(::String, ::String)

julia> same_type_numeric(Int32(1), Int64(2))
false
```

`same_type_numeric` 함수는 위에 정의 된 `same_type` 함수와 매우 비슷하게 동작하지만 숫자 쌍에 대해서만 정의됩니다.

파라 메트릭 메소드는 타입 작성에 사용되는 `where` 표현식과 같은 구문을 허용합니다 ([UnionAll Types](@ ref) 참조).
하나의 매개 변수 만있는 경우에는 `{T}` 에있는 중괄호를 생략 할 수 있지만 명확성을 위해 선호하는 경우가 많습니다.
여러 매개 변수는 쉼표로 구분할 수 있습니다. e.g. `where {T, S<:Real}`, 또는 `where` 중첩을 사용하여 작성 , e.g. `where S<:Real where T`.

##재정의 메소드
------------------


메소드를 재정의하거나 새 메소드를 추가 할 때 이러한 변경 사항이 즉시 적용되지 않는다는 것을 인식하는 것이 중요합니다.
Julia가 일반적인 JIT 트릭이나 오버 헤드없이 정적으로 코드를 추론하고 컴파일하여 실행하는 것이 중요합니다.
실제로 새로운 메소드 정의는 Tasks와 쓰레드 (그리고 이전에 정의 된 `@generated` 함수들) 를 포함하여 현재 런타임 환경에서 볼 수 없을 것입니다.
예를 들어 이것이 무엇을 의미하는지 알아 봅시다.

```julia-repl
julia> function tryeval()
           @eval newfun() = 1
           newfun()
       end
tryeval (generic function with 1 method)

julia> tryeval()
ERROR: MethodError: newfun ()과 일치하는 메소드가 없습니다
적용 가능한 방법이 너무 새롭다: current world is xxxx2인동안 world age xxxx1실행.
가장 가까운 후보자는 다음과 같습니다:
  none:1 에서 newfun()  (this world context에서 호출하기에는 너무 새로운 메소드.)
 in tryeval() at none:1
 ...

julia> newfun()
1
```


이 예제에서는 `newfun` 에 대한 새로운 정의가 생성되었지만 즉시 호출 할 수 없음을 관찰합니다.
새로운 전역 변수는 `tryeval` 함수에서 즉시 볼 수 있으므로 `return newfun` (괄호없이)을 쓸 수 있습니다.
그러나 당신이나 당신의 호출자, 또는 그들이 부르는 기능도 아닙니다.
이 새로운 메소드 정의를 호출 할 수 있습니다!

그러나 예외가 있습니다 : 미래의`newfun` 호출은 예상대로 *REPL* 에서 작동합니다. newfun의 새로운 정의를보고 호출 할 수 있습니다.

그러나 'tryeval'에 대한 향후 호출은 *이전 선언문 REPL* 에서처럼 `newfun` 의 정의를 계속 볼 것이며, 따라서 `tryeval` 에 대한 호출 전에 나타납니다.


어떻게 작동하는지 직접 확인해보십시오.

이 동작의 구현은 "세계 시대 카운터"입니다.이 단조 증가 값은 각 메소드 정의 연산을 추적합니다.
이를 통해 "주어진 런타임 환경에서 볼 수있는 메소드 정의 세트"를 단일 숫자 또는 "world age"로 설명 할 수 있습니다.
또한 서수 값을 비교하여 두 worlds에서 사용할 수있는 방법을 비교할 수 있습니다.
위 예제에서  "current world"("newfun"메서드가있는)는 `tryeval` 실행이 시작될 때 수정 된 작업 로컬 "런타임 환경" 보다 큰 것입니다.

때로는 이것을 피하는 것이 필요합니다 (예를 들어 위의 REPL을 구현하는 경우).
다행히도 쉬운 해결책이 있습니다 : [`Base.invokelatest`](@ ref)를 사용하여 함수를 호출하십시오 :

```jldoctest
julia> function tryeval2()
           @eval newfun2() = 2
           Base.invokelatest(newfun2)
       end
tryeval2 (한가지 메소드를 가진 일반함수)

julia> tryeval2()
2
```

마지막으로,이 규칙이 적용되는 좀 더 복잡한 예제를 살펴 보겠습니다.
처음에는 하나의 메소드를 가지고있는 함수 `f(x)` 를 정의합니다 :

```jldoctest 메소드재정의
julia> f(x) = "원래 정의"
f (한가지 메소드를 가진 일반함수)
```


`f (x)`를 사용하는 다른 연산을 시작합니다.:

```jldoctest 메소드재정의
julia> g(x) = f(x)
g (한가지 메소드를 가진 일반함수)

julia> t = @async f(wait()); yield();
```

이제 우리는`f (x)`에 몇 가지 새로운 메소드를 추가합니다 :

```jldoctest 메소드재정의
julia> f(x::Int) = "Int로 정의"
f (두가지 메소드를 가진 일반함수)

julia> f(x::Type{Int}) = "Type{Int}로 정의"
f (세가지 메소드를 가진 일반함수)
```

결과가 어떻게 다른지 비교해봅시다.:

```jldoctest 메소드재정의
julia> f(1)
"Int로 정의"

julia> g(1)
"Int로 정의"

julia> wait(schedule(t, 1))
"기본 정의"

julia> t = @async f(wait()); yield();

julia> wait(schedule(t, 1))
"Int로 정의"
```

## 파라 메트릭 방법을 사용한 디자인 패턴


성능이나 유용성에 복잡한 디스패치 로직이 필요하지는 않지만 때로는 일부 알고리즘을 표현하는 가장 좋은 방법 일 수 있습니다.
이런 방식으로 디스패치를 ​​사용할 때 때로는 나타나는 몇 가지 일반적인 디자인 패턴이 있습니다.

### super-type 에서 type 매개 변수 추출



여기 `AbstractArray` 의 임의의 하위 유형의 요소 유형 `T` 를 반환하기위한 올바른 코드 템플릿이 있습니다.:

```julia
abstract type AbstractArray{T, N} end
eltype(::Type{<:AbstractArray{T}}) where {T} = T
```
삼각 파견을 사용합니다. 예를 들어 `T` 가 `UnionAll` 타입 인 경우에 주목합니다. `eltype(Array{T} where T <: Integer)` 이면 `Any` 가 반환됩니다.
 (`Base` 에있는 `eltype` 의 버전도 마찬가지입니다).
 Note that if `T` is a `UnionAll`


 Julia v0.6에서 삼각형 파견의 출현 이전에 유일한 올바른 방법이었던 또 다른 방법은 다음과 같습니다. :

```julia
abstract type AbstractArray{T, N} end
eltype(::Type{AbstractArray}) = Any
eltype(::Type{AbstractArray{T}}) where {T} = T
eltype(::Type{AbstractArray{T, N}}) where {T, N} = T
eltype(::Type{A}) where {A<:AbstractArray} = eltype(supertype(A))
```

또 다른 가능성은 다음과 같습니다. 매개 변수 `T` 가 더 좁게 일치해야하는 경우에 적용하는 것이 유용 할 수 있습니다.

```julia
eltype(::Type{AbstractArray{T, N} where {T<:S, N<:M}}) where {M, S} = Any
eltype(::Type{AbstractArray{T, N} where {T<:S}}) where {N, S} = Any
eltype(::Type{AbstractArray{T, N} where {N<:M}}) where {M, T} = T
eltype(::Type{AbstractArray{T, N}}) where {T, N} = T
eltype(::Type{A}) where {A <: AbstractArray} = eltype(supertype(A))
```


일반적인 실수 중 하나는 내부 검사를 사용하여 요소 유형을 얻는 것입니다. :

```julia
eltype_wrong(::Type{A}) where {A<:AbstractArray} = A.parameters[1]
```

그러나 이것이 실패 할 경우를 만드는 것은 어렵지 않습니다. :

```julia
struct BitVector <: AbstractArray{Bool, 1}; end
```

여기서 우리는 매개 변수를 가지지 않는 `BitVector` 타입을 만들었지만, element-type이 여전히 완전하게 지정되고 `T` 는 `Bool` 과 같습니다!


### 다른 형식 매개 변수를 사용하여 비슷한 유형 만들기


일반적인 코드를 만들 때 유형의 레이아웃을 변경하고 유사한 유형의 객체를 생성해야하는 경우가 종종 있습니다. 유형 매개 변수의 변경이 필요합니다.
예를 들어 임의의 요소 유형을 가진 일종의 추상 배열을 가질 수 있으며 특정 요소 유형으로 계산을 작성하려고합니다.
이 유형 변환을 계산하는 방법을 설명하는 각 `AbstractArray{T}` 하위 유형에 대한 메소드를 구현해야합니다.
하나의 부속 유형에 대해 다른 매개 변수를 갖는 다른 부속 유형으로의 변환이 없습니다.
(빠른 검토 : 이것이 왜 있는지 보시겠습니까?)


`AbstractArray` 의 부속유형은 일반적으로이를 달성하는 두가지 메소드를 구현합니다. 입력배열을 특정 `AbstractArray {T, N}` 추상유형의 부속유형으로 변환하는 메소드 및 특정요소 유형을 가진 초기화되지 않은 새로운 배열을 만드는 방법.
이들의 샘플구현은 표준 라이브러리에서 찾을 수 있습니다.
다음은 `input` 과 `output` 이 같은 타입으로되어 있다는 것을 보장하는 기본적인 예제사용법입니다 :

```julia
input = convert(AbstractArray{Eltype}, input)
output = similar(input, Eltype)
```

이를 확장하기 위해 알고리즘에 입력배열의 복사본이 필요한경우 반환값이 원래입력의 별칭일 수 있으므로 [`convert`](@ref) 는 충분하지 않습니다.
출력배열을 만들기 위해 [`similar`](@ref)와 입력데이터로 채우기 위해 [`copy!`](@ref) 를 결합하는 것은 변경가능한
입력인수 복사본에 대한 요구사항을 표현하는 일반적인 방법입니다.:

```julia
copy_with_eltype(input, Eltype) = copy!(similar(input, Eltype), input)
```

### 반복 디스패치


다단계 매개변수 목록을 발송하려면 종종 각 발송 단계를 별개의 기능으로 분리하는 것이 가장 좋습니다.
단일발송에 대한 접근방식과 비슷할 수도 있지만, 아래에서 보게 되겠지만 더 유연합니다.


예를들어 배열의 요소유형을 디스패칭하려고하면 종종 모호한 상황이 발생합니다.
대신 일반적으로 코드는 컨테이너유형에 먼저 전달되고 eltype를 기반으로 한 것 보다 구체적인 메소드로 순환됩니다.
대부분의 경우 알고리즘은이 계층적 접근방식을 편리하게 사용하지만 다른 경우에는 수동으로 이 엄격성을 해결해야합니다.
이 디스패칭 브랜칭은 두 개의 행렬을 합산하는 로직에서 볼 수 있습니다. :

```julia
# 첫 번째 디스패치는 요소별 합계에 대한 map 알고리즘을 선택합니다.
+(a::Matrix, b::Matrix) = map(+, a, b)
# 그런 다음 디스패치는 각 요소를 처리하고 적절한 요소를 선택합니다.
# 계산을위한 공통 요소 유형.
+(a, b) = +(promote(a, b)...)
# 요소의 유형이 같으면 추가 할 수 있습니다.
# 예를 들어, 프로세서에 의해 노출된 원시연산을 통해.
+(a::Float64, b::Float64) = Core.add(a, b)
```

### Trait-based 디스패치

위의 iterated 디스패치를 ​​자연스럽게 확장하면 형식계층에 정의된 집합과 독립적인 형식집합을 디스패치 할 수있는 계층을 메서드선택에 추가 할 수 있습니다.
우리는 문제의유형의 `조합` 을 작성하여 그러한 집합을 구성 할 수 있지만, 생성 후에 `연합` 유형을 변경할 수 없으므로이 집합은 확장 할 수 없습니다.
그러나 이러한 확장가능 세트는 종종 ["Holy-trait"](https://github.com/JuliaLang/julia/issues/2345#issuecomment-54537633) 이라고하는 디자인 패턴으로 프로그래밍 될 수 있습니다.

이 패턴은 함수인수가 속할 수있는 각 특성집합에 대해 다른 단일값 (또는 유형)을 계산하는 일반함수를 정의하여 구현됩니다. 이 기능이 순수하면 정상적인 발송과 비교하여 성능에 영향을주지 않습니다.


이전 섹션의 예제는 [`map`](@ref) 및 [`promote`](@ref)의 구현세부사항을 설명했습니다.이 두 특성은 이러한 특성에 따라 작동합니다.
`map` 의 구현과 같이 행렬을 반복 할 때 중요한 질문 중 하나는 데이터를 순회하기 위해 사용하는 순서입니다.
`AbstractArray` 보조형이 [`Base.IndexStyle`](@ref) 형질을 구현할 때 `map` 과 같은 다른함수는 이러한 정보를 보내서 최상의 알고리즘을 선택합니다 ([Abstract Array Interface](@ref man-interface -정렬)).
즉, 일반정의 + 특성클래스를 사용하면 시스템에서 가장 빠른 버전을 선택할 수 있기 때문에 각 하위유형에서 `map` 의 사용자정의버전을 구현할 필요가 없습니다.
trait-based의 디스패치를 ​​보여주는 `map` 의 장난감 구현 :

```julia
map(f, a::AbstractArray, b::AbstractArray) = map(Base.IndexStyle(a, b), f, a, b)
# 일반적인 구현 :
map(::Base.IndexCartesian, f, a::AbstractArray, b::AbstractArray) = ...
# 선형 인덱싱 구현 (더 빠름)
map(::Base.IndexLinear, f, a::AbstractArray, b::AbstractArray) = ...
```

이 trait-based 접근법은 스칼라 `+` 에 의해 채택 된 [`promote`](@ref) 메커니즘에도 존재합니다.
이것은 [`promote_type`](@ref) 을 사용하는데, 이것은 최적의 공통 유형을 반환합니다.
두 가지 유형의 피연산자가 주어진 경우 연산을 계산합시다.
이를 통해 모든 유형의 인수에 대해 모든 함수를 구현하는 문제를 줄이고,
각 유형에서 일반 유형으로 변환 작업을 구현하는 훨씬 작은 문제와 선호되는 preferred pair-wise promotion rules표를 줄일 수 있습니다.


### 출력 유형 계산

trait-based 프로모션에 대한 논의는 다음 디자인패턴으로의 전환을 제공합니다. 매트릭스 작동을위한 출력 요소 유형 계산.

추가 같은 기본 연산을 구현하기 위해 [`promote_type`](@ref) 함수를 사용하여 원하는 출력유형을 계산합니다.
(이전과 마찬가지로 `+` 호출로 `promote` 호출에서 이것을 보았습니다).

행렬에 대한 함수의 경우보다 더 복잡한 연산 순서에 대해 예상되는 반환 형식을 계산해야 할 수도 있습니다.
이 작업은 종종 다음 단계로 수행됩니다.

1. 알고리즘의 커널에 의해 수행되는 일련의 연산을 나타내는 작은 함수 `op` 를 작성합니다.
2. 결과 행렬의 요소 타입 `R` 을`promote_op (op, argument_types ...)` 로 계산합니다. 여기서 `argument_types` 는 각 입력 배열에 적용된 `eltype` 에서 계산됩니다.
3. 출력 행렬을 `similar(R, dims)` 로 만듭니다. 여기서 `dims` 는 출력 배열의 원하는 차원입니다.

For a more specific example, a generic square-matrix multiply pseudo-code might look like:

좀 더 구체적인 예를 들어, 일반제곱 - 행렬곱셈 pseudo코드는 다음과 같습니다.

```julia
function matmul(a::AbstractMatrix, b::AbstractMatrix)
    op = (ai, bi) -> ai * bi + ai * bi

    ## 이것은 `one(eltype (a))` 가 생성 가능하다고 가정하기 때문에 불충분합니다.:
    # R = typeof(op(one(eltype(a)), one(eltype(b))))

    ## 이것은`a [1]`이 있다고 가정하기 때문에 실패하고, 배열의 모든 요소를 ​​나타 내기 때문에 실패합니다
    # R = typeof(op(a[1], b[1]))

    ## 이것은 `+` 가 `promote_type` 를 호출한다고 가정하기 때문에 올바르지 않습니다.
    ## 그러나 Bool과 같은 일부 유형에서는 그렇지 않습니다.:
    # R = promote_type(ai, bi)

    # 타입 추론의 반환 값에 따라 매우 취약하기 때문에 잘못되었습니다.(최적화가 불가능할뿐만 아니라):
    # R = return_types(op, (eltype(a), eltype(b)))

    ## 그래서 결국 이렇습니다.:
    R = promote_op(op, eltype(a), eltype(b))
    ## 때로는 원하는 유형보다 더 큰 유형을 제공 할 수도 있지만 항상 올바른 유형을 제공합니다.

    output = similar(b, R, (size(a, 1), size(b, 2)))
    if size(a, 2) > 0
        for j in 1:size(b, 2)
            for i in 1:size(b, 1)
                ## 여기서 `R` 는 `Any`, `zero(Any)` 는 정의되지 않았기 때문에 `ab = zero(R)` 을 사용하지 않습니다.
                ## 우리는 또한 typeof (a * b)! = typeof (a * b + a * b) == R이 가능하기 때문에 `ab::R` 을 선언하여 루프에서  `ab` 의 타입을 상수로 만들어야합니다.
                ab::R = a[i, 1] * b[1, j]
                for k in 2:size(a, 2)
                    ab += a[i, k] * b[k, j]
                end
                output[i, j] = ab
            end
        end
    end
    return output
end
```

### 별도의 변환과 커널로직

컴파일 시간을 줄이고 복잡성을 테스트하는 한 가지 방법은 원하는 유형으로 변환하기위한 로직과 계산을 분리하는 것입니다. 이를 통해 컴파일러는 변환 논리를 대형 커널의 나머지 본문과 독립적으로 특수화하고 인라인 할 수 있습니다.

이것은 더 큰 클래스 유형에서 변환 할 때 나타나는 공통 패턴입니다
알고리즘이 실제로 지원하는 특정 인수 유형으로 변환합니다.

```julia
complexfunction(arg::Int) = ...
complexfunction(arg::Any) = complexfunction(convert(Int, arg))

matmul(a::T, b::T) = ...
matmul(a, b) = matmul(promote(a, b)...)
```

## 매개 변수 적으로 제한된 Varargs 메소드


함수매개변수는 "varargs"함수 ([Varargs Functions](@ref))에 제공 될 수있는 인수의 수를 제한하는 데 사용될 수도 있습니다.
`Vararg {T, N}` 표기법은 그러한 제약을 나타내기 위해 사용됩니다. 예 :

```jldoctest
julia> bar(a,b,x::Vararg{Any,2}) = (a,b,x)
bar (한가지 방법을 가진 일반함수)

julia> bar(1,2,3)
ERROR: MethodError: 메소드 일치 bar(::Int64, ::Int64, ::Int64) 없음
가장 가까운 후보자는 다음과 같습니다.:
  bar(::Any, ::Any, ::Any, !Matched::Any) at none:1

julia> bar(1,2,3,4)
(1, 2, (3, 4))

julia> bar(1,2,3,4,5)
ERROR: MethodError: 메소드 일치 bar(::Int64, ::Int64, ::Int64, ::Int64, ::Int64) 없음
가장 가까운 후보자는 다음과 같습니다.:
  bar(::Any, ::Any, ::Any, ::Any) at none:1
```

보다 유용하게 파라미터에 의해 varargs 메소드를 제한하는 것이 가능합니다. 예 :

```julia
function getindex(A::AbstractArray{T,N}, indexes::Vararg{Number,N}) where {T,N}
```

`인덱스` 의 수가 배열의 차원과 일치 할 때만 호출됩니다.

When only the type of supplied arguments needs to be constrained `Vararg{T}` can be equivalently
written as `T...`. For instance `f(x::Int...) = x` is a shorthand for `f(x::Vararg{Int}) = x`.

오직 제공된 인자의 타입만이 제약을 받아야 할 때 `Vararg{T}` 는 `T...` 와 같이 쓰일 수 있습니다. 예를 들어, `f(x::Int ...) = x` 는 `f(x::Vararg{Int}) = x` 의 속기입니다.

## 키워드 인수 선택 사항에 대한 참고 사항

[Functions](@ ref man-functions) 에서 간략하게 언급했듯이 선택적 인수는 여러 메소드정의의 구문으로 구현됩니다. 예를 들어, 이 정의는 다음과 같습니다.

```julia
f(a=1,b=2) = a+2b
```

다음 세 가지 방법으로 변환됩니다.

```julia
f(a,b) = a+2b
f(a) = f(a,2)
f() = f(1,2)
```

This means that calling `f()` is equivalent to calling `f(1,2)`. In this case the result is `5`,
because `f(1,2)` invokes the first method of `f` above. However, this need not always be the case.
If you define a fourth method that is more specialized for integers:
이것은 `f()` 를 호출하는 것이 `f(1,2)` 를 호출하는 것과 동일하다는 것을 의미합니다.이 경우 결과는`5`입니다.
왜냐하면 `f(1,2)` 가 위의 `f` 의 첫 번째 메소드를 호출하기 때문입니다. 그러나, 항상 그런 것은 아닙니다.
정수에보다 특수화 된 네 번째 메서드를 정의하면 다음과 같습니다.

```julia
f(a::Int,b::Int) = a-2b
```

`f()` 와 `f(1,2)` 의 결과는 `-3` 입니다. 즉, 선택적 인수는 해당함수의 특정메서드가 아닌 함수에 연결됩니다.
그것은 메소드가 불려지는 옵션 인수의 형태에 의존합니다.
선택적 인수가 전역 변수로 정의되면 선택적 인수의 유형이 런타임에 변경 될 수도 있습니다.


키워드 인수는 일반적인 위치 인수와는 상당히 다르게 작동합니다.
특히, 메소드 디스패치에 참여하지 않습니다.
메소드는 일치하는 메소드가 식별 된 후에 처리되는 키워드 인수를 가진 위치인수에 기반하여 발송됩니다.

## 함수같은 객체

메서드는 형식과 관련이 있으므로 형식에 메서드를 추가하여 임의의 Julia 개체를 "호출가능" 하게 만들 수 있습니다. (이러한 "호출가능"한 객체를 "functors"라고합니다.)

예를 들어 다항식의 계수를 저장하는 유형을 정의 할 수 있습니다.
다항식을 계산하는 함수 :

```jldoctest polynomial
julia> struct Polynomial{R}
           coeffs::Vector{R}
       end

julia> function (p::Polynomial)(x)
           v = p.coeffs[end]
           for i = (length(p.coeffs)-1):-1:1
               v = v*x + p.coeffs[i]
           end
           return v
       end
```

함수는 이름 대신 형식으로 지정됩니다. 함수 본문에서 `p` 는 호출 된 객체를 나타냅니다. `다항식` 은 다음과 같이 사용할 수 있습니다.

```jldoctest polynomial
julia> p = Polynomial([1,10,100])
Polynomial{Int64}([1, 10, 100])

julia> p(3)
931
```


이 메카니즘은 타입 생성자와 클로저 (주변 환경을 참조하는 내부 함수)가 Julia에서 어떻게 작동 하는지를 결정하는 열쇠이기도합니다.
[나중에이 매뉴얼에서 설명합니다](@ref constructors-and-conversion).

## 빈 일반 함수

때때로 메소드를 추가하지 않고 일반함수를 도입하는 것이 유용하기도 합니다. 이것은 인터페이스 정의와 구현을 분리하는데 사용할 수 있습니다.
문서화 또는 코드가독성을 위해 수행 될 수도 있습니다.
이를위한 문법은 인자의 튜플이없는 빈`function` 블록입니다 :

```julia
function emptyfunc
end
```

## [방법 설계 및 모호한 방지](@id man-method-design-ambiguities)

Julia의 방법 다형성은 가장 강력한 기능 중 하나이지만,이 힘을 이용하는 것은 설계상의 어려움을 야기 할 수 있습니다.
특히,보다 복잡한 메소드 계층 구조에서는 [모호성 (ambiguities)](@ ref man-ambiguities) 이 발생하는 경우는 드뭅니다.
위에서, 모호성을 해결할 수 있다고 지적했었습니다.

```julia
f(x, y::Int) = 1
f(x::Int, y) = 2
```

메소드를 정의함으로서

```julia
f(x::Int, y::Int) = 3
```

이것은 종종 올바른 전략일수 있습니다. 그러나이 조언을 맹목적으로 따르는 것이 비생산적일 수 있는 상황이 있습니다.
특히, 일반 함수의 메서드가 많을수록 모호성 가능성이 커집니다. 메소드 계층구조가 간단한 예제보다 복잡해지면 대체 전략에 대해 신중하게 생각하는 것이 가치가 있습니다.
아래에서는 특정 문제와 이러한 문제를 해결할 수있는 몇 가지 대안을 논의합니다.

### 튜플 및 NTuple 인수

`Tuple` (그리고 `NTuple`) 인자는 특별한 도전을 제시합니다. 예를 들어,

```julia
f(x::NTuple{N,Int}) where {N} = 1
f(x::NTuple{N,Float64}) where {N} = 2
```

`N==0`일 가능성 때문에 모호하다면 :`Int` 나 `Float64` 변형이 호출되어야 하는지를 결정하는 요소가 없습니다.
모호성을 해결하기 위해 한 가지 방법은 빈 튜플에 대한 메서드를 정의하는 것입니다.

```julia
f(x::Tuple{}) = 3
```

또는 하나의 메소드를 제외한 모든 메소드에 대해 적어도 하나의 요소가 튜플에 있다고 주장 할 수 있습니다.

```julia
f(x::NTuple{N,Int}) where {N} = 1           # 이것은 대체품입니다.
f(x::Tuple{Float64, Vararg{Float64}}) = 2   # 적어도 하나의 Float64가 필요합니다.
```

### [디자인 직교화](@id man-methods-orthogonalize)

이상의 인수를 디스패치하려는 상황일 때 "wrapper"기능이 보다 단순한 설계를 할 수 있는지 고려해야합니다.
예를 들어 여러 변형을 작성하는 대신에 :

```julia
f(x::A, y::A) = ...
f(x::A, y::B) = ...
f(x::B, y::A) = ...
f(x::B, y::B) = ...
```

정의하는 것을 고려할 수 있습니다.

```julia
f(x::A, y::A) = ...
f(x, y) = f(g(x), g(y))
```

where `g` converts the argument to type `A`. This is a very specific
example of the more general principle of
[orthogonal design](https://en.wikipedia.org/wiki/Orthogonality_(programming)),
in which separate concepts are assigned to separate methods. Here, `g`
will most likely need a fallback definition
여기서 `g` 는 인수를 타입 A로 변환합니다.
이것은 별도의 개념이 별도의 방법으로 할당 된 [직교 설계](https://en.wikipedia.org/wiki/Orthogonality_ (프로그래밍))의 보다 일반적인 매우 구체적인 예입니다.
여기서 `g` 는 대개 대체 정의를 요구합니다.
```julia
g(x::A) = x
```


A related strategy은 `x`와`y`를 일반적인 유형으로 유도하기 위해 `promote` 을 이용합니다 :

```julia
f(x::T, y::T) where {T} = ...
f(x, y) = f(promote(x, y)...)
```

이 디자인의 한 가지 위험은 `x` 와 `y` 를 같은 유형으로 변환하는 적절한 프로모션 방법이 없으면 두 번째 방법이 무한히 반복되어 스택 오버플로가 트리거 될 수 있다는 것입니다.
exported 안된 함수 `Base.promote_noncircular` 는 대안으로 사용할 수 있습니다. 프로모션이 실패하면 여전히 오류가 발생하지만 더 구체적인 오류 메시지로 인해 더 빨리 오류가 발생합니다.

### 한 번에 하나의 인수로 디스패치

If you need to dispatch on multiple arguments, and there are many
fallbacks with too many combinations to make it practical to define
all possible variants, then consider introducing a "name cascade"
where (for example) you dispatch on the first argument and then call
an internal method:

여러 인수를 전달해야하거나 가능한 많은 변형을 정의하기 위해 너무 많은 조합을 사용하는 많은 대체 시스템이있는 경우에는
"name cascade"를 도입하여 (예를 들어) 첫 번째 인수로 전달한 다음 내부 메소드를 호출하는 것을 고려하십시오.

```julia
f(x::A, y) = _fA(x, y)
f(x::B, y) = _fB(x, y)
```

그러면 내부 메소드 `_fA` 와 `_fB` 는 `x` 에 대해 서로 모호한 점을 고려하지 않고 `y` 에 디스패치 할 수 있습니다.

이 전략에는 최소 하나이상의 주요한 단점이 있습니다 : 많은 경우, 사용자가 exported한 함수 `f` 의 추가 특수화를 정의하여 `f` 의 동작을 추가로 사용자정의 할 수 없습니다.
대신, 내부 메소드 `_fA` 와 `_fB` 에 대한 전문화를 정의해야하며, 이는 exported한 메소드와 exported한 메소드 사이의 줄을 흐리게 만듭니다.

### 추상 컨테이너 및 요소 유형

가능한, 파견하는 방법을 정의하지 않도록하십시오.
추상 컨테이너의 특정 요소 유형은 예를 들어,

```julia
-(A::AbstractArray{T}, b::Date) where {T<:Date}
```

메소드를 정의할 누군가를 위해 모호한 메소드를 정의합니다.

```julia
-(A::MyArrayType{T}, b::T) where {T}
```

가장 좋은 방법은 다음중 하나의 방법을 정의하는 것을 피하는 것입니다.
대신, 일반적인 메소드`- A::AbstractArray, b)` 이 메소드가 각 컨테이너 유형과 요소 유형에 대해 올바른 작업을 수행하는 일반 호출(예 :`similar` and `-`)로 구현되었는지 확인하십시오. 이것은 당신의 메소드를 [직교 화](@ ref man-methods-orthogonalize) 하는 조언의 좀 더 복잡한 변형입니다.


이 접근법이 가능하지 않을 때 모호성을 해결하는 것에 대해 다른 개발자와 토론을 시작하는 것이 좋습니다. 처음에 하나의 방법이 정의되었다고해서 그것이 반드시 수정되거나 제거 될 수 없다는 것을 의미하지는 않습니다. 최후의 수단으로 한 개발자는 "반창고"방법을 정의 할 수 있습니다

```julia
-(A::MyArrayType{T}, b::Date) where {T<:Date} = ...
```

그것은 무차별한 힘에 의한 모호성을 해결합니다.

### 복잡한 인수 "cascades"와 기본 인수

기본값을 제공하는 "cascades"메서드를 정의하는 경우 잠재적 기본값에 해당하는 인수를 삭제하는 데 주의해야합니다.
 예를 들어, 디지털 필터링 알고리즘을 작성 중이며 패딩을 적용하여 신호의 가장자리를 처리하는 방법이 있다고 가정합니다. :

```julia
function myfilter(A, kernel, ::Replicate)
    Apadded = replicate_edges(A, size(kernel))
    myfilter(Apadded, kernel)  # 이제 "실제"계산을 수행하십시오.
end
```

이것은 디폴트 패딩을 제공하는 메소드와 충돌 할 것이다. :

```julia
myfilter(A, kernel) = myfilter(A, kernel, Replicate()) # replicate the edge by default
```

이 두 가지 방법은 A가 계속 커지면서 무한 재귀를 생성합니다.

더 나은 디자인은 다음과 같이 호출 계층 구조를 정의하는 것입니다.

```julia
struct NoPad end  # 패딩이 필요하지 않거나 이미 적용되었음을 나타냅니다.

myfilter(A, kernel) = myfilter(A, kernel, Replicate())  # 기본 경계 조건

function myfilter(A, kernel, ::Replicate)
    Apadded = replicate_edges(A, size(kernel))
    myfilter(Apadded, kernel, NoPad())  # 새로운 경계 조건을 나타냅니다.
end

# 다른 패딩 방법은 여기에 있습니다.

function myfilter(A, kernel, ::NoPad)
    # 다음은 핵심 계산의 "실제"구현입니다.
end
```

`NoPad` is supplied in the same argument position as any other kind of
padding, so it keeps the dispatch hierarchy well organized and with
reduced likelihood of ambiguities. Moreover, it extends the "public"
`myfilter` interface: a user who wants to control the padding
explicitly can call the `NoPad` variant directly.

`NoPad`는 다른 종류의 패딩과 같은 인수 위치에서 제공되기 때문에, 디스패치 계층을 잘 정리하고 애매하게 만들 가능성이 낮습니다.
또한, "public" `myfilter` 인터페이스를 확장합니다. 패딩을 명시 적으로 제어하려는 사용자는 `NoPad` 변형을 직접 호출 할 수 있습니다.

[^Clarke61]: Arthur C. Clarke, *Profiles of the Future* (1961): Clarke's Third Law.
