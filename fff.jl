# fff
# hero section
function hfun_hero_fff(params)
    hero_img, hero_title, hero_subtitle = params
    return """
<section class="px-2 pb-8 bg-white md:px-0">
  <div class="relative text-center mx-2"> <!-- constrain width -->
    <img
      class="rounded-md sm:rounded-xl object-cover max-h-96 w-full"
      src="$hero_img"
    />
    <div class="absolute inset-0 bg-black/40 rounded-md sm:rounded-xl"></div>
    <div class="absolute top-0 left-0 w-full px-4 sm:px-8 md:px-12 mt-10"> <!-- use padding, not fixed left -->
      <div class="border-l-4 border-white pl-4 text-left">
        <h1 class="text-4xl font-extrabold tracking-tight text-white sm:text-5xl md:text-6xl my-0">
          <span class="block">$hero_title</span>
        </h1>
        <h2 class="text-white text-base sm:text-2xl md:text-3xl mt-4 leading-snug break-words">
          $hero_subtitle
        </h2>
      </div>
    </div>
  </div>
</section>

    """
end

function hfun_expert_fff(name, role, former_positions::Vector{String}, img_path)
    former_html = join(["<div class=\"text-gray-500 dark:text-gray-300 text-lg ml-2.5\">$pos</div>" for pos in former_positions], "\n")
    return """
    <div class="flex items-center space-x-4">
        <img src="$img_path" class="w-28 h-28 mb-6 rounded-full object-cover" />
        <div>
            <div class="font-bold text-xl lg:whitespace-nowrap mb-0.5 ml-2.5">$name</div>
            <div class="text-[#00416b] dark:text-gray-300 text-lg ml-2.5">$role</div>
            $former_html
        </div>
    </div>
    """
end

function hfun_experts_fff(expert_params::Vector{String})
    return join([hfun_expert_from_string_fff(e) for e in expert_params], "\n")
end

function hfun_expert_from_string_fff(s::String)
    parts = split(s, "|")
    name, role, img = String.(parts[1:3])   # force to plain Strings
    former = length(parts) > 3 ? String.(split(parts[4], ";")) : String[]
    return hfun_expert_fff(name, role, former, img)
end



# Our Work section — heading + video only (html_content rendered separately)
function hfun_work_fff(heading, youtube_url)
    if youtube_url == ""
        return """
        <div class="container max-w-6xl mx-auto px-8 xl:px-5">
            <h2 class="text-4xl font-bold tracking-tight dark:text-gray-200 py-8 text-center">
                $heading
            </h2>
        </div>
        """
    end
    return """
    <div class="container max-w-4xl mx-auto px-8 xl:px-5">
        <h2 class="text-4xl font-bold tracking-tight dark:text-gray-200 py-8 text-center">
            $heading
        </h2>
        <div class="relative w-full rounded-xl overflow-hidden" style="padding-top: 56.25%;">
            <iframe
                class="absolute top-0 left-0 w-full h-full"
                src="$youtube_url"
                title="YouTube video"
                frameborder="0"
                allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
                allowfullscreen>
            </iframe>
        </div>
    </div>
    """
end

# html_content block — rendered between the video and the bullet points
function hfun_content_fff(html_content)
    return isempty(html_content) ? "" : """
    <div class="container max-w-6xl mx-auto px-8 xl:px-5">
        <div class="flex justify-center">
            <div class="max-w-3xl w-full text-gray-600 dark:text-gray-300 text-lg leading-relaxed mt-8">
                $html_content
            </div>
        </div>
    </div>
    """
end


