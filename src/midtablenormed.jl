
"."
struct MidNormalizedTableBuilder <: MidBasicBuilder
    name::AbstractString
    versionid::AbstractString
    normalizer::MidDiplomaticBuilder
end

function diplomatictable(; versionid = "normed")
   MidDiplomaticBuilder("MID normalized edition builder for tables", versionid, normalizedbuilder())
end
