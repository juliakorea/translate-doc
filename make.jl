# code from https://github.com/JuliaLang/julia/blob/master/doc/make.jl

# Install dependencies needed to build the documentation.
using Pkg
empty!(DEPOT_PATH)
pushfirst!(DEPOT_PATH, joinpath(@__DIR__, "deps"))
pushfirst!(LOAD_PATH, @__DIR__)

if !isdir(joinpath(@__DIR__, "deps", "packages", "Documenter")) || "deps" in ARGS
    Pkg.instantiate()
    Pkg.add("Documenter")
end

using Documenter
include("contrib/html_writer.jl")

# Include the `build_sysimg` file.

baremodule GenStdLib end
@isdefined(build_sysimg) || @eval module BuildSysImg
    include(joinpath(@__DIR__, "contrib", "build_sysimg.jl"))
end

# make links for stdlib package docs, this is needed until #522 in Documenter.jl is finished
const STDLIB_DIR = normpath(@__DIR__, "..", "julia", "stdlib")
const STDLIB_DOCS = filter(!ismissing, map(readdir(STDLIB_DIR)) do dir
    sourcefile = joinpath(STDLIB_DIR, dir, "docs", "src", "index.md")
    if isfile(sourcefile)
        targetfile = joinpath("stdlib", dir * ".md")
        (stdlib = Symbol(dir), targetfile = targetfile,)
    else
        missing
    end
end)

# Korean text in PAGES
const t_Home     = "홈"
const t_Manual   = "매뉴얼"

const PAGES = [
    t_Home => "index.md",
    hide("NEWS.md"),
    t_Manual => [
        "manual/getting-started.md",
        "manual/variables.md",
        "manual/integers-and-floating-point-numbers.md",
        "manual/mathematical-operations.md",
        "manual/complex-and-rational-numbers.md",
        "manual/strings.md",
        "manual/functions.md",
        "manual/control-flow.md",
        "manual/variables-and-scoping.md",
        "manual/types.md",
        "manual/methods.md",
        "manual/constructors.md",
        "manual/conversion-and-promotion.md",
        "manual/interfaces.md",
        "manual/modules.md",
        "manual/documentation.md",
        "manual/metaprogramming.md",
        "manual/arrays.md",
        "manual/missing.md",
        "manual/networking-and-streams.md",
        "manual/parallel-computing.md",
        "manual/running-external-programs.md",
        "manual/calling-c-and-fortran-code.md",
        "manual/handling-operating-system-variation.md",
        "manual/environment-variables.md",
        "manual/embedding.md",
        "manual/code-loading.md",
        "manual/profile.md",
        "manual/stacktraces.md",
        "manual/performance-tips.md",
        "manual/workflow-tips.md",
        "manual/style-guide.md",
        "manual/faq.md",
        "manual/noteworthy-differences.md",
        "manual/unicode-input.md",
    ],
    "Base" => [
        "base/base.md",
        "base/collections.md",
        "base/math.md",
        "base/numbers.md",
        "base/strings.md",
        "base/arrays.md",
        "base/parallel.md",
        "base/multi-threading.md",
        "base/constants.md",
        "base/file.md",
        "base/io-network.md",
        "base/punctuation.md",
        "base/sort.md",
        "base/iterators.md",
        "base/c.md",
        "base/libc.md",
        "base/stacktraces.md",
        "base/simd-types.md",
    ],
    "Standard Library" =>
        [stdlib.targetfile for stdlib in STDLIB_DOCS],
    "Developer Documentation" => [
        "devdocs/reflection.md",
        "Documentation of Julia's Internals" => [
            "devdocs/init.md",
            "devdocs/ast.md",
            "devdocs/types.md",
            "devdocs/object.md",
            "devdocs/eval.md",
            "devdocs/callconv.md",
            "devdocs/compiler.md",
            "devdocs/functions.md",
            "devdocs/cartesian.md",
            "devdocs/meta.md",
            "devdocs/subarrays.md",
            "devdocs/sysimg.md",
            "devdocs/llvm.md",
            "devdocs/stdio.md",
            "devdocs/boundscheck.md",
            "devdocs/locks.md",
            "devdocs/offset-arrays.md",
            "devdocs/require.md",
            "devdocs/inference.md",
            "devdocs/ssair.md", # Julia SSA-form IR
        ],
        "Developing/debugging Julia's C code" => [
            "devdocs/backtraces.md",
            "devdocs/debuggingtips.md",
            "devdocs/valgrind.md",
            "devdocs/sanitizers.md",
        ]
    ],
]

for stdlib in STDLIB_DOCS
    @eval using $(stdlib.stdlib)
end

# Korean text for makedocs
const t_sitename       = "줄리아 언어"
const t_analytics      = "UA-110655381-2" # juliakorea analytic ID
const t_html_canonical = "https://juliakorea.github.io/ko/latest/"

makedocs(
    build     = joinpath(pwd(), "local" in ARGS ? "_build_local" : "_build/html/ko/latest"),
    modules   = [Base, Core, BuildSysImg, [Base.root_module(Base, stdlib.stdlib) for stdlib in STDLIB_DOCS]...],
    clean     = false, # true
    doctest   = ("doctest=fix" in ARGS) ? (:fix) : ("doctest=true" in ARGS) ? true : false,
    linkcheck = "linkcheck=true" in ARGS,
    linkcheck_ignore = ["https://bugs.kde.org/show_bug.cgi?id=136779"], # fails to load from nanosoldier?
    strict    = true,
    checkdocs = :none,
    format    = "pdf" in ARGS ? :latex : :html,
    sitename  = t_sitename,
    authors   = "The Julia Project",
    analytics = t_analytics,
    pages     = PAGES,
    html_prettyurls = !("local" in ARGS),
    html_canonical = t_html_canonical,
    assets = ["assets/julia-manual.css", ]
)
