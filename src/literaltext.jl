
# Simply collect text from root.


struct LiteralTextBuilder <: EditionBuilder
    name
end


"Generic edition builder."
function editedNode(builder::T, citablenode::CitableNode, version::AbstractString) where {T <: EditionBuilder}
    doc = parsexml(citablenode.text)
    txt = root(doc).content
    CitableNode(addversion(citablenode.urn, version), txt)
end