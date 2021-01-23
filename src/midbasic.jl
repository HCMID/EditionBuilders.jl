# Functions shared by builders for diplomatic and normalized editions
# from archival XML following editorial standards of a basic
# MID project.

"EditionBuilders sharing editorial conventions of a basic MID project."
abstract type MidBasicBuilder <: EditionBuilder end

"Valid element names in `MidDiplomaticReader` and `MidNormalizedReader`."
function validElementNames(builder::MidBasicBuilder)
    [
        "p","l", # internal structure of citable units
        "unclear", "gap", # transcription level
        "w", "num", # tokenization
        "del", "add", # scribal modification
        "choice", "abbr", "expan",  "orig", "reg", "sic", "corr", #choices
        "persName", "placeName", "rs", # NE disambiguation
        "q", "cit", "title" # discourse analysis
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


"""Walk parsed XML tree and compose diplomatic text.
`n` is a parsed Node.  `accum` is the accumulation of any
text already seen and collected.
"""
function editedtext(builder::MidBasicBuilder, n::EzXML.Node, accum = "")
	rslts = [accum]
    if n.type == EzXML.ELEMENT_NODE 
        if ! validelname(builder, n.name)
            throw(DomainError("Invalid element $(n.name)."))
        end
        if n.name == "choice"
            if ! validchoice(n)
                children = elements(n)
                childnames = map(n -> n.name, children)
                badlist = join(childnames, ", ")
                throw(DomainError("Invalid children of `choice` element: $(badlist)"))
            end
        end

		children = nodes(n)
		if !(isempty(children))
			for c in children
				childres =  editedtext(builder, c, accum)
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

