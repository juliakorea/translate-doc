# code from https://github.com/JuliaLang/julia/blob/master/doc/make.jl

# Install dependencies needed to build the documentation.
empty!(LOAD_PATH)
push!(LOAD_PATH, @__DIR__, "@stdlib")
empty!(DEPOT_PATH)
pushfirst!(DEPOT_PATH, joinpath(@__DIR__, "deps"))
using Pkg
Pkg.instantiate()

using Documenter, DocumenterLaTeX

include("contrib/html_writer.jl") # Korean customize

baremodule GenStdLib end

# Documenter Setup.

symlink_q(tgt, link) = isfile(link) || symlink(tgt, link)
cp_q(src, dest) = isfile(dest) || cp(src, dest)

# make links for stdlib package docs, this is needed until #552 in Documenter.jl is finished
const STDLIB_DOCS = []
const STDLIB_DIR = Sys.STDLIB
const EXT_STDLIB_DOCS = ["Pkg"]
cd(joinpath(@__DIR__, "src")) do
    # Base.rm("stdlib"; recursive=true, force=true)
    # mkdir("stdlib")
    for dir in readdir(STDLIB_DIR)
        sourcefile = joinpath(STDLIB_DIR, dir, "docs", "src")
        if dir in EXT_STDLIB_DOCS
            sourcefile = joinpath(sourcefile, "basedocs.md")
        else
            sourcefile = joinpath(sourcefile, "index.md")
        end
        if isfile(sourcefile)
            targetfile = joinpath("stdlib", dir * ".md")
            push!(STDLIB_DOCS, (stdlib = Symbol(dir), targetfile = targetfile))
            # if Sys.iswindows()
            #     cp_q(sourcefile, targetfile)
            # else
            #     symlink_q(sourcefile, targetfile)
            # end
        end
    end
end

# Korean text for makedocs
const t_sitename       = "줄리아 언어"
const t_analytics      = "UA-110655381-2" # juliakorea analytic ID
const t_html_canonical = "https://juliakorea.github.io/ko/latest/"

# Korean text in PAGES
const t_Home                    = "홈"
const t_Manual                  = "매뉴얼"
const t_Julia_Documentation     = "줄리아 문서"
const t_Base                    = "Base"
const t_Standard_Library        = "표준 라이브러리"
const t_Developer_Documentation = "개발자 문서"

Manual = [
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
    "manual/asynchronous-programming.md",
    "manual/multi-threading.md",
    "manual/distributed-computing.md",
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
]

BaseDocs = [
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
]

StdlibDocs = [stdlib.targetfile for stdlib in STDLIB_DOCS]

DevDocs = [
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
        "devdocs/isbitsunionarrays.md",
        "devdocs/sysimg.md",
        "devdocs/llvm.md",
        "devdocs/stdio.md",
        "devdocs/boundscheck.md",
        "devdocs/locks.md",
        "devdocs/offset-arrays.md",
        "devdocs/require.md",
        "devdocs/inference.md",
        "devdocs/ssair.md",
        "devdocs/gc-sa.md",
    ],
    "Developing/debugging Julia's C code" => [
        "devdocs/backtraces.md",
        "devdocs/debuggingtips.md",
        "devdocs/valgrind.md",
        "devdocs/sanitizers.md",
    ]
]

# TRAVIS_TAG="1.5.1" julia make.jl pdf
const render_pdf = "pdf" in ARGS

if render_pdf
include("tools/latex.jl")
const PAGES = [
    t_Manual => ["index.md", Manual...],
    t_Base => BaseDocs,
    t_Standard_Library => StdlibDocs,
    t_Developer_Documentation => DevDocs,
    hide("NEWS.md"),
]
else
const PAGES = [
    t_Julia_Documentation => "index.md",
    hide("NEWS.md"),
    t_Manual => Manual,
    t_Base => BaseDocs,
    t_Standard_Library => StdlibDocs,
    t_Developer_Documentation => DevDocs,
]
end

for stdlib in STDLIB_DOCS
    @eval using $(stdlib.stdlib)
end

let r = r"buildroot=(.+)", i = findfirst(x -> occursin(r, x), ARGS)
    global const buildroot = i === nothing ? (@__DIR__) : first(match(r, ARGS[i]).captures)
end

const format = if render_pdf
    LaTeX(
        platform = "texplatform=docker" in ARGS ? "docker" : "native"
    )
else
    Documenter.HTML(
        prettyurls = !("local" in ARGS),
        canonical = t_html_canonical,
        analytics = t_analytics,
        assets = ["assets/julia-manual.css", ],
        collapselevel = 1,
    )
end

makedocs(
    build     = joinpath(pwd(), "local" in ARGS ? "_build_local" : "_build/html/ko/latest"),
    modules   = [Main, Base, Core, [Base.root_module(Base, stdlib.stdlib) for stdlib in STDLIB_DOCS]...],
    clean     = false, # true
    doctest   = ("doctest=fix" in ARGS) ? (:fix) : ("doctest=true" in ARGS) ? true : false,
    linkcheck = "linkcheck=true" in ARGS,
    linkcheck_ignore = ["https://bugs.kde.org/show_bug.cgi?id=136779"], # fails to load from nanosoldier?
    strict    = false, # true,
    checkdocs = :none,
    format    = format,
    sitename  = t_sitename,
    authors   = "The Julia Project",
    pages     = PAGES,
)
