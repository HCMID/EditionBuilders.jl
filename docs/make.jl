# Build docs from repository root:
# 
#    julia --project=docs/ docs/make.jl
#
# Serve docs from repository root:
#
#   julia -e 'using LiveServer; serve(dir="docs/build")'
#
using Pkg
Pkg.activate(".")
Pkg.instantiate()


using Documenter, DocStringExtensions
using CitableText, CitableCorpus
using EditionBuilders

makedocs(
    sitename = "EditionBuilders",
    pages = [
        "Home" => "index.md",
        "Guide" => [
            "guide/guide.md"
        ],
        "API documentation" => [
            "man/index.md",
            "man/internals.md"
        ]
    ]
)


deploydocs(
    repo = "github.com/HCMID/EditionBuilders.jl.git",
)

