@delay function hfun_recent_posts(m::Vector{String})
    @assert length(m) == 1 "only one argument allowed for recent posts (the number of recent posts to pull)"
    n = parse(Int64, m[1])
    list = readdir("posts")
    filter!(f -> endswith(f, ".md") && f != "index.md", list)
    posts = []
    df = DateFormat("yyyy-mm-dd")
    for (k, post) in enumerate(list)
        fi = "posts/" * splitext(post)[1]
        title = pagevar(fi, :title)
        datestr = pagevar(fi, :date)
        tags = pagevar(fi, :tags; default=[""])
        author = pagevar(fi, :author)
        short_text = pagevar(fi, :short_text)
        img = pagevar(fi, :img; default=nothing)
        if !isnothing(datestr)
            date = Date(datestr, df)
            push!(posts, (
                title=title,
                link=fi,
                date=date,
                tags=tags,
                author=author,
                short_text=short_text,
                img=img
            ))
        end
    end

    html = """
    <section class="bg-white">
      <div class="w-full px-5 py-6 mx-auto space-y-5 sm:py-8 md:py-12 sm:space-y-8 md:space-y-16 max-w-7xl">
    """

    # pull all posts if n <= 0
    n = n >= 0 ? n : length(posts) + 1

    eles = sort(posts, by=x -> x.date, rev=true)
    fp = eles[1]

    html *= featured_post(fp.title, fp.link, fp.date, fp.short_text, fp.author; tags=fp.tags, img = fp.img)

    html *= """\n
      <div class="flex grid grid-cols-12 pb-10 sm:px-5 gap-x-8 gap-y-16">
    """

    for ele in eles[2:min(length(posts), n)]
        html *= grid_post(ele.title, ele.link, ele.date, ele.short_text, ele.author; tags=ele.tags, img=ele.img)
    end

    html *= """
        </div>
      </div>
    </section>
    """

    return html
end

@delay function hfun_all_posts()
    return hfun_recent_posts(["-1"])
end

function featured_post(title, link, date, short_text="test", author="Presage Group"; length=nothing, tags=nothing, img=nothing)
    if isnothing(tags)
        tag_html = ""
    else
        tag_html = reduce(*, format_tag.(tags))
    end

    if isnothing(length)
        length_html = "5 min. read"
    else
        length_html = length
    end

    if isnothing(img)
        img_src = "/assets/Presage_Logo_noTXT.svg"
    else
        img_src = img
    end

    html = """
    <div class="flex flex-row items-center sm:px-5 md:flex-row">
        <div class="w-full md:w-1/2">
            <a href="/$link/" class="block">
                <img class="object-cover w-full h-full rounded-lg max-h-64 sm:max-h-96" src="$img_src">
            </a>
        </div>
        <div class="flex flex-col items-start justify-center w-full h-full py-6 mb-6 md:mb-0 md:w-1/2">
            <div class="flex flex-col items-start justify-center h-full space-y-1 transform md:pl-10 lg:pl-16 md:space-y-2">

                <h1 class="text-4xl font-bold leading-none mb-0 lg:text-5xl xl:text-6xl">
                  <a href="/$link/">$title.</a>
                </h1>

                <p class="text-sm text-gray-500">$short_text</p>

                <div class="flex flex-row w-full">
                  $tag_html
                </div>

                <p class="pt-2 text-sm font-medium">by <a href="/pages/team" class="mr-1 underline dark:!text-white">$author</a> · <span class="mx-1">$date</span> · <span class="mx-1 text-gray-600 dark:text-white">$length_html</span></p>
            </div>
        </div>
    </div>
    """
    return html
end

function grid_post(title, link, date, short_text="test", author="Presage Group"; length=nothing, tags=nothing, img=nothing)

    if isnothing(tags)
        tag_html = ""
    else
        tag_html = reduce(*, format_tag.(tags))
    end

    if isnothing(length)
        length_html = "5 min. read"
    else
        length_html = length
    end

    if isnothing(img)
        img_src = "/assets/Presage_Logo_noTXT.svg"
    else
        img_src = img
    end

    html = """
    <div class="flex flex-col items-start col-span-12 space-y-3 sm:col-span-6 xl:col-span-4 dark:border dark:border-gray-700 dark:rounded-lg">
        <a href="/$link/" class="block">
            <img class="object-contain w-full aspect-video mb-2 overflow-hidden rounded-lg shadow-sm" src="$img_src">
        </a>
        <div class="flex flex-row w-full">
          $tag_html
        </div>
        <h2 class="text-lg font-bold sm:text-xl md:text-2xl"><a href="/$link/">$title</a></h2>
        <p class="text-sm text-gray-500">$short_text</p>
        <p class="pt-2 text-xs font-medium"><a href="/pages/team" class="mr-1 underline dark:!text-white">$author</a> · <span class="mx-1">$date</span> · <span class="mx-1 text-gray-600 dark:!text-white"">$length_html</span></p>
    </div>
    """
    return html
end

function format_tag(tag_name)
    html = """\n
    <div class="bg-$(tag_color(tag_name)) flex items-center px-3 py-1.5 leading-none rounded-full text-xs font-medium uppercase text-white inline-block">
      <span>$tag_name</span>
    </div>\n
    """
    return html
end

function tag_color(string)
    selected = Int(hash(string) % 12)
    return tag_color_lookup[selected]
end

const tag_color_lookup = Dict{Int64,String}(
    0 => "teal-500",
    1 => "purple-500",
    2 => "blue-500",
    3 => "red-500",
    4 => "orange-500",
    5 => "emerald-500",
    6 => "sky-500",
    7 => "violet-500",
    8 => "rose-500",
    9 => "amber-500",
    10 => "lime-500",
    11 => "indigo-500"
)



function lx_blogheader(com, _)
    return """
        ~~~
        <div class="flex flex-col items-center text-center sm:px-5 gap-y-4">
            <img
                class="h-48 w-96 object-contain rounded-md mt-6"
                src="$(locvar("img"))"
                alt="Blog header image"
            >
            <p class="text-3xl font-semibold max-w-2xl">
                $(locvar("title"))
            </p>
        </div>
        ~~~

        """
end


