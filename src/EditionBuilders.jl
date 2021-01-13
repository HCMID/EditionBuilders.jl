module EditionBuilders

using Documenter, DocStringExtensions
using EzXML
using CitableText

export EditionBuilder, LiteralTextBuilder
export editednode

"An abstract type for orthographic systems."
abstract type EditionBuilder end

include("literaltext.jl")

end # module
