
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



"""Walk parsed XML tree and compose diplomatic text.
`n` is a parsed Node.  `accum` is the accumulation of any
text already seen and collected.
"""
function diplomatic(builder::MidDiplomaticBuilder, n::EzXML.Node, accum = "")
	rslts = [accum]
	if n.type == EzXML.ELEMENT_NODE 
		children = nodes(n)
		#kidcount = length(children)
		#println("EL ", n.name, " at accum " , accum,  " with ", kidcount, " children ")	
		if !(isempty(children))
			for c in children
				childres =  diplomatic(builder, c, accum)
				#println("  -- pushing child result ", childres)
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
			
			
	#println("  =>Returning result ",  rslts)
	join(rslts,"")
end