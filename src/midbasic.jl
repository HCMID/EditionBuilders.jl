# Functions shared by builders for diplomatic and normalized editions
# from archival XML following editorial standards of a basic
# MID project.

"EditionBuilders sharing editorial conventions of a basic MID project."
abstract type MidBasicBuilder <: EditionBuilder end

"Valid element names in `MidDiplomaticReader` and `MidNormalizedReader`."
function validElementNames(builder::MidBasicBuilder)
    [
        "p","l", "head", # citable units
        "ab", "div", "list", "item", # internal structure of citable units 
        "unclear", "gap", "supplied", # transcription level
        "w", "num", # tokenization
        "del", "add", # scribal modification
        "choice", "abbr", "expan",  "orig", "reg", "sic", "corr", #choices
        "persName", "placeName", "rs", # NE disambiguation
        "q", "cit", "ref", "title" # discourse analysis
    ]
end

"True if `elname` is a valid element name in an `MidBasicBuilder`."
function validelname(builder::MidBasicBuilder, elname::AbstractString)
    elname in validElementNames(builder)
end

"True if syntax of `n` is valid for contents of a TEI `choice`."
function validchoice(n::EzXML.Node)
    if n.name == "choice" && countelements(n) == 2
        children = elements(n)
        childnames = map(n -> n.name, children)
        
        validpairs = [
            ["abbr", "expan"],
            ["orig", "reg"],
            ["sic", "corr"]
        ]
        checked = map(check -> isempty(setdiff(check, childnames)), validpairs)
        true in checked

    else 
        false
    end
end

"Compose edited text of a given XML element using a given builder."
function editedelement(builder::MidBasicBuilder, el, accum)
    if ! validelname(builder, el.name)
        str = ezxmlstring(el)
        msg = "Invalid element $(el.name) in $(str)"
        throw(DomainError(msg))


    end

    reply = []
    if el.name == "choice"
        if ! validchoice(el)
            children = elements(el)
            childnames = map(n -> n.name, children)
            badlist = join(childnames, ", ")
            msg = "Invalid children of `choice` element: $(badlist) in  $(ezxmlstring(el))"
            throw(DomainError(msg))
            
        else
            chosen = TEIchoice(builder, el)
            push!(reply, chosen)
        end

    elseif el.name == "w"
        # collect and squeeze:
        children = nodes(el)
        wordparts = []
        for c in children
            childres = editedtext(builder, c, "")
            push!(wordparts, childres)
        end
        # single token padded by ws:
        singletoken = replace(join(wordparts,""), r"[ ]+" => "")
        push!(reply, " $(singletoken) ")
   
    elseif skipelement(builder, el.name)
        # do nothing

    else
        children = nodes(el)
        if !(isempty(children))
            for c in children
                childres =  editedtext(builder, c, accum)
                push!(reply, childres)
            end
        end
    end
    join(reply,"")
end

"""Walk parsed XML tree and compose diplomatic text.
`n` is a parsed Node.  `accum` is the accumulation of any
text already seen and collected.
"""
function editedtext(builder::MidBasicBuilder, n::EzXML.Node, accum = "")::AbstractString
	rslts = [accum]
    if n.type == EzXML.ELEMENT_NODE 
        elresults = editedelement(builder, n, accum)
        push!(rslts, elresults)

	elseif 	n.type == EzXML.TEXT_NODE
		tidier = cleanws(n.content )
		if !isempty(tidier)
			push!(rslts, accum * tidier)
		end
				
    else
        throw(DomainError("Unrecognized node type for node $(n.type)"))
	end
	join(rslts,"")
end

"Builder for constructing a citable node for a diplomatic text from a citable node in archival XML."
function editednode(builder::MidBasicBuilder, citablenode::CitableNode)
    nd  = root(parsexml(citablenode.text))
    txt = editedtext(builder, nd)
    CitableNode(addversion(citablenode.urn, builder.versionid), txt)
end


