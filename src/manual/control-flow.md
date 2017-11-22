# Control Flow

Julia는 다양한 제어 흐름 구조를 제공합니다.

  * 복합 표현: `begin` 및 `(;)`.
  * 조건부 평가: `if`-`elseif`-`else` 및 `?:` (삼항 연산자).
  * 단락 평가: `&&`, `||` 및 연속 비교문.
  * 반복 평가: 루프: `while` 및 `for`.
  * 예외 처리: `try`-`catch`, `error` 및 `throw`.
  * Tasks (aka Coroutines): `yieldto`.

처음 5개의 제어 흐름 메커니즘은 고급 프로그래밍 언어의 표준입니다. 하지만 `태스크`는 그렇지 않습니다. 태스크는 비지역적 제어 흐름을 제공하여, 일시적으로 중단된 계산을 바꾸는 것을 가능하게 만듭니다. 태스크는 강력한 구조입니다: Julia는 예외 처리 및 협력적 멀티태스킹 모두를 태스크를 사용하여 구현합니다. 일상적인 프로그래밍에서는 태스크를 사용할 필요가 없지만, 몇몇 문제는 태스크를 사용함으로써 더 쉽게 해결될 수 있습니다.

## 복합 표현

때로는 여러 하위식을 순서대로 평가하는 단 하나의 식이 더 편리하며, 이 경우 마지막 하위식의 값을 그 값으로 반환하게 됩니다. 이를 수행하는 두 개의 Julia 구조가 있습니다: 바로 `begin` 구문과 `(;)` 체인 구문입니다. 두 복합 표현 구조의 값은 마지막 하위식의 값입니다. 다음은 `begin` 구문의 예제입니다.

```jldoctest
julia> z = begin
           x = 1
           y = 2
           x + y
       end
3
```

위와 같이 식의 길이가 매우 짧고 단순하다면, 유용한 `(;)` 체인 구문을 사용해 한 줄로 쉽게 표현할 수 있습니다.

```jldoctest
julia> z = (x = 1; y = 2; x + y)
3
```

이 구문은 함수 문서에 소개된 간결한 단일 행 함수를 정의할 때 특히 유용합니다. 전형적인 구문처럼 보이겠지만, `begin` 블록 내부가 여러 줄일 필요도 없고, `(;)` 체인이 전부 한 줄에서 이루어질 필요도 없습니다.

```jldoctest
julia> begin x = 1; y = 2; x + y end
3

julia> (x = 1;
        y = 2;
        x + y)
3
```

## 조건부 평가

조건부 평가는 논리식의 값에 따라 일부 코드의 실행 여부를 결정합니다. 다음은 `if`-`elseif`-`else` 조건 구문의 구조입니다.

```julia
if x < y
    println("x is less than y")
elseif x > y
    println("x is greater than y")
else
    println("x is equal to y")
end
```

조건식 `x < y`가 `true`이면 해당 블록이 실행됩니다. 참이 아니라면, 조건식 `x > y`를 평가하고 `true`이면 해당 블록이 실행됩니다. 만약 두 표현 둘 다 참이 아니라면, `else` 블록이 실행됩니다. 다음은 실행 예제입니다.

```jldoctest
julia> function test(x, y)
           if x < y
               println("x is less than y")
           elseif x > y
               println("x is greater than y")
           else
               println("x is equal to y")
           end
       end
test (generic function with 1 method)

julia> test(1, 2)
x is less than y

julia> test(2, 1)
x is greater than y

julia> test(1, 1)
x is equal to y
```

`elseif`와 `else` 블록은 선택 사항이며, 원하는 만큼 많은 `elseif` 블록을 사용할 수 있습니다. `if`-`elseif`-`else` 구문 안의 조건식은 어느 한 식이 처음으로 `true`로 평가될 때까지 평가되고, 그 후에 관련 블록이 실행되며, 이후로는 어떤 식이나 블록도 실행되지 않습니다.

`if` 블록은 지역 범위를 만들지 않기 때문에 한 마디로 "구멍이 났다"고 할 수 있습니다. 이는 `if` 절 안에서 정의된 새로운 변수가 `if` 블록 다음에도 사용될 수 있음을 의미합니다. 따라서, 위에서 정의한 `test` 함수를 다음과 같이 정의할 수도 있습니다.

```jldoctest
julia> function test(x,y)
           if x < y
               relation = "less than"
           elseif x == y
               relation = "equal to"
           else
               relation = "greater than"
           end
           println("x is ", relation, " y.")
       end
test (generic function with 1 method)

julia> test(2, 1)
x is greater than y.
```

