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
            <div class="container w-full absolute top-0 left-10 mt-10 border-l-4 border-white pl-4">
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
            <div class="font-bold text-xl lg:whitespace-nowrap mb-0.5 ml-2.5">$name</div>
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
            <div class="max-w-[85ch] mx-auto">
                <h2 
                    class="text-4xl font-bold tracking-tight dark:text-gray-200 py-8 text-left">
                    Our Work
                </h2>
                <p 
                    class="text-xl text-gray-500 text-left">
                    $work_text
                </p>
            </div>          
        </div>

        <div class="md:col-span-4">
            <h2 class="text-3xl font-bold tracking-tight text-left text-gray-500 dark:text-gray-200 py-8 ml-8">
                Our Industry Experts
            </h2>
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
        class="flex flex-col items-center justify-between col-span-4 px-8 py-12 space-y-4 bg-gray-100 dark:bg-blue-300 sm:rounded-xl"
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
            <h2 class="text-4xl font-bold tracking-tight text-center dark:text-gray-200">
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

        <h2 class="text-lg text-black dark:text-white font-bold sm:text-xl md:text-2xl">
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


function hfun_marquee()
    return raw"""
<div
    x-data
    x-init="
            $nextTick(() => {
                const content = $refs.content;
                const item = $refs.item;
                const clone = item.cloneNode(true);
                content.appendChild(clone);
            });
    "
    class="relative w-full bg-gray-900 container-block mt-10"
>
    <div
        class="relative w-full py-3 mx-auto overflow-hidden text-lg italic tracking-wide text-white uppercase bg-gray-900 max-w-7xl sm:text-xs md:text-sm lg:text-base xl:text-xl 2xl:text-2xl"
    >
        <div
            class="absolute left-0 z-20 w-40 h-full bg-gradient-to-r from-gray-900 to-transparent"
        ></div>
        <div
            class="absolute right-0 z-20 w-40 h-full bg-gradient-to-l from-gray-900 to-transparent"
        ></div>
        <div x-ref="content" class="flex animate-marquee">
            <div
                x-ref="item"
                class="flex items-center justify-around flex-shrink-0 w-full py-2 space-x-2 text-white"
            >
                <img src="/assets/Delta_logo.svg" width="100" />
                <img src="/assets/luft.svg" width="100" />
                <img src="/assets/airways.png" width="100" />
                <img src="/assets/air-canada.svg" width="100" />
                <img src="/assets/FlightSafety-Logo-Color.svg" width="100" />
                <img src="/assets/Virgin_Australia_Logo_2022.svg" width="100" />
                <img src="/assets/Porter_Airlines_Logo.svg" width="100" />
                <img
                    src="/assets/bas-logo-inverse-transparent.svg"
                    width="200"
                />
            </div>
        </div>
    </div>
</div>
<style>
    @keyframes marquee {
        0% { transform: translateX(0); }
        100% { transform: translateX(-100%); }
    }
    .animate-marquee {
        animation: marquee 20s linear infinite;
    }
</style>
"""
end



function hfun_call_to_action()
    return """
    <section class="px-2 py-25 bg-white md:px-0">
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
                                class="block text-[#00416b] dark:text-[#e76254] xl:inline"
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
    marquee_html = hfun_marquee()

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

    return hero_html * work_html * areas_html * projects_html * marquee_html * call_to_action_html
end