function hfun_small_card(args)
    name = args[1]
    photo = args[2]
    title = args[3]
    page = args[4]
    links = args[5:end]

    card = """
    <div class="w-full border border-gray-200 rounded-lg shadow-sm">
        <div class="flex flex-col items-center justify-between p-6">
            <img class="mx-auto mb-1 w-36 h-36 rounded-full object-cover" src="$photo" alt="$name">

            <h3 class="mb-1 text-2xl font-bold tracking-tight text-gray-900 dark:text-white">
                <a href=$page>$name</a>
            </h3>

            <p class="mb-1 text-gray-500 dark:text-gray-400"><a href=$page>$title</a></p>
        </div>

        <div class="flex border-t border-gray-200 divide-x divide-gray-200">
    """

    for link in 1:2:length(links)
        card *= profile_link(links[link], links[link+1])
    end

    card *= profile_link("info", page)

    card *= """
        </div>
    </div>
    """
    return card
end


function profile_link(type, link)
    return """
    <a href="$link" class="flex-1 block p-5 text-center text-gray-300 transition duration-200 ease-out hover:bg-gray-100 hover:text-gray-500">
        $(icons[type])
    </a>
    """
end


const icons = Dict{String,String}(
    "linkedin" => """
    <svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6 mx-auto fill-current" viewBox="0 0 24 24"><path d="M19 0h-14c-2.761 0-5 2.239-5 5v14c0 2.761 2.239 5 5 5h14c2.762 0 5-2.239 5-5v-14c0-2.761-2.238-5-5-5zm-11 19h-3v-11h3v11zm-1.5-12.268c-.966 0-1.75-.79-1.75-1.764s.784-1.764 1.75-1.764 1.75.79 1.75 1.764-.783 1.764-1.75 1.764zm13.5 12.268h-3v-5.604c0-3.368-4-3.113-4 0v5.604h-3v-11h3v1.765c1.396-2.586 7-2.777 7 2.476v6.759z"/></svg>
    """,
    "google_scholar" => """
    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" class="w-6 h-6 mx-auto fill-current">
      <path d="M11.7 2.805a.75.75 0 0 1 .6 0A60.65 60.65 0 0 1 22.83 8.72a.75.75 0 0 1-.231 1.337 49.948 49.948 0 0 0-9.902 3.912l-.003.002c-.114.06-.227.119-.34.18a.75.75 0 0 1-.707 0A50.88 50.88 0 0 0 7.5 12.173v-.224c0-.131.067-.248.172-.311a54.615 54.615 0 0 1 4.653-2.52.75.75 0 0 0-.65-1.352 56.123 56.123 0 0 0-4.78 2.589 1.858 1.858 0 0 0-.859 1.228 49.803 49.803 0 0 0-4.634-1.527.75.75 0 0 1-.231-1.337A60.653 60.653 0 0 1 11.7 2.805Z" />
      <path d="M13.06 15.473a48.45 48.45 0 0 1 7.666-3.282c.134 1.414.22 2.843.255 4.284a.75.75 0 0 1-.46.711 47.87 47.87 0 0 0-8.105 4.342.75.75 0 0 1-.832 0 47.87 47.87 0 0 0-8.104-4.342.75.75 0 0 1-.461-.71c.035-1.442.121-2.87.255-4.286.921.304 1.83.634 2.726.99v1.27a1.5 1.5 0 0 0-.14 2.508c-.09.38-.222.753-.397 1.11.452.213.901.434 1.346.66a6.727 6.727 0 0 0 .551-1.607 1.5 1.5 0 0 0 .14-2.67v-.645a48.549 48.549 0 0 1 3.44 1.667 2.25 2.25 0 0 0 2.12 0Z" />
      <path d="M4.462 19.462c.42-.419.753-.89 1-1.395.453.214.902.435 1.347.662a6.742 6.742 0 0 1-1.286 1.794.75.75 0 0 1-1.06-1.06Z" />
    </svg>
    """,
    "x" => """
    <svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6 mx-auto fill-current" viewBox="0 0 24 24"><path d="M24 4.557c-.883.392-1.832.656-2.828.775 1.017-.609 1.798-1.574 2.165-2.724-.951.564-2.005.974-3.127 1.195-.897-.957-2.178-1.555-3.594-1.555-3.179 0-5.515 2.966-4.797 6.045-4.091-.205-7.719-2.165-10.148-5.144-1.29 2.213-.669 5.108 1.523 6.574-.806-.026-1.566-.247-2.229-.616-.054 2.281 1.581 4.415 3.949 4.89-.693.188-1.452.232-2.224.084.626 1.956 2.444 3.379 4.6 3.419-2.07 1.623-4.678 2.348-7.29 2.04 2.179 1.397 4.768 2.212 7.548 2.212 9.142 0 14.307-7.721 13.995-14.646.962-.695 1.797-1.562 2.457-2.549z" /></svg>
    """,
    "github" => """
    <svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6 mx-auto fill-current" viewBox="0 0 24 24"><path d="M12 0c-6.626 0-12 5.373-12 12 0 5.302 3.438 9.8 8.207 11.387.599.111.793-.261.793-.577v-2.234c-3.338.726-4.033-1.416-4.033-1.416-.546-1.387-1.333-1.756-1.333-1.756-1.089-.745.083-.729.083-.729 1.205.084 1.839 1.237 1.839 1.237 1.07 1.834 2.807 1.304 3.492.997.107-.775.418-1.305.762-1.604-2.665-.305-5.467-1.334-5.467-5.931 0-1.311.469-2.381 1.236-3.221-.124-.303-.535-1.524.117-3.176 0 0 1.008-.322 3.301 1.23.957-.266 1.983-.399 3.003-.404 1.02.005 2.047.138 3.006.404 2.291-1.552 3.297-1.23 3.297-1.23.653 1.653.242 2.874.118 3.176.77.84 1.235 1.911 1.235 3.221 0 4.609-2.807 5.624-5.479 5.921.43.372.823 1.102.823 2.222v3.293c0 .319.192.694.801.576 4.765-1.589 8.199-6.086 8.199-11.386 0-6.627-5.373-12-12-12z" /></svg>
    """,
    "email" => """
    <svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6 mx-auto fill-current" viewBox="0 0 1920 1920">
        <path d="M1920 428.266v1189.54l-464.16-580.146-88.203 70.585 468.679 585.904H83.684l468.679-585.904-88.202-70.585L0 1617.805V428.265l959.944 832.441L1920 428.266ZM1919.932 226v52.627l-959.943 832.44L.045 278.628V226h1919.887Z" fill-rule="evenodd"/>
    </svg>
    """,
    "info" => """
    <svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6 mx-auto fill-current" viewBox="0 0 24 24">
      <path fill-rule="evenodd" d="M2 12C2 6.477 6.477 2 12 2s10 4.477 10 10-4.477 10-10 10S2 17.523 2 12Zm9.408-5.5a1 1 0 1 0 0 2h.01a1 1 0 1 0 0-2h-.01ZM10 10a1 1 0 1 0 0 2h1v3h-1a1 1 0 1 0 0 2h4a1 1 0 1 0 0-2h-1v-4a1 1 0 0 0-1-1h-2Z" clip-rule="evenodd"/>
    </svg>
    """
)


function hfun_member(args)
    name = args[1]
    photo = args[2]
    title = args[3]
    bio = args[4]
    links = args[5:end]

    html = """
    <section class="bg-white dark:bg-gray-900 py-12">
      <div class="max-w-4xl mx-auto px-6 lg:px-8">
        <div class="flex flex-col items-center text-center">
          <img class="w-48 h-48 rounded-full object-cover mb-6 shadow-lg" src="$photo" alt="$name">
          <h1 class="text-4xl font-extrabold text-gray-900 dark:text-white mb-2">$name</h1>
          <h2 class="text-lg font-medium text-gray-500 dark:text-gray-400 mb-6">$title</h2>
          <p class="text-lg leading-relaxed text-gray-700 dark:text-gray-300 mb-8">$bio</p>
          <ul class="flex justify-center space-x-6 mb-8">
    """

    for link in 1:2:length(links)
        html *= profile_link(links[link], links[link+1])
    end

    html *= """
          </ul>
          <a href="/pages/team/" class="blue-btn inline-block px-6 py-3 rounded-lg bg-[#00638a] text-white font-medium shadow hover:bg-[#00638a] transition">
            ← Back to Team
          </a>
        </div>
      </div>
    </section>
    """
    return html
end
