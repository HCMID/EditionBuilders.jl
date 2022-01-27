
"Builder for reading diplomatic text from TEI XML following MID conventions."
struct MidDiplomaticBuilder <: MidBasicBuilder
    name::AbstractString
    versionid::AbstractString
end


"""Instantiate a `MidDiplomaticBuilder`.
$(SIGNATURES)
"""
function diplomaticbuilder(; versionid = "dipl")
    MidDiplomaticBuilder("MID diplomatic edition builder", versionid)
end

"""Return version identifier.
$(SIGNATURES)
"""
function versionid(bldr::MidDiplomaticBuilder)
   bldr.versionid
end


"""Make diplomatic choice of MID-legal TEI choice.
$(SIGNATURES)
"""
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
        edited_text(builder, abbrlist[1])

    elseif "orig" in childnames
        origlist = filter(n -> n.name == "orig", children)
        edited_text(builder, origlist[1])


    elseif "sic" in childnames
        siclist = filter(n -> n.name == "sic", children)
        edited_text(builder, siclist[1])


    else
        msg = "Invalid syntax for choice element with children " * join(childnames, ", ") * " in " * ezxmlstring(n)
        throw(DomainError(msg))
    end
end

"""True if element should be omitted.
$(SIGNATURES)
"""
function skipelement(builder::MidDiplomaticBuilder,elname)
    elname in ["add", "supplied", "ref"]
end

#=
function tidyFrag(cn::CitablePassage)
    newtext = replace(cn.text, "++" => "")
    CitablePassage(cn.urn, newtext)
end
=#


"""Edit corpus `c` using `builder`.
$(SIGNATURES)
"""
function edited(
    builder::MidDiplomaticBuilder, 
    c::CitableTextCorpus;
    edition = nothing, exemplar = nothing)
    passages = map(cn -> edited(builder, cn, edition = edition, exemplar = exemplar), c.passages)
    #tidied = map(cn -> tidyFrag(cn),passages)
    CitableTextCorpus(passages)
end
