module EditionBuilders

using Documenter, DocStringExtensions
using EzXML
using CitableText

export EditionBuilder, LiteralTextBuilder, MidDiplomaticBuilder
export editednode
export acceptedElementNames, validelname, usageerrors

"An abstract type for orthographic systems."
abstract type EditionBuilder end

include("literaltext.jl")
include("midbasic.jl")

end # module
