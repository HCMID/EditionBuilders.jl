# Builders for diplomatic and normalized editions
# from archival XML following MID standards.

"Builder for reading diplomatic text from TEI XML following MID conventions."
struct MidDiplomaticBuilder <: EditionBuilder
    name
    versionid
end

"Builder for constructing a citable node for a diplomatic text from a citable node in archival XML."
function editednode(builder::MidDiplomaticBuilder, citablenode::CitableNode)
    doc = parsexml(citablenode.text)
    txt = root(doc).content
    #CitableNode(addversion(citablenode.urn, builder.versionid), txt)
end


"Generic validator accepting any XML element in the text of `citablenode`."
function badusage(builder::MidDiplomaticBuilder, citablenode::CitableNode)
    []
end

function acceptedElementNames(builder::MidDiplomaticBuilder)
    [
        "unclear", "gap", # transcription level
        "w", "num", # tokenization
        "del", "add", # scribal modification
        "choice", "abbr", "expan",  "orig", "reg", "sic", "corr", #choices
        "persName", "placeName", "rs", # NE disambiguation
        "q", "cit", "title" # discourse analysis
    ]
end





