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
    <div class="flex flex-col items-center sm:px-5 md:flex-row">
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

                <div class="flex flex-col w-full md:flex-row">
                  $tag_html
                </div>

                <p class="pt-2 text-sm font-medium">by <a href="/pages/team.html" class="mr-1 underline">$author</a> · <span class="mx-1">$date</span> · <span class="mx-1 text-gray-600">$length_html</span></p>
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
    <div class="flex flex-col items-start col-span-12 space-y-3 sm:col-span-6 xl:col-span-4">
        <a href="/$link/" class="block">
            <img class="object-cover w-full mb-2 overflow-hidden rounded-lg shadow-sm max-h-56" src="$img_src">
        </a>
        <div class="flex flex-col w-full md:flex-row">
          $tag_html
        </div>
        <h2 class="text-lg font-bold sm:text-xl md:text-2xl"><a href="/$link/">$title</a></h2>
        <p class="text-sm text-gray-500">$short_text</p>
        <p class="pt-2 text-xs font-medium"><a href="#_" class="mr-1 underline">$author</a> · <span class="mx-1">$date</span> · <span class="mx-1 text-gray-600">$length_html</span></p>
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

function hfun_small_card(args)
    name = args[1]
    photo = args[2]
    title = args[3]
    bio = args[4]

    links = args[5:end]

    link_html = """
    <div class="col-12 col-md-6 col-lg-4">
    <div class="card border-0 shadow-lg pt-5 my-5 position-relative">
      <div class="card-body p-4">
        <div class="member-profile position-absolute w-100 text-center">
          <img
            class="rounded-circle mx-auto d-inline-block shadow-sm"
            src=$photo
            alt=""
          />
        </div>
        <div class="card-text pt-1">
          <h5 class="member-name mb-0 text-center text-primary font-weight-bold">
            $name
          </h5>
          <div class="mb-3 text-center">
            $title
          </div>
          <div>
            $bio
          </div>
        </div>
      </div>
      <div class="card-footer theme-bg-primary border-0 text-center">
        <ul class="social-list list-inline mb-0 mx-auto">
    """

    for link in 1:2:length(links)
        link_html *= profile_link(links[link], links[link+1])
    end

    link_html *= """
          </ul>
        </div>
      </div>
    </div>
    """
    return link_html
end

function profile_link(type, link)
    html = """
    <li class="list-inline-item">
      <a class="text-dark" href="$link">
    """

    html *= icons[type]

    return html
end

