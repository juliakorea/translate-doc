# [다차원 배열](@id man-multi-dim-arrays)

Julia는 대부분의 수치 계산용 언어처럼 일급 객체로써 배열 구현을 제공한다.
대부분의 언어는 배열의 구현에 많은 신경을 쓰지만 Julia는 배열을 특별하게 취급하지는 않는다.
배열 관련 라이브러리는 거의 다 Julia로 작성되었으며, Julia 컴파일러가 성능을 좌우한다.
또한 [`AbstractArray`](@ref)를 상속하여 커스텀 배열 타입을 정의하는 것이 가능하다.
커스텀 배열 타입을 구현할 때 필요한 세부사항은 [manual section on the AbstractArray interface](@ref man-interface-array) 를 참조하기 바란다.

배열은 다차원 그리드(multi-dimensional grid)에 저장된 객체들의 모음이다.
일반으로 배열은 [`Any`](@ref) 타입의 객체들을 담을 수 있다.
수치 계산용으로 사용하려면 배열은 [`Float64`](@ref)이나 [`Int32`](@ref)와 같이 더 구체적인 타입의 객체를 담는 것이 좋다.

다른 많은 수치 계산용 언어에서는 성능을 위해 프로그램을 벡터화된 스타일로 작성하지만, Julia에서는 대개 그럴 필요가 없다.
Julia 컴파일러는 타입 추론을 통해 스칼라 배열 인덱싱에 최적화된 코드를 생성한다.
따라서 편리하고 읽기 쉬운 스타일로 프로그램을 작성해도 성능이 보존되며, 오히려 메모리를 더 적게 사용하는 경우도 있다.

