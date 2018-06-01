# check_codex.jl
# diff between  translate-doc/codex  and  ../julia/doc

const TOP_PATH = abspath(dirname(@__FILE__), "..")
const JULIA_PATH = abspath(TOP_PATH, "..", "julia")

const required_julia_version = v"0.7.0-alpha"
if !(VERSION >= required_julia_version)
    println("Run with Julia ", required_julia_version)
end

if !isdir(JULIA_PATH)
    println("Requires Julia repository at $JULIA_PATH")
end

const codex_path = abspath(TOP_PATH, "codex")
const src_path = abspath(TOP_PATH, "src")
const julia_doc_src_path = abspath(JULIA_PATH, "doc", "src")
translated_files = []

function check_src_and_codex(path1, path2)
    ignore_assets = ["custom.css"]
    src_codex_diff = `diff -qr $path1 $path2`
    lines = readlines(ignorestatus(src_codex_diff))
    for line in lines
        chunk = split(line, " ")
        if length(chunk) > 1
            (kind,) = chunk
            if kind == "Files"
                (_,_,_,nubble) = chunk
                nub = nubble[length(codex_path)+2:end]
                push!(translated_files, nub)
            elseif kind == "Only"
                (_,_,dircolon,filename) = chunk
                dir = replace(dircolon, ":" => "/")
                if occursin(src_path, dir)
                    if endswith(filename, ".swp")
                        continue
                    elseif !(filename in ignore_assets)
                        #print_with_color(:red, "rm ")
                        #print_with_color(:white, dir)
                        #print_with_color(:yellow, filename)
                        print("rm ", dir, filename)
                        println()
                    end
                end
            end
        end
    end
end

function copy_julia_doc_src_to_codex_and_src(julia_doc_src_dir, filename)
    for d in (codex_path, src_path)
        dir = replace(julia_doc_src_dir, julia_doc_src_path => d)
        #print_with_color(:cyan, "cp ")
        #print_with_color(:white, julia_doc_src_dir)
        #print_with_color(:yellow, filename, " ")
        #print_with_color(:white, dir)
        #print_with_color(:yellow, filename)
        print("cp ", julia_doc_src_dir, filename, " ", dir, filename)
        println()
    end
end

function manual_julia_doc_src_to_codex(julia_doc_src_dir, filename)
    dir = replace(julia_doc_src_dir, julia_doc_src_path => codex_path)
    #print_with_color(:blue, "# diff ")
    #print_with_color(:white, dir)
    #print_with_color(:yellow, filename, " ")
    #print_with_color(:white, julia_doc_src_dir)
    #print_with_color(:yellow, filename)
    print("# diff -u ", dir, filename, " ", julia_doc_src_dir, filename)
    println()
    edit_dir = replace(julia_doc_src_dir, julia_doc_src_path => src_path)
    #print_with_color(:blue, "# edit ")
    #print_with_color(:white, edit_dir)
    #print_with_color(:yellow, filename)
    print("# edit ", edit_dir, filename)
    println()
    print("# cp ", julia_doc_src_dir, filename, " ", dir, filename)
    println()
end


function check_julia_doc_src_and_codex(path1, path2)
    julia_doc_src_codex_diff = `diff -qr $path1 $path2`
    lines = readlines(ignorestatus(julia_doc_src_codex_diff))
    for line in lines
        chunk = split(line, " ")
        if length(chunk) > 1
            (kind,) = chunk
            if kind == "Files"
                (_,julia_doc_src_file,_,nubble) = chunk
                nub = nubble[length(codex_path)+2:end]
                dir, filename = splitdir(julia_doc_src_file)
                julia_doc_src_dir = string(dir, "/")
                if nub in translated_files
                    manual_julia_doc_src_to_codex(julia_doc_src_dir, filename)
                else
                    if ".gitignore" != filename
                        copy_julia_doc_src_to_codex_and_src(julia_doc_src_dir, filename)
                    end
                end
            elseif kind == "Only"
                (_,_,dircolon,filename) = chunk
                if endswith(filename, ".swp")
                    continue
                end
                dir = replace(dircolon, ":" => "/")
                if occursin(codex_path, dir)
                    for d in (dir, replace(dir, codex_path => src_path))
                        #print_with_color(:red, "rm ")
                        #print_with_color(:white, d)
                        #print_with_color(:yellow, filename)
                        print("rm ", d, filename)
                        println()
                    end
                elseif occursin(julia_doc_src_path, dir)
                    copy_julia_doc_src_to_codex_and_src(dir, filename)
                end
            end
        end
    end
end

function get_pages(f, path)
    s = read(path, String)
    r = Regex("const (PAGES = .*^\\])", "ms")
    m = match(r, s)
    s = string("hide(s) = nothing; STDLIB_DOCS = []; ", m[1])
    eval(Meta.parse(f(s)))
end

function check_pages()
    makejl_path = abspath(TOP_PATH, "make.jl")
    julia_doc_makejl_path = abspath(JULIA_PATH, "doc", "make.jl")
    pages1 = get_pages(julia_doc_makejl_path) do s; s end
    pages2 = get_pages(makejl_path) do s
        for (a,b) in [("t_Home", "\"Home\""),
                      ("t_Manual", "\"Manual\""),
                      ("\"devdocs/ssair.md\", # Julia SSA-form IR", ""), # temporal
                     ]
            s = replace(s, a => b)
        end
        s
    end
    if pages1 == pages2
    else
        @info "pages" setdiff(pages1, pages2)
    end
end

const src_stdlib_path = abspath(src_path, "stdlib")
const codex_stdlib_path = abspath(codex_path, "stdlib")
const julia_doc_src_stdlib_path = abspath(JULIA_PATH, "doc", "src", "stdlib")

check_pages()
check_src_and_codex(src_path, codex_path)
check_julia_doc_src_and_codex(julia_doc_src_path, codex_path)
