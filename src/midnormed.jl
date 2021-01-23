"Builder for reading diplomatic text from TEI XML following MID conventions."
struct MidNormalizedBuilder <: MidBasicBuilder
    name
    versionid
end

"Builder for constructing a citable node for a diplomatic text from a citable node in archival XML."
function editednode(builder::MidNormalizedBuilder, citablenode::CitableNode)
    doc = parsexml(citablenode.text)
    txt = root(doc).content
    #CitableNode(addversion(citablenode.urn, builder.versionid), txt)
end


"Make normalized choice of MID-legal TEI choice."
function TEIchoice(builder::MidNormalizedBuilder, n)
    #= Account for:
        abbr/expan
        orig/reg
        sic/corr
    =#
    children = elements(n)
    childnames = map(n -> n.name, children)
    if "expan" in childnames
        abbrlist = filter(n -> n.name == "expan", children)
        editedtext(builder, abbrlist[1])

    elseif "reg" in childnames
        origlist = filter(n -> n.name == "reg", children)
        editedtext(builder, origlist[1])


    elseif "corr" in childnames
        siclist = filter(n -> n.name == "corr", children)
        editedtext(builder, siclist[1])


    else
        msg = "Invalid syntax for choice element with children " * join(childnames, ", ")
        throw(DomainError(msg))
    end
end