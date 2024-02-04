module EditionBuilders

using Documenter, DocStringExtensions
using EzXML
using CitableText, CitableCorpus

import CitableBase: addversion
import CitableBase: versionid

# Abstractions of the `EditionBuilder` trait.
export EditionBuilder
export versionid
export edited_text, edited, edition
export validElementNames, validelname

# Implementations
export LiteralTextBuilder
export MidBasicBuilder
export MidDiplomaticBuilder, diplomaticbuilder
export MidNormalizedBuilder, normalizedbuilder
export MidEpigraphicBuilder
export MidDiplomaticTableBuilder, diplomatictable
export MidNormalizedTableBuilder, normedtable


export ezxmlstring


include("basetype.jl")
include("utils.jl")
include("literaltext.jl")
include("midbasic.jl")
include("middipl.jl")
include("midnormed.jl")
include("midepigraphic.jl")
include("midtablediplomatic.jl")
include("midtablenormed.jl")

end # module



