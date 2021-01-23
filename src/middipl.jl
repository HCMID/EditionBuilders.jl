
"Builder for reading diplomatic text from TEI XML following MID conventions."
struct MidDiplomaticBuilder <: MidBasicBuilder
    name
    versionid
end


"Builder for constructing a citable node for a diplomatic text from a citable node in archival XML."
function editednode(builder::MidDiplomaticBuilder, citablenode::CitableNode)
    doc = parsexml(citablenode.text)
    txt = root(doc).content
    #CitableNode(addversion(citablenode.urn, builder.versionid), txt)
end


function TEIchoice(builder::MidDiplomaticBuilder, n)

end