`relation` 변수는 `if` 블록 안에서 선언되었지만, 블록 밖에서 사용되고 있습니다. 그러나, 모든 코드 경로가 이 구문을 통해 변수 값을 정의할 수 있는지 확인해야 합니다. 위 함수를 다음과 같이 변경하면 런타임 오류가 발생합니다.

```jldoctest
julia> function test(x,y)
           if x < y
               relation = "less than"
           elseif x == y
               relation = "equal to"
           end
           println("x is ", relation, " y.")
       end
test (generic function with 1 method)

julia> test(1,2)
x is less than y.

julia> test(2,1)
ERROR: UndefVarError: relation not defined
Stacktrace:
 [1] test(::Int64, ::Int64) at ./none:7
```

`if` 블록도 값을 반환하기 때문에 다른 많은 언어에서 오는 사용자에게는 어색해 보일 수 있습니다. 이 값은 단순히 선택한 분기에서 마지막으로 실행한 명령문의 반환값이며, 따라서

```jldoctest
julia> x = 3
3

julia> if x > 0
           "positive!"
       else
           "negative..."
       end
"positive!"
```

아주 짧은(한 줄로 된) 조건문은 다음 절에 설명되었듯이 Julia의 단락 회로 평가를 통해 자주 표현된다는 것을 유념하시기 바랍니다.

C, MATLAB, Perl, Python, Ruby와는 다르게 조건식의 값이 `true`나 `false`가 아니면 오류가 발생하며, 이는 Java와 같이 자료형을 엄격하게 다루는 언어와 비슷하다고 할 수 있습니다.

```jldoctest
julia> if 1
           println("true")
       end
ERROR: TypeError: non-boolean (Int64) used in boolean context
```

이 오류는 조건부에 잘못된 자료형을 넣었음을 나타냅니다. `Int64`형 대신 `Bool`형이 들어가야 하죠.

소위 "삼항 연산자"라고 불리는 `?:`는 `if`-`elseif`-`else` 구문과 밀접한 관련이 있습니다. 후자가 긴 코드 블록의 조건 실행에 사용되는 것과 달리, 전자는 단일식에서의 조건부 선택이 필요한 곳에서 사용됩니다. 이 연산자는 대부분의 다른 언어에서도 피연산자 셋을 취하는 유일한 연산자라는 칭호를 얻었습니다.

```julia
a ? b : c
```

`?` 앞의 `a`는 조건식이고, 삼항 연산자는 `a`가 `true`이면 `:` 앞의 `b`를, `false`이면 `:` 뒤의 `c`를 실행합니다. 여기서 `?`와 `:` 주위에는 공백이 있어야 함을 명심하십시오. `a?b:c`와 같은 식은 유효하지 않은 식입니다.(다만 `?`와 `:` 각각의 뒤에 개행 문자는 사용 가능)

이 동작을 이해하는 가장 쉬운 방법은 예제를 보는 것입니다. 이전 예제에서 `println` 호출은 세 브랜치 모두에서 공유되었습니다. 실제로 고른 것은 오직 출력할 리터럴 문자열이었습니다. 이제 삼항 연산자를 사용하여 보다 간결하게 예제를 작성할 수 있습니다. 명확히 하기 위해, 먼저 둘 중 하나를 고르는 버전을 사용해 봅시다.

```jldoctest
julia> x = 1; y = 2;

julia> println(x < y ? "less than" : "not less than")
less than

julia> x = 1; y = 0;

julia> println(x < y ? "less than" : "not less than")
not less than
```

`x < y` 식이 참이면, 전체 삼항 연산자 식은 `"미만"` 문자열을 평가하고, 거짓이면 `"이상"` 문자열을 평가할 것입니다. 기존의 셋 중 하나를 고르는 예제를 구현하려면 삼항 연산자를 여러 번 사용하여 중첩할 필요가 있습니다.

```jldoctest
julia> test(x, y) = println(x < y ? "x is less than y"    :
                            x > y ? "x is greater than y" : "x is equal to y")
test (generic function with 1 method)

julia> test(1, 2)
x is less than y

julia> test(2, 1)
x is greater than y

julia> test(1, 1)
x is equal to y
```

연결을 쉽게 하기 위해 연산자는 오른쪽에서 왼쪽으로 연결됩니다.

`if`-`elseif`-`else`와 같이 조건식이 각각 `true`나 `false`로 평가될 때만 `:` 앞뒤로 있는 식이 평가된다는 점 역시 중요합니다.