const icons = Dict{String,String}(
    "linkedin" => """
    <svg class="svg-inline--fa fa-linkedin-in fa-w-14 fa-fw"
              aria-hidden="true"
              focusable="false"
              data-prefix="fab"
              data-icon="linkedin-in"
              role="img"
              xmlns="http://www.w3.org/2000/svg"
              viewBox="0 0 448 512"
              data-fa-i2svg=""
          >
              <path
                  fill="currentColor"
                  d="M100.28 448H7.4V148.9h92.88zM53.79 108.1C24.09 108.1 0 83.5 0 53.8a53.79 53.79 0 0 1 107.58 0c0 29.7-24.1 54.3-53.79 54.3zM447.9 448h-92.68V302.4c0-34.7-.7-79.2-48.29-79.2-48.29 0-55.69 37.7-55.69 76.7V448h-92.78V148.9h89.08v40.8h1.3c12.4-23.5 42.69-48.3 87.88-48.3 94 0 111.28 61.9 111.28 142.3V448z"
              ></path></svg
          ><!-- <i class="fab fa-linkedin-in fa-fw"></i> Font Awesome fontawesome.com --></a
      >
    </li>
    """,
    "google scholar" => """
    <svg
        xmlns="http://www.w3.org/2000/svg"
        width="16"
        height="16"
        fill="currentColor"
        class="bi bi-mortarboard-fill"
        viewBox="0 0 16 16"
    >
        <path
            d="M8.211 2.047a.5.5 0 0 0-.422 0l-7.5 3.5a.5.5 0 0 0 .025.917l7.5 3a.5.5 0 0 0 .372 0L14 7.14V13a1 1 0 0 0-1 1v2h3v-2a1 1 0 0 0-1-1V6.739l.686-.275a.5.5 0 0 0 .025-.917z"
        />
        <path
            d="M4.176 9.032a.5.5 0 0 0-.656.327l-.5 1.7a.5.5 0 0 0 .294.605l4.5 1.8a.5.5 0 0 0 .372 0l4.5-1.8a.5.5 0 0 0 .294-.605l-.5-1.7a.5.5 0 0 0-.656-.327L8 10.466z"
        /></svg
      ><!-- <i class="fab fa-linkedin-in fa-fw"></i> Font Awesome fontawesome.com --></a>
    </li>
    """,
    "x" => """
    <svg
        class="svg-inline--fa fa-twitter fa-w-16 fa-fw"
        aria-hidden="true"
        focusable="false"
        data-prefix="fab"
        data-icon="twitter"
        role="img"
        xmlns="http://www.w3.org/2000/svg"
        viewBox="0 0 512 512"
        data-fa-i2svg=""
    >
        <path
            fill="currentColor"
            d="M459.37 151.716c.325 4.548.325 9.097.325 13.645 0 138.72-105.583 298.558-298.558 298.558-59.452 0-114.68-17.219-161.137-47.106 8.447.974 16.568 1.299 25.34 1.299 49.055 0 94.213-16.568 130.274-44.832-46.132-.975-84.792-31.188-98.112-72.772 6.498.974 12.995 1.624 19.818 1.624 9.421 0 18.843-1.3 27.614-3.573-48.081-9.747-84.143-51.98-84.143-102.985v-1.299c13.969 7.797 30.214 12.67 47.431 13.319-28.264-18.843-46.781-51.005-46.781-87.391 0-19.492 5.197-37.36 14.294-52.954 51.655 63.675 129.3 105.258 216.365 109.807-1.624-7.797-2.599-15.918-2.599-24.04 0-57.828 46.782-104.934 104.934-104.934 30.213 0 57.502 12.67 76.67 33.137 23.715-4.548 46.456-13.32 66.599-25.34-7.798 24.366-24.366 44.833-46.132 57.827 21.117-2.273 41.584-8.122 60.426-16.243-14.292 20.791-32.161 39.308-52.628 54.253z"
        ></path></svg
    ><!-- <i class="fab fa-twitter fa-fw"></i> Font Awesome fontawesome.com --></a>
    </li>
    """,
    "github" => """
    <svg
        class="svg-inline--fa fa-github fa-w-16 fa-fw"
        aria-hidden="true"
        focusable="false"
        data-prefix="fab"
        data-icon="github"
        role="img"
        xmlns="http://www.w3.org/2000/svg"
        viewBox="0 0 496 512"
        data-fa-i2svg=""
    >
        <path
            fill="currentColor"
            d="M165.9 397.4c0 2-2.3 3.6-5.2 3.6-3.3.3-5.6-1.3-5.6-3.6 0-2 2.3-3.6 5.2-3.6 3-.3 5.6 1.3 5.6 3.6zm-31.1-4.5c-.7 2 1.3 4.3 4.3 4.9 2.6 1 5.6 0 6.2-2s-1.3-4.3-4.3-5.2c-2.6-.7-5.5.3-6.2 2.3zm44.2-1.7c-2.9.7-4.9 2.6-4.6 4.9.3 2 2.9 3.3 5.9 2.6 2.9-.7 4.9-2.6 4.6-4.6-.3-1.9-3-3.2-5.9-2.9zM244.8 8C106.1 8 0 113.3 0 252c0 110.9 69.8 205.8 169.5 239.2 12.8 2.3 17.3-5.6 17.3-12.1 0-6.2-.3-40.4-.3-61.4 0 0-70 15-84.7-29.8 0 0-11.4-29.1-27.8-36.6 0 0-22.9-15.7 1.6-15.4 0 0 24.9 2 38.6 25.8 21.9 38.6 58.6 27.5 72.9 20.9 2.3-16 8.8-27.1 16-33.7-55.9-6.2-112.3-14.3-112.3-110.5 0-27.5 7.6-41.3 23.6-58.9-2.6-6.5-11.1-33.3 2.6-67.9 20.9-6.5 69 27 69 27 20-5.6 41.5-8.5 62.8-8.5s42.8 2.9 62.8 8.5c0 0 48.1-33.6 69-27 13.7 34.7 5.2 61.4 2.6 67.9 16 17.7 25.8 31.5 25.8 58.9 0 96.5-58.9 104.2-114.8 110.5 9.2 7.9 17 22.9 17 46.4 0 33.7-.3 75.4-.3 83.6 0 6.5 4.6 14.4 17.3 12.1C428.2 457.8 496 362.9 496 252 496 113.3 383.5 8 244.8 8zM97.2 352.9c-1.3 1-1 3.3.7 5.2 1.6 1.6 3.9 2.3 5.2 1 1.3-1 1-3.3-.7-5.2-1.6-1.6-3.9-2.3-5.2-1zm-10.8-8.1c-.7 1.3.3 2.9 2.3 3.9 1.6 1 3.6.7 4.3-.7.7-1.3-.3-2.9-2.3-3.9-2-.6-3.6-.3-4.3.7zm32.4 35.6c-1.6 1.3-1 4.3 1.3 6.2 2.3 2.3 5.2 2.6 6.5 1 1.3-1.3.7-4.3-1.3-6.2-2.2-2.3-5.2-2.6-6.5-1zm-11.4-14.7c-1.6 1-1.6 3.6 0 5.9 1.6 2.3 4.3 3.3 5.6 2.3 1.6-1.3 1.6-3.9 0-6.2-1.4-2.3-4-3.3-5.6-2z"
        ></path></svg
    ><!-- <i class="fab fa-github fa-fw"></i> Font Awesome fontawesome.com --></a>
    </li>
    """,
    "email" => """
    <svg
        xmlns="http://www.w3.org/2000/svg"
        width="18"
        height="18"
        fill="currentColor"
        class="bi bi-envelope"
        viewBox="0 0 16 16"
    >
        <path
            d="M0 4a2 2 0 0 1 2-2h12a2 2 0 0 1 2 2v8a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2zm2-1a1 1 0 0 0-1 1v.217l7 4.2 7-4.2V4a1 1 0 0 0-1-1zm13 2.383-4.708 2.825L15 11.105zm-.034 6.876-5.64-3.471L8 9.583l-1.326-.795-5.64 3.47A1 1 0 0 0 2 13h12a1 1 0 0 0 .966-.741M1 11.105l4.708-2.897L1 5.383z"
        ></path></svg
    ><!-- <i class="fab fa-linkedin-in fa-fw"></i> Font Awesome fontawesome.com --></a>
    </li>
    """)

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


