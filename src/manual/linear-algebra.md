# [선형 대수](@id Linear-algebra)

다차원 배열 지원에 더불어, Julia는 자주 쓰이고 유용한 여러 선형 대수 연산의 네이티브 구현을 제공한다.
[`trace`](@ref), [`det`](@ref), [`inv`](@ref) 등의 기초적 연산을 모두 지원한다:

```jldoctest
julia> A = [1 2 3; 4 1 6; 7 8 1]
3×3 Array{Int64,2}:
 1  2  3
 4  1  6
 7  8  1

julia> trace(A)
3

julia> det(A)
104.0

julia> inv(A)
3×3 Array{Float64,2}:
 -0.451923   0.211538    0.0865385
  0.365385  -0.192308    0.0576923
  0.240385   0.0576923  -0.0673077
```

또한 고윳값과 고유 벡터 찾기 등의 다른 유용한 연산들도 지원한다:

```jldoctest
julia> A = [-4. -17.; 2. 2.]
2×2 Array{Float64,2}:
 -4.0  -17.0
  2.0    2.0

julia> eigvals(A)
2-element Array{Complex{Float64},1}:
 -1.0 + 5.0im
 -1.0 - 5.0im

julia> eigvecs(A)
2×2 Array{Complex{Float64},2}:
  0.945905+0.0im        0.945905-0.0im
 -0.166924-0.278207im  -0.166924+0.278207im
```

이에 더불어, Julia는 여러 [분해](@ref man-linalg-factorizations)를 제공한다: 
선형 방정식 풀이나 행렬 지수 함수 계산 등을 할 때, 행렬을 (성능이나 메모리 등의 이유로) 더 용이한 형태로 사전 분해 함으로써 속도를 높여줄 수 있다.
자세한 내용은 [`factorize`](@ref) 문서를 참조하라.
예를 들어:

```jldoctest
julia> A = [1.5 2 -4; 3 -1 -6; -10 2.3 4]
3×3 Array{Float64,2}:
   1.5   2.0  -4.0
   3.0  -1.0  -6.0
 -10.0   2.3   4.0

julia> factorize(A)
Base.LinAlg.LU{Float64,Array{Float64,2}} with factors L and U:
[1.0 0.0 0.0; -0.15 1.0 0.0; -0.3 -0.132196 1.0]
[-10.0 2.3 4.0; 0.0 2.345 -3.4; 0.0 0.0 -5.24947]
```

`A`가 에르미트, 대칭, 삼각, 3중 대각 또는 2중 대각이 아니므로, LU 분해가 가장 좋은 방법일 것이다.
이를 다음과 비교해보자:

```jldoctest
julia> B = [1.5 2 -4; 2 -1 -3; -4 -3 5]
3×3 Array{Float64,2}:
  1.5   2.0  -4.0
  2.0  -1.0  -3.0
 -4.0  -3.0   5.0

julia> factorize(B)
Base.LinAlg.BunchKaufman{Float64,Array{Float64,2}}
D factor:
3×3 Tridiagonal{Float64,Array{Float64,1}}:
 -1.64286   0.0   ⋅
  0.0      -2.8  0.0
   ⋅        0.0  5.0
U factor:
3×3 Base.LinAlg.UnitUpperTriangular{Float64,Array{Float64,2}}:
 1.0  0.142857  -0.8
 0.0  1.0       -0.6
 0.0  0.0        1.0
permutation:
3-element Array{Int64,1}:
 1
 2
 3
```

여기서는 Julia가 `B`가 대칭임을 감지하여 더 적절한 분해를 사용하였다.
행렬의 특성(예를 들어 대칭, 3중 대각 등)을 알고 있는 경우 더 효율적인 코드를 작성할 수 있는 경우가 많이 있다.
Julia는 행렬에 태그를 붙여 이러한 특성들을 표기할 수 있도록 해주는 특수 타입들을 제공한다.
예를 들어:

```jldoctest
julia> B = [1.5 2 -4; 2 -1 -3; -4 -3 5]
3×3 Array{Float64,2}:
  1.5   2.0  -4.0
  2.0  -1.0  -3.0
 -4.0  -3.0   5.0

julia> sB = Symmetric(B)
3×3 Symmetric{Float64,Array{Float64,2}}:
  1.5   2.0  -4.0
  2.0  -1.0  -3.0
 -4.0  -3.0   5.0
```

`sB`는 (실)대칭인 행렬로 태그되었다.
따라서 이후에 고윳값 분해나 벡터와의 곱 등을 할 때, 참조하는 데이터를 반으로 줄임으로써 계산을 효율적으로 할 수 있다.
예를 들어:

```jldoctest
julia> B = [1.5 2 -4; 2 -1 -3; -4 -3 5]
3×3 Array{Float64,2}:
  1.5   2.0  -4.0
  2.0  -1.0  -3.0
 -4.0  -3.0   5.0

julia> sB = Symmetric(B)
3×3 Symmetric{Float64,Array{Float64,2}}:
  1.5   2.0  -4.0
  2.0  -1.0  -3.0
 -4.0  -3.0   5.0

julia> x = [1; 2; 3]
3-element Array{Int64,1}:
 1
 2
 3

julia> sB\x
3-element Array{Float64,1}:
 -1.7391304347826084
 -1.1086956521739126
 -1.4565217391304346
```