```jldoctest
julia> v(x) = (println(x); x)
v (generic function with 1 method)

julia> 1 < 2 ? v("yes") : v("no")
yes
"yes"

julia> 1 > 2 ? v("yes") : v("no")
no
"no"
```

## 단락 평가

단락 평가는 조건부 평가와 상당히 유사합니다. 이 동작은 `&&` 및 `||` 연산자가 있는 대부분의 명령형 프로그래밍 언어에서 찾을 수 있습니다. 이런 연산자로 연결된 일련의 표현식에서, 최종 논리값을 결정하는 데 필요한 최소 식만 평가됩니다. 명쾌하게 말하자면, 이는 다음을 의미합니다.

  * 표현식 `a && b`에서, 하위 표현식 `b`는 오직 `a`가 `true`로 평가될 때만 평가를 받는다.
  * 표현식 `a || b`에서, 하위 표현식 `b`는 오직 `a`가 `false`로 평가될 때만 평가를 받는다.

왜냐 하면, `a`가 `false`이면, `b`의 값에 관계없이 `a && b`는 무조건 `false`가 되고, `a`가 `true`이면, `b`의 값에 관계없이 `a && b`는 무조건 `true`가 되기 때문입니다. `&&`와 `||` 모두 오른쪽에 연관되지만, `&&`가 `||`보다 우선 순위가 더 높습니다. 실험해 보면 동작을 이해하기 쉽습니다.

```jldoctest tandf
julia> t(x) = (println(x); true)
t (generic function with 1 method)

julia> f(x) = (println(x); false)
f (generic function with 1 method)

julia> t(1) && t(2)
1
2
true

julia> t(1) && f(2)
1
2
false

julia> f(1) && t(2)
1
false

julia> f(1) && f(2)
1
false

julia> t(1) || t(2)
1
true

julia> t(1) || f(2)
1
true

julia> f(1) || t(2)
1
2
true

julia> f(1) || f(2)
1
2
false
```

`&&` 및 `||` 연산자의 다양한 조합의 연관성과 우선 순위를 통해 같은 방식으로 쉽게 실험할 수 있습니다.

이 동작은 Julia에서 매우 짧은 `if` 문의 대용으로 자주 사용됩니다. `if <조건> <문장> end` 대신에, `<조건>` 그리고 나서 `<문장>`이라고 읽을 수 있는 `<조건> && <문장>`을 쓸 수 있습니다. 비슷하게, `if ! <조건> <문장> end` 대신에, `<조건>` 아니면 `<문장>`이라고 읽을 수 있는 `<조건> || <문장>`을 쓸 수 있습니다.

예제로 재귀적 팩토리얼 함수를 다음과 같이 선언할 수 있습니다.

```jldoctest
julia> function fact(n::Int)
           n >= 0 || error("n must be non-negative")
           n == 0 && return 1
           n * fact(n-1)
       end
fact (generic function with 1 method)

julia> fact(5)
120

julia> fact(0)
1

julia> fact(-1)
ERROR: n must be non-negative
Stacktrace:
 [1] fact(::Int64) at ./none:2
```

Mathematical Operations and Elementary Functions: `&` 및 `|`에서 소개한 비트 논리 연산자로 단락 평가가 없는 논리 연산을 할 수 있습니다. 그것들은 이항연산자 구문을 지원하지만, 항상 인수를 평가하는 일반적인 함수라고 할 수 있습니다.

```jldoctest tandf
julia> f(1) & t(2)
1
2
false

julia> t(1) | t(2)
1
2
true
```

`if`, `elseif` 또는 삼항 연산자에서 사용되는 조건식과 마찬가지로, `&&`나 `||` 역시 피연산자가 논리값(`true` 또는 `false`)을 가져야 합니다. 조건부 체인의 가장 마지막 항목을 제외하고는 어디에도 비논리값을 사용하면 오류가 발생합니다.

```jldoctest
julia> 1 && true
ERROR: TypeError: non-boolean (Int64) used in boolean context
```

반면에 조건부 체인 끝에는 어떤 표현식이든 사용할 수 있습니다. 이는 선행 조건에 따라 평가되고 반환될 것이기 때문입니다.

```jldoctest
julia> true && (x = (1, 2, 3))
(1, 2, 3)

julia> false && (x = (1, 2, 3))
false
```

## 반복 평가: 루프

반복 평가식에는 두 구문이 있습니다. 바로 `while` 루프와 `for` 루프입니다. 다음은 `while` 루프의 예제입니다.

