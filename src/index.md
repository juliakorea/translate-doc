```@eval
io = IOBuffer()
release = isempty(VERSION.prerelease)
v = "$(VERSION.major).$(VERSION.minor)"
!release && (v = v*"-$(first(VERSION.prerelease))")
print(io, """
    # 줄리아 $(v) 문서

    환영합니다. 줄리아 $(v) 문서입니다.

    """)
if !release
    print(io,"""
        !!! warning "작업 진행 중!"
            개발 버전의 줄리아 문서입니다.
        """)
end
import Markdown
Markdown.parse(String(take!(io)))
```

!!! note "번역 안내"
    한글 문서 번역은 깃헙 [https://github.com/juliakorea/translate-doc](https://github.com/juliakorea/translate-doc) 에서 누구나 참여하실 수 있습니다.
    많은 참여 부탁드립니다.

!!! note "구글 자동 번역"
    중국어 번역 자료를 한국어로 자동 번역해서 유용하게 볼 수 있습니다.
    - Julia 대만(juliatw) 문서 [https://docs.juliatw.org/latest/](https://translate.google.com/translate?sl=zh-CN&tl=ko&u=https%3A%2F%2Fdocs.juliatw.org%2Flatest%2F)
    - Julia 중국(juliacn) 문서 [http://docs.juliacn.com/latest/](https://translate.google.com/translate?sl=zh-CN&tl=ko&u=http%3A%2F%2Fdocs.juliacn.com%2Flatest%2F)

```@eval
file = url = "julia-1.5.1.pdf"
import Markdown
Markdown.parse("""
!!! note
    이 문서를 PDF 형태로 보실 수 있습니다: [$file]($url).
""")
```

### [소개 글](@id man-introduction)

과학 분야 컴퓨팅은 빠른 성능을 요구함에도, 정작 대부분의 연구자들은 속도가 느린 동적인 언어로 일을 처리한다.
동적 언어를 즐겨쓰는 여러 이유로 보아 이러한 추세는 쉽게 사그러들지는 않아 보인다.
다행히 언어 디자인과 컴파일러 기법의 발달로 성능 문제가 해결되면서 동적 언어의 성능 하락 문제를 극복하고 프로토타이핑과 계산 집중형 애플리케이션의 구축을 하나의 환경에서 발휘할 수 있게 되었다.
줄리아 (Julia)는 이런 장점을 최대화한 언어이다. 줄리아는 (1) 과학과 수학 분야의 컴퓨팅에 적합한 동적 언어이면서 (2) 정적 타입 언어에 견줄만한 성능을 지닌다.

줄리아 컴파일러는 파이썬, R과 같은 언어의 해석 방식과 다르다. 줄리아가 뽑아내는 성능이 아마도 처음에는 의아할 것이다.
그럼에도 작성한 코드가 느리다면 [성능 팁](@ref man-performance-tips)을 읽어보길 권한다.
줄리아가 어떤 식으로 작동하는지 이해한 뒤라면, C에 근접하는 성능의 코드를 짜는 건 쉽다.

줄리아는 타입 추론과 [LLVM](https://ko.wikipedia.org/wiki/LLVM)으로 구현한 [JIT 컴파일](https://ko.wikipedia.org/wiki/JIT_%EC%BB%B4%ED%8C%8C%EC%9D%BC)을 사용해
선택적 타입, 멀티플 디스패치, 좋은 성능을 이뤄내고 있다. 그리고 명령형, 함수형, 객체 지향 프로그래밍의 특징을 포괄하는 다양한 패러다임을 추구한다.
줄리아는 고급 단계의 수치 계산에 있어 R, 매트랩, 파이썬처럼 간편하고 표현력이 우수하다.
뿐만 아니라 일반적인 형태의 프로그래밍 또한 가능하다. 이를 위해 줄리아는 수학 프로그래밍 언어를 근간으로 해서 구축하였고
[리스프](https://ko.wikipedia.org/wiki/%EB%A6%AC%EC%8A%A4%ED%94%84), [펄](https://ko.wikipedia.org/wiki/%ED%8E%84),
[파이썬](https://ko.wikipedia.org/wiki/%ED%8C%8C%EC%9D%B4%EC%8D%AC), [루아](https://ko.wikipedia.org/wiki/%EB%A3%A8%EC%95%84_(%ED%94%84%EB%A1%9C%EA%B7%B8%EB%9E%98%EB%B0%8D_%EC%96%B8%EC%96%B4)),
[루비](https://ko.wikipedia.org/wiki/%EB%A3%A8%EB%B9%84_(%ED%94%84%EB%A1%9C%EA%B7%B8%EB%9E%98%EB%B0%8D_%EC%96%B8%EC%96%B4))와 같은 인기있는 동적 언어의 기능을 취합하고 있다.

기존에 있는 동적 언어와 비교해 보는 줄리아만의 독특한 점은:

  * 핵심 언어는 최소한으로 꾸린다; 정수를 다루는 프리미티브 연산자(`+` `-` `*` 같은)를 포함하는, 줄리아 Base와 표준 라이브러리는 줄리아 코드로 짜여져 있다.
  * 객체를 구성하고 서술하는 타입(types)을 풍부하게 지원하며, 타입 선언을 만들 때도 선택적으로 사용된다.
  * 인자 타입을 조합함으로서 함수의 작동 행위를 정의하는 [멀티플 디스패치(multiple dispatch)](https://en.wikipedia.org/wiki/Multiple_dispatch)
  * 인자 타입에 따라 효율적이고 특화된 코드를 자동으로 생성
  * C와 같은 정적으로 컴파일되는 언어에 근접하는 훌륭한 성능

동적 언어에 대해 "타입이 없다"는 식으로 말하곤 하는데 사실은 그렇지 않다: 기본 타입이거나 별도 정의를 통해 모든 객체는 타입을 가진다.
그러나 대부분의 동적 언어는 타입 선언의 부족으로 컴파일러가 해당 값의 타입을 인지하지 못한다거나 타입에 대해 무엇인지 명시적으로 밝힐 수 없는 상태가 되곤 한다.
한편 정적 언어는 타입 정보를 -- 대개 -- 컴파일러용으로서 달기에, 타입은 오직 컴파일 시점에만 존재하여 실행시에는 이를 다루거나 표현할 수 없다.
줄리아에서 타입은 그 자체로 런타임 객체이며 컴파일러가 요하는 정보를 알려주는 데에도 쓰인다.

보통의 프로그래머라면 개의치 않을 타입과 멀티플 디스패치는 줄리아의 핵심 개념이다: 함수들은 서로 다른 인자 타입들을 조합함으로서 정의되고
가장 그 정의와 맞물리는 타입을 찾아 디스패치하여 실행된다. 이 모델은 수학 프로그래밍과 잘 맞는데,
전통적인 객체 지향 디스패치라면 첫번째 인자로 연산자를 "갖는" 것은 자연스럽지 않다.
연산자는 단지 특별히 표기한 함수일 뿐이다 -- `+` 함수에 엮일 새로운 데이터 타입을 정의하려면, 해당하는 메서드 정의만 추가하면 된다.
기존 코드는 새로운 데이터 타입과 더불어 원할하게 작동한다.

런타임 타입 추론(타입 지정을 점진적으로 늘려가며)을 이유로, 또 이 프로젝트를 시작할 때 무엇보다도 성능을 강조하였기에
줄리아의 계산 효율은 다른 동적 언어들에 비해 우월하며 심지어 정적으로 컴파일하는 경쟁 언어들마저 능가한다.
거대 규모의 수치 해석 문제에 있어 속도는 매번 그리고 앞으로도, 아마 항상 결정적 요소일 것이다: 처리되는 데이터의 양이 지난 수십 년간 무어의 법칙을 따르고 있지 않은가.

사용하기 편하면서도 강력하고 효율적인 언어를 줄리아는 목표하고 있다. 다른 시스템과 견주어 줄리아를 씀으로 좋은 점은 다음과 같다:

  * 자유롭게 사용 가능하며 오픈 소스이다 ([MIT 라이센스](https://github.com/JuliaLang/julia/blob/master/LICENSE.md))
  * 사용자가 정의한 타입 또한 내장한 타입처럼 빠르고 간결하다
  * 성능을 위해 코드를 벡터화할 필요가 없다; 벡터화하지 않은 코드도 빠르다
  * 병렬과 분산 처리를 위해 고안되었다
  * 가벼운 "그린" 쓰레딩 ([코루틴](https://en.wikipedia.org/wiki/Coroutine))
  * 거슬리지 않는 강력한 타입 시스템
  * 숫자와 다른 타입을 위한 우아하고 확장 가능한 컨버젼 및 프로모션(타입 변환)
  * 효율적인 [유니코드](https://ko.wikipedia.org/wiki/%EC%9C%A0%EB%8B%88%EC%BD%94%EB%93%9C) 와 [UTF-8](https://ko.wikipedia.org/wiki/UTF-8) 지원
  * C 함수 직접 호출(별도의 래퍼나 특정한 API가 필요하지 않음)
  * 다른 프로세스를 관리하는 쉘과 비슷한 강력한 기능
  * 리스프 (Lisp)와 비슷한 매크로, 메타프로그래밍을 위한 장치들
