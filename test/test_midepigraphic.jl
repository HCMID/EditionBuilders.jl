
@testset "Test construction of MidEpigraphicBuilder" begin
    bldr = MidEpigraphicBuilder("Edition of epigraphic text", "epig")
    @test supertype(typeof(bldr)) == MidBasicBuilder
end

@testset "Test collecting normalized text from abbr/expan choice" begin
    bldr = MidEpigraphicBuilder("Edition of epigraphic text", "epig")
    doc = parsexml("<choice><abbr>Dr.</abbr><expan>Doctor</expan></choice>")    
    n = root(doc)
    @test editedtext(bldr, n) == "Doctor"
end

@testset "Test collecting diplomatic text from orig/reg choice" begin
    bldr = MidEpigraphicBuilder("Edition of epigraphic text", "epig")
    doc = parsexml("<choice><orig>good</orig><reg>better</reg></choice>")    
    n = root(doc)
    @test editedtext(bldr, n) == "better"
end

@testset "Test collecting diplomatic text from sic/cor choice" begin
    bldr = MidEpigraphicBuilder("Edition of epigraphic text", "epig")
    doc = parsexml("<choice><sic>speling</sic><corr>spelling</corr></choice>")    
    n = root(doc)
    @test editedtext(bldr, n) == "spelling"
end

@testset "Test tokenization of TEI w and supplied elements" begin
    raw = """<p>A bunch of <w><unclear>ha</unclear>
    rd</w> to read stuff.</p>"""
    doc = parsexml(raw)
    n = root(doc)
    bldr = MidEpigraphicBuilder("Edition of epigraphic text", "epig")
    @test editedtext(bldr, n) == "A bunch of hard to read stuff."

    raw2 = "<ab n=\"3\">tideimi : hrppi : ladi : se <w>tide<supplied>imi</supplied></w></ab>"
    n2 = root(parsexml(raw2))
    @test editedtext(bldr, n2) == "tideimi : hrppi : ladi : se tideimi"
end

@testset "Test building dictionary of word fragments" begin
    bldr = MidEpigraphicBuilder("Edition of epigraphic text", "epig") 
    cn1 = CitablePassage(
        CtsUrn("urn:cts:lycian:tl.t3.test:1"),
        """<ab n="1"><w n="1">tidei</w></ab>"""
    )
    cn2 = CitablePassage(
        CtsUrn("urn:cts:lycian:tl.t3.test:2"),
        """<ab n="1"><w n="1">mi</w> : hrppi</ab>"""
    )
    corpus = CitableTextCorpus([cn1, cn2])
    fragg = EditionBuilders.fragmentsDictionary(bldr, corpus)
    @test fragg["1"] == "tidei-mi"
    #=
    edited = edition(bldr, corpus)
    @test length(edited.passages)  == 2

    dipl1 =  CitablePassage(
        CtsUrn("urn:cts:lycian:tl.t3.dipl:1"),
        """tidei"""
    )
    @test edited.passages[1] == dipl1

    dipl2 =  CitablePassage(
        CtsUrn("urn:cts:lycian:tl.t3.dipl:2"),
        """mi : hrppi"""
    )
    =#
end

@testset "Test multiline line crossing text" begin 
    cn1 = CitablePassage(
        CtsUrn("urn:cts:lycian:tl.t3.test:1"),
        """<ab n="1">ebENnE : <w n="1">xo</w></ab>""")
    cn2 = CitablePassage(
        CtsUrn("urn:cts:lycian:tl.t3.test:2"),
        """<ab n="2"><w n="1">pA</w> : <w>m<unclear>E</unclear>=ne</w> <w n="2">pr</w></ab>""")
    cn3 = CitablePassage(
            CtsUrn("urn:cts:lycian:tl.t3.test:3"),
            """ <ab n="3"><w n="2">NnawatE</w> : <w n="3">me</w></ab>""")
    cn4 = CitablePassage(
        CtsUrn("urn:cts:lycian:tl.t3.test:4"),
        """<ab n="4"><w n="3">de</w> : epNnEni</ab>""")
    cn5 = CitablePassage(
        CtsUrn("urn:cts:lycian:tl.t3.test:5"),
        """<ab n="5">ehbi : <persName><w n="5">hMprA</w></persName></ab>""")
    cn6 = CitablePassage(
        CtsUrn("urn:cts:lycian:tl.t3.test:5"),
        """<ab n="6"><w n="5">ma</w> : sey=atli</ab>""")
    nodes = [cn1, cn2, cn3, cn4, cn5, cn6]
    corpus = CitableTextCorpus(nodes)

end


