
# Simply collect text from root.

"Builder for reading raw text from XML edition."
struct LiteralTextBuilder <: EditionBuilder
    name
    versionid
end


"Generic edition builder mindlessly extracting all text content from XML node."
function editednode(builder::LiteralTextBuilder, citablenode::CitableNode)
    doc = parsexml(citablenode.text)
    txt = root(doc).content
    CitableNode(addversion(citablenode.urn, builder.versionid), txt)
end


"Generic validator accepting any XML element in the text of `citablenode`."
function badusage(builder::LiteralTextBuilder, citablenode::CitableNode)
    []
end


"True if elname is a valid name for an XML element in the given Edition Builder."
function validelname(builder::EditionBuilder, elname::AbstractString)::Bool
    elname in acceptedElementNames(builder)
end

"""No element names are accepted by default. 
Subtypes of `EditionBuilder` must implement this function appropriately."""
function acceptedElementNames(builder::EditionBuilder)
    []
end