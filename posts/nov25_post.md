@def author = "Umair Durrani"
@def date = "2025-11-28"
@def tags = ["analytics", "AI"]
@def title = "Consistent Branding of reports and applications with LLMs"
@def short_text = "brand.yml and brandthis"
@def rss_pubdate = Date(2025, 11, 28)
@def img = "/assets/brand.png"

\blogheader{}

Analytics team at Presage uses tools such as [Quarto](https://quarto.org/) and [Shiny](https://shiny.posit.co/) for developing reports, dashboards, and applications. These outputs require significant customization based on the company branding guidelines. [brand.yml](https://posit-dev.github.io/brand-yml/) project by Posit makes the branding process easier by requiring a single `_brand.yml` file that is placed in your project folder. This file must contain info. from the branding guidelines i.e., fonts, colours, and logos. The accompanying `brand.yml` R and Python packages also bundle functions for theming visualizatios and tables for a consistent look of reports and applications, making the branding process significantly faster. 

For further increase in productivity, we leverage three features of Large Language Model (LLM) APIs for generating `_brand.yml` files and colour palettes in our projects. These features are (1) Tool calling, (2) Retrieval-Augmented Generation (RAG), and (3) Structured output.


The following functions are bundled in the R package [`brandthis`](https://github.com/durraniu/brandthis): 

| Function               | Description                      | LLM Feature                                   |
| ---------------------- | -------------------------------- | --------------------------------------------- |
| `create_brand`         | Creates `_brand.yml`             | Image-to-colour extraction, contrast checking |
| `suggest_color_scales` | Suggests suitable color palettes | RAG                                           |
| `create_color_palette` | Creates color palettes           | Structured output                             |

Check out a presentation about `brandthis` below or view full screen [here](https://dru.quarto.pub/brandthis/#/title-slide).

~~~

<iframe width="800" height="400" style="display:block; margin:0 auto;" marginheight="10" marginwidth="10" src="https://dru.quarto.pub/brandthis/#/title-slide"></iframe>

~~~