
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
    cn1 = CitableNode(
        CtsUrn("urn:cts:lycian:tl.t3.test:1"),
        """<ab n="1"><w n="1">tidei</w></ab>"""
    )
    cn2 = CitableNode(
        CtsUrn("urn:cts:lycian:tl.t3.test:2"),
        """<ab n="1"><w n="1">mi</w> : hrppi</ab>"""
    )
    corpus = CitableCorpus([cn1, cn2])
    fragg = EditionBuilders.fragmentsDictionary(bldr, corpus)
    @test fragg["1"] == "tidei-mi"
    #=
    edited = edition(bldr, corpus)
    @test length(edited.corpus)  == 2

    dipl1 =  CitableNode(
        CtsUrn("urn:cts:lycian:tl.t3.dipl:1"),
        """tidei"""
    )
    @test edited.corpus[1] == dipl1

    dipl2 =  CitableNode(
        CtsUrn("urn:cts:lycian:tl.t3.dipl:2"),
        """mi : hrppi"""
    )
    =#
end

@testset "Test multiline line crossing text" begin 
    cn1 = CitableNode(
        CtsUrn("urn:cts:lycian:tl.t3.test:1"),
        """<ab n="1"><w>eb<unclear>A</unclear>Nn<supplied>E</supplied></w> prNnawA : <w>me=<supplied>t</supplied>i</w></ab>""")
    cn2 = CitableNode(
        CtsUrn("urn:cts:lycian:tl.t3.test:2"),
        """<ab n="2">prNnawatE : <persName><w>telex<unclear>o</unclear>zi</w></persName> : <w>hrp<supplied>p</supplied>i</w></ab>""")
    cn3 = CitableNode(
            CtsUrn("urn:cts:lycian:tl.t3.test:2"),
            """<ab n="3"><w>l<supplied>a</supplied>di</w> : <w>ehb<supplied>i</supplied></w> : se tideimi se=di</ab>""")
    cn4 = CitableNode(
        CtsUrn("urn:cts:lycian:tl.t3.test:2"),
        """<ab n="4">Nta <w><supplied>t</supplied>adE</w> tesi : miNti : <w n="4">alad</w></ab>""")
    cn5 = CitableNode(
        CtsUrn("urn:cts:lycian:tl.t3.test:2"),
        """<ab n="5"><w n="4">ehali</w> : adE <num>IIII</num> </ab>""")
    nodes = [cn1, cn2, cn3, cn4, cn5]
    corpus = CitableCorpus(nodes)
end


