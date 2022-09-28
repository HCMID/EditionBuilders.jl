

@testset "Test MidDiplomaticTableBuilder" begin
    u  = CtsUrn("urn:cts:latinLit:stoa0162.stoa005.gen49:14.t1.header")
    txt = "<row role=\"header\" n=\"header\"><cell>Header cell 1</cell><cell>Header col 2</cell></row>"
    cn = CitablePassage(u, txt)
   
    
end


#=
 using CitableBase

julia> using CitableText

julia> using CitableCorpus

julia> u  = CtsUrn("urn:cts:latinLit:stoa0162.stoa005.gen49:14.t1.header")
urn:cts:latinLit:stoa0162.stoa005.gen49:14.t1.header

julia> cn = CitablePassage(u, txt)
<urn:cts:latinLit:stoa0162.stoa005.gen49:14.t1.header> <row role="header" n="header"><cell>Header cell 1</cell><cell>Header col 2</cell></row>
=#