# check_codex.jl
# translate-doc/codex와 ../julia/doc을 비교하는 스크립트

const TOP_PATH = abspath(dirname(@__FILE__), "..")
const JULIA_PATH = abspath(TOP_PATH, "..", "julia")

if !(VERSION >= v"0.7.0-DEV")
    println("Julia ", v"0.7.0-DEV", " 버젼으로 실행하세요")
end

if !isdir(JULIA_PATH)
    println("줄리아 리파지토리 경로를 지정해 주세요 $JULIA_PATH")
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
                # src에만 있으면 src에 있는 파일 지우기
                if contains(dir, src_path)
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
                # codex에만 있으면 codex, src에 있는 파일 지우기
                if contains(dir, codex_path)
                    for d in (dir, replace(dir, codex_path => src_path))
                        #print_with_color(:red, "rm ")
                        #print_with_color(:white, d)
                        #print_with_color(:yellow, filename)
                        print("rm ", d, filename)
                        println()
                    end
                # julia_doc_src에만 있으면 codex, src에 복사
                elseif contains(dir, julia_doc_src_path)
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
        for (a,b) in [("홈", "Home"),
                      ("매뉴얼", "Manual"),
                      ("\"devdocs/ssair.md\", # Julia SSA-form IR", ""), # 임시
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
