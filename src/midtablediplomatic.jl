
"."
struct MidDiplomaticTableBuilder <: MidBasicBuilder
    name::AbstractString
    versionid::AbstractString
    diplomatizer::MidDiplomaticBuilder
end

function versionid(bldr::MidDiplomaticTableBuilder) 
    bldr.versionid
end

function diplomatictable(; versionid = "dipl")
    MidDiplomaticTableBuilder("MID diplomatic edition builder for tables", versionid, diplomaticbuilder())
end


"""Walk parsed XML tree and compose text content for an edition
using `builder`. `n` is a parsed passage. 
`accum` is the accumulation of any text already seen and collected.
$(SIGNATURES)
"""
function edited_text(builder::MidDiplomaticTableBuilder, n::EzXML.Node, accum = "")::AbstractString

    if n.name == "row"
        @info("Process whole row")
    end

	rslts = [accum]

    #=
    if n.type == EzXML.ELEMENT_NODE 
        elresults = editedelement(builder, n, accum)
        push!(rslts, elresults)

	elseif 	n.type == EzXML.TEXT_NODE
		tidier = cleanws(n.content )
		if !isempty(tidier)
			push!(rslts, accum * tidier)
		end
                
    elseif n.type == EzXML.COMMENT_NODE
        # do nothing
    else
        throw(DomainError("Unrecognized passage type for passage $(n.type)"))
	end
    stripped = strip(join(rslts," "))
    replace(stripped, r"[ \t]+" => " ")
    =#
    ""
end

"""Builder for constructing a citable passage for a diplomatic text from a citable passage in archival XML.
$(SIGNATURES)
"""
function edited(
    builder::MidDiplomaticTableBuilder,
    passage::CitablePassage; 
    edition = nothing, exemplar = nothing)
    nd  = root(parsexml(passage.text))
    editiontext = edited_text(builder, nd)
    psg = passage.urn
    if length(workparts(psg)) < 3
        throw(ArgumentError("Only nodes citable at a specific version level can be edited."))
    end

    versionedurn = nothing
    if isnothing(exemplar)
        newversion = isnothing(edition) ? versionid(builder) : edition  
        versionedurn = addversion(psg, newversion)

    else
        newversion = isnothing(edition) ? versionid(builder) : edition
        version1 =  addversion(psg, newversion) 
        versionedurn = addexemplar(version1, exemplar)
    end

    CitablePassage(versionedurn, editiontext)
end