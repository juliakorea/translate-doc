# [변수](@id Variables)

변수는 값의 이름이다.
나중에 값을 재사용하려고 한다면 변수에 저장하여 활용할 수 있다:

```julia-repl
# 변수 x에 10을 할당한다.
julia> x = 10
10

# x의 값으로 계산할 수 있다.
julia> x + 1
11

# x의 값을 재할당할 수 있다.
julia> x = 1 + 1
2

# 기존에 저장된 값과 다른 타입을 저장할 수 있다(예시: 문자열).

julia> x = "Hello World!"
"Hello World!"
```

Julia는 유연한 변수 명명법을 가진다.
일단 변수 이름은 대소문자를 구분한다:

```jldoctest
julia> x = 1.0
1.0

julia> y = -3
-3

julia> Z = "My string"
"My string"

julia> customary_phrase = "Hello world!"
"Hello world!"

julia> UniversalDeclarationOfHumanRightsStart = "모든 인간은 태어날 때부터 자유로우며 그 존엄과 권리에 있어 동등하다."
"모든 인간은 태어날 때부터 자유로우며 그 존엄과 권리에 있어 동등하다."
```

Julia는 유니코드 기반의 변수를 허용한다:

```jldoctest
julia> δ = 0.00001
1.0e-5

julia> 안녕하세요 = "Hello"
"Hello"
```

REPL 및 다른 여러 줄리아 편집 환경에서 많은 유니코드 수학 기호를 입력할 수 있다.
`\` - *LaTeX 기호명* - *tab*을 입력하면 기호로 변환된다.
예를 들어 변수명 δ는 `\delta`-tab, `α̂₂`는 `\alpha`-*tab*-`\hat`-*tab*-`\_2`-*tab* 으로 입력할 수 있다.
특정 기호의 LaTex 기호명이 궁금하다면 REPL에서 ?(help 호출)를 입력하고 원하는 유니코드 기호를 넣어서 확인할 수 있다.


julia는 심지어 내장 상수와 함수를 필요한 경우 변수로 재정의할 수 있다(추천하지 않는 방법이다):
```
julia> pi = 3
3

julia> pi
3

julia> sqrt = 4
4
```

그러나 이미 사용했던 내장 상수나 함수를 다시 정의하려고 하면 다음과 같은 오류를 낸다.

```jldoctest
julia> pi
π = 3.1415926535897...

julia> pi = 3
ERROR: cannot assign a value to variable MathConstants.pi from module Main

julia> sqrt(100)
10.0

julia> sqrt = 4
ERROR: cannot assign a value to variable Base.sqrt from module Main
```

##허용하는 변수 이름


변수 이름은 문자(A-Z 또는 a-z), 밑줄(`_`) 또는 00A0보다 큰 유니코드 코드의 부분 집합으로 시작해야 한다.
특히 [유니 코드 문자 범주] (http://www.fileformat.info/info/unicode/category/index.htm) Lu/Ll/Lt/Lm/Lo/Nl(문자), Sc/So(통화 및 기타 기호) 및 기타 문자와 유사한 문자(Sm의 부분집합)가 허용된다.
그 다음 문자는 !와 숫자 (0-9와 Nd/No에 포함된 문자) 및 기타 유니코드 코드 포인트: (Mn/Mc/Me/Sk)의 발음 구별 기호 및 기타 수정 표시, 구두점(Pc), 소수(primes) 및 몇 가지 다른 문자)를 포함할 수 있다.

`+`와 같은 연산자도 유니코드에 포함되지만 예외적으로 파싱된다.
일부 조건에서는 연산자를 변수로 사용할 수 있다.
예를 들어`(+)`는 더하기 함수를 가리키고, `(+) = f`로 재할당을 할 수 있다.
`⊕`와 같은 대부분의 유니코드 중위 연산자(Sm)는 Julia의 중위 연산자로 파싱되며 사용자 정의 메소드(예 :크로네커 곱을 정의하기 위해`const ⊗ = kron`를 정의)를 사용할 수도 있다.
연산자는 수정 기호, 프라임 기호, 윗첨자/아래첨자를 접두로 붙일 수 있다.
예를 들어 `+̂ₐ″`는`+`와 같은 우선 순위를 가진 중위 연산자로 파싱된다.

허용되지 않는 변수 이름은 내장 [Keywords](@ref)뿐이다.


```julia-repl
julia> else = false
ERROR: syntax: unexpected "else"

julia> try = "No"
ERROR: syntax: unexpected "="
```

일부 유니코드 문자는 동등하게 간주된다.
유니코드가 달라도 문자가 같으면 동일하게 취급된다(Julia는 NFC 표준을 사용함).
예를 들어 유니코드 문자 `ɛ` (U + 025B : 라틴어 소문자 열린 e)와 `μ`(U + 00B5 : 마이크로 부호)는 이와 형태가 같은 그리스 문자와 동일하게 취급된다.

## 문체 규칙


Julia는 변수 명명법이 자유롭지만 다음 규칙을 준수하는 것을 추천한다:

  * 변수는 소문자를 사용한다.
  * `'_'`와 같은 문자는 다른 사람을 배려해 되도록 사용하지 않는다.
  * 타입과 모듈 이름은 대문자로 시작하고 단어 분리는 밑줄(`_`)대신 쌍봉낙타 표기법(UpperCamelCase: 모든 단어의 첫글자를 대문자로 표기)을 지향한다.
  * `함수`와 `매크로`의 이름에는 밑줄을 넣지 않는다.
  * in-place 함수의 이름은 `!`로 끝난다.
