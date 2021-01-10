using Pkg
pkg"activate .."
push!(LOAD_PATH,"../src/")


using Documenter, DocStringExtensions, EditionBuilders

makedocs(sitename = "EditionBuilders Documentation")
