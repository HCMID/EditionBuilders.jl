module EditionBuilders

using Documenter, DocStringExtensions
using EzXML
using CitableText, CitableCorpus


# Abstractions of the `EditionBuilder` trait.
export EditionBuilder
export editedtext, editednode, edition
export validElementNames, validelname

# Implementations
export LiteralTextBuilder
export MidBasicBuilder, MidDiplomaticBuilder, MidNormalizedBuilder
export MidEpigraphicBuilder
export ezxmlstring

"An abstract type for orthographic systems."
abstract type EditionBuilder end

include("utils.jl")
include("literaltext.jl")
include("midbasic.jl")
include("middipl.jl")
include("midnormed.jl")
include("midepigraphic.jl")


"Edit all citable nodes using a given builder."
function edition(builder::EditionBuilder, c::CitableTextCorpus)
    nodes = map(cn -> editednode(builder, cn), c.passages)
    CitableTextCorpus(nodes)
end

end # module
