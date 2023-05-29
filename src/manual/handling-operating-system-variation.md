# 운영체제 변수 다루기

크로스 플랫폼(cross-plaform) 어플리케이션이나 라이브러리 설계는 운영체제 간의 작동방식을 다르게 할 필요가 생기기도 하다.
`Sys.KERNEL` 변수는 이런 상황을 다룰 때 사용한다.
`Sys` 모듈은 `Sys.KERNEL`변수를 더 편리하게 사용하기 위해 `isunix`, `islinux`, `isapple`, `isbsd`, `isfreebsd`, `iswindows`같은 함수를 지원한다:

```julia
if Sys.iswindows()
    windows_specific_thing(a)
end
```

`islinux`, `isapple`,`isfreebsd`은 `isunix`의 상호 배타적 부분 집합이다.

`@static` 매크로를 사용하여 특정 조건을 만족하지 않으면 함수를 실행하지 못하게 할 수 있다:

Simple blocks:

```
ccall((@static Sys.iswindows() ? :_fopen : :fopen), ...)
```

Complex blocks:

```julia
@static if Sys.islinux()
    linux_specific_thing(a)
else
    generic_thing(a)
end
```

조건문을 여럿 사용하는 경우 (`if`/`elseif`/`end`포함) `@static`을 각 단계마다 작성해야 한다 (괄호는 필요없지만 가독성을 위해 추천한다):

```julia
@static Sys.iswindows() ? :a : (@static Sys.isapple() ? :b : :c)
```

