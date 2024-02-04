
"An abstract type for orthographic systems."
abstract type EditionBuilder end


"""Define default version identifier.
$(SIGNATURES)
"""
function versionid(bldr::T) where {T <: EditionBuilder}
    "univocal"
end


"""Edit all citable passages using a given builder.
$(SIGNATURES)
"""
function edited(
    builder::T, 
    c::CitableTextCorpus; 
    edition = nothing, exemplar = nothing) where {T <: EditionBuilder}
    passages = map(cn -> edited(builder, cn;  edition = edition, exemplar = exemplar), c.passages)
    CitableTextCorpus(passages)
end