# Animated bullet points, revealed one by one on scroll
function hfun_bullets_fff(bullets::Vector{String})
    items = join([
        """
        <li class="bullet-reveal flex items-start gap-3 opacity-0 translate-y-4 transition-all duration-500 text-gray-700 dark:text-gray-200 text-lg">
            <span class="mt-3 shrink-0 w-3 h-3 rounded-full bg-[#00416b]"></span>
            <span>$b</span>
        </li>
        """ for b in bullets
    ], "\n")

    return """
    <section class="bg-white pt-12 pb-4">
        <div class="container max-w-3xl mx-auto px-8">
            <ul class="space-y-4" id="bullet-list">
                $items
            </ul>
        </div>
    </section>
    <style>
        .bullet-reveal.visible {
            opacity: 1 !important;
            transform: translateY(0) !important;
        }
    </style>
    <script>
        (function () {
            const items = document.querySelectorAll('.bullet-reveal');
            const observer = new IntersectionObserver((entries) => {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        // stagger each bullet by its index
                        const idx = Array.from(items).indexOf(entry.target);
                        setTimeout(() => entry.target.classList.add('visible'), idx * 150);
                        observer.unobserve(entry.target);
                    }
                });
            }, { threshold: 0.15 });
            items.forEach(el => observer.observe(el));
        })();
    </script>
    """
end

# Big bold block quote
function hfun_quote_fff(text::String)
    return """
    <section class="bg-white py-10">
        <div class="container max-w-4xl mx-auto px-8">
            <blockquote class="border-l-8 border-[#00416b] pl-6 py-2">
                <p class="text-2xl sm:text-3xl font-extrabold text-[#00416b] dark:text-gray-100 leading-snug">
                    &ldquo;$text&rdquo;
                </p>
            </blockquote>
        </div>
    </section>
    """
end

# 
function hfun_area_fff(title::String, desc::String, icon_name::String="circle")
    return """
    <div class="flex flex-col items-center justify-between col-span-4 px-8 py-12 space-y-4 bg-gray-100 dark:bg-blue-300 sm:rounded-xl">
        <div class="p-3 text-white bg-blue-500 rounded-full">
            <i data-lucide="$icon_name"></i>
        </div>
        <h4 class="text-xl font-medium text-gray-700 text-center">$title</h4>
        <p class="text-base text-center text-gray-500">$desc</p>
    </div>
    """
end


function hfun_area_from_string_fff(s::String)
    parts = split(s, "|")
    title = String(parts[1])
    desc  = length(parts) > 1 ? String(parts[2]) : ""
    svg   = length(parts) > 2 ? String(parts[3]) : ""
    return hfun_area_fff(title, desc, svg)
end

# All areas
function hfun_areas_fff(area_params::Vector{String}, title::String)
    cards = join([hfun_area_from_string_fff(s) for s in area_params], "\n")
    return """
    <section class="pt-12 bg-white">
        <div class="container max-w-6xl mx-auto">
            <h2 class="text-4xl font-bold tracking-tight text-center dark:text-gray-200">
                $title
            </h2>
            <div class="grid grid-cols-4 gap-8 mt-10 sm:grid-cols-8 lg:grid-cols-12 sm:px-8 xl:px-0">
                $cards
            </div>
        </div>
    </section>
    """
end