```jldoctest
julia> i = 1;

julia> while i <= 5
           println(i)
           i += 1
       end
1
2
3
4
5
```

`while` 루프는 조건식(여기서는 `i <= 5`)을 평가하여, `true`가 아닐 때까지 내내 `while` 루프를 반복하여 실행합니다. `while` 루프에 도착했을 때, 조건식이 `false`이면 루프를 실행하지 않습니다.

`for` 루프는 평범한 반복 평가문을 작성하기 쉽게 만들어 줍니다. 위의 `while` 루프와 같이 위아래로 세는 것이 일반적이므로 `for` 루프를 통해 보다 간결하게 표현할 수 있습니다.

```jldoctest
julia> for i = 1:5
           println(i)
       end
1
2
3
4
5
```

여기에서 `1:5`는 범위 객체이며 숫자 1, 2, 3, 4, 5의 순서를 나타냅니다. `for` 루프는 이 값들을 반복하며, 각 수들을 차례로 변수 `i`에 할당합니다. 앞의 `while` 루프 형식과 `for` 루프 형식의 중요한 차이점 중 하나는 바로 변수가 표시되는 범위입니다. 만약 변수 `i`가 다른 영역에서 선언되지 않았다면, `for` 루프 형식에서는 `for` 루프 내부에서만 볼 수 있고, 루프 외부나 루프 종료 이후로는 볼 수 없습니다. 이를 테스트하려면 새로운 대화형 세션 인스턴스나 다른 변수 이름이 필요할 겁니다.

```jldoctest
julia> for j = 1:5
           println(j)
       end
1
2
3
4
5

julia> j
ERROR: UndefVarError: j not defined
```

변수 범위에 관한 자세한 설명과 그것이 Julia에서 어떻게 작동하는지는 Scope of Variables 문서를 통해 확인하십시오.

일반적으로, `for` 루프 구조는 어떤 컨테이너든 반복할 수 있습니다. 이 경우, 코드의 더 명확한 가독성을 위해 `=` 대신 일반적으로 `in`이나 `∈`가 대용(그러나 완전히 동등한) 키워드로 사용됩니다.

```jldoctest
julia> for i in [1,4,0]
           println(i)
       end
1
4
0

julia> for s ∈ ["foo","bar","baz"]
           println(s)
       end
foo
bar
baz
```

다양한 유형의 반복 가능한 컨테이너가 매뉴얼 뒷부분(예: Multi-dimensional Arrays 문서 참조)에서 소개되고 논의될 것입니다.

테스트 조건이 위조되기 전에 `while` 반복을 종료하거나, 반복용 변수가 끝에 도달하기 전에 `for` 루프를 멈추는 것이 편리할 때가 있습니다. 이는 `break` 키워드로 수행할 수 있습니다.

```jldoctest
julia> i = 1;

julia> while true
           println(i)
           if i >= 5
               break
           end
           i += 1
       end
1
2
3
4
5

julia> for j = 1:1000
           println(j)
           if j >= 5
               break
           end
       end
1
2
3
4
5
```

`break` 키워드 없이는 `while` 루프는 절대 스스로 종료되지 않을 것이며, `for` 루프는 1000까지 세고 말 것입니다. 이 루프 모두 `break`를 사용하여 빠져나갈 수 있습니다.

다른 상황에서는 반복을 중지하고 즉시 다음 단계로 넘어가는 것이 더 유용할 수 있습니다. `continue` 키워드는 다음을 수행합니다.

```jldoctest
julia> for i = 1:10
           if i % 3 != 0
               continue
           end
           println(i)
       end
3
6
9
```

이는 조건을 무효화하고 조건을 무효화하고 `println` 호출을 `if` 블록 안에 두어 더 똑같은 동작을 명확하게 나타낼 수 있기 때문에 다소 고안된 예제입니다. 실제 코드에서는 `continue` 뒤에 평가할 코드가 더 많을 것이며, 종종 `continue`가 여러 번 사용될 수도 있습니다.

다중 중첩 `for` 루프는 하나의 외부 루프로 결합되어, 반복용 변수의 데카르트 곱을 형성합니다.

```jldoctest
julia> for i = 1:2, j = 3:4
           println((i, j))
       end
(1, 3)
(1, 4)
(2, 3)
(2, 4)
```

이러한 루프 내부의 `break`문은 내부의 루프 하나만을 종료하는 것이 아닌, 루프 전체를 종료합니다.

## 예외 처리

