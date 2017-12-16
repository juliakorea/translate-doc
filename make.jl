# Install dependencies needed to build the documentation.
ENV["JULIA_PKGDIR"] = joinpath(@__DIR__, "deps")

if "deps" in ARGS
Pkg.init()
cp(joinpath(@__DIR__, "REQUIRE"), Pkg.dir("REQUIRE"); remove_destination = true)
Pkg.update()
Pkg.resolve()
end

using Documenter
include("contrib/html_writer.jl")

# Include the `build_sysimg` file.

baremodule GenStdLib end
@isdefined(build_sysimg) || @eval module BuildSysImg
    include(joinpath(@__DIR__, "contrib", "build_sysimg.jl"))
end

const PAGES = [
    "Home" => "index.md",
    "Manual" => [
        "manual/introduction.md",
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
        "manual/linear-algebra.md",
        "manual/missing.md",
        "manual/networking-and-streams.md",
        "manual/parallel-computing.md",
        "manual/dates.md",
        "manual/interacting-with-julia.md",
        "manual/running-external-programs.md",
        "manual/calling-c-and-fortran-code.md",
        "manual/handling-operating-system-variation.md",
        "manual/environment-variables.md",
        "manual/embedding.md",
        "manual/packages.md",
        "manual/profile.md",
        "manual/stacktraces.md",
        "manual/performance-tips.md",
        "manual/workflow-tips.md",
        "manual/style-guide.md",
        "manual/faq.md",
        "manual/noteworthy-differences.md",
        "manual/unicode-input.md",
    ],
    "Standard Library" => [
        "stdlib/base.md",
        "stdlib/collections.md",
        "stdlib/math.md",
        "stdlib/numbers.md",
        "stdlib/strings.md",
        "stdlib/arrays.md",
        "stdlib/parallel.md",
        "stdlib/distributed.md",
        "stdlib/multi-threading.md",
        "stdlib/linalg.md",
        "stdlib/constants.md",
        "stdlib/file.md",
        "stdlib/delimitedfiles.md",
        "stdlib/io-network.md",
        "stdlib/punctuation.md",
        "stdlib/sort.md",
        "stdlib/pkg.md",
        "stdlib/dates.md",
        "stdlib/iterators.md",
        "stdlib/test.md",
        "stdlib/c.md",
        "stdlib/libc.md",
        "stdlib/libdl.md",
        "stdlib/profile.md",
        "stdlib/stacktraces.md",
        "stdlib/simd-types.md",
        "stdlib/base64.md",
        "stdlib/mmap.md",
        "stdlib/sharedarrays.md",
        "stdlib/filewatching.md",
        "stdlib/crc32c.md",
        "stdlib/iterativeeigensolvers.md",
        "stdlib/unicode.md",
    ],
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
            "devdocs/libgit2.md",
            "devdocs/require.md",
            "devdocs/inference.md",
        ],
        "Developing/debugging Julia's C code" => [
            "devdocs/backtraces.md",
            "devdocs/debuggingtips.md",
            "devdocs/valgrind.md",
            "devdocs/sanitizers.md",
        ]
    ],
]

using DelimitedFiles, Test, Mmap, SharedArrays, Profile, Base64, FileWatching, CRC32c,
      Dates, IterativeEigensolvers, Unicode, Distributed

makedocs(
    build     = joinpath(pwd(), "_build/html/ko"),
    modules   = [Base, Core, BuildSysImg, DelimitedFiles, Test, Mmap, SharedArrays, Profile,
                 Base64, FileWatching, Dates, IterativeEigensolvers, Unicode, Distributed],
    clean     = false,
    doctest   = "doctest" in ARGS,
    linkcheck = "linkcheck" in ARGS,
    linkcheck_ignore = ["https://bugs.kde.org/show_bug.cgi?id=136779"], # fails to load from nanosoldier?
    strict    = false,
    checkdocs = :none,
    format    = "pdf" in ARGS ? :latex : :html,
    sitename  = "The Julia Language",
    authors   = "The Julia Project",
    analytics = "UA-110655381-2", # juliakorea 추척 ID
    pages     = PAGES,
    html_prettyurls = ("deploy" in ARGS),
)