# Services
# hero section
function hfun_hero(params)
    hero_img, hero_title, hero_subtitle = params
    return """
    <section class="px-2 pb-8 bg-white md:px-0">
        <div class="relative text-center">
            <img
                class="rounded-md sm:rounded-xl object-cover max-h-96 w-full"
                src="$hero_img"
            />
            <div class="absolute inset-0 bg-black/40 rounded-md sm:rounded-xl"></div>
            <div class="container w-full absolute top-0 left-10 mt-10">
                <h1
                    class="text-4xl font-extrabold tracking-tight text-left text-white sm:text-5xl md:text-6xl my-0"
                >
                    <span class="block">$hero_title</span>
                </h1>
                <h2
                    class="text-white text-left text-base sm:text-2xl md:text-3xl mt-1 leading-snug break-words"
                >
                    $hero_subtitle
                </h2>
            </div>
        </div>
    </section>
    """
end

# Single expert
function hfun_expert(name, role, former_positions::Vector{String}, img_path)
    former_html = join(["<div class=\"text-gray-500 dark:text-gray-300 text-lg ml-2.5\">$pos</div>" for pos in former_positions], "\n")
    return """
    <div class="flex items-center space-x-4">
        <img src="$img_path" class="w-28 h-28 mb-6 rounded-full" />
        <div>
            <p class="font-bold text-xl lg:whitespace-nowrap">$name</p>
            <div class="text-[#00416b] dark:text-gray-300 text-lg ml-2.5">$role</div>
            $former_html
        </div>
    </div>
    """
end

# All experts
function hfun_experts(expert_params::Vector{String})
    return join([hfun_expert_from_string(e) for e in expert_params], "\n")
end

function hfun_expert_from_string(s::String)
    parts = split(s, "|")
    name, role, img = String.(parts[1:3])   # force to plain Strings
    former = length(parts) > 3 ? String.(split(parts[4], ";")) : String[]
    return hfun_expert(name, role, former, img)
end



