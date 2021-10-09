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
        "figure", "figDesc", "floatingText", "body", #internal structure of text associated with figure"
        "unclear", "gap", "supplied", # transcription level
        "w", "num", "foreign", # tokenization
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

"Collect text of w element"
function collectw(el, bldr)
     # collect and squeeze:
     children = nodes(el)
     wordparts = []
     for c in children
         childres = edited_text(bldr, c, "")
         push!(wordparts, childres)
     end
     # single token padded by ws:
     singletoken = replace(join(wordparts,""), r"[ ]+" => "")
end

"Compose edited text of a given XML element using a given builder."
function editedelement(builder::MidBasicBuilder, el, accum)
    if ! validelname(builder, el.name)
        str = ezxmlstring(el)
        msg = "Invalid element $(el.name) in $(str)"
        throw(DomainError(msg))
    end

    reply = []
    if el.name == "foreign"
        push!(reply, "«" * el.content * "»")

    elseif el.name == "choice"
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
        push!(reply, collectw(el, builder))
       
        # check for word-fragment convention:
        # `w` with `@n` attribute:
        # mark for subsequent peek-ahead
        #if hasattribute(el, "n")
        #    push!(reply, " ++$(singletoken)++ ")
        #else
        #    push!(reply, " $(singletoken) ")
        #end
       
        
        
    elseif skipelement(builder, el.name)
        # do nothing

    else
        children = nodes(el)
        if !(isempty(children))
            for c in children
                childres =  edited_text(builder, c, accum)
                push!(reply, childres)
            end
        end
    end
    strip(join(reply," "))
end

"""Walk parsed XML tree and compose a specific edition.
`builder` is the edition builder to use. `n` is a parsed passage. 
`accum` is the accumulation of any text already seen and collected.
"""
function edited_text(builder::MidBasicBuilder, n::EzXML.Node, accum = "")::AbstractString
	rslts = [accum]
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
end

"Builder for constructing a citable passage for a diplomatic text from a citable passage in archival XML."
function edited_passage(builder::MidBasicBuilder, passage::CitablePassage)
    nd  = root(parsexml(passage.text))
    editiontext = edited_text(builder, nd)
    CitablePassage(addversion(passage.urn, builder.versionid), editiontext)
end