여기서 `\` (왼쪽나누기) 연산은 선형 해법을 계산한다. 왼쪽나누기 연산자는 강력하여 간소하고 읽기 쉬우면서도 모든 종류의 선형 방정식의 풀이할 수 있을 정도로 충분히 유연한 코드를 작성하기 쉽게 해 준다.

## 특수 행렬

선형대수에서는 [특수한 대칭성과 구조를 가진 행렬](http://www2.imm.dtu.dk/pubdb/views/publication_details.php?id=3274)이 종종 등장하는데, 행렬의 종류에 따라 여러가지 행렬 분해와 연관지을 수 있다.
Julia는 특수 행렬 타입의 풍부한 컬렉션을 제공하며, 이를 통해 특정 행렬 타입에 특수화된 루틴으로 계산을 빠르게 할 수 있도록 해준다.

다음은 Julia에 구현된 특수 행렬의 종류와, 이들에 대해 최적화 된 LAPACK 메소드로의 후크 여부를 요약한 표이다.

| 행렬 타입                 | 설명                                                                                                   |
|:------------------------- |:------------------------------------------------------------------------------------------------------ |
| [`Symmetric`](@ref)       | [대칭 행렬](https://ko.wikipedia.org/wiki/%EB%8C%80%EC%B9%AD%ED%96%89%EB%A0%AC)                        |
| [`Hermitian`](@ref)       | [에르미트 행렬](https://ko.wikipedia.org/wiki/%EC%97%90%EB%A5%B4%EB%AF%B8%ED%8A%B8_%ED%96%89%EB%A0%AC) |
| [`UpperTriangular`](@ref) | 상 [삼각 행렬](https://ko.wikipedia.org/wiki/%EC%82%BC%EA%B0%81%ED%96%89%EB%A0%AC)                     |
| [`LowerTriangular`](@ref) | 하 [삼각 행렬](https://ko.wikipedia.org/wiki/%EC%82%BC%EA%B0%81%ED%96%89%EB%A0%AC)                     |
| [`Tridiagonal`](@ref)     | [3중 대각 행렬](https://ko.wikipedia.org/wiki/3%EC%A4%91%EB%8C%80%EA%B0%81%ED%96%89%EB%A0%AC)          |
| [`SymTridiagonal`](@ref)  | 대칭 3중 삼각 행렬                                                                                     |
| [`Bidiagonal`](@ref)      | 상/하 [2중 대각 행렬](https://en.wikipedia.org/wiki/Bidiagonal_matrix)                                 |
| [`Diagonal`](@ref)        | [대각 행렬](https://ko.wikipedia.org/wiki/%EB%8C%80%EA%B0%81%ED%96%89%EB%A0%AC)                        |
| [`UniformScaling`](@ref)  | [균일 스케일링 연산자](https://en.wikipedia.org/wiki/Uniform_scaling)                                  |

### 기초 연산

| 행렬 타입                 | `+` | `-` | `*` | `\` | 그 외 최적화된 함수                                         |
|:------------------------- |:--- |:--- |:--- |:--- |:----------------------------------------------------------- |
| [`Symmetric`](@ref)       |     |     |     | MV  | [`inv`](@ref), [`sqrt`](@ref), [`exp`](@ref)                |
| [`Hermitian`](@ref)       |     |     |     | MV  | [`inv`](@ref), [`sqrt`](@ref), [`exp`](@ref)                |
| [`UpperTriangular`](@ref) |     |     | MV  | MV  | [`inv`](@ref), [`det`](@ref)                                |
| [`LowerTriangular`](@ref) |     |     | MV  | MV  | [`inv`](@ref), [`det`](@ref)                                |
| [`SymTridiagonal`](@ref)  | M   | M   | MS  | MV  | [`eigmax`](@ref), [`eigmin`](@ref)                          |
| [`Tridiagonal`](@ref)     | M   | M   | MS  | MV  |                                                             |
| [`Bidiagonal`](@ref)      | M   | M   | MS  | MV  |                                                             |
| [`Diagonal`](@ref)        | M   | M   | MV  | MV  | [`inv`](@ref), [`det`](@ref), [`logdet`](@ref), [`/`](@ref) |
| [`UniformScaling`](@ref)  | M   | M   | MVS | MVS | [`/`](@ref)                                                 |

범례:

| 기호               | 설명                                       |
|:------------------ |:------------------------------------------ |
| M (matrix, 행뎔)   | 최적화된 행렬-행렬 연산을 사용할 수 있음   |
| V (vector, 벡터)   | 최적화된 행렬-벡터 연산을 사용할 수 있음   |
| S (scalar, 스칼라) | 최적화된 행렬-스칼라 연산을 사용할 수 있음 |

### 행렬 분해

| 행렬 타입                 | LAPACK | [`eig`](@ref) | [`eigvals`](@ref) | [`eigvecs`](@ref) | [`svd`](@ref) | [`svdvals`](@ref) |
|:------------------------- |:------ |:------------- |:----------------- |:----------------- |:------------- |:----------------- |
| [`Symmetric`](@ref)       | SY     |               | ARI               |                   |               |                   |
| [`Hermitian`](@ref)       | HE     |               | ARI               |                   |               |                   |
| [`UpperTriangular`](@ref) | TR     | A             | A                 | A                 |               |                   |
| [`LowerTriangular`](@ref) | TR     | A             | A                 | A                 |               |                   |
| [`SymTridiagonal`](@ref)  | ST     | A             | ARI               | AV                |               |                   |
| [`Tridiagonal`](@ref)     | GT     |               |                   |                   |               |                   |
| [`Bidiagonal`](@ref)      | BD     |               |                   |                   | A             | A                 |
| [`Diagonal`](@ref)        | DI     |               | A                 |                   |               |                   |

범례:

| 기호               | 설명                                                                                      | 예시                 |
|:------------------ |:----------------------------------------------------------------------------------------- |:-------------------- |
| A (all, 모두)      | 모든 특성 값 및 특성 벡터를 찾는 최적화된 메소드를 사용할 수 있음                         | 예) `eigvals(M)`    |
| R (range, 범위)    | `il`번째에서 `ih`번째 사이의 특성 값을 찾는 최적화된 메소드를 사용할 수 있음              | `eigvals(M, il, ih)` |
| I (interval, 구간) | 구간 [`vl`, `vh`] 사이의 특성 값을 찾는 최적화된 메소드를 사용할 수 있음                  | `eigvals(M, vl, vh)` |
| V (vectors, 벡터)  | 특성 값들 `x=[x1, x2,...]`에 해당하는 특성 벡터들을 찾는 최적화된 메소드를 사용할 수 있음 | `eigvecs(M, x)`      |

### 균일 스케일링 연산자

[`UniformScaling`](@ref) 연산자는 스칼라와 단위 행렬의 곱 `λ*I`를 나타낸다.
항등 연산자 `I` 는 상수로 정의되며 `UniformScaling` 의 인스턴스이다.
`UniformScaling` 연산자의 크기는 제네릭하며 이항 연산자 [`+`](@ref), [`-`](@ref), [`*`](@ref), [`\`](@ref) 에서 다른 행렬과 일치하도록 결정된다.
`A+I` and `A-I` 는 `A` 가 정사각 행렬임을 의미한다.
항등 연산자 `I`를 곱하는 것은 (스케일링 비율이 1임을 체크하는 것을 제외하면) noop이며 따라서 오버헤드가 거의 없다.

`UniformScaling` 연산자가 어떻게 사용되는지 살펴보자:

```jldoctest
julia> U = UniformScaling(2);

