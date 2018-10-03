# [시작하기](@id man-getting-started)

줄리아의 설치는 어렵지 않다.  미리 컴파일된 실행파일을 이용하거나, 아니면 소스로부터 직접 컴파일하는 두가지 방법이 존재한다. [https://julialang.org/downloads/](https://julialang.org/downloads/)에서
 알려주는 방법에 따라 Julia를 다운로드하고 설치하면 된다.

Julia를 처음 접할 때는 대화형 실행 환경을 통해서 시작하는 것이 가장 쉽게 Julia를 익힐 수 있는 방법이다. 대화형 실행 환경은 단순히 Julia 실행파일을 더블 클릭하거나, 명령창에서 `julia` 명령어를 입력하여 실행할 수 있다.

```@eval
io = IOBuffer()
Base.banner(io)
banner = String(take!(io))
import Markdown
Markdown.parse("```\n\$ julia\n\n$(banner)\njulia> 1 + 2\n3\n\njulia> ans\n3\n```")
```

대화형 실행 환경을 종료하기 위해서는 `CTRL-D`(컨트롤/`^` 키와 `d` 키를 함께 누른다) 를 입력하거나 
`exit()`를 대화형 실행 환경 입력창에 타이핑한다. 대화형 실행 환경을 실행하면, 위와 같이 `julia` 배너가 보여지고, 커서창이 사용자의 입력을 기다리며 깜빡이고 있다. 사용자가 `1 + 2`, 와 같은 표현식을 입력한 뒤, 엔터 버튼을 누르는 순간, Julia는 표현식을 평가하고 그 결과를 보여준다. 만약 사용자가 입력한 표현식이 세미콜론(;)으로 끝난다면, 대화형 실행 환경은 결과를 바로 보여주지 않는다. 대신에 `ans` 라는 변수가 결과를 보여주든 보여주지 않든 가장 마지막으로 계산된 표현식의 결과를 저장하고 있다 `ans` 변수는 대화형 실행 환경에서만 존재하며, 다른 방식으로 동작하는 Julia 코드 상에서는 나타나지 않는다.

`file.jl`라는 소스 파일에 저장되어 있는 표현식을 계산하기 위해서는, `include("file.jl")`와 같이 입력한다.

대화형 실행 환경을 이용하지 않고 파일에 저장되어 있는 소스 코드를 실행하기 위해서는, 소스 코드 파일 이름을`julia` 명령어의 첫번째 매개 변수로 넣어서 실행한다.

명령어:

```
$ julia script.jl arg1 arg2...
```

예제와 같이 `julia` 실행 명령 뒤에 오는 매개변수들은 전역 상수 `ARGS`라고 불리우는 `script.jl`라는 프로그램의 명령줄 인자로 작동한다. 이 프로그램의 이름은 전역 상수 `PROGRAM_FILE` 에도 설정된다. 또한 `ARGS`는 이 뿐만이 아니라`-e` 옵션을 통해서 julia 스크립트를 실행할 때도 설정할 수 있음을 알 필요가 있다. 그러나 이 경우에는 `PROGRAM_FILE` 은 아무것도 설정되지 않은 채로 실행될 것이다.(아래의 `julia` 도움말을 보도록 하자.) 예를 들어, 단순히 스크립트에 주어진 명령줄 인자를 출력할 때는 다음과 같이 입력하면 된다.

```
$ julia -e 'println(PROGRAM_FILE); for x in ARGS; println(x); end' foo bar

foo
bar
```

아니면 저 코드를 스크립트 파일에 넣고 실행시켜도 가능하다.

```
$ echo 'println(PROGRAM_FILE); for x in ARGS; println(x); end' > script.jl
$ julia script.jl foo bar
script.jl
foo
bar
```

`--` 구분자는 명령어와 줄리아에 넘겨줄 인자를 구분하는데 사용한다.

```
$ julia --color=yes -O -- foo.jl arg1 arg2..
```

See also [Scripting](@ref man-scripting) for more information on writing Julia scripts.

Julia는 `-p` 옵션이나 `--machine-file` 옵션을 이용하여 병렬 환경에서 실행시킬 수 있다. `-p n` 옵션은 n개의 worker 프로세스를 생성하지만, `--machine-file file` 옵션은 file의 각 행에 지정된 노드마다 worker를 생성한다. `file` 에 지정된 노드(machine)들은 `ssh` 로그인을 통해 패스워드가 필요없이 실행할 수 있어야 하며, Julia는 현재 호스트와 같은 경로에 설치가 되어 있어야 한다. `file` 에 작성되는 노드는 `[count*][user@]host[:port] [bind_addr[:port]]` 와 같은 형식으로 작성한다. `user` 는 현재 user id를 나타내고, `port` 는 기본 ssh port, `count` 는 각 노드당 생성하는 worker의 개수 (기본값 : 1) `bin-to bind_addr[:port]` 은 선택적인 옵션으로 다른 worker들이 현재의 worker로 연결하기 위해 필요한 특정 IP 주소와 포트를 지정한다.

만약 Julia가 실행할 때마다 실행되는 코드가 있다면, 그 코드를 `~/.juliarc.ji` 에 넣으면 된다.

```
$ echo 'println("Greetings! 你好! 안녕하세요?")' > ~/.julia/config/startup.jl
$ julia
Greetings! 你好! 안녕하세요?

...
```

`perl` 과 `ruby` 와 같이,  Julia 코드를 실행하고 옵션을 지정하는 방법은 다음과 같이 여러가지가 있다.

```
julia [switches] -- [programfile] [args...]
```

|스위치                                 |설명|
|:---                                   |:---|
|`-v`, `--version`                      |버전 정보를 표시한다|
|`-h`, `--help`                         |이 메세지를 표시한다|
|`-J`, `--sysimage <file>`              |주어진 시스템 이미지 파일로 실행한다|
|`-H`, `--home <dir>`                   |`julia` 실행파일의 위치를 지정한다|
|`--startup-file={yes\|no}`             |`~/.julia/config/startup.jl` 를 불러온다|
|`--handle-signals={yes\|no}`           |Julia의 기본 시그널 핸들러를 켜거나 끈다|
|`--sysimage-native-code={yes\|no}`     |시스템 이미지의 기존 코드 사용/사용하지 않는다|
|`--compiled-modules={yes\|no}`         |모듈의 사전 증분 컴파일을 활성화/비활성화 한다|
|`-e`, `--eval <expr>`                  |`<expr>`를 실행만 한다|
|`-E`, `--print <expr>`                 |`<expr>`를 실행하고 결과를 표시한다|
|`-L`, `--load <file>`                  |`<file>`을 모든 프로세서에 로드한다|
|`-p`, `--procs {N\|auto`}              |N개의 로컬 worker 프로세스를 추가로 생성한다; `auto`는 로컬 CPU 스레드 (논리적 코어) 만큼의 worker 프로세스를 생성한다|
|`--machine-file <file>`                |`<file>`에 나열된 호스트에서 worker 프로세스를 실행한다|
|`-i`                                   |대화형 모드; PEPL을 돌리며 `ininteractive()`는 true이다|
|`-q`, `--quiet`                        |깔끔히 시작하기: 배너 없이, REPL 경고도 안 보여준다|
|`--banner={yes\|no\|auto}`             |시작 배너 사용/사용하지 않는다|
|`--color={yes\|no\|auto}`              |모든 텍스트에 색상을 표시하거나 표시하지 않는다|
|`--history-file={yes\|no}`             |작업내역을 저장하거나 로드한다|
|`--depwarn={yes\|no\|error}`           |문법과 함수가 폐기됐다는 경고를 활성화/비활성화 한다 (`error`는 경고를 에러로 바꾼다)|
|`--warn-overwrite={yes\|no}`           |메소드 오버라이딩 경고를 활성화/비활성화 한다|
|`-C`, `--cpu-target <target>`          |`<target>`까지의 CPU 기능만을 사용한다; 사용 가능한 옵션을 보려면 `help`로 설정|
|`-O`, `--optimize={0,1,2,3}`           |코드 실행시간에 관련된 최적화를 실행한다 (지정되지 않을 경우 2단계 실행, 레벨 이외의 값을 사용할 경우 3단계 실행)|
|`-g`, `-g <level>`                     |디버그 정보 생성 수준을 활성화/비활성화 합니다 (지정되지 않을 경우 레벨 1, 레벨 이외의 값을 사용할 경우 레벨 2)|
|`--inline={yes\|no}`                   |`@inline`으로 선언된 함수를 덮어쓰는 경우를 포함해서, 인라이닝을 허용할지 결정한다|
|`--check-bounds={yes\|no}`             |배열의 경계 체크를 항상 실행/생략한다 (변수 선언을 무시)|
|`--math-mode={ieee,fast}`              |unsafe 부동소수점 최적화를 끄거나 켠다 (@fastmath 선언을 오버라이드한다)|
|`--code-coverage={none\|user\|all}`    |소스 코드 라인의 실행 횟수를 기록한다|
|`--code-coverage`                      |`--code-coverage=user`와 같다|
|`--track-allocation={none\|user\|all}` |각 소스 코드 라인에 의해 할당되는 바이트 수를 기록한다|
|`--track-allocation`                   |`--track-allocation=user`와 같다|

## 참고 자료

줄리아 웹사이트의 [배우기](https://juliakorea.github.io/learning/) 페이지에 사용자가 보면 유용한 자료를 엄선하여 모아두었다.
