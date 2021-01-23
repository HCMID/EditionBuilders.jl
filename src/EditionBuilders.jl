module EditionBuilders

using Documenter, DocStringExtensions
using EzXML
using CitableText

# Abstractions of the `EditionBuilder` trait.
export EditionBuilder
export editedtext, editednode, edition
export validElementNames, validelname

# Implementations
export LiteralTextBuilder
export MidBasicBuilder, MidDiplomaticBuilder, MidNormalizedBuilder


"An abstract type for orthographic systems."
abstract type EditionBuilder end

include("utils.jl")
include("literaltext.jl")
include("midbasic.jl")
include("middipl.jl")
include("midnormed.jl")

end # module