julia> a = [1 2; 3 4]
2×2 Array{Int64,2}:
 1  2
 3  4

julia> a + U
2×2 Array{Int64,2}:
 3  2
 3  6

julia> a * U
2×2 Array{Int64,2}:
 2  4
 6  8

julia> [a U]
2×4 Array{Int64,2}:
 1  2  2  0
 3  4  0  2

julia> b = [1 2 3; 4 5 6]
2×3 Array{Int64,2}:
 1  2  3
 4  5  6

julia> b - U
ERROR: DimensionMismatch("matrix is not square: dimensions are (2, 3)")
Stacktrace:
 [1] checksquare at ./linalg/linalg.jl:220 [inlined]
 [2] -(::Array{Int64,2}, ::UniformScaling{Int64}) at ./linalg/uniformscaling.jl:156
 [3] top-level scope
```

## [행렬 분해](@id man-linalg-factorizations)

[행렬 분해](https://en.wikipedia.org/wiki/Matrix_decomposition)는 주어진 행렬을 여러 행렬의 곱으로 분해하는 것이며, 선형 대수의 중심이 되는 개념 중 하나이다.

아래는 Julia에 구현된 행렬 분해를 요약한 표이다.
각 분해와 연관된 메소드에 관한 자세한 내용은 줄리아 Base 문서의 [선형 대수](@ref Linear-Algebra) 섹션을 참조하기 바란다.

| 종류              | 설명                                                                                                                |
|:----------------- |:------------------------------------------------------------------------------------------------------------------- |
| `Cholesky`        | [숄레스키 분해](https://ko.wikipedia.org/wiki/%EC%88%84%EB%A0%88%EC%8A%A4%ED%82%A4_%EB%B6%84%ED%95%B4)              |
| `CholeskyPivoted` | [피벗](https://ko.wikipedia.org/wiki/%ED%94%BC%EB%B2%97) 숄레스키 분해                                              |
| `LU`              | [LU 분해](https://ko.wikipedia.org/wiki/LU_%EB%B6%84%ED%95%B4)                                                      |
| `LUTridiagonal`   | [`Tridiagonal`](@ref) 행렬에 대한 LU 분해                                                                           |
| `QR`              | [QR 분해](https://ko.wikipedia.org/wiki/QR_%EB%B6%84%ED%95%B4)                                                      |
| `QRCompactWY`     | QR 분해의 컴팩트 WY 폼                                                                                              |
| `QRPivoted`       | 피벗 QR 분해                                                                                                        |
| `Hessenberg`      | [헤센베르크 분해](http://mathworld.wolfram.com/HessenbergDecomposition.html)                                        |
| `Eigen`           | [고윳값 분해](https://en.wikipedia.org/wiki/Eigendecomposition_(matrix))                                            |
| `SVD`             | [특이값 분해](https://ko.wikipedia.org/wiki/%ED%8A%B9%EC%9E%87%EA%B0%92)                                            |
| `GeneralizedSVD`  | [일반화된 특이값 분해](https://en.wikipedia.org/wiki/Generalized_singular_value_decomposition#Higher_order_version) |
