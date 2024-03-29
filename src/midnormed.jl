"Builder for reading diplomatic text from TEI XML following MID conventions."
struct MidNormalizedBuilder <: MidBasicBuilder
    name
    versionid
end

"""Instantiate a `MidNormalizedBuilder`.
$(SIGNATURES)
"""
function normalizedbuilder(; versionid = "normed")
    MidNormalizedBuilder("MID normalized edition builder", versionid)
end

"""Return version identifier.
$(SIGNATURES)
"""
function versionid(bldr::MidNormalizedBuilder)
   bldr.versionid
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
    if "abbr" in childnames
        abbrlist = filter(n -> n.name == "expan", children)
        edited_text(builder, abbrlist[1])

    elseif "orig" in childnames
        origlist = filter(n -> n.name == "reg", children)
        edited_text(builder, origlist[1])


    elseif "sic" in childnames
        siclist = filter(n -> n.name == "corr", children)
        edited_text(builder, siclist[1])


    else
        nameslist = join(childnames, ", ")
        x = ezxmlstring(n)
        msg =  "Invalid syntax for choice element with children $(nameslist) in $(x)"
  
        throw(DomainError(msg))
    end
end

function skipelement(builder::MidNormalizedBuilder,elname)
    elname in ["del", "ref"]
end