예기치 않은 조건이 발생하면 함수가 호출자에게 적절한 값을 반환하지 못할 수 있습니다. 이런 경우에는 예외적인 조건에서 진단 오류 메시지를 출력하는 동안 프로그램을 종료하는 것이 좋을 수도 있지만, 프로그래머가 예외적인 상황을 처리하는 코드를 제공한 경우 해당 코드가 적절한 조치를 취하도록 하는 것이 최선의 방법입니다.

### 기본 제공 '예외'

예기치 않은 조건이 일어나면 `Exception`이 발생합니다. 아래에 나열된 기본 제공 `Exception`은 모두 정상적인 제어 흐름을 방해합니다.

| `Exception`                   |
|:----------------------------- |
| [`ArgumentError`](@ref)       |
| [`BoundsError`](@ref)         |
| `CompositeException`          |
| [`DivideError`](@ref)         |
| [`DomainError`](@ref)         |
| [`EOFError`](@ref)            |
| [`ErrorException`](@ref)      |
| [`InexactError`](@ref)        |
| [`InitError`](@ref)           |
| [`InterruptException`](@ref)  |
| `InvalidStateException`       |
| [`KeyError`](@ref)            |
| [`LoadError`](@ref)           |
| [`OutOfMemoryError`](@ref)    |
| [`ReadOnlyMemoryError`](@ref) |
| [`RemoteException`](@ref)     |
| [`MethodError`](@ref)         |
| [`OverflowError`](@ref)       |
| [`ParseError`](@ref)          |
| [`SystemError`](@ref)         |
| [`TypeError`](@ref)           |
| [`UndefRefError`](@ref)       |
| [`UndefVarError`](@ref)       |
| `UnicodeError`                |

예를 들어, 음의 실수 값에 적용된 `sqrt` 함수는 `DomainError`를 throw합니다.

```jldoctest
julia> sqrt(-1)
ERROR: DomainError with -1.0:
sqrt will only return a complex result if called with a complex argument. Try sqrt(Complex(x)).
Stacktrace:
[...]
```

다음과 같은 방법으로 사용자 정의 예외를 직접 만들 수 있습니다.

```jldoctest
julia> struct MyCustomException <: Exception end
```

### `throw` 함수

예외는 `throw`를 사용하여 명시적으로 만들 수 있습니다. 예를 들어, 인수가 음수이면 인수가 음수가 아닌 숫자로만 정의된 함수를 작성하여 `DomainError`를 `throw`할 수 있습니다.

```jldoctest
julia> f(x) = x>=0 ? exp(-x) : throw(DomainError(x, "argument must be nonnegative"))
f (generic function with 1 method)

julia> f(1)
0.36787944117144233

julia> f(-1)
ERROR: DomainError with -1:
argument must be nonnegative
Stacktrace:
 [1] f(::Int64) at ./none:1
```

괄호가 없는 `DomainError`는 예외가 아니라 예외 유형임을 기억하십시오. `Exception` 객체를 얻으려면 호출해야 합니다.

```jldoctest
julia> typeof(DomainError(nothing)) <: Exception
true

julia> typeof(DomainError) <: Exception
false
```

또한 일부 예외 유형은 오류 보고에 사용되는 하나 이상의 인수를 필요로 합니다.

```jldoctest
julia> throw(UndefVarError(:x))
ERROR: UndefVarError: x not defined
```

이 메커니즘은 `UndefVarError`가 쓰여지는 방식에 따라 사용자 정의 예외 유형에 의해 쉽게 구현될 수 있습니다.

```jldoctest
julia> struct MyUndefVarError <: Exception
           var::Symbol
       end

julia> Base.showerror(io::IO, e::MyUndefVarError) = print(io, e.var, " not defined")
```

!!! 주의
    오류 메시지를 작성할 때 첫 번째 단어를 소문자로 만드는 것이 좋습니다. 예를 들어,
    `size(A) == size(B) || throw(DimensionMismatch("size of A not equal to size of B"))`

    가 아래보다 선호됩니다.

    `size(A) == size(B) || throw(DimensionMismatch("Size of A not equal to size of B"))`.

    하지만 때로는 대문자의 첫 번째 문자는 그대로 두는 것이 좋은데, 예를 들어 함수의 인수가 대문자일 경우입니다. `size(A,1) == size(B,2) || throw(DimensionMismatch("A has first dimension..."))`.

### 오류

`error` 함수는 정상적인 제어 흐름을 방해하는 `ErrorException`을 생성하는 데 사용됩니다.