줄리아는 함수에 인자를 줄 때 "공유를 통한 전달([pass-by-sharing](https://en.wikipedia.org/wiki/Evaluation_strategy#Call_by_sharing))을 한다.
몇몇 프로그래밍 언어는 배열을 값으로 전달하여([pass-by-value](https://en.wikipedia.org/wiki/Evaluation_strategy#Call_by_value)), 원치않는 수정을 막지만 무분별한 값의 복사로 인해 속도 지연을 겪을 수 있다.
Julia는 함수 내에서 값이 수정되거나 삭제될 가능성을 있을 때, 관습적으로 `!`을 함수 이름의 마지막에 붙여서 알려준다([`sort`](@ref)와 [`sort!`](@ref)를 비교해보자).
Collee가 객체의 수정을 피하려면 명시적으로 객체를 복사를 해야한다.
객체를 수정하지 않는 함수는 `!`이 붙여진 동일 이름의 함수와 같은 역할을 하면서 복사된 객체를 반환한다.

## 기본 함수

| 함수                   | 설명                                                           |
|:---------------------- |:-------------------------------------------------------------- |
| [`eltype(A)`](@ref)    | `A` 의 원소 타입                                               |
| [`length(A)`](@ref)    | `A` 의 원소 갯수                                               |
| [`ndims(A)`](@ref)     | `A` 의 차원수                                                  |
| [`size(A)`](@ref)      | `A` 의 크기 튜플                                               |
| [`size(A,n)`](@ref)    | `A` 의 `n` 차원의 크기                                         |
| [`axes(A)`](@ref)      | `A` 의 유효한 인덱스 튜플                                      |
| [`axes(A,n)`](@ref)    | `A` 의 유효 인덱스 `n`차원 범위(range)                         |
| [`eachindex(A)`](@ref) | `A` 의 모든 위치를 방문하는 효율적인 반복자(iterator)          |
| [`stride(A,k)`](@ref)  | `k` 차원 방향의 스트라이드 (연속한 원소 간의 선형 인덱스 거리) |
| [`strides(A)`](@ref)   | 모든 차원의 스트라이드 튜플                                    |

## 생성과 초기화

배열을 생성하고 초기화 하는 많은 함수가 있다.
다음에 나열된 함수들에서 `dims...` 인수는 차원의 크기들을 나타내는 튜플 하나를 받거나, 혹은 각 차원의 크기를 여러 인수로 받을 수 있다.
이 함수들의 대부분은 첫번째 인수로 배열의 원소 타입 `T`를 받을 수 있다.
`T`가 생략되었다면 [`Float64`](@ref)가 기본값이다.

| 함수                               | 설명                                                                                                                                                                                                                                         |
|:---------------------------------- |:-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [`Array{T}(undef, dims...)`](@ref)             | 초기화 되지 않은 밀집 [`Array`](@ref)                                                                                                                                                                                                        |
| [`zeros(T, dims...)`](@ref)                    | 모든 값이 0으로 초기화 된 `Array`                                                                                                                                                                                                            |
| [`ones(T, dims...)`](@ref)                     | 모든 값이 1로 초기화 된 `Array`                                                                                                                                                                                                              |
| [`trues(dims...)`](@ref)                       | 모든 값이 `true`로 초기화 된 [`BitArray`](@ref)                                                                                                                                                                                              |
| [`falses(dims...)`](@ref)                      | 모든 값이 `false`로 초기화 된 `BitArray`                                                                                                                                                                                                     |
| [`reshape(A, dims...)`](@ref)                  | `A` 와 동일한 데이타를 가지고 있지만 형상이 다른 배열                                                                                                                                                                                        |
| [`copy(A)`](@ref)                              | `A` 의 얕은 복사                                                                                                                                                                                                                             |
| [`deepcopy(A)`](@ref)                          | `A` 의 깊은 복사 (모든 원소를 재귀적으로 복사함)                                                                                                                                                                                             |
| [`similar(A, T, dims...)`](@ref)               | `A` 와 동일한 종류(밀집, 희소, 등)의 초기화 되지 않은 배열. 지정된 원소 타입과 형상을 가짐. 두번째와 세번째 인수는 선택적이며, 기본값은 `A`의 원소타입과 차원이다.                                                                           |
| [`reinterpret(T, A)`](@ref)                    | `A` 와 동일한 이진 데이터를 가지고 있지만, 원소 타입이 `T` 인 배열                                                                                                                                                                           |
| [`rand(T, dims...)`](@ref)                     | 독립 동일하며 열린구간 ``[0, 1)`` 상에서 연속 균일 분포를 가진 랜덤 `Array`                                                                                                                                                                  |
| [`randn(T, dims...)`](@ref)                    | 독립 동일하며 표준 정규 분포를 가진 랜덤 `Array`                                                                                                                                                                                             |
| [`Matrix{T}(I, m, n)`](@ref)                   | 크기가 `m` × `n` 인 단위 행렬                                                                                                                                                                                                                |
| [`range(start, stop=stop, length=n)`](@ref)    | `start`에서 `stop`까지 `n` 개의 원소가 선형적으로 배치된 구간                                                                                                                                                                                |
| [`fill!(A, x)`](@ref)                          | 배열 `A` 를 `x` 값으로 채우기                                                                                                                                                                                                                |
| [`fill(x, dims...)`](@ref)                     | `x` 값으로 차 있는 `Array`                                                                                                                                                                                                                   |

`[A, B, C, ...]` 문법은 주어진 인수들의 일차원 배열(이를테면 벡터)을 생성한다.
만약 모든 인수가 공통의 [확장 타입(promotion type)](@ref conversion-and-promotion)을 가진다면, 이들은 [`convert`](@ref)를 통해 공통의 확장 타입으로 변환된다.

To see the various ways we can pass dimensions to these constructors, consider the following examples:
```jldoctest
julia> zeros(Int8, 2, 3)
2×3 Array{Int8,2}:
 0  0  0
 0  0  0

julia> zeros(Int8, (2, 3))
2×3 Array{Int8,2}:
 0  0  0
 0  0  0

julia> zeros((2, 3))
2×3 Array{Float64,2}:
 0.0  0.0  0.0
 0.0  0.0  0.0
```
Here, `(2, 3)` is a [`Tuple`](@ref).

## 병합(Concatenation)

배열은 다음의 함수를 사용하여 생성하고 병합할 수 있다.

| 함수                        | 설명                             |
|:--------------------------- |:-------------------------------- |
| [`cat(A...; dims=k)`](@ref) | 입력 배열을 `k` 차원에 따라 병합 |
| [`vcat(A...)`](@ref)        | `cat(A...; dims=1)`의 줄임       |
| [`hcat(A...)`](@ref)        | `cat(A...; dims=2)`의 줄임       |

스칼라 값이 인수로 전달되면 원소 갯수가 하나인 배열로 취급한다. 예를 들어,
```jldoctest
julia> vcat([1, 2], 3)
3-element Array{Int64,1}:
 1
 2
 3

julia> hcat([1 2], 3)
1×3 Array{Int64,2}:
 1  2  3
```

병합 함수는 자주 사용되므로 다음의 특별한 문법을 가진다:

| 표현식            | 함수            |
|:----------------- |:--------------- |
| `[A; B; C; ...]`  | [`vcat`](@ref)  |
| `[A B C ...]`     | [`hcat`](@ref)  |
| `[A B; C D; ...]` | [`hvcat`](@ref) |

[`hvcat`](@ref) 은 1차원 (세미콜론으로 구분) 과 2차원(스페이스로 구분) 모두 병합한다.
아래 예제의 문법과 결과물을 비교해보자:
```jldoctest
julia> [[1; 2]; [3, 4]]
4-element Array{Int64,1}:
 1
 2
 3
 4

julia> [[1 2] [3 4]]
1×4 Array{Int64,2}:
 1  2  3  4

julia> [[1 2]; [3 4]]
2×2 Array{Int64,2}:
 1  2
 3  4
```

## 타입이 있는 배열의 초기화

특정 원소 타입의 배열은 `T[A, B, C, ...]` 문법을 통해 생성할 수 있다.
이는 원소 타입이 `T`인 일차원 배열을 생성하고, 원소 `A`, `B`, `C` 등을 담도록 초기화한다.
예를 들어, `Any[x, y, z]`는 어떤 값이든 가질 수 있는 배열을 생성한다.

병합 구문 또한 비슷한 방법으로 원소 타입을 지정할 수 있다.

```jldoctest
julia> [[1 2] [3 4]]
1×4 Array{Int64,2}:
 1  2  3  4

julia> Int8[[1 2] [3 4]]
1×4 Array{Int8,2}:
 1  2  3  4
```

## [컴프리헨션(Comprehensions)](@id Comprehensions)

컴프리헨션은 배열을 생성하는 일반적이면서도 강력한 방법을 제공한다.
컴프리헨션의 문법은 수학에서 쓰이는 집합의 조건제시법과 유사하다:

```
A = [ F(x,y,...) for x=rx, y=ry, ... ]
```

이는 `x`, `y` 등의 변수가 주어진 목록의 값을 각각 가지도록 하여 `F(x,y,...)`를 계산한다는 뜻이다.
값의 목록은 반복 가능한(iterable) 어떤 객체도 될 수 있지만, 주로 `1:n` 혹은 `2:(n-1)` 와 같은 범위이거나, `[1.2, 3.4, 5.7]`와 같이 명시적인 값의 배열이다.
결과는 N차원 배열이며, 그 크기는 변수의 범위인 `rx`, `ry` 등의 크기를 병합한 것과 같다.
그리고 각 `F(x,y,...)` 계산은 스칼라 값을 리턴한다.

다음의 예는 일차원 그리드에서, 현재 원소와 왼쪽 이웃, 오른쪽 이웃의 가중 평균을 계산한다:

```julia-repl
julia> x = rand(8)
8-element Array{Float64,1}:
 0.843025
 0.869052
 0.365105
 0.699456
 0.977653
 0.994953
 0.41084
 0.809411

julia> [ 0.25*x[i-1] + 0.5*x[i] + 0.25*x[i+1] for i=2:length(x)-1 ]
6-element Array{Float64,1}:
 0.736559
 0.57468
 0.685417
 0.912429
 0.8446
 0.656511
```

결과 배열의 타입은 계산된 원소가 결정한다.
타입을 명시적으로 정하려면 컴프리헨션 앞에 타입을 붙이면 된다.
예를 들어, 다음과 같이 결과를 단정밀도(single precision)로 요청할 수 있다:

```julia
Float32[ 0.25*x[i-1] + 0.5*x[i] + 0.25*x[i+1] for i=2:length(x)-1 ]
```

## 제너레이터 표현식 (Generator Expressions)

컴프리헨션은 대괄호 없이도 쓸 수 있으며, 이 경우 제너레이터 객체를 생성한다.
제너레이터는 배열을 미리 할당하고 값을 저장하는 것이 아니라, 필요에 따라 값을 생성하도록 반복할 수 있다 ([반복](@ref Iteration) 참조).
예를 들어, 다음의 표현식은 메모리 할당 없이 수열의 합을 계산한다:

```jldoctest
julia> sum(1/n^2 for n=1:1000)
1.6439345666815615
```

인수 목록 안에서 다차원 제너레이터 표현식을 사용할 때에는 괄호를 사용하여 그 다음의 인수와 구분한다:

```julia-repl
julia> map(tuple, 1/(i+j) for i=1:2, j=1:2, [1:4;])
ERROR: syntax: invalid iteration specification
```

`for` 다음에 나오는 쉼표로 구분된 모든 표현식은 범위로 해석되므로, 여기에 괄호를 추가함으로써 [`map`](@ref)에 세번째 인수를 추가할 수 있다.

```jldoctest
julia> map(tuple, (1/(i+j) for i=1:2, j=1:2), [1 3; 2 4])
2×2 Array{Tuple{Float64,Int64},2}:
 (0.5, 1)       (0.333333, 3)
 (0.333333, 2)  (0.25, 4)
```

Generators are implemented via inner functions. Just like
inner functions used elsewhere in the language, variables from the enclosing scope can be
"captured" in the inner function.  For example, `sum(p[i] - q[i] for i=1:n)`
captures the three variables `p`, `q` and `n` from the enclosing scope.
Captured variables can present performance challenges; see
[performance tips](@ref man-performance-tips).

제너레이터와 컴프리헨션에서 `for` 키워드를 여러번 사용함으로써 범위가 앞선 범위에 의존하도록 할 수 있다.

```jldoctest
julia> [(i,j) for i=1:3 for j=1:i]
6-element Array{Tuple{Int64,Int64},1}:
 (1, 1)
 (2, 1)
 (2, 2)
 (3, 1)
 (3, 2)
 (3, 3)
```

이러한 경우 결과는 항상 1차원이다.

생성된 값은 `if` 키워드를 사용하여 필터링 할 수 있다.

```jldoctest
julia> [(i,j) for i=1:3 for j=1:i if i+j == 4]
2-element Array{Tuple{Int64,Int64},1}:
 (2, 2)
 (3, 1)
```

## [인덱싱](@id man-array-indexing)

n차원 배열 `A`를 인덱싱 하는 일반적인 문법은 다음과 같다:

```
X = A[I_1, I_2, ..., I_n]
```

여기서 `I_k` 는 스칼라 정수, 정수의 배열, 혹은 [지원하는 다른 인덱스](@ref man-supported-index-types) 중 하나이다.
여기에는 모든 인덱스를 선택하는 [`Colon`](@ref) (`:`), 연속되거나 일정한 간격의 부분수열을 선택하는 `a:c` 혹은 `a:b:c`와 같은 형태의 범위, 그리고 `true` 값을 선택하는 부울 배열도 포함된다.

만약 모든 인덱스가 스칼라라면, 결과 `X`는 배열 `A`의 원소 중 하나이다.
그렇지 않을 경우 `X`는 배열이며, 모든 인덱스의 차원 수의 합이 `X`의 차원수가 된다.

예를 들어, 모든 인덱스 `I_k`가 벡터라면 `X`의 크기는 `(length(I_1), length(I_2), ..., length(I_n))`가 되고, `X`의 `i_1, i_2, ..., i_n` 위치는  `A[I_1[i_1], I_2[i_2], ..., I_n[i_n]]` 값을 가지게 된다.

Example:

```jldoctest
julia> A = reshape(collect(1:16), (2, 2, 2, 2))
2×2×2×2 Array{Int64,4}:
[:, :, 1, 1] =
 1  3
 2  4

[:, :, 2, 1] =
 5  7
 6  8

[:, :, 1, 2] =
  9  11
 10  12

[:, :, 2, 2] =
 13  15
 14  16

julia> A[1, 2, 1, 1] # all scalar indices
3

julia> A[[1, 2], [1], [1, 2], [1]] # all vector indices
2×1×2×1 Array{Int64,4}:
[:, :, 1, 1] =
 1
 2

[:, :, 2, 1] =
 5
 6

julia> A[[1, 2], [1], [1, 2], 1] # a mix of index types
2×1×2 Array{Int64,3}:
[:, :, 1] =
 1
 2

[:, :, 2] =
 5
 6
```

Note how the size of the resulting array is different in the last two cases.

만약 `I_1`이 2차원 행렬로 바뀐다면, `X`는 크기가 `(size(I_1, 1), size(I_1, 2), length(I_2), ..., length(I_n))`인 `n+1`차원 배열이 된다.
행렬이 차원을 하나 추가하는 것이다.

Example:

```jldoctest
julia> A = reshape(collect(1:16), (2, 2, 2, 2));

julia> A[[1 2; 1 2]]
2×2 Array{Int64,2}:
 1  2
 1  2

julia> A[[1 2; 1 2], 1, 2, 1]
2×2 Array{Int64,2}:
 5  6
 5  6
```

`X`의 `i_1, i_2, i_3, ..., i_{n+1}` 위치는 `A[I_1[i_1, i_2], I_2[i_3], ..., I_n[i_{n+1}]]` 값을 가진다.
스칼라(scalars)로 인덱스된 모든 차원은 결과에서 빠진다. 예를 들어, `J`가 인덱스들의 배열이면 `A[2, J, 3]`의 결과는 크기가 `size(J)`인 배열이며, `j`번째 원소의 값은 `A[2, J[j], 3]`이다.

인덱싱 문법의 특수한 한 부분으로서, 각 차원의 마지막 인덱스를 나타내기 위해서 인덱싱 괄호 안에서 `end` 키워드를 사용할 수 있다.
마지막 인덱스는 인덱싱 되는 가장 안쪽의 배열의 크기에 따라 결정된다.
`end` 키워드 없는 인덱싱 문법은 [`getindex`](@ref) 호출과 동일하다:

```
X = getindex(A, I_1, I_2, ..., I_n)
```

예시:

```jldoctest
julia> x = reshape(1:16, 4, 4)
4×4 reshape(::UnitRange{Int64}, 4, 4) with eltype Int64:
 1  5   9  13
 2  6  10  14
 3  7  11  15
 4  8  12  16

julia> x[2:3, 2:end-1]
2×2 Array{Int64,2}:
 6  10
 7  11

julia> x[1, [2 3; 4 1]]
2×2 Array{Int64,2}:
  5  9
 13  1
```

## 대입

n차원 배열 `A`에 값을 대입하는 일반적인 문법은 다음과 같다:

```
A[I_1, I_2, ..., I_n] = X
```

여기서 `I_k` 는 스칼라 정수, 정수의 배열, 혹은 [지원하는 다른 인덱스](@ref man-supported-index-types) 중 하나이다.
여기에는 모든 인덱스를 선택하는 [`Colon`](@ref) (`:`), 연속되거나 일정한 간격의 부분수열을 선택하는 `a:c` 혹은 `a:b:c`와 같은 형태의 범위, 그리고 `true` 값을 선택하는 부울 배열도 포함된다.

만약 인덱스 `I_k`들이 모두 정수라면, `A`의 `I_1, I_2, ..., I_n`에 위치한 값은 `X`의 값으로 덮어씌워진다. 
필요하다면 `A`의 [`eltype`](@ref)으로 형 변환[`convert`](@ref)이 일어날 수 있다.

만약 어떤 인덱스 `I_k`가 한 개보다 많은 위치를 선택할 경우, 
우변의 `X`는 `A[I_1, I_2, ..., I_n]`의 인덱싱 결과와 같은 모양의 배열이거나, 성분 개수가 같은 벡터여야만 한다.
`A`의 `I_1[i_1], I_2[i_2], ..., I_n[i_n]`에 위치한 값은 값 `X[I_1, I_2, ..., I_n]`으로 덮어씌워지며, 필요한 경우 형 변환이 일어난다.
성분별 대입 연산자(The element-wise assignment operator) `.=`를 선택된 위치 전체에 대한 `X`의 브로드캐스팅[broadcast](@ref Broadcasting)에 쓸 수도 있다.

```
A[I_1, I_2, ..., I_n] .= X
```

[인덱싱](@ref man-array-indexing)에서와 마찬가지로, 각 차원의 마지막 인덱스를 나타내기 위해서 인덱싱 괄호 안에서 `end` 키워드를 사용할 수 있다.
마지막 인덱스는 인덱싱 되는 가장 안쪽의 배열의 크기에 따라 결정된다.
`end` 키워드 없는 대입의 문법은 [`setindex!`](@ref) 호출과 동일하다:

```
setindex!(A, X, I_1, I_2, ..., I_n)
```

예시:

```jldoctest
julia> x = collect(reshape(1:9, 3, 3))
3×3 Array{Int64,2}:
 1  4  7
 2  5  8
 3  6  9

julia> x[3, 3] = -9;

julia> x[1:2, 1:2] = [-1 -4; -2 -5];

julia> x
3×3 Array{Int64,2}:
 -1  -4   7
 -2  -5   8
  3   6  -9
```

## [지원하는 인덱스 타입](@id man-supported-index-types)

표현식 `A[I_1, I_2, ..., I_n]`에서, `I_k`는 스칼라 인덱스, 스칼라 인덱스의 배열, 혹은 [`to_indices`](@ref)를 통해 스칼라 인덱스 배열로 변환될 수 있는 객체 중 하나이다:

1. 스칼라 인덱스. 다음을 포함한다:
    * 부울이 아닌 정수.
    * [`CartesianIndex{N}`](@ref). 여러 차원에 걸쳐있는 정수의 `N`튜플처럼 행동한다. (자세한 내용은 아래를 참조.)
2. 스칼라 인덱스의 배열. 다음을 포함한다:
    * 정수 벡터와 다차원 정수 배열.
    * `[]`와 같은 빈 배열. 아무 원소도 선택하지 않는다.
    * `a:c` 나 `a:b:c`와 같은 범위. `a` 와 `c` 사이의 연속되거나 일정 간격의 subsection을 선택.
    * `AbstractArray`의 서브타입인 배열 스칼라의 .
    * `CartesianIndex{N}`의 배열 (자세한 내용은 아래를 참조).
3. 스칼라 인덱스의 배열을 나타내는 객체이면서 [`to_indices`](@ref)를 통해 스칼라 인덱스의 배열로 변환될 수 있는 것. 기본으로 다음을 포함한다:
    * [`Colon()`](@ref) (`:`). 차원 혹은 배열의 모든 원소를 선택한다.
    * 부울 배열. `true` 인덱스에 있는 원소를 선택한다 (자세한 내용은 아래를 참조)

Some examples:
```jldoctest
julia> A = reshape(collect(1:2:18), (3, 3))
3×3 Array{Int64,2}:
 1   7  13
 3   9  15
 5  11  17

julia> A[4]
7

julia> A[[2, 5, 8]]
3-element Array{Int64,1}:
  3
  9
 15

julia> A[[1 4; 3 8]]
2×2 Array{Int64,2}:
 1   7
 5  15

julia> A[[]]
0-element Array{Int64,1}

julia> A[1:2:5]
3-element Array{Int64,1}:
 1
 5
 9

julia> A[2, :]
3-element Array{Int64,1}:
  3
  9
 15

julia> A[:, 3]
3-element Array{Int64,1}:
 13
 15
 17
```

### 직교 인덱스(Cartesian indices)

`CartesianIndex{N}` 객체는 여러 차원을 포괄하는 정수의 `N`튜플처럼 동작하는 스칼라 인덱스를 나타낸다.

```jldoctest cartesianindex
julia> A = reshape(1:32, 4, 4, 2);

julia> A[3, 2, 1]
7

julia> A[CartesianIndex(3, 2, 1)] == A[3, 2, 1] == 7
true
```

따로 떼어놓고 생각했을때, 이는 매우 간단하게 보일지도 모른다;
`CartesianIndex`는 단순히 여러 정수를 하나의 객체로 묶어서 하나의 다차원 인덱스로 나타내는 것이다.
하지만 다른 형식의 인덱싱이나, `CartesianIndex`를 내어놓는 반복자와 결합하면 매우 우아하고 효율적인 코드를 쓸 수 있다.
아래의 [반복자](@ref Iteration)를 참조하라.
더 고급 예시는 [다차원 알고리즘과 반복에 관한 이 블로그](https://julialang.org/blog/2016/02/iteration)를 참조하라.

`CartesianIndex{N}`의 배열 또한 지원된다.
이는 각각 `N`차원을 포괄하는 스칼라 인덱스의 모음을 나타나며, 점별(pointwise) 인덱싱이라고도 불리는 인덱싱의 형태를 가능하게 한다.
예를 들어, 앞선 예시에서 정의된 `A`의 첫 "페이지"의 대각원소들을 다음과 같이 엑세스 할 수 있다:

```jldoctest cartesianindex
julia> page = A[:,:,1]
4×4 Array{Int64,2}:
 1  5   9  13
 2  6  10  14
 3  7  11  15
 4  8  12  16

julia> page[[CartesianIndex(1,1),
             CartesianIndex(2,2),
             CartesianIndex(3,3),
             CartesianIndex(4,4)]]
4-element Array{Int64,1}:
  1
  6
 11
 16
```

이는 [점 브로드캐스팅](@ref man-vectorized)을 정수 인덱스와 함께 씀으로써 (`A`로 부터 첫번째 "페이지"를 추출하는 별도의 과정 없이) 더욱더 간단하게 표한할 수 있다.
뿐만 아니라 `:`와 결합하여 두 페이지의 대각원소들을 한번에 추출할 수도 있다:

```jldoctest cartesianindex
julia> A[CartesianIndex.(axes(A, 1), axes(A, 2)), 1]
4-element Array{Int64,1}:
  1
  6
 11
 16

julia> A[CartesianIndex.(axes(A, 1), axes(A, 2)), :]
4×2 Array{Int64,2}:
  1  17
  6  22
 11  27
 16  32
```

!!! 경고

    `CartesianIndex`와 `CartesianIndex`의 배열은 차원의 마지막 인덱스를 나타내는 `end` 키워드와 호환되지 않으므로, `CartesianIndex` 혹은 `CartesianIndex`의 배열을 포함할 수도 있는 표현식에서는 `end`를 사용해서는 안된다.

### 논리적 인덱싱

부울 배열을 이용한 인덱싱은 값이 `true`인 곳의 인덱스를 선택한다.
주로 논리적 인덱싱, 혹은 논리적 마스크를 사용한 인덱싱이라고 부르며, 부울 벡터 `B`를 통한 인덱싱은 [`findall(B)`](@ref)가 리턴하는 정수의 벡터를 통한 인덱싱과 동일하다.
이와 마찬가지로, `N`차원 부울 배열을 통한 인덱싱은, `true` 값의 위치를 나타내는 `CartesianIndex{N}`들의 배열을 통한 인덱싱과 동일하다.
논리적 인덱스는, 인덱스의 크기와 인덱스하는 배열의 해당 차원의 크기가 일치하거나, 혹은 배열과 크기 및 차원이 일치하는 단 하나의 인덱스이어야 한다.
부울 배열을 사용하여 바로 인덱싱 하는 것이 [`findall`](@ref)를 먼저 호출하는 것보다 일반적으로 더 효율적이다.

```jldoctest
julia> x = reshape(1:16, 4, 4)
4×4 reshape(::UnitRange{Int64}, 4, 4) with eltype Int64:
 1  5   9  13
 2  6  10  14
 3  7  11  15
 4  8  12  16

julia> x[[false, true, true, false], :]
2×4 Array{Int64,2}:
 2  6  10  14
 3  7  11  15

julia> mask = map(ispow2, x)
4×4 Array{Bool,2}:
 1  0  0  0
 1  0  0  0
 0  0  0  0
 1  1  0  1

julia> x[mask]
5-element Array{Int64,1}:
  1
  2
  4
  8
 16
```

### Number of indices

#### Cartesian indexing

The ordinary way to index into an `N`-dimensional array is to use exactly `N` indices; each
index selects the position(s) in its particular dimension. For example, in the three-dimensional
array `A = rand(4, 3, 2)`, `A[2, 3, 1]` will select the number in the second row of the third
column in the first "page" of the array. This is often referred to as _cartesian indexing_.

#### Linear indexing

When exactly one index `i` is provided, that index no longer represents a location in a
particular dimension of the array. Instead, it selects the `i`th element using the
column-major iteration order that linearly spans the entire array. This is known as _linear
indexing_. It essentially treats the array as though it had been reshaped into a
one-dimensional vector with [`vec`](@ref).

```jldoctest linindexing
julia> A = [2 6; 4 7; 3 1]
3×2 Array{Int64,2}:
 2  6
 4  7
 3  1

julia> A[5]
7

julia> vec(A)[5]
7
```

A linear index into the array `A` can be converted to a `CartesianIndex` for cartesian
indexing with `CartesianIndices(A)[i]` (see [`CartesianIndices`](@ref)), and a set of
`N` cartesian indices can be converted to a linear index with
`LinearIndices(A)[i_1, i_2, ..., i_N]` (see [`LinearIndices`](@ref)).

```jldoctest linindexing
julia> CartesianIndices(A)[5]
CartesianIndex(2, 2)

julia> LinearIndices(A)[2, 2]
5
```

It's important to note that there's a very large assymmetry in the performance
of these conversions. Converting a linear index to a set of cartesian indices
requires dividing and taking the remainder, whereas going the other way is just
multiplies and adds. In modern processors, integer division can be 10-50 times
slower than multiplication. While some arrays — like [`Array`](@ref) itself —
are implemented using a linear chunk of memory and directly use a linear index
in their implementations, other arrays — like [`Diagonal`](@ref) — need the
full set of cartesian indices to do their lookup (see [`IndexStyle`](@ref) to
introspect which is which). As such, when iterating over an entire array, it's
much better to iterate over [`eachindex(A)`](@ref) instead of `1:length(A)`.
Not only will the former be much faster in cases where `A` is `IndexCartesian`,
but it will also support OffsetArrays, too.

#### Omitted and extra indices

In addition to linear indexing, an `N`-dimensional array may be indexed with
fewer or more than `N` indices in certain situations.

Indices may be omitted if the trailing dimensions that are not indexed into are
all length one. In other words, trailing indices can be omitted only if there
is only one possible value that those omitted indices could be for an in-bounds
indexing expression. For example, a four-dimensional array with size `(3, 4, 2,
1)` may be indexed with only three indices as the dimension that gets skipped
(the fourth dimension) has length one. Note that linear indexing takes
precedence over this rule.

```jldoctest
julia> A = reshape(1:24, 3, 4, 2, 1)
3×4×2×1 reshape(::UnitRange{Int64}, 3, 4, 2, 1) with eltype Int64:
[:, :, 1, 1] =
 1  4  7  10
 2  5  8  11
 3  6  9  12

[:, :, 2, 1] =
 13  16  19  22
 14  17  20  23
 15  18  21  24

julia> A[1, 3, 2] # Omits the fourth dimension (length 1)
19

julia> A[1, 3] # Attempts to omit dimensions 3 & 4 (lengths 2 and 1)
ERROR: BoundsError: attempt to access 3×4×2×1 reshape(::UnitRange{Int64}, 3, 4, 2, 1) with eltype Int64 at index [1, 3]

julia> A[19] # Linear indexing
19
```

When omitting _all_ indices with `A[]`, this semantic provides a simple idiom
to retrieve the only element in an array and simultaneously ensure that there
was only one element.

Similarly, more than `N` indices may be provided if all the indices beyond the
dimensionality of the array are `1` (or more generally are the first and only
element of `axes(A, d)` where `d` is that particular dimension number). This
allows vectors to be indexed like one-column matrices, for example:

```jldoctest
julia> A = [8,6,7]
3-element Array{Int64,1}:
 8
 6
 7

julia> A[2,1]
6
```

## [반복(Iteration)](@id Iteration)

배열 전체를 반복하는 방법으로는 다음을 추천한다:

```julia
for a in A
    # 원소 a로 뭔가 한다
end

for i in eachindex(A)
    # i 혹은 A[i] 로 뭔가 한다
end
```

첫번째 구문은 인덱스가 아니라 값이 필요할 때 사용한다.
두번째 구문에서 `A`가 빠른 선형 인덱싱을 지원하는 배열이라면 `i`는 `Int` 타입, 그렇지 않을 경우는 `CartesianIndex` 타입이다:

```jldoctest
julia> A = rand(4,3);

julia> B = view(A, 1:3, 2:3);

julia> for i in eachindex(B)
           @show i
       end
i = CartesianIndex(1, 1)
i = CartesianIndex(2, 1)
i = CartesianIndex(3, 1)
i = CartesianIndex(1, 2)
i = CartesianIndex(2, 2)
i = CartesianIndex(3, 2)
```

`for i = 1:length(A)`에 비해, [`eachindex`](@ref)는 모든 종류의 배열을 효율적으로 반복할 수 있도록 해준다.

## 배열 특성(trait)

커스텀 [`AbstractArray`](@ref) 타입을 정의하는 경우, 빠른 선형 인덱싱이 가능함을 지정할 수 있다:

```julia
Base.IndexStyle(::Type{<:MyArray}) = IndexLinear()
```

이 설정은 `eachindex`가 정수를 사용하여 `MyArray`를 반복하도록 한다.
이 특성을 지정하지 않으면, 기본값인 `IndexCartesian()`를 사용한다.

## 배열과 벡터화된 연산자/함수

배열은 다음의 연산자를 지원한다:

1. 단항 산술 연산자 -- `-`, `+`
2. 이항 산술 연산자 -- `-`, `+`, `*`, `/`, `\`, `^`
3. 비교 연산자 -- `==`, `!=`, `≈` ([`isapprox`](@ref)), `≉`

배열 혹은 배열과 스칼라의 혼합에 대한 원소별 연산에 대해
`f.(args...)` 형태의 (예: `sin.(x)`, `min.(x,y)`) [점 문법](@ref man-vectorized)을 사용하여 수학 연산과 다른 연산을 편리하게 벡터화 할 수 있다;
배열, 혹은 배열과 스칼라의 혼합에 대해 원소별 연산을 하기 위해서 점 문법을 쓸 수 있다 ([브로드캐스팅](@ref Broadcasting) 연산).
추가적인 이점으로는 다른 dot call 과 같이 쓴다면 하나의 루프로 융합한다는 것이다 (예: `sin.(cos.(x))`).

또한, *모든* 이항 연산자는 [점을 찍어](@ref man-dot-operators)사용할 수 있으며, 이는 [융합 브로드캐스팅 연산](@ref man-vectorized)에서 배열(그리고 배열과 스칼라의 조합)에 적용할 수 있다 (예: `z .== sin.(x .* y)`).

참고로, `==` 와 같은 연산자는 전체 배열에 적용되어, 단 하나의 부울 값을 내어놓는다.
원소별 비교를 위해서는 점 `.==`와 같은 점 연산자를 사용하라.
(`<`와 같은 비교 연산은, 원소별 연산 `.<`*만*이 배열에 적용 가능하다.)

또한,  [`max`](@ref)를 `a`와 `b`에 원소별로 [`broadcast`](@ref) 하는 `max.(a,b)`와 , `a`의 최대값을 찾는 [`maximum(a)`](@ref)의 차이에 유의하라.
`min.(a,b)` 와 `minimum(a)` 의 관계도 마찬가지이다.

## [브로드캐스팅](@id Broadcasting)

행렬의 각 배열을 더하는 것 처럼, 다른 크기의 배열들을 원소별로 이항 연산할 필요가 종종 있다.
이를 비효율적으로 하는 방법은 벡터를 행렬과 같은 크기로 복사하는 것이다:

```julia-repl
julia> a = rand(2,1); A = rand(2,3);

julia> repeat(a,1,3)+A
2×3 Array{Float64,2}:
 1.20813  1.82068  1.25387
 1.56851  1.86401  1.67846
```

차원의 크기가 커지면 위 방법은 낭비가 심해지므로, Julia는 [`broadcast`](@ref)를 제공한다.
`broadcast`는 추가적인 메모리를 사용하지 않으면서, 주어진 한 배열의 차원 중 크기가 1인 차원을 주어진 다른 배열의 해당 차원의 크기와 일치하도록 확장하여 주어진 함수를 원소별로 적용하는 함수이다:

```julia-repl
julia> broadcast(+, a, A)
2×3 Array{Float64,2}:
 1.20813  1.82068  1.25387
 1.56851  1.86401  1.67846

julia> b = rand(1,2)
1×2 Array{Float64,2}:
 0.867535  0.00457906

julia> broadcast(+, a, b)
2×2 Array{Float64,2}:
 1.71056  0.847604
 1.73659  0.873631
```

`.+` 와 `.*` 같은 [점찍은 연산자](@ref man-dot-operators)는 `broadcast` 호출과 (아래에 설명할 융합을 제외한다면) 동일하다.
또한 명시적으로 목적지를 지정하는 [`broadcast!`](@ref)도 있다.
(`.=` 대입을 사용하여 융합하여서도 액세스할 수 있다.)
사실, `f.(args...)`는 `broadcast(f, args...)`와 동일하며, 어떤 함수든 [점 문법](@ref man-vectorized)을 통하여 편리하게 브로드캐스팅 할 수 있는 문법을 제공한다.
중첩된 "점 호출" `f.(...)`은 (`.+` 등의 연산자도 포함하여) 하나의 `broadcast` 호출로 [자동으로 융합](@ref man-dot-operators)한다.

추가적으로, [`broadcast`](@ref)는 배열에 국한되지 않고 (함수 문서 참조) 튜플 또한 지원하며,
배열, 튜플, [`Ref`](@ref)([`Ptr`](@ref) 제외)가 아닌 모든 값은 "스칼라"로 취급한다.

```jldoctest
julia> convert.(Float32, [1, 2])
2-element Array{Float32,1}:
 1.0
 2.0

julia> ceil.((UInt8,), [1.2 3.4; 5.6 6.7])
2×2 Array{UInt8,2}:
 0x02  0x04
 0x06  0x07

julia> string.(1:3, ". ", ["First", "Second", "Third"])
3-element Array{String,1}:
 "1. First"
 "2. Second"
 "3. Third"
```

## 구현

Julia에서 기본 배열 타입은 추상 타입인 [`AbstractArray{T,N}`](@ref)이다.
`AbstractArray{T,N}`는 차원수 `N`과 원소 타입 `T`로 매개변수화 되어 있다.
[`AbstractVector`](@ref)와 [`AbstractMatrix`](@ref)는 일차원과 이차원 배열의 앨리어스(alias)이다.
`AbstractArray` 객체에 대한 연산은 기저 스토리지에 독립적인 형태로 고수준의 연산자와 함수를 사용하여 정의된다.
이 연산은 일반적으로 구체적 배열 구현의 폴백(fallback)으로서 정상동작한다.

`AbstractArray` 타입은 배열과 비슷한 모든 것을 포함하며, 이들의 구현은 전통적인 배열과는 차이가 많이 날 수도 있다.
예를 들어, 원소를 저장하지 않고 요청에 따라서 계산할 수도 있다.
다만 모든 구체적인 `AbstractArray{T,N}` 타입은 일반적으로 적어도 (`Int` 튜플을 리턴하는) [`size(A)`](@ref),
[`getindex(A,i)`](@ref), 그리고 [`getindex(A,i1,...,iN)`](@ref getindex)를 구현해야 한다.
변경 가능한 배열은 [`setindex!`](@ref)도 구현해야 한다.
이러한 연산들은 대략 상수 시간 복잡도, 엄밀히 말해 Õ(1) 복잡도를 가지도록 구현하는 것이 좋다.
그렇지 않으면 어떤 배열 함수는 생각 이상으로 느릴지도 모른다.
구체적 타입은 [`copy`](@ref)등의 out-of-place 연산에서 유사한 배열을 할당하는데에 쓰일 수 있는 [`similar(A,T=eltype(A),dims=size(A))`](@ref)메소드를 제공해야 한다.
`AbstractArray{T,N}`가 내부적으로 어떻게 표현이 되든, `T` 는 *정수* 인덱싱이 리턴하는 객체(`A` 가 빈 배열이 아닌 경우 `A[1, ..., 1]`)의 타입이며, `N`은 [`size`](@ref)가 리턴하는 튜플의 길이여야 한다.
For more details on defining custom
`AbstractArray` implementations, see the [array interface guide in the interfaces chapter](@ref man-interface-array).

`DenseArray` is an abstract subtype of `AbstractArray` intended to include all arrays where
elements are stored contiguously in column-major order (see additional notes in
[Performance Tips](@ref man-performance-tips)). The [`Array`](@ref) type is a specific instance
of `DenseArray`;  [`Vector`](@ref) and [`Matrix`](@ref) are aliases for the 1-d and 2-d cases.
Very few operations are implemented specifically for `Array` beyond those that are required
for all `AbstractArray`s; much of the array library is implemented in a generic
manner that allows all custom arrays to behave similarly.

`SubArray` is a specialization of `AbstractArray` that performs indexing by
sharing memory with the original array rather than by copying it. A `SubArray`
is created with the [`view`](@ref) function, which is called the same way as
[`getindex`](@ref) (with an array and a series of index arguments). The result
of [`view`](@ref) looks the same as the result of [`getindex`](@ref), except the
data is left in place. [`view`](@ref) stores the input index vectors in a
`SubArray` object, which can later be used to index the original array
indirectly.
             [`@views`](@ref) 매크로를 표현식이나 코드 블록 앞에 둠으로써, 그 표현식 내의 모든 `array[...]` 슬라이스가 `SubArray` 뷰를 생성하도록 할 수 있다.

[`BitArray`](@ref)s are space-efficient "packed" boolean arrays, which store one bit per boolean value.
They can be used similarly to `Array{Bool}` arrays (which store one byte per boolean value),
and can be converted to/from the latter via `Array(bitarray)` and `BitArray(array)`, respectively.

A "strided" array is stored in memory with elements laid out in regular offsets such that
an instance with a supported `isbits` element type can be passed to
external C and Fortran functions that expect this memory layout. Strided arrays
must define a [`strides(A)`](@ref) method that returns a tuple of "strides" for each dimension; a
provided [`stride(A,k)`](@ref) method accesses the `k`th element within this tuple. Increasing the
index of dimension `k` by `1` should increase the index `i` of [`getindex(A,i)`](@ref) by
[`stride(A,k)`](@ref). If a pointer conversion method [`Base.unsafe_convert(Ptr{T}, A)`](@ref) is
provided, the memory layout must correspond in the same way to these strides. `DenseArray` is a
very specific example of a strided array where the elements are arranged contiguously, thus it
provides its subtypes with the approporiate definition of `strides`. More concrete examples
can be found within the [interface guide for strided arrays](@ref man-interface-strided-arrays).
[`StridedVector`](@ref) and [`StridedMatrix`](@ref) are convenient aliases for many of the builtin array types that
are considered strided arrays, allowing them to dispatch to select specialized implementations that
call highly tuned and optimized BLAS and LAPACK functions using just the pointer and strides.

다음 예시에서는 임시 배열을 만들지 않고 적절한 LAPACK 함수를 차원 크기와 스트라이드를 사용하여 호출하여 큰 배열의 작은 섹션의 QR 분해를 계산한다.

```julia-repl
julia> a = rand(10, 10)
10×10 Array{Float64,2}:
 0.517515  0.0348206  0.749042   0.0979679  …  0.75984     0.950481   0.579513
 0.901092  0.873479   0.134533   0.0697848     0.0586695   0.193254   0.726898
 0.976808  0.0901881  0.208332   0.920358      0.288535    0.705941   0.337137
 0.657127  0.0317896  0.772837   0.534457      0.0966037   0.700694   0.675999
 0.471777  0.144969   0.0718405  0.0827916     0.527233    0.173132   0.694304
 0.160872  0.455168   0.489254   0.827851   …  0.62226     0.0995456  0.946522
 0.291857  0.769492   0.68043    0.629461      0.727558    0.910796   0.834837
 0.775774  0.700731   0.700177   0.0126213     0.00822304  0.327502   0.955181
 0.9715    0.64354    0.848441   0.241474      0.591611    0.792573   0.194357
 0.646596  0.575456   0.0995212  0.038517      0.709233    0.477657   0.0507231

julia> b = view(a, 2:2:8,2:2:4)
4×2 view(::Array{Float64,2}, 2:2:8, 2:2:4) with eltype Float64:
 0.873479   0.0697848
 0.0317896  0.534457
 0.455168   0.827851
 0.700731   0.0126213

julia> (q, r) = qr(b);

julia> q
4×4 LinearAlgebra.QRCompactWYQ{Float64,Array{Float64,2}}:
 -0.722358    0.227524  -0.247784    -0.604181
 -0.0262896  -0.575919  -0.804227     0.144377
 -0.376419   -0.75072    0.540177    -0.0541979
 -0.579497    0.230151  -0.00552346   0.781782

julia> r
2×2 Array{Float64,2}:
 -1.20921  -0.383393
  0.0      -0.910506
```
