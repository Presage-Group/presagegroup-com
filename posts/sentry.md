@def author = "Randy Boyes"
@def date = "2025-10-14"
@def tags = ["news", "analytics", "julia"]
@def title = "Announcing Sentry.jl: A minimal SDK for Sentry in julia"
@def short_text = "Sentry.jl is a in-development julia package for error monitoring using sentry.io"
@def rss_pubdate = Date(2025, 10, 14)
@def img = "/assets/Julia_Programming_Language_Logo.svg"

\blogheader{}

Presage is happy to open-source Sentry.jl, a small package designed to make interfacing with [sentry](https://sentry.io/welcome/) easier when building web applications with [julia](https://julialang.org/). Sentry.jl builds on the work done by [SentryIntegration.jl](https://github.com/synchronoustechnologies/SentryIntegration.jl), with updates to the code to allow installation in modern versions of julia without dependencies on unregistered packages. 

Sentry.jl is a set of utilities for for capturing data about an exceptional state in an application. Given this data, it then builds and sends a JSON payload to the Sentry server.

To use Sentry.jl, you will need an account on sentry.io. Once you have a DSN assigned to your project, you can initialize the package using the `Sentry.init()` function. 

```julia
Sentry.init("https://0000000000.ingest.sentry.io/0000000")
```

The core functionality is in the `capture_exception` and `capture_message` functions, which are intended to be used at a high level in your application. When these functions are called after Sentry.jl is initialized, they will capture, package, and send the error object to Sentry. As a basic example: 

```julia
try
    core_loop()
catch exc
    capture_exception(exc)
end
```

Tags can be set to make classification and sorting of errors easier: 

```julia
Sentry.set_tag("customer", customer)
Sentry.set_tag("release", string(VERSION))
Sentry.set_tag("environment", get(ENV, "RUN_ENV", "unset"))
```

Presage uses a julia-based server to quickly and efficiently process questionnaire results and provide near-realtime feedback to our clients about their employees. Sentry.jl is an important part of monitoring the health of this server and will continue to be developed into a full-featured SDK. You can contribute to or just keep up with our progress on github at the [Sentry.jl repository](https://github.com/Presage-Group/Sentry.jl). 