음수의 제곱근을 취하면 즉시 실행을 멈추고 싶다고 합시다. 이것을 하기 위해 인수가 음수이면 오류가 발생하는 `sqrt` 함수의 까다로운 버전을 정의할 수 있습니다.

```jldoctest fussy_sqrt
julia> fussy_sqrt(x) = x >= 0 ? sqrt(x) : error("negative x not allowed")
fussy_sqrt (generic function with 1 method)

julia> fussy_sqrt(2)
1.4142135623730951

julia> fussy_sqrt(-1)
ERROR: negative x not allowed
Stacktrace:
 [1] fussy_sqrt(::Int64) at ./none:1
```

`fussy_sqrt`가 호출 함수의 실행을 계속하려 하는 것이 아니라 다른 함수에서 음수 값으로 호출되면, 즉시 반환되어 대화식 세션에 오류 메시지를 표시합니다.

```jldoctest fussy_sqrt
julia> function verbose_fussy_sqrt(x)
           println("before fussy_sqrt")
           r = fussy_sqrt(x)
           println("after fussy_sqrt")
           return r
       end
verbose_fussy_sqrt (generic function with 1 method)

julia> verbose_fussy_sqrt(2)
before fussy_sqrt
after fussy_sqrt
1.4142135623730951

julia> verbose_fussy_sqrt(-1)
before fussy_sqrt
ERROR: negative x not allowed
Stacktrace:
 [1] fussy_sqrt at ./none:1 [inlined]
 [2] verbose_fussy_sqrt(::Int64) at ./none:3
```

### 경고 및 정보 메시지

또한 Julia는 표준 오류 입출력에 메시지를 쓰지만 `Exception`을 throw하지도 않고, 때문에 실행을 중단하지도 않는 다른 함수를 제공합니다.

```jldoctest
julia> info("Hi"); 1+1
INFO: Hi
2

julia> warn("Hi"); 1+1
WARNING: Hi
2

julia> error("Hi"); 1+1
ERROR: Hi
Stacktrace:
 [1] error(::String) at ./error.jl:33
```

### `try/catch`문

`try/catch`문은 `Exception`을 테스트할 수 있습니다. 예를 들어, 사용자 정의 제곱근 함수를 `Exception`을 사용하여 필요에 따라 실수 또는 복소수 제곱근 방법을 자동으로 호출하도록 작성할 수 있습니다.

```jldoctest
julia> f(x) = try
           sqrt(x)
       catch
           sqrt(complex(x, 0))
       end
f (generic function with 1 method)

julia> f(1)
1.0

julia> f(-1)
0.0 + 1.0im
```

이 함수를 계산하는 실제 코드에서는 예외를 잡는 대신 `x`와 0을 비교한다는 점에 유의해야 합니다. 단순히 비교하고 분기하는 것보다 예외는 훨씬 느립니다.

또한 `try/catch`문은 `Exception`이 변수에 저장되도록 합니다. 이 고안된 예제에서, 다음 예제는 `x`가 색인 가능한 경우 `x`의 두 번째 요소의 제곱근을 계산하고, 그렇지 않으면 `x`가 실수임을 가정하고 제곱근을 반환합니다.

```jldoctest
julia> sqrt_second(x) = try
           sqrt(x[2])
       catch y
           if isa(y, DomainError)
               sqrt(complex(x[2], 0))
           elseif isa(y, BoundsError)
               sqrt(x)
           end
       end
sqrt_second (generic function with 1 method)

julia> sqrt_second([1 4])
2.0

julia> sqrt_second([1 -4])
0.0 + 2.0im

julia> sqrt_second(9)
3.0

julia> sqrt_second(-9)
ERROR: DomainError with -9.0:
sqrt will only return a complex result if called with a complex argument. Try sqrt(Complex(x)).
Stacktrace:
[...]
```

`catch` 다음의 기호는 항상 예외 이름으로 해석될 것이고, 때문에 한 줄로 `try/catch`문을 작성할 때 주의해야 합니다. 다음 코드는 오류가 발생하더라도 `x`의 값을 반환하지 않습니다.

```julia
try bad() catch x end
```

대신 세미콜론을 사용하거나 `catch` 다음에 개행 문자를 삽입하십시오.

```julia
try bad() catch; x end

try bad()
catch
    x
end
```

`catch`절은 꼭 필요한 것은 아닙니다. 생략한다면 기본 반환값은 `nothing`입니다.

```jldoctest
julia> try error() end # Returns nothing
```