# Our Work section
function hfun_work(work_text, experts_html="")
    return """
    <div class="grid grid-cols-1 md:grid-cols-10 gap-4 px-4 md:px-0">
        <div class="md:col-span-6">
            <h2 class="text-4xl font-bold tracking-tight text-left dark:text-gray-200 py-8 ml-8">Our Work</h2>
            <p class="text-xl text-gray-500">$work_text</p>
        </div>

        <div class="md:col-span-4">
            <h3 class="text-3xl font-bold tracking-tight text-left text-gray-500 dark:text-gray-200 py-8 ml-8">
                Our Industry Experts
            </h3>
            $experts_html
            <div class="text-center">
                <a href="/pages/team/" class="mx-auto inline-block px-6 py-3 mt-4 mb-3 text-lg text-white bg-[#00416b] rounded-full hover:bg-[#00638a]" data-primary="#00416b" data-rounded="rounded-full">
                    Learn More About Our Team
                </a>
            </div>
        </div>
    </div>
    """
end



# One area of expertise card
function hfun_area(title::String, desc::String)
    svg = """
    <svg xmlns="http://www.w3.org/2000/svg"
         width="24" height="24" viewBox="0 0 24 24"
         stroke-width="2" stroke="currentColor" fill="none"
         stroke-linecap="round" stroke-linejoin="round">
        <path fill="none" stroke="none" d="M0 0h24v24H0z" />
        <path d="M4 20V16L14.5 5.5A1.5 1.5 0 0 1 18.5 9.5L8 20H4M13.5 6.5L17.5 10.5" />
    </svg>
    """
    return """
    <div
        class="flex flex-col items-center justify-between col-span-4 px-8 py-12 space-y-4 bg-gray-100 sm:rounded-xl"
        data-rounded="rounded-xl"
        data-rounded-max="rounded-full"
    >
        <div class="p-3 text-white bg-blue-500 rounded-full"
             data-primary="blue-500"
             data-rounded="rounded-full">
            $svg
        </div>
        <h4 class="text-xl font-medium text-gray-700 text-center">
            $title
        </h4>
        <p class="text-base text-center text-gray-500">
            $desc
        </p>
    </div>
    """
end

# Function for processing the input string for areas of expertise
function hfun_area_from_string(s::String)
    parts = split(s, "|")
    title = String(parts[1])
    desc  = length(parts) > 1 ? String(parts[2]) : ""
    return hfun_area(title, desc)
end

# All areas
function hfun_areas(area_params::Vector{String})
    cards = join([hfun_area_from_string(s) for s in area_params], "\n")
    return """
    <section class="pt-32 bg-white">
        <div class="container max-w-6xl mx-auto">
            <h2 class="text-4xl font-bold tracking-tight text-center">
                Our Areas of Expertise
            </h2>
            <div class="grid grid-cols-4 gap-8 mt-10 sm:grid-cols-8 lg:grid-cols-12 sm:px-8 xl:px-0">
                $cards
            </div>
        </div>
    </section>
    """
end



# Single project card.
function hfun_project(title, description, tag, author, date, minutes, link, img, tag_color="bg-gray-500")
    return """
    <div class="w-full sm:w-1/2 xl:w-1/3">
        <a href="$link" class="block">
            <img
                class="object-cover w-full mb-2 overflow-hidden rounded-lg shadow-sm max-h-56 max-w-6xl"
                src="$img"
                alt="$title"
            />
        </a>

        <div class="$tag_color px-3 py-1.5 mb-3 leading-none rounded-full text-xs font-medium uppercase text-white inline-block">
            <span>$tag</span>
        </div>

        <h2 class="text-lg font-bold sm:text-xl md:text-2xl">
            <a href="$link">$title</a>
        </h2>

        <p class="text-sm text-gray-500">
            $description
        </p>

        <p class="pt-2 text-xs font-medium">
            <span class="mr-1 underline">$author</span> ·
            <span class="mx-1">$date</span> ·
            <span class="mx-1 text-gray-600">$minutes</span>
        </p>
    </div>
    """
end



# Multiple projects
function hfun_projects(service_name::String, project_params::Vector{String})
    projects_html = join([hfun_project_from_string(p) for p in project_params], "\n")
    return """
    <section class="pt-32 bg-white">
        <h2 class="text-4xl font-bold tracking-tight text-center dark:text-gray-200">
            Featured Projects in $service_name
        </h2>

        <div class="flex flex-wrap justify-center gap-8 pb-10 sm:px-5 m-10">
            $projects_html
        </div>
    </section>
    """
end

