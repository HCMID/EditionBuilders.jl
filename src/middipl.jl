
"Builder for reading diplomatic text from TEI XML following MID conventions."
struct MidDiplomaticBuilder <: MidBasicBuilder
    name
    versionid
end


"Builder for constructing a citable node for a diplomatic text from a citable node in archival XML."
function editednode(builder::MidDiplomaticBuilder, citablenode::CitableNode)
    nd  = root(parsexml(citablenode.text))
    txt = editedtext(builder, nd)
    CitableNode(addversion(citablenode.urn, builder.versionid), txt)
end

"Make diplomatic choice of MID-legal TEI choice."
function TEIchoice(builder::MidDiplomaticBuilder, n)
    #= Account for:
        abbr/expan
        orig/reg
        sic/corr
    =#
    children = elements(n)
    childnames = map(n -> n.name, children)
    if "abbr" in childnames
        abbrlist = filter(n -> n.name == "abbr", children)
        editedtext(builder, abbrlist[1])

    elseif "orig" in childnames
        origlist = filter(n -> n.name == "orig", children)
        editedtext(builder, origlist[1])


    elseif "sic" in childnames
        siclist = filter(n -> n.name == "sic", children)
        editedtext(builder, siclist[1])


    else
        msg = "Invalid syntax for choice element with children " * join(childnames, ", ")
        throw(DomainError(msg))
    end
end