`try/catch`문의 장점은 호출 함수의 스택에서 훨씬 더 높은 레벨로 깊게 중첩된 계산을 즉시 풀 수 있는 능력에 있습니다. 오류가 발생하지 않은 상황이 있지만 스택을 풀어 더 높은 레벨로 값을 전달하는 것이 바람직합니다. Julia는 고급 오류 처리를 위해 `rethrow`, `backtrace`, `catch_backtrace`와 같은 함수들을 제공합니다.

### `finally`문

상태 변경을 수행하거나 파일과 같은 리소스를 사용하는 코드에서는 일반적으로 코드가 끝났을 때 수행해야 하는 정리 작업(예: 파일 닫기)이 있습니다. 예외는 이 작업을 어쩌면 복잡하게 만들 수 있습니다. 왜냐하면 코드 블록이 정상적으로 끝나기 전에 종료될 수 있기 때문입니다. `finally` 키워드는 주어진 코드 블록의 종료가 정상 유무를 가리지 않고 특정 코드를 실행하게 해줍니다.

예를 들면, 열린 파일을 확실히 닫을 수 있는 방법은 다음과 같습니다.

```julia
f = open("file")
try
    # operate on file f
finally
    close(f)
end
```

제어가 `try` 블록을 떠날 때(`return` 때문에 끝나든, 정상적으로 끝나든) `close(f)`가 실행됩니다. 만약 여기서 `try` 블록이 예외로 인해 종료되면 예외는 계속 증식할 것입니다. `catch` 블록은 `try` 및 `finally`와 결합할 수 있으므로, 이 상황에서는 `catch`가 오류를 처리한 후에 `finally`문이 실행되면 좋을 것입니다.

## [Tasks (aka Coroutines)](@id man-tasks)

Tasks are a control flow feature that allows computations to be suspended and resumed in a flexible
manner. This feature is sometimes called by other names, such as symmetric coroutines, lightweight
threads, cooperative multitasking, or one-shot continuations.

When a piece of computing work (in practice, executing a particular function) is designated as
a [`Task`](@ref), it becomes possible to interrupt it by switching to another [`Task`](@ref).
The original [`Task`](@ref) can later be resumed, at which point it will pick up right where it
left off. At first, this may seem similar to a function call. However there are two key differences.
First, switching tasks does not use any space, so any number of task switches can occur without
consuming the call stack. Second, switching among tasks can occur in any order, unlike function
calls, where the called function must finish executing before control returns to the calling function.

This kind of control flow can make it much easier to solve certain problems. In some problems,
the various pieces of required work are not naturally related by function calls; there is no obvious
"caller" or "callee" among the jobs that need to be done. An example is the producer-consumer
problem, where one complex procedure is generating values and another complex procedure is consuming
them. The consumer cannot simply call a producer function to get a value, because the producer
may have more values to generate and so might not yet be ready to return. With tasks, the producer
and consumer can both run as long as they need to, passing values back and forth as necessary.

Julia provides a [`Channel`](@ref) mechanism for solving this problem.
A [`Channel`](@ref) is a waitable first-in first-out queue which can have
multiple tasks reading from and writing to it.

Let's define a producer task, which produces values via the [`put!`](@ref) call.
To consume values, we need to schedule the producer to run in a new task. A special [`Channel`](@ref)
constructor which accepts a 1-arg function as an argument can be used to run a task bound to a channel.
We can then [`take!`](@ref) values repeatedly from the channel object:

```jldoctest producer
julia> function producer(c::Channel)
           put!(c, "start")
           for n=1:4
               put!(c, 2n)
           end
           put!(c, "stop")
       end;

julia> chnl = Channel(producer);

julia> take!(chnl)
"start"

julia> take!(chnl)
2

julia> take!(chnl)
4

julia> take!(chnl)
6

julia> take!(chnl)
8

julia> take!(chnl)
"stop"
```

One way to think of this behavior is that `producer` was able to return multiple times. Between
calls to [`put!`](@ref), the producer's execution is suspended and the consumer has control.

The returned [`Channel`](@ref) can be used as an iterable object in a `for` loop, in which case the
loop variable takes on all the produced values. The loop is terminated when the channel is closed.

```jldoctest producer
julia> for x in Channel(producer)
           println(x)
       end
start
2
4
6
8
stop
```

Note that we did not have to explicitly close the channel in the producer. This is because
the act of binding a [`Channel`](@ref) to a [`Task`](@ref) associates the open lifetime of
a channel with that of the bound task. The channel object is closed automatically when the task
terminates. Multiple channels can be bound to a task, and vice-versa.