# Function for processing the input string for projects
function hfun_project_from_string(s::String)
    parts = split(s, "|")
    # ensure there are at least 8 parts (9th optional tag_color)
    if length(parts) < 8
        error("Project string must have at least 8 parts: title|desc|tag|author|date|minutes|link|img[|tag_color]")
    end
    # convert SubString -> String
    parts_s = String.(parts)
    title, description, tag, author, date, minutes, link, img = parts_s[1:8]
    tag_color = length(parts_s) > 8 ? parts_s[9] : "bg-gray-500"
    return hfun_project(title, description, tag, author, date, minutes, link, img, tag_color)
end


function hfun_call_to_action()
    return """
    <section class="px-2 py-25 bg-white md:px-0">
        <div class="hidden lg:relative lg:flex h-1 mt-10 my-10 -mx-1 bg-[#00415b]"></div>
        <div class="container items-center max-w-6xl px-8 mx-auto xl:px-5">
            <div class="flex flex-wrap items-center sm:-mx-3">
                <div class="w-full md:w-1/2 md:px-3">
                    <div
                        class="w-full pb-6 space-y-6 sm:max-w-md lg:max-w-lg md:space-y-4 lg:space-y-8 xl:space-y-9 sm:pr-5 lg:pr-0 md:pb-0"
                    >
                        <h1
                            class="mb-0 text-4xl font-extrabold tracking-tight text-gray-900 sm:text-5xl md:text-4xl lg:text-5xl xl:text-6xl"
                        >
                            <span class="block xl:inline">Reach out to experience</span>
                            <span
                                class="block text-[#00416b] xl:inline"
                                data-primary="indigo-600"
                                >the Presage Effect!</span
                            >
                        </h1>
                        <p
                            class="mx-auto mt-0 text-base text-gray-500 sm:max-w-md lg:text-xl md:max-w-3xl"
                        >
                            Help us understand your needs and goals, and we'll
                            work with you to create a custom solution that meets
                            your unique requirements.
                        </p>
                        <div
                            class="relative flex flex-col sm:flex-row sm:space-x-4"
                        >
                            <a
                                href="mailto:sales@presagegroup.com?subject=RFP%20Aviation?body=Describe%20your%20question"
                                class="flex items-center w-full px-6 py-3 mb-3 text-lg text-white bg-[#00416b] rounded-md sm:mb-0 hover:bg-[#00638a] sm:w-auto"
                                data-primary="#00416b"
                                data-rounded="rounded-md"
                            >
                                Start the Conversation
                                <svg
                                    xmlns="http://www.w3.org/2000/svg"
                                    class="w-5 h-5 ml-1"
                                    viewBox="0 0 24 24"
                                    fill="none"
                                    stroke="currentColor"
                                    stroke-width="2"
                                    stroke-linecap="round"
                                    stroke-linejoin="round"
                                    class="feather feather-arrow-right"
                                >
                                    <line x1="5" y1="12" x2="19" y2="12"></line>
                                    <polyline
                                        points="12 5 19 12 12 19"
                                    ></polyline>
                                </svg>
                            </a>
                        </div>
                    </div>
                </div>
                <div class="w-full md:w-1/2">
                    <div
                        class="w-full h-auto overflow-hidden rounded-md shadow-xl sm:rounded-xl"
                        data-rounded="rounded-xl"
                        data-rounded-max="rounded-full"
                    >
                        <img src="/assets/images/citation.jpg" />
                    </div>
                </div>
            </div>
        </div>
    </section>
    """
end


"""
Service page skeleton.
"""
function hfun_service(params)
    hero_html = hfun_hero(params[1:3])
    work_html = ""
    areas_html = ""
    projects_html = ""
    call_to_action_html = hfun_call_to_action()

    if "--areas--" in params || "--projects--" in params
        idx_area = findfirst(==("--areas--"), params)
        idx_proj = findfirst(==("--projects--"), params)

        cutoff = minimum(filter(!isnothing, [idx_area, idx_proj]))
        if cutoff > 5
            experts_html = hfun_experts(params[5:cutoff-1])
            work_html = hfun_work(params[4], experts_html)
        else
            work_html = hfun_work(params[4])
        end

        if idx_area !== nothing
            stop = (idx_proj === nothing ? length(params) : idx_proj - 1)
            areas_html = hfun_areas(params[idx_area+1:stop])
        end

        if idx_proj !== nothing
            service_name = params[idx_proj+1]
            projects_html = hfun_projects(service_name, params[idx_proj+2:end])
        end
    else
        experts_html = length(params) > 4 ? hfun_experts(params[5:end]) : ""
        work_html = hfun_work(params[4], experts_html)
    end

    return hero_html * work_html * areas_html * projects_html * call_to_action_html
end


