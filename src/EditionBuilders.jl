module EditionBuilders

using Documenter, DocStringExtensions
using EzXML
using CitableText, CitableCorpus

# Abstractions of the `EditionBuilder` trait.
export EditionBuilder
export versionid
export edited_text, edited_passage, edition
export validElementNames, validelname

# Implementations
export LiteralTextBuilder
export MidBasicBuilder
export MidDiplomaticBuilder, diplomaticbuilder
export MidNormalizedBuilder, normalizedbuilder
export MidEpigraphicBuilder

export ezxmlstring

include("basetype.jl")
include("utils.jl")
include("literaltext.jl")
include("midbasic.jl")
include("middipl.jl")
include("midnormed.jl")
include("midepigraphic.jl")

end # module
