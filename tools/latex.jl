# to change the STYLE file from Documenter.jl/src/Writers/LaTeXWriter.jl
const KR_STYLE = normpath(@__DIR__, "documenter.sty")

using Documenter.Writers.LaTeXWriter
using .LaTeXWriter: DOCUMENT_STRUCTURE, Documents, LaTeX, Context, writeheader, writefooter, files, latex, compile_tex, _println

function LaTeXWriter.render(doc::Documents.Document, settings::LaTeX=LaTeX())
    @info "LaTeXWriter: creating the LaTeX file."
    Base.mktempdir() do path
        cp(joinpath(doc.user.root, doc.user.build), joinpath(path, "build"))
        cd(joinpath(path, "build")) do
            name = "julia" # doc.user.sitename
            let tag = get(ENV, "TRAVIS_TAG", "")
                if occursin(Base.VERSION_REGEX, tag)
                    v = VersionNumber(tag)
                    name *= "-$(v.major).$(v.minor).$(v.patch)"
                end
            end
            name = replace(name, " " => "")
            texfile = name * ".tex"
            pdffile = name * ".pdf"
            open(texfile, "w") do io
                context = Context(io)
                writeheader(context, doc)
                for (title, filename, depth) in files(doc.user.pages)
                    context.filename = filename
                    empty!(context.footnotes)
                    if 1 <= depth <= length(DOCUMENT_STRUCTURE)
                        header_type = DOCUMENT_STRUCTURE[depth]
                        header_text = "\n\\$(header_type){$(title)}\n"
                        if isempty(filename)
                            _println(context, header_text)
                        else
                            path = normpath(filename)
                            page = doc.blueprint.pages[path]
                            if get(page.globals.meta, :IgnorePage, :none) !== :latex
                                context.depth = depth + (isempty(title) ? 0 : 1)
                                context.depth > depth && _println(context, header_text)
                                latex(context, page, doc)
                            end
                        end
                    end
                end
                writefooter(context, doc)
            end
            cp(KR_STYLE, "documenter.sty")

            # compile .tex
            status = compile_tex(doc, settings, texfile)

            # Debug: if DOCUMENTER_LATEX_DEBUG environment variable is set, copy the LaTeX
            # source files over to a directory under doc.user.root.
            if haskey(ENV, "DOCUMENTER_LATEX_DEBUG")
                dst = isempty(ENV["DOCUMENTER_LATEX_DEBUG"]) ? mktempdir(doc.user.root) :
                    joinpath(doc.user.root, ENV["DOCUMENTER_LATEX_DEBUG"])
                sources = cp(pwd(), dst, force=true)
                @info "LaTeX sources copied for debugging to $(sources)"
            end

            # If the build was successful, copy the PDF or the LaTeX source to the .build directory
            if status && (settings.platform != "none")
                cp(pdffile, joinpath(doc.user.root, doc.user.build, pdffile); force = true)
            elseif status && (settings.platform == "none")
                cp(pwd(), joinpath(doc.user.root, doc.user.build); force = true)
            else
                error("Compiling the .tex file failed. See logs for more information.")
            end
        end
    end
end