While the [`Task`](@ref) constructor expects a 0-argument function, the [`Channel`](@ref)
method which creates a channel bound task expects a function that accepts a single argument of
type [`Channel`](@ref). A common pattern is for the producer to be parameterized, in which case a partial
function application is needed to create a 0 or 1 argument [anonymous function](@ref man-anonymous-functions).

For [`Task`](@ref) objects this can be done either directly or by use of a convenience macro:

```julia
function mytask(myarg)
    ...
end

taskHdl = Task(() -> mytask(7))
# 또는 동일하게
taskHdl = @task mytask(7)
```

To orchestrate more advanced work distribution patterns, [`bind`](@ref) and [`schedule`](@ref)
can be used in conjunction with [`Task`](@ref) and [`Channel`](@ref)
constructors to explicitly link a set of channels with a set of producer/consumer tasks.

Note that currently Julia tasks are not scheduled to run on separate CPU cores.
True kernel threads are discussed under the topic of [Parallel Computing](@ref).

### Core task operations

Let us explore the low level construct [`yieldto`](@ref) to underestand how task switching works.
`yieldto(task,value)` suspends the current task, switches to the specified `task`, and causes
that task's last [`yieldto`](@ref) call to return the specified `value`. Notice that [`yieldto`](@ref)
is the only operation required to use task-style control flow; instead of calling and returning
we are always just switching to a different task. This is why this feature is also called "symmetric
coroutines"; each task is switched to and from using the same mechanism.

[`yieldto`](@ref) is powerful, but most uses of tasks do not invoke it directly. Consider why
this might be. If you switch away from the current task, you will probably want to switch back
to it at some point, but knowing when to switch back, and knowing which task has the responsibility
of switching back, can require considerable coordination. For example, [`put!`](@ref) and [`take!`](@ref)
are blocking operations, which, when used in the context of channels maintain state to remember
who the consumers are. Not needing to manually keep track of the consuming task is what makes [`put!`](@ref)
easier to use than the low-level [`yieldto`](@ref).

In addition to [`yieldto`](@ref), a few other basic functions are needed to use tasks effectively.

  * [`current_task`](@ref) gets a reference to the currently-running task.
  * [`istaskdone`](@ref) queries whether a task has exited.
  * [`istaskstarted`](@ref) queries whether a task has run yet.
  * [`task_local_storage`](@ref) manipulates a key-value store specific to the current task.

### Tasks and events

Most task switches occur as a result of waiting for events such as I/O requests, and are performed
by a scheduler included in the standard library. The scheduler maintains a queue of runnable tasks,
and executes an event loop that restarts tasks based on external events such as message arrival.

The basic function for waiting for an event is [`wait`](@ref). Several objects implement [`wait`](@ref);
for example, given a `Process` object, [`wait`](@ref) will wait for it to exit. [`wait`](@ref)
is often implicit; for example, a [`wait`](@ref) can happen inside a call to [`read`](@ref)
to wait for data to be available.

In all of these cases, [`wait`](@ref) ultimately operates on a [`Condition`](@ref) object, which
is in charge of queueing and restarting tasks. When a task calls [`wait`](@ref) on a [`Condition`](@ref),
the task is marked as non-runnable, added to the condition's queue, and switches to the scheduler.
The scheduler will then pick another task to run, or block waiting for external events. If all
goes well, eventually an event handler will call [`notify`](@ref) on the condition, which causes
tasks waiting for that condition to become runnable again.

A task created explicitly by calling [`Task`](@ref) is initially not known to the scheduler. This
allows you to manage tasks manually using [`yieldto`](@ref) if you wish. However, when such
a task waits for an event, it still gets restarted automatically when the event happens, as you
would expect. It is also possible to make the scheduler run a task whenever it can, without necessarily
waiting for any events. This is done by calling [`schedule`](@ref), or using the [`@schedule`](@ref)
or [`@async`](@ref) macros (see [Parallel Computing](@ref) for more details).

### Task states

Tasks have a `state` field that describes their execution status. A [`Task`](@ref) `state` is one of the following
symbols:

| Symbol      | Meaning                                            |
|:----------- |:-------------------------------------------------- |
| `:runnable` | Currently running, or available to be switched to  |
| `:waiting`  | Blocked waiting for a specific event               |
| `:queued`   | In the scheduler's run queue about to be restarted |
| `:done`     | Successfully finished executing                    |
| `:failed`   | Finished with an uncaught exception                |
