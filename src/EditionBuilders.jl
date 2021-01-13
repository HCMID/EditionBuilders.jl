module EditionBuilders

using Documenter, DocStringExtensions
using EzXML
using CitableText

export EditionBuilder, LiteralTextBuilder

"An abstract type for orthographic systems."
abstract type EditionBuilder end


end # module
