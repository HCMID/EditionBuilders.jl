
@testset "Test construction of MidDiplomaticBuilder" begin
    bldr = MidDiplomaticBuilder("Diplomatic edition", "dipl")
    @test supertype(typeof(bldr)) == MidBasicBuilder
end

@testset "Test collecting diplomatic text from abbr/expan choice" begin
    bldr = MidDiplomaticBuilder("Diplomatic edition", "dipl")
    doc = parsexml("<choice><abbr>Dr.</abbr><expan>Doctor</expan></choice>")    
    n = root(doc)
    @test editedtext(bldr, n) == "Dr."
end

@testset "Test collecting diplomatic text from orig/reg choice" begin
    bldr = MidDiplomaticBuilder("Diplomatic edition", "dipl")
    doc = parsexml("<choice><orig>good</orig><reg>better</reg></choice>")    
    n = root(doc)
    @test editedtext(bldr, n) == "good"
end

@testset "Test collecting diplomatic text from sic/cor choice" begin
    bldr = MidDiplomaticBuilder("Diplomatic edition", "dipl")
    doc = parsexml("<choice><sic>speling</sic><corr>spelling</corr></choice>")    
    n = root(doc)
    @test editedtext(bldr, n) == "speling"
end

@testset "Test tokenization of TEI w and supplied elements" begin
    raw = """<p>A bunch of <w><unclear>ha</unclear>
    rd</w> to read stuff.</p>"""
    doc = parsexml(raw)
    n = root(doc)
    bldr = MidDiplomaticBuilder("Diplomatic edition", "dipl")
    @test editedtext(bldr, n) == "A bunch of hard to read stuff."

    raw2 = "<ab n=\"3\">tideimi : hrppi : ladi : se <w>tide<supplied>imi</supplied></w></ab>"
    n2 = root(parsexml(raw2))
    @test editedtext(bldr, n2) == "tideimi : hrppi : ladi : se tide"
end

@testset "Test rendering of word fragments" begin
    bldr = MidDiplomaticBuilder("Diplomatic edition", "dipl") 
    cn1 = CitableNode(
        CtsUrn("urn:cts:lycian:tl.t3.test:1"),
        """<ab n="1"><w n="1">tidei</w></ab>"""
    )
    cn2 = CitableNode(
        CtsUrn("urn:cts:lycian:tl.t3.test:2"),
        """<ab n="1"><w n="1">mi</w> : hrppi</ab>"""
    )
    corpus = CitableCorpus([cn1, cn2])
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
   
end