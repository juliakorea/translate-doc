# 시작하기

줄리아의 설치는 어렵지 않다.  미리 컴파일된 실행파일을 이용하거나, 아니면 소스로부터 직접 컴파일하는 두가지 방법이 존재한다. [https://julialang.org/downloads/](https://julialang.org/downloads/)에서
 알려주는 방법에 따라 Julia를 다운로드하고 설치하면 된다.

Julia를 처음 접할 때는 대화형 실행 환경을 통해서 시작하는 것이 가장 쉽게 Julia를 익힐 수 있는 방법이다. 대화형 실행 환경은 단순히 Julia 실행파일을 더블 클릭하거나, 명령창에서 `julia` 명령어를 입력하여 실행할 수 있다.

```
$ julia
               _
   _       _ _(_)_     |  A fresh approach to technical computing
  (_)     | (_) (_)    |  Documentation: https://docs.julialang.org
   _ _   _| |_  __ _   |  Type "?help" for help.
  | | | | | | |/ _` |  |
  | | |_| | | | (_| |  |  Version 0.5.0-dev+2440 (2016-02-01 02:22 UTC)
 _/ |\__'_|_|_|\__'_|  |  Commit 2bb94d6 (11 days old master)
|__/                   |  x86_64-apple-darwin13.1.0

julia> 1 + 2
3

julia> ans
3
```

대화형 실행 환경을 종료하기 위해서는 `^D`(컨트롤 키와 `d` 키를 함께 누른다.) 를 입력하거나 
`quit()`를 대화형 실행 환경 입력창에 타이핑한다. 대화형 실행 환경을 실행하면, 위와 같이 `julia` 배너가 보여지고, 커서창이 사용자의 입력을 기다리며 깜빡이고 있다. 사용자가 `1 + 2`, 와 같은 표현식을 입력한 뒤, 엔터 버튼을 누르는 순간, Julia는 표현식을 평가하고 그 결과를 보여준다. 만약 사용자가 입력한 표현식이 세미콜론(;)으로 끝난다면, 대화형 실행 환경은 결과를 바로 보여주지 않는다. 대신에 `ans` 라는 변수가 결과를 보여주든 보여주지 않든 가장 마지막으로 계산된 표현식의 결과를 저장하고 있다 `ans` 변수는 대화형 실행 환경에서만 존재하며, 다른 방식으로 동작하는 Julia 코드 상에서는 나타나지 않는다.

`file.jl`라는 소스 파일에 저장되어 있는 표현식을 계산하기 위해서는, `include("file.jl")`와 같이 입력한다.

대화형 실행 환경을 이용하지 않고 파일에 저장되어 있는 소스 코드를 실행하기 위해서는, 소스 코드 파일 이름을`julia` 명령어의 첫번째 매개 변수로 넣어서 실행한다.

명령어:

```
$ julia script.jl arg1 arg2...
```

예제와 같이`julia` 실행 명령 뒤에 오는 매개변수들은 전역 상수 `ARGS`라고 불리우는 `script.jl`라는 프로그램의 명령줄 인자로 작동한다. 이 프로그램의 이름은 전역 상수 `PROGRAM_FILE` 에도 설정된다. 또한 `ARGS`는 이 뿐만이 아니라`-e` 옵션을 통해서 julia 스크립트를 실행할 때도 설정할 수 있음을 알 필요가 있다. 그러나 이 경우에는 `PROGRAM_FILE` 은 아무것도 설정되지 않은 채로 실행될 것이다.(아래의 `julia` 도움말을 보도록 하자.) 예를 들어, 단순히 스크립트에 주어진 명령줄 인자를 출력할 때는 다음과 같이 입력하면 된다.

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

Julia는 `-p` 옵션이나 `--machinefile` 옵션을 이용하여 병렬 환경에서 실행시킬 수 있다. `-p n` 옵션은 n개의 worker 프로세스를 생성하지만, `--machinefile file` 옵션은 file의 각 행에 지정된 노드마다 worker를 생성한다. `file` 에 지정된 노드(machine)들은 `ssh` 로그인을 통해 패스워드가 필요없이 실행할 수 있어야 하며, Julia는 현재 호스트와 같은 경로에 설치가 되어 있어야 한다. `file` 에 작성되는 노드는 `[count*][user@]host[:port] [bind_addr[:port]]` 와 같은 형식으로 작성한다. `user` 는 현재 user id를 나타내고, `port` 는 기본 ssh port, `count` 는 각 노드당 생성하는 worker의 개수 (기본값 : 1) `bin-to bind_addr[:port]` 은 선택적인 옵션으로 다른 worker들이 현재의 worker로 연결하기 위해 필요한 특정 ip 주소와 포트를 지정한다.

만약 Julia가 실행할 때마다 실행되는 코드가 있다면, 그 코드를 `~/.juliarc.ji` 에 넣으면 된다.

```
$ echo 'println("Greetings! 你好! 안녕하세요?")' > ~/.juliarc.jl
$ julia
Greetings! 你好! 안녕하세요?

...
```

`perl` 과 `ruby` 와 같이,  Julia 코드를 실행하고 옵션을 지정하는 방법은 다음과 같이 여러가지가 있다.

```
julia [switches] -- [programfile] [args...]
 -v, --version             버전 정보를 표시한다.
 -h, --help                이 메세지를 표시한다.

 -J, --sysimage <file>     <file>이라는 시스템 이미지 파일을 로드한 뒤 실행한다.
 -H, --home <dir>          Set location of `julia` executable
 --startup-file={yes|no}   Load ~/.juliarc.jl
 --handle-signals={yes|no} Enable or disable Julia's default signal handlers
 --sysimage-native-code={yes|no}
                           Use native code from system image if available
 --compiled-modules={yes|no}
                           Enable or disable incremental precompilation of modules

 -e, --eval <expr>         <expr>를 실행만 한다
 -E, --print <expr>        <expr>를 실행하고 표시한다.
 -L, --load <file>         <file>을 모든 프로세서에 로드한다.

 -p, --procs {N|auto}      N개의 worker 프로세스를 추가로 생성한다. "auto"는 현재 Julia를 실행하는 컴퓨터의 최대 코어수만큼 worker 프로세스를 생성한다.
                           
 --machinefile <file>      Run processes on hosts listed in <file>

 -i                        대화형 모드; PEPL을 돌리며 ininteractive()는 true이다.
 -q, --quiet               시작할 때 배너, REPL 경고를 제거한다.
 --banner={yes|no}         Enable or disable startup banner
 --color={yes|no}          Enable or disable color text
 --history-file={yes|no}   Load or save history

 --depwarn={yes|no|error}  Enable or disable syntax and method deprecation warnings ("error" turns warnings into errors)
 --warn-overwrite={yes|no} Enable or disable method overwrite warnings

 -C, --cpu-target <target> Limit usage of cpu features up to <target>; set to "help" to see the available options
 -O, --optimize={0,1,2,3}  Set the optimization level (default level is 2 if unspecified or 3 if used without a level)
 -g, -g <level>            Enable / Set the level of debug info generation (default level is 1 if unspecified or 2 if used without a level)
 --inline={yes|no}         Control whether inlining is permitted, including overriding @inline declarations
 --check-bounds={yes|no}   Emit bounds checks always or never (ignoring declarations)
 --math-mode={ieee,fast}   Disallow or enable unsafe floating point optimizations (overrides @fastmath declaration)

 --code-coverage={none|user|all}, --code-coverage
                           Count executions of source lines (omitting setting is equivalent to "user")
 --track-allocation={none|user|all}, --track-allocation
                           Count bytes allocated by each source line
```

## 읽을거리

이 매뉴얼 뿐만 아니라 Julia를 처음 접하는 사용자들에게 도움을 줄 수 있는 다른 문서를 소개한다.

  * [Julia and IJulia cheatsheet](http://math.mit.edu/~stevenj/Julia-cheatsheet.pdf)
  * [Learn Julia in a few minutes](https://learnxinyminutes.com/docs/julia/)
  * [Learn Julia the Hard Way](https://github.com/chrisvoncsefalvay/learn-julia-the-hard-way)
  * [Julia by Example](http://samuelcolvin.github.io/JuliaByExample/)
  * [Hands-on Julia](https://github.com/dpsanders/hands_on_julia)
  * [Tutorial for Homer Reid's numerical analysis class](http://homerreid.dyndns.org/teaching/18.330/JuliaProgramming.shtml)
  * [An introductory presentation](https://raw.githubusercontent.com/ViralBShah/julia-presentations/master/Fifth-Elephant-2013/Fifth-Elephant-2013.pdf)
  * [Videos from the Julia tutorial at MIT](https://julialang.org/blog/2013/03/julia-tutorial-MIT)
  * [YouTube videos from the JuliaCons](https://www.youtube.com/user/JuliaLanguage/playlists)
