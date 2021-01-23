
"Minimize whitespace according to XML syntax."
function cleanws(s)
    rmnls = replace(s, "\n" => " ")
    reducedws = replace(rmnls, r"[ \t]+" => " ")
    strip(reducedws) 
end

"Edit all citable nodes using a given builder."
function edition(builder::EditionBuilder, c::CitableCorpus)
    ""
end