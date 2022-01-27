
# Simply collect text from root.

"Builder for reading raw text from XML edition."
struct LiteralTextBuilder <: EditionBuilder
    name
    versionid
end


"""Generic edition builder mindlessly extracting all text content from XML passage.
$(SIGNATURES)
"""
function edited(
	builder::LiteralTextBuilder, 
	passage::CitablePassage; 
	edition = nothing, exemplar = nothing)
    doc = parsexml(passage.text)
    txt = root(doc).content
    CitablePassage(addversion(passage.urn, builder.versionid), txt)
end


"""Generic validator accepting any XML element in the text of `CitablePassage`.
$(SIGNATURES)
"""
function usageerrors(builder::LiteralTextBuilder, passage::CitablePassage)
    []
end


"""True if elname is a valid name for an XML element in the given Edition Builder.
$(SIGNATURES)
"""
function validelname(builder::EditionBuilder, elname::AbstractString)::Bool
    elname in validElementNames(builder)
end

"""No element names are accepted by default. 
Subtypes of `EditionBuilder` must implement this function appropriately."""
function validElementNames(builder::EditionBuilder)
    []
end

"""Compose text content from an XML passage using a LiteralTextBuilder.
$(SIGNATURES)
"""
function edited_text(builder::LiteralTextBuilder, n::EzXML.Node, accum = "")
	rslts = [accum]
	if n.type == EzXML.ELEMENT_NODE 
		children = nodes(n)
		if !(isempty(children))
			for c in children
				childres =  edited_text(builder, c, accum)
			 	push!(rslts, childres)
			end
		end
			
	elseif 	n.type == EzXML.TEXT_NODE
		tidier = cleanws(n.content )#
		if !isempty(tidier)
			push!(rslts, accum * tidier)
		end
				
    else
        throw(DomainError("Unrecognized node type for node $(n.type)"))
	end
	join(rslts,"")
end