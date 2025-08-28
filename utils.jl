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
    for e in eles[1:2]
        html *= """\n
        <a href="$(e.link)" class="block">
          <blockquote
            class="flex w-full col-span-1 bg-white rounded-lg shadow overflow-hidden my-2 h-24 sm:h-32 lg:h-40 mx-6 lg:mx-0"
            data-rounded="rounded-lg"
            data-rounded-max="rounded-full"
          >
            <!-- Image column with gradient fade -->
            <div class="relative h-full w-32 sm:w-40 lg:w-48">
              <img
                class="object-cover h-full w-full"
                src="$(e.img)"
                alt="$(e.title)"
              />
              <!-- Gradient overlay -->
              <div class="absolute inset-y-0 right-0 w-24 bg-gradient-to-r from-transparent to-white"></div>
            </div>

            <!-- Text column -->
            <div class="flex flex-col justify-center p-6 flex-1 dark:bg-[#1f2937]">
              <h3 class="text-lg font-bold text-gray-900 leading-tight">
                $(e.title)
              </h3>
              <p class="mt-2 text-sm text-gray-500">
                $(e.date)
              </p>
            </div>
          </blockquote>
        </a>
        """
    end
    return html
end

