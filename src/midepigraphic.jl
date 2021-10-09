"Builder for reading normalized text from TEI XML following MID conventions."
struct MidEpigraphicBuilder <: MidBasicBuilder
    name
    versionid
end

"Make normalized choice of MID-legal TEI choice."
function TEIchoice(builder::MidEpigraphicBuilder, n)
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

function skipelement(builder::MidEpigraphicBuilder,elname)
    elname in ["del", "ref"]
end

"Build a dictionary of line-spanning word fragments."
function fragmentsDictionary(builder::MidEpigraphicBuilder, c::CitableTextCorpus)
    fragments = Dict()
    # Build dictionary of fragemented words
    for n in c.passages
        nroot = parsexml(n.text).root
        wds = findall("//w", nroot)
        #println(string("FOUND words " , length(wds)))
        for w in wds
            attnames = map(att -> att.name, attributes(w))
            if "n" in attnames
                nval = w["n"]
                wtext = EditionBuilders.collectw(w, builder)
                #println("\tThis one has nval " * nval)
                if nval in keys(fragments)
                    #println("MODIFY")
                    fragments[nval] = fragments[nval] * "-" * wtext
                else
                    
                    #println("ADD " * wtext)
                    fragments[nval] = wtext
                end
            end
        end

    end
    fragments
end


"Compose edited text of a given XML element using a given builder."
function editedelement(builder::MidEpigraphicBuilder, el, fragments, seen, accum)
    nowseen = seen
    #println("Editing ", el.name, " with seen ", seen)
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
        #println("\n\nSEEING A W and fraglist is ", keys(fragments))
        #println("While already seen = ", nowseen)
        if hasattribute(el, "n")
            nval = el["n"]
            if nval in nowseen
                #println("Already seen " * nval)
                # skip
            elseif nval in keys(fragments)
                #println("Checking n = " * nval)
                push!(reply, fragments[nval])
                if nval in seen
                    pritnln("\tAlready seen")
                else
                    #println("\tPushing ", nval)
                    push!(nowseen, nval)
                    #println("and seen is now ", nowseen )
                end
                
            else
                push!(reply, collectw(el, builder))
            end
        else
            # Regular word wrapper
            push!(reply, collectw(el, builder))
        end
    
    
    
        
    elseif skipelement(builder, el.name)
        # do nothing

    else
        #println("Getting epigraphic children.")
        children = nodes(el)
        if !(isempty(children))
            for c in children
                childres =  edited_text(builder, c, fragments, nowseen, accum)
                push!(reply, childres)
            end
        end
    end
    (strip(join(reply," ")), nowseen)
    
end


function edited_passage(
    builder::MidEpigraphicBuilder, 
    CitablePassage::CitablePassage, 
    fragments::Dict, 
    seen::Array, 
    accum::AbstractString = "")
    n  = root(parsexml(CitablePassage.text))
    #editiontext = edited_text(builder, nd)
    rslts = [accum]
    if n.type == EzXML.ELEMENT_NODE 
        elresults = editedelement(builder, n,  fragments, seen, accum)
        push!(rslts, elresults[1])

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
    editiontext =replace(stripped, r"[ \t]+" => " ")
    #println("==>Add text ", editiontext, " for urn ", passagecomponent(CitablePassage.urn), "\n\n")
    (CitablePassage(addversion(CitablePassage.urn, builder.versionid), editiontext),
    seen
    )
end


"""Walk parsed XML tree and compose a specific edition.
`builder` is the edition builder to use. `n` is a parsed passage. 
`accum` is the accumulation of any text already seen and collected.
"""
function edited_text(builder::MidEpigraphicBuilder, n::EzXML.Node, fragments, seen = [], accum = "")::AbstractString
	rslts = [accum]
    if n.type == EzXML.ELEMENT_NODE 
        elresults = editedelement(builder, n, fragments, seen, accum)
        push!(rslts, elresults[1])

	elseif 	n.type == EzXML.TEXT_NODE
		tidier = cleanws(n.content)
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


function edition(builder::MidEpigraphicBuilder, c::CitableTextCorpus)
    # First, build a dictionary of word fragments
    fragments = fragmentsDictionary(builder, c)
    usedfragments = []
    passages = []
    for cn in c.passages
        editedpair = edited_passage(builder, cn, fragments, usedfragments, "")
        push!(passages, editedpair[1])
        push!(usedfragments, editedpair[2])
    end
    #passages = map(cn -> edited_passage(builder, cn), c.passages)
    #nd  = root(parsexml(CitablePassage.text))
    #editiontext = edited_text(builder, nd, fragments)
    # CitablePassage(addversion(CitablePassage.urn, builder.versionid), editiontext)
    CitableTextCorpus(passages)
end

