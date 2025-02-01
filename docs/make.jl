using Documenter
using BrazilEconData

makedocs(
    sitename="BrazilEconData.jl",
    # build="build",
    modules=[BrazilEconData],
    format=Documenter.HTML(),
    pages=[
        "Home" => "index.md",
        "API" => "api.md",
    ],
    authors="Livio Maya",
    # clean=true,
    source="src/",
    remotes=nothing
)