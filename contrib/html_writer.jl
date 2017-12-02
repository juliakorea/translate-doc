# override Documenter.jl/src/Writers/HTMLWriter.jl

import Documenter: Anchors, Builder, Documents, Expanders, Formats, Documenter, Utilities, Writers
import Documenter.Utilities.DOM: DOM, Tag, @tags
import Documenter.Writers.HTMLWriter: pagetitle, mdconvert, navhref, getpage, render_topbar, domify

function Documenter.Writers.HTMLWriter.render_article(ctx, navnode)
    @tags article header footer nav ul li hr span a

    header_links = map(Documents.navpath(navnode)) do nn
        title = mdconvert(pagetitle(ctx, nn); droplinks=true)
        nn.page === nothing ? li(title) : li(a[:href => navhref(ctx, nn, navnode)](title))
    end

    topnav = nav(ul(header_links))

    # Set the logo and name for the "Edit on.." button. We assume GitHub as a host.
    host = "GitHub"
    logo = "\uf09b"

    host_type = Utilities.repo_host_from_url(ctx.doc.user.repo)
    if host_type == Utilities.RepoGitlab
        host = "GitLab"
        logo = "\uf296"
    elseif host_type == Utilities.RepoBitbucket
        host = "BitBucket"
        logo = "\uf171"
    end

    if !ctx.doc.user.html_disable_git
        url = Utilities.url(ctx.doc.user.repo, getpage(ctx, navnode).source, commit=ctx.doc.user.html_edit_branch)
        if url !== nothing
            push!(topnav.nodes, a[".edit-page", :href => url](span[".fa"](logo), " Edit on $host"))
        end
    end
    art_header = header(topnav, hr(), render_topbar(ctx, navnode))

    # build the footer with nav links
    art_footer = footer(hr())
    if navnode.prev !== nothing
        direction = span[".direction"]("이전글") # Previous
        title = span[".title"](mdconvert(pagetitle(ctx, navnode.prev); droplinks=true))
        link = a[".previous", :href => navhref(ctx, navnode.prev, navnode)](direction, title)
        push!(art_footer.nodes, link)
    end

    if navnode.next !== nothing
        direction = span[".direction"]("다음글") # Next
        title = span[".title"](mdconvert(pagetitle(ctx, navnode.next); droplinks=true))
        link = a[".next", :href => navhref(ctx, navnode.next, navnode)](direction, title)
        push!(art_footer.nodes, link)
    end

    pagenodes = domify(ctx, navnode)
    article["#docs"](art_header, pagenodes, art_footer)
end
