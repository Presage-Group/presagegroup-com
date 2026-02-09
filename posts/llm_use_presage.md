@def author = "Randy Boyes"
@def date = "2026-01-26"
@def tags = ["analytics", "AI"]
@def title = "AI use at Presage"
@def short_text = "How do we use AI at Presage?"
@def rss_pubdate = Date(2026, 01, 26)
@def img = "/assets/team.webp"

\blogheader{}

LLMs are a powerful tool for programming and data science tasks, but must be used responsibly to ensure that we are providing reliable and accurate answers for our clients. At Presage, we have developed a set of best practices for LLM use that help us to leverage their capabilities while still maintaining human control and accountability for our work. 

#### Local vs. Cloud-based LLMs

Presage will prefer to use local LLMs where possible, and will never upload sensitive data (whether ours or our clients') to cloud-based LLMs.

#### Text generation

We do not use LLM-generated text in any client-facing document, including reports, presentations, or emails, unless explicitly communicated to the client prior to report delivery. We do occaisonally use LLMs to generate filler text for internal prototypes and assist with internal documentation.

#### Image and Video Generation

We do not use AI-generated images or videos for any purpose. 

#### Code generation

Presage uses LLMs for coding support. The extent of LLM use depends on the importance of the task. Prototyping and proof-of-concept tasks may rely more heavily on LLM-generated code, while final analysis code is nearly 100% written without LLM assistance. We are more willing to outsource tasks that are easy to verify for correctness - such as cosmetic changes to a website, or edits to the theme or appearance of a figure - to an AI assistant, and are less willing to do so when mistakes may be hard to catch. In all cases, the human in charge of the project is the one accountable for the correctness of the code and the results it produces.

#### Transcription

Presage relies on local models for transcription of audio and video files.

#### Research

We may use LLMs to assist us in finding research papers, but will never base conclusions or recommendations on the summaries provided by an LLM. We will always read the primary source material directly. 