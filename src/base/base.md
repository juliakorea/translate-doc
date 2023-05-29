# 기본 골자

## 소개

Julia Base contains a range of functions and macros appropriate for performing
scientific and numerical computing, but is also as broad as those of many general purpose programming
languages. Additional functionality is available from a growing collection of available packages.
Functions are grouped by topic below. 함수들은 아래의 주제별로 묶여있다.

몇몇의 기본 사항은 다음과 같다:

  * 모듈의 함수를 사용하기 위해서는 `import Module`로 모듈을 가지고 와서(import), `Module.fn(x)`의 형식으로 사용하면 된다.
  * 다른 방법으로, `using Module`을 사용하면 현재의 namespace에서 `Module`의 모든 (all exported) 함수를 사용할 수 있다.
  * 관습적으로(by convention), 느낌표(`!`)로 그 이름이 끝나는 함수는 전달받은 전달인자(arguments)의 값을 바꾼다.
    몇몇 함수는 바꾸는 경우(e.g., `sort!`)와 바꾸지 않는 경우(`sort`)의 두 가지 버전을 모두 갖는다.

## Getting Around

```@docs
Base.exit
Base.atexit
Base.isinteractive
Base.summarysize
Base.require
Base.compilecache
Base.__precompile__
Base.include
Base.MainInclude.include
Base.include_string
Base.include_dependency
Base.which(::Any, ::Any)
Base.methods
Base.@show
ans
```

## 주요 단어들

아래의 단어 목록은 줄리아의 예약어(reserved keyword) 목록이다:
`baremodule`, `begin`, `break`, `catch`, `const`, `continue`, `do`,
`else`, `elseif`, `end`, `export`, `false`, `finally`, `for`, `function`,
`global`, `if`, `import`, `let`, `local`, `macro`, `module`, `quote`,
`return`, `struct`, `true`, `try`, `using`, `while`.
이 단어들은 변수 이름으로 사용하는 것이 불가하다.

아래의 연속된 두 단어짜리 구 전체는 예약어이다 (따라서 변수 이름으로 사용할 수 없다.):
`abstract type`, `mutable struct`, `primitive type`.
하지만, 아래의 이름으로 변수를 만드는 것은 가능하다:
`abstract`, `mutable`, `primitive`, and `type`.

마지막으로, Finally, `where`는 parametric method나 type 정의를 적을 때 중위 연산자(infix operator)로 구문분석된다(is parsed).
`in`과 `isa` 또한 중위 연산자로 구문분석된다.
그러나 `where`, `in` 혹은 `isa`로 변수 이름을 짓는 것은 허용된다.

```@docs
module
export
import
using
baremodule
function
macro
return
do
begin
end
let
if
for
while
break
continue
try
finally
quote
local
global
const
struct
mutable struct
abstract type
primitive type
where
...
;
=
```

## Standard Modules
```@docs
Main
Core
Base
```

## Base Submodules
```@docs
Base.Broadcast
Base.Docs
Base.Iterators
Base.Libc
Base.Meta
Base.StackTraces
Base.Sys
Base.Threads
Base.GC
```

## All Objects

```@docs
Core.:(===)
Core.isa
Base.isequal
Base.isless
Base.ifelse
Core.typeassert
Core.typeof
Core.tuple
Base.ntuple
Base.objectid
Base.hash
Base.finalizer
Base.finalize
Base.copy
Base.deepcopy
Base.getproperty
Base.setproperty!
Base.propertynames
Base.hasproperty
Core.getfield
Core.setfield!
Core.isdefined
Base.@isdefined
Base.convert
Base.promote
Base.oftype
Base.widen
Base.identity
```

## Properties of Types

### Type relations

```@docs
Base.supertype
Core.:(<:)
Base.:(>:)
Base.typejoin
Base.typeintersect
Base.promote_type
Base.promote_rule
Base.isdispatchtuple
```

### Declared structure

```@docs
Base.isimmutable
Base.isabstracttype
Base.isprimitivetype
Base.issingletontype
Base.isstructtype
Base.nameof(::DataType)
Base.fieldnames
Base.fieldname
Base.hasfield
```

### Memory layout

```@docs
Base.sizeof(::Type)
Base.isconcretetype
Base.isbits
Base.isbitstype
Core.fieldtype
Base.fieldtypes
Base.fieldcount
Base.fieldoffset
Base.datatype_alignment
Base.datatype_haspadding
Base.datatype_pointerfree
```

### Special values

```@docs
Base.typemin
Base.typemax
Base.floatmin
Base.floatmax
Base.maxintfloat
Base.eps(::Type{<:AbstractFloat})
Base.eps(::AbstractFloat)
Base.instances
```

## Special Types

```@docs
Core.Any
Core.Union
Union{}
Core.UnionAll
Core.Tuple
Core.NamedTuple
Base.Val
Core.Vararg
Core.Nothing
Base.isnothing
Base.Some
Base.something
Base.Enums.Enum
Base.Enums.@enum
Core.Expr
Core.Symbol
Core.Symbol(x...)
Core.Module
```

## Generic Functions

```@docs
Core.Function
Base.hasmethod
Core.applicable
Core.invoke
Base.invokelatest
new
Base.:(|>)
Base.:(∘)
```

## Syntax

```@docs
Core.eval
Base.MainInclude.eval
Base.@eval
Base.evalfile
Base.esc
Base.@inbounds
Base.@boundscheck
Base.@propagate_inbounds
Base.@inline
Base.@noinline
Base.@nospecialize
Base.@specialize
Base.gensym
Base.@gensym
Base.@goto
Base.@label
Base.@simd
Base.@polly
Base.@generated
Base.@pure
Base.@deprecate
```

## Missing Values
```@docs
Base.Missing
Base.missing
Base.coalesce
Base.ismissing
Base.skipmissing
```

## System

```@docs
Base.run
Base.devnull
Base.success
Base.process_running
Base.process_exited
Base.kill(::Base.Process, ::Integer)
Base.Sys.set_process_title
Base.Sys.get_process_title
Base.ignorestatus
Base.detach
Base.Cmd
Base.setenv
Base.withenv
Base.pipeline(::Any, ::Any, ::Any, ::Any...)
Base.pipeline(::Base.AbstractCmd)
Base.Libc.gethostname
Base.Libc.getpid
Base.Libc.time()
Base.time_ns
Base.@time
Base.@timev
Base.@timed
Base.@elapsed
Base.@allocated
Base.EnvDict
Base.ENV
Base.Sys.isunix
Base.Sys.isapple
Base.Sys.islinux
Base.Sys.isbsd
Base.Sys.isfreebsd
Base.Sys.isopenbsd
Base.Sys.isnetbsd
Base.Sys.isdragonfly
Base.Sys.iswindows
Base.Sys.windows_version
Base.Sys.free_memory
Base.Sys.total_memory
Base.@static
```

## Versioning

```@docs
Base.VersionNumber
Base.@v_str
```

## Errors

```@docs
Base.error
Core.throw
Base.rethrow
Base.backtrace
Base.catch_backtrace
Base.catch_stack
Base.@assert
Base.ArgumentError
Base.AssertionError
Core.BoundsError
Base.CompositeException
Base.DimensionMismatch
Core.DivideError
Core.DomainError
Base.EOFError
Core.ErrorException
Core.InexactError
Core.InterruptException
Base.KeyError
Base.LoadError
Base.MethodError
Base.MissingException
Core.OutOfMemoryError
Core.ReadOnlyMemoryError
Core.OverflowError
Base.ProcessFailedException
Core.StackOverflowError
Base.SystemError
Core.TypeError
Core.UndefKeywordError
Core.UndefRefError
Core.UndefVarError
Base.StringIndexError
Base.InitError
Base.retry
Base.ExponentialBackOff
```

## Events

```@docs
Base.Timer(::Function, ::Real)
Base.Timer
Base.AsyncCondition
Base.AsyncCondition(::Function)
```

## Reflection

```@docs
Base.nameof(::Module)
Base.parentmodule
Base.pathof(::Module)
Base.moduleroot
Base.@__MODULE__
Base.fullname
Base.names
Core.nfields
Base.isconst
Base.nameof(::Function)
Base.functionloc(::Any, ::Any)
Base.functionloc(::Method)
```

## Internals

```@docs
Base.GC.gc
Base.GC.enable
Base.GC.@preserve
Meta.lower
Meta.@lower
Meta.parse(::AbstractString, ::Int)
Meta.parse(::AbstractString)
Meta.ParseError
Core.QuoteNode
Base.macroexpand
Base.@macroexpand
Base.@macroexpand1
Base.code_lowered
Base.code_typed
Base.precompile
```

## Meta
```@docs
Meta.quot
Meta.isexpr
Meta.show_sexpr
```
