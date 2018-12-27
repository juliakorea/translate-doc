# override Documenter.jl/src/Writers/HTMLWriter.jl

import Documenter: Anchors, Builder, Documents, Expanders, Documenter, Utilities, Writers
import Documenter.Utilities.DOM: DOM, Tag, @tags
import Documenter.Writers.HTMLWriter: pagetitle, domify, open_output
import Documenter.Writers.HTMLWriter: navhref, relhref
import Documenter.Writers.HTMLWriter: mdconvert, mdflatten
import Documenter.Writers.HTMLWriter: getpage, get_url
import Documenter.Writers.HTMLWriter: render_head, render_topbar, render_navmenu, render_article
import Documenter.Writers.HTMLWriter: normalize_css, google_fonts, fontawesome_css, highlightjs_css
import Documenter.Writers.HTMLWriter: analytics_script, requirejs_cdn, asset_links
import Documenter.Writers.HTMLWriter: canonical_link_element

function Documenter.Writers.HTMLWriter.render_head(ctx, navnode)
    @tags head meta link script title
    src = get_url(ctx, navnode)

    page_title = "$(mdflatten(pagetitle(ctx, navnode))) · $(ctx.doc.user.sitename)"
    css_links = [
        normalize_css,
        google_fonts,
        fontawesome_css,
        highlightjs_css,
    ]
    head(
        meta[:charset=>"UTF-8"],
        meta[:name => "viewport", :content => "width=device-width, initial-scale=1.0"],
        title(page_title),

        analytics_script(ctx.doc.user.analytics),

        canonical_link_element(ctx.settings.canonical, src),

        # Stylesheets.
        map(css_links) do each
            link[:href => each, :rel => "stylesheet", :type => "text/css"]

        end,

        script("documenterBaseURL=\"$(relhref(src, "."))\""),
        script[
            :src => requirejs_cdn,
            Symbol("data-main") => relhref(src, ctx.documenter_js)
        ],

        script[:src => relhref(src, "siteinfo.js")],
        script[:src => relhref(src, "../versions.js")],

        # Custom user-provided assets.
        asset_links(src, ctx.local_assets),

        # juliakorea custom css
        link[:href => relhref(src, "assets/custom.css"), :rel => "stylesheet", :type => "text/css"],

        # juliakorea Korean word break
        script[:src => "/js/jquery-1.8.3.min.js"],
        script[:src => "/js/jquery.word-break-keep-all.min.js"],
        script("\$(document).ready(function() { \$('p').wordBreakKeepAll(); });")
    )
end

function Documenter.Writers.HTMLWriter.render_page(ctx, navnode)
    @tags html body

    page = getpage(ctx, navnode)

    head = render_head(ctx, navnode)
    navmenu = render_navmenu(ctx, navnode)
    article = render_article(ctx, navnode)

    htmldoc = DOM.HTMLDocument(
        html[:lang=>"ko"](
            head,
            body(navmenu, article)
        )
    )

    open_output(ctx, navnode) do io
        print(io, htmldoc)
    end
end

const t_Previous = "이전글"
const t_Next     = "다음글"
t_Edit_on(host)  = " Edit on $host"

function Documenter.Writers.HTMLWriter.render_article(ctx, navnode)
    @tags article header footer nav ul li hr span a

    header_links = map(Documents.navpath(navnode)) do nn
        title = mdconvert(pagetitle(ctx, nn); droplinks=true)
        nn.page === nothing ? li(title) : li(a[:href => navhref(ctx, nn, navnode)](title))
    end

    topnav = nav(ul(header_links))

    # Set the logo and name for the "Edit on.." button.
    host_type = Utilities.repo_host_from_url(ctx.doc.user.repo)
    if host_type == Utilities.RepoGitlab
        host = "GitLab"
        logo = "\uf296"
    elseif host_type == Utilities.RepoGithub
        host = "GitHub"
        logo = "\uf09b"
    elseif host_type == Utilities.RepoBitbucket
        host = "BitBucket"
        logo = "\uf171"
    else
        host = ""
        logo = "\uf15c"
    end
    hoststring = isempty(host) ? " source" : " on $(host)"

    if !ctx.settings.disable_git
        pageurl = get(getpage(ctx, navnode).globals.meta, :EditURL, getpage(ctx, navnode).source)
        if Utilities.isabsurl(pageurl)
            url = pageurl
        else
            if !(pageurl == getpage(ctx, navnode).source)
                # need to set users path relative the page itself
                pageurl = joinpath(first(splitdir(getpage(ctx, navnode).source)), pageurl)
            end
            url = Utilities.url(ctx.doc.user.repo, pageurl, commit=ctx.settings.edit_branch)
        end
        if url !== nothing
            edit_verb = (ctx.settings.edit_branch === nothing) ? "View" : "Edit"
            push!(topnav.nodes, a[".edit-page", :href => url](span[".fa"](logo), " $(edit_verb)$hoststring"))
        end
    end
    art_header = header(topnav, hr(), render_topbar(ctx, navnode))

    # build the footer with nav links
    art_footer = footer(hr())
    if navnode.prev !== nothing
        direction = span[".direction"](t_Previous)
        title = span[".title"](mdconvert(pagetitle(ctx, navnode.prev); droplinks=true))
        link = a[".previous", :href => navhref(ctx, navnode.prev, navnode)](direction, title)
        push!(art_footer.nodes, link)
    end

    if navnode.next !== nothing
        direction = span[".direction"](t_Next)
        title = span[".title"](mdconvert(pagetitle(ctx, navnode.next); droplinks=true))
        link = a[".next", :href => navhref(ctx, navnode.next, navnode)](direction, title)
        push!(art_footer.nodes, link)
    end

    pagenodes = domify(ctx, navnode)
    article["#docs"](art_header, pagenodes, art_footer)
end
