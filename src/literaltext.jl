
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