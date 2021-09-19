
"Builder for reading diplomatic text from TEI XML following MID conventions."
struct MidDiplomaticBuilder <: MidBasicBuilder
    name
    versionid
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
        msg = "Invalid syntax for choice element with children " * join(childnames, ", ") * " in " * ezxmlstring(n)
        throw(DomainError(msg))
    end
end


function skipelement(builder::MidDiplomaticBuilder,elname)
    elname in ["add", "supplied", "ref"]
end

#=
function tidyFrag(cn::CitablePassage)
    newtext = replace(cn.text, "++" => "")
    CitablePassage(cn.urn, newtext)
end
=#

function edition(builder::MidDiplomaticBuilder, c::CitableTextCorpus)
    nodes = map(cn -> editednode(builder, cn), c.passages)
    #tidied = map(cn -> tidyFrag(cn),nodes)
    CitableTextCorpus(nodes)
end