# Single project card.
function hfun_project_fff(title, description, tag, author, date, minutes, link, img, tag_color="bg-gray-500")
    return """
    <div class="w-full sm:w-1/2 xl:w-1/3">
        <a href="$link" target="_blank" class="block">
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
            <a href="$link" target="_blank">$title</a>
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
function hfun_projects_fff(project_params::Vector{String})
    # drop the CTA image if it's the last entry
    clean_params = filter(p -> endswith(p, ".jpg") == false &&
                           endswith(p, ".jpeg") == false &&
                           endswith(p, ".webp") == false &&
                           endswith(p, ".png") == false, project_params)

    if isempty(clean_params)
        return ""  # no projects → return nothing
    end

    projects_html = join([hfun_project_from_string_fff(p) for p in clean_params], "\n")
    return """
    <section class="pt-32 bg-white">
        <h2 class="text-4xl font-bold tracking-tight text-center dark:text-gray-200">
            Learn More
        </h2>

        <div class="flex flex-wrap justify-center gap-8 pb-10 sm:px-5 m-10">
            $projects_html
        </div>
    </section>
    """
end



# Function for processing the input string for projects
function hfun_project_from_string_fff(s::String)
    parts = split(s, "|")
    # ensure there are at least 8 parts (9th optional tag_color)
    if length(parts) < 8
        error("Project string must have at least 8 parts: title|desc|tag|author|date|minutes|link|img[|tag_color]")
    end
    # convert SubString -> String
    parts_s = String.(parts)
    title, description, tag, author, date, minutes, link, img = parts_s[1:8]
    tag_color = length(parts_s) > 8 ? parts_s[9] : "bg-gray-500"
    return hfun_project_fff(title, description, tag, author, date, minutes, link, img, tag_color)
end


function hfun_call_to_action_fff(img::String="/assets/images/citation.webp")
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
                                >the Presage Effect!</span>
                        </h1>
                        <p
                            class="mx-auto mt-0 text-base text-gray-500 sm:max-w-md lg:text-xl md:max-w-3xl"
                        >
                            Help us understand your needs and goals, and we'll
                            work with you to create a custom solution that meets
                            your unique requirements.
                        </p>
                        <div class="relative flex flex-col sm:flex-row sm:space-x-4">
                            <a
                                href="mailto:info@presagegroup.com?subject=RFP%20Aviation?body=Describe%20your%20question"
                                class="blue-btn flex items-center w-full px-6 py-3 mb-3 text-lg text-white bg-[#00416b] rounded-md sm:mb-0 hover:bg-[#00638a] sm:w-auto"
                                data-primary="#00416b"
                                data-rounded="rounded-md"
                            >
                                Start the Conversation
                                <svg xmlns="http://www.w3.org/2000/svg"
                                    class="w-5 h-5 ml-1"
                                    viewBox="0 0 24 24"
                                    fill="none"
                                    stroke="currentColor"
                                    stroke-width="2"
                                    stroke-linecap="round"
                                    stroke-linejoin="round">
                                    <line x1="5" y1="12" x2="19" y2="12"></line>
                                    <polyline points="12 5 19 12 12 19"></polyline>
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
                        <img src="$img" />
                    </div>
                </div>
            </div>
        </div>
    </section>
    """
end



"""
fff page skeleton.

Section order:
  hero → quote → work (heading + video) → content → bullets → areas → projects → CTA
"""
function hfun_fff(params)
    hero_html           = hfun_hero_fff(params[1:3])
    img                 = last(params)
    call_to_action_html = hfun_call_to_action_fff(img)

    heading      = params[4]
    youtube_url  = params[5]
    html_content = params[6]

    # locate all section delimiters
    idx_bullets  = findfirst(==("--bullets--"),  params)
    idx_quote    = findfirst(==("--quote--"),     params)
    idx_area     = findfirst(==("--areas--"),     params)
    idx_proj     = findfirst(==("--projects--"),  params)

    # ── block quote (now above the video) ────────────────────────────────────
    quote_html = ""
    if idx_quote !== nothing
        stop_quote = something(idx_area, idx_proj, length(params)) - 1
        quote_html = hfun_quote_fff(join(params[idx_quote+1:stop_quote], " "))
    end

    # ── heading + video (html_content moved out) ─────────────────────────────
    work_html    = hfun_work_fff(heading, youtube_url)

    # ── html_content (now between video and bullets) ──────────────────────────
    content_html = hfun_content_fff(html_content)

    # ── bullets ──────────────────────────────────────────────────────────────
    bullets_html = ""
    if idx_bullets !== nothing
        stop_bullets = something(idx_quote, idx_area, idx_proj, length(params)) - 1
        bullets_html = hfun_bullets_fff(params[idx_bullets+1:stop_bullets])
    end

    # ── areas ────────────────────────────────────────────────────────────────
    areas_html = ""
    if idx_area !== nothing
        stop_area  = idx_proj === nothing ? length(params) - 1 : idx_proj - 1
        grid_heading = length(params[idx_area+1:stop_area]) > 6 ? "Scientific Studies" : "Features and Outcomes"
        areas_html = hfun_areas_fff(params[idx_area+1:stop_area], grid_heading)
    end

    # ── projects ─────────────────────────────────────────────────────────────
    projects_html = ""
    if idx_proj !== nothing
        projects_html = hfun_projects_fff(params[idx_proj+1:end-1])
    end

    return hero_html * quote_html * work_html * content_html * bullets_html * areas_html * projects_html * call_to_action_html
end