using Pkg
Pkg.activate(".")
Pkg.instantiate()
push!(LOAD_PATH,"../")


using Documenter, DocStringExtensions
using CitableText
using EditionBuilders

makedocs(
    sitename = "EditionBuilders",
    pages = [
        "Home" => "index.md",
        "Guide" => [
            "guide/guide.md"
        ],
        "API documentation" => [
            "man/index.md"
        ]
    ]
)


deploydocs(
    repo = "github.com/HCMID/EditionBuilders.jl.git",
)

