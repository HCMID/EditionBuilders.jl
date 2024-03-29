
"."
struct MidNormalizedTableBuilder <: MidBasicBuilder
    name::AbstractString
    versionid::AbstractString
    normalizer::MidNormalizedBuilder
end



function normedtable(; versionid = "normed")
    MidNormalizedTableBuilder("MID normalized edition builder for tables", versionid, normalizedbuilder())
end




"""Version identifier used by this builder.
$(SIGNATURES)
"""
function versionid(bldr::MidNormalizedTableBuilder) 
    bldr.versionid
end



"""
$(SIGNATURES)
"""
function edited_row(builder::MidNormalizedTableBuilder, row::EzXML.Node, tablify = false)::AbstractString
    rslts = []
    
    if row.name == "row"
        
        cells = findall("cell", row)
        @debug("Process row: $(length(cells)) cells")
        if tablify
            for i in 1:length(cells)
                push!(rslts, "| ")
            end
            push!(rslts, " |\n")
            for i in 1:length(cells)
                push!(rslts, "| --- ")
            end
            push!(rslts, " |\n")
        end

        for c in cells  
            push!(rslts, "| ")
            for n in eachnode(c)
                if n.type == EzXML.ELEMENT_NODE 
                    elresults = editedelement(builder.normalizer, n, "")
                    push!(rslts, elresults)
                 
                elseif 	n.type == EzXML.TEXT_NODE
                    tidier = cleanws(n.content )
                    if !isempty(tidier)
                        push!(rslts, tidier)
                    end
                            
                elseif n.type == EzXML.COMMENT_NODE
                    # do nothing
                else
                    throw(DomainError("Unrecognized XML node type for passage $(n.type)"))
                end
            end
            
        end
        
        push!(rslts, " |")
        @info("Results for row: ", join(rslts, " "))
        
        if haskey(row, "role")
            role = row["role"]
            if lowercase(role) == "header"
                @debug("FORMAT $(role)") 
                push!(rslts, "\n")                
                for i in 1:length(cells)
                    push!(rslts, "| --- ")
                end
           
                
            end
        end
        push!(rslts, " |")
        join(rslts, " ")
    
    else
        @warn("I'm not prepared to parse a $(row.name)")
    end
end

"""Builder for constructing a citable passage for a normalized text from a citable passage in archival XML.
$(SIGNATURES)
"""
function edited(
    builder::MidNormalizedTableBuilder,
    passage::CitablePassage; 
    edition = nothing, exemplar = nothing,
    tablify = false)
    nd  = root(parsexml(passage.text))
    @debug("xml node is a", nd.name)
    @debug("xml text is ", passage.text)



    editiontext = edited_row(builder, nd, tablify)
    @debug("Edition text is", editiontext)
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




function edited(
    builder::MidNormalizedTableBuilder, 
    c::CitableTextCorpus;
    edition = nothing, exemplar = nothing)
    passages = map(cn -> edited(builder, cn, edition = edition, exemplar = exemplar), c.passages)
    #tidied = map(cn -> tidyFrag(cn),passages)
    CitableTextCorpus(passages)
end