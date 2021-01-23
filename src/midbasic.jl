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
