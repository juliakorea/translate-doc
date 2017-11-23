의 변수는 값에 연결된 (또는 바인딩 된) 이름입니다. 나중에 사용할 수 있도록 값 (예 : 일부 계산 후에 얻은 값)을 저장하려는 경우 유용합니다.

예 :

```julia-repl
# 변수 x에 10을 할당할때
# Assign the value 10 to the variable x
julia> x = 10
10

# x의 값으로 계산할떄
julia> x + 1
11

# x의값을 재설계할때
julia> x = 1 + 1
2

# 텍스트 문자열과 같은 다른 유형의 값을 지정할 수 있습니다.

julia> x = "Hello World!"
"Hello World!"
```

 Julia는 변수 명명에 매우 유연한 시스템을 제공합니다. 변수 이름은 대소 문자를 구
분합니다. 그리고 의미 론적 의미가 없습니다 (즉, 언어는 변수를 다르게 취급하지 않
습니다.

```jldoctest
julia> x = 1.0
1.0

julia> y = -3
-3

julia> Z = "My string"
"My string"

julia> customary_phrase = "Hello world!"
"Hello world!"

julia> UniversalDeclarationOfHumanRightsStart = "人人生而自由，在尊严和权利上一>律平等。"
"人人生而自由，在尊严和权利上一律平等。"
```

Unicode names (in UTF-8 encoding) are allowed:

```jldoctest
julia> δ = 0.00001
1.0e-5

julia> 안녕하세요 = "Hello"
"Hello"
```

 a REPL 및 다른 여러 줄리아 편집 환경에서 많은 유니 코드 수학을 입력 할 수 있습>니다 백 슬래쉬 된 LaTeX 심볼 이름 다음에 탭을 입력하여 심볼을 제거하십시오.예를 를어 `TeX 심볼 이름 다음에 탭을 입력하여 심볼을 제거하십시오. 예를 들어, 변수 `delta`- * tab *을 입력하거나`\ alpha`- * tab * -` \ hat`-
* tab * -`\ _2` - * tab *. 다른 사람의 코드와 같이 기호를 어딘가에서 찾으면
당신이 입력하는 방법을 모르겠다면, REPL 도움말은 당신에게 말할 것입니다 

julia> pi = 3
3

julia> pi
3

julia> sqrt = 4
4
```

그러나 이미 사용중인 내장 상수 또는 기능을 다시 정의하려고하면 
julia는 다음과같은 에러를 낼것이다

```jldoctest
julia> pi
π = 3.1415926535897...

julia> pi = 3
ERROR: cannot assign variable MathConstants.pi from module Main

julia> sqrt(100)
10.0

julia> sqrt = 4
ERROR: cannot assign variable Base.sqrt from module Main
```

##허용된 변수 이름


변수 이름은 문자 (A-Z 또는 a-z), 밑줄 또는 유니 코드 코드의 하위 집합으로 시작해
야합니다
00A0보다 큰 점; 특히 [유니 코드 문자 범주] (http://www.fileformat.info/info/unicode/category/index.htm)
Lu / Ll / Lt / Lm / Lo / Nl (문자), Sc / So (통화 및 기타 기호) 및 기타 문자와 >유사한 문자
(예 : Sm 수학 기호의 서브 세트)이 허용됩니다. 그 다음 문자는
숫자 (0-9 및 Nd / No 범주의 다른 문자) 및 기타 유니 코드 코드 포인트 : 발음 구별
 기호
및 기타 수정 표시 (Mn / Mc / Me / Sk 범주), 일부 구두점 커넥터 (범주 Pc),
소수 (primes) 및 몇 가지 다른 문자가 포함되어 있습니다.

`+`와 같은 연산자도 유효한 식별자이지만 특별히 구문 분석됩니다. 일부 상황에서는 연산자
변수와 마찬가지로 사용할 수 있습니다. 예를 들어`(+)`는 더하기 함수를,`(+) = f`는그것을 재 할당합니다. `⊕ '와 같은 대부분의 유니 코드 중온 연산자 (범주 Sm에서)는
 파싱됩니다
중온 연산자 (infix operators)로 사용되며 사용자 정의 메소드 (예 :`const ⊗ = kron`를 사용할 수 있습니다.
'⊗`을 크로 니커 제품으로 정의). 연산자에는 수정 표시가 붙을 수 있습니다.
소수 (primes), 서브 / 윗 첨자 (sub / superscript). `+ ₐ '`는`+`와 같은 우선 순위
를 가진 중위 연산자로 파싱됩니다.
명시 적으로 허용되지 않는 변수 이름은 내장 명령문의 이름입니다.


```julia-repl
julia> else = false
ERROR: syntax: unexpected "else"

julia> try = "No"
ERROR: syntax: unexpected "="
```


일부 유니 코드 문자는 식별자에서 동등한 것으로 간주됩니다.
문자 조합 (예 : 악센트)을 입력하는 다양한 방법
(줄리아 식별자는 NFC 표준화되어 있음).
유니 코드 문자`ɛ` (U + 025B : 라틴 소문자 e)
및 'μ'(U + 00B5 : 마이크로 부호)는 대응하는
전자는 일부 입력 방법을 통해 쉽게 액세스 할 수 있기 때문에 그리스 문자를 사용합>니다.
## 문체 규칙


Julia는 유효한 이름에 대해 제한을 두지 않지만 다음을 채택하는 것이 유용 해졌습니
다
협약 :

  * 변수는 소문자를 사용합니다.
  *  (`'_'`)를 사용할수 있지만,사용 안하는 것이 좋습니다.(다른사람이 사용하기 불
    편합니다)
  * `Type`과`Module`의 이름은 대문자로 시작하고 단어 분리는 upper
    camel 경우에 대신에  underscores.
  * `함수`와`매크로`의 이름에는 밑줄을 넣지 않습니다
  * 인수에 쓰는 함수의 이름은!로 끝납니다. 이들은 때때로 "mutating"또는 "in-place"함수라고 불리는데, 그 이유는 값을 반환하는 것이 아니라 함수가 호출 된 후에 인>수가 변경되기 때문입니다.
