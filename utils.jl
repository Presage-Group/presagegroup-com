include("blog.jl")
include("services.jl")

function hfun_bar(vname)
    val = Meta.parse(vname[1])
    return round(sqrt(val), digits=2)
end

function hfun_m1fill(vname)
    var = vname[1]
    return pagevar("index", var)
end

function lx_baz(com, _)
    # keep this first line
    brace_content = Franklin.content(com.braces[1]) # input string
    # do whatever you want here
    return uppercase(brace_content)
end

@delay function hfun_homepage_posts()
    list = readdir("posts")
    filter!(f -> endswith(f, ".md") && f != "index.md", list)
    posts = []
    df = DateFormat("yyyy-mm-dd")
    for (k, post) in enumerate(list)
        fi = "posts/" * splitext(post)[1]
        title = pagevar(fi, :title)
        datestr = pagevar(fi, :date)
        img = pagevar(fi, :img; default="/assets/Presage_Logo_noTXT.svg")
        if !isnothing(datestr)
            date = Date(datestr, df)
            push!(posts, (
                title=title,
                link=fi,
                date=date,
                img=img
            ))
        end
    end

    eles = sort(posts, by=x -> x.date, rev=true)
    html = ""
    for e in eles[1:3]
        html *= """\n
        <a href="$(e.link)"
        class = "block">
        <blockquote
            class="flex items-center justify-between w-full col-span-1 p-6 bg-white rounded-lg shadow my-2"
            data-rounded="rounded-lg"
            data-rounded-max="rounded-full"

        >
            <div class="flex flex-col pr-8">
                <div class="relative pl-2">
                    <p
                        class="mt-2 text-sm text-gray-600 sm:text-base lg:text-sm xl:text-base"
                    >
                        $(e.title)
                    </p>
                </div>

            <h3
                class="pl-12 mt-3 text-sm font-medium text-gray-800 truncate sm:text-base lg:text-sm lg:text-base"
            >
                Date • $(e.date)
            </h3>
             </div>
            <img
                class="object-cover w-24 h-24 bg-gray-300 rounded-md border"
                src=$(e.img)
            />
        </blockquote>
        </a>\n
        """
    end
    return html
end