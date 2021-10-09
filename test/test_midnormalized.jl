
@testset "Test construction of MidNormalizedBuilder" begin
    bldr = MidNormalizedBuilder("Normalized edition", "normed")
    @test supertype(typeof(bldr)) == MidBasicBuilder
end


@testset "Test collecting diplomatic text from abbr/expan choice" begin
    bldr = MidNormalizedBuilder("Normalized edition", "normed")
    doc = parsexml("<choice><abbr>Dr.</abbr><expan>Doctor</expan></choice>")    
    n = root(doc)
    @test edited_text(bldr, n) == "Doctor"
end

@testset "Test collecting diplomatic text from orig/reg choice" begin
    bldr = MidNormalizedBuilder("Normalized edition", "normed")
    doc = parsexml("<choice><orig>good</orig><reg>better</reg></choice>")    
    n = root(doc)
    @test edited_text(bldr, n) == "better"
end

@testset "Test collecting diplomatic text from sic/cor choice" begin
    bldr = MidNormalizedBuilder("Normalized edition", "normed")
    doc = parsexml("<choice><sic>speling</sic><corr>spelling</corr></choice>")    
    n = root(doc)
    @test edited_text(bldr, n) == "spelling"
end


@testset "Test rendering of word fragments" begin
bldr = MidNormalizedBuilder("Normalized edition", "normed")
    cn1 = CitablePassage(
        CtsUrn("urn:cts:lycian:tl.t3.test:1"),
        """<ab n="1"><w n="1">tidei</w></ab>"""
    )
    cn2 = CitablePassage(
        CtsUrn("urn:cts:lycian:tl.t3.test:2"),
        """<ab n="1"><w n="1">mi</w> : hrppi</ab>"""
    )
    corpus = CitableTextCorpus([cn1, cn2])
    edited = edition(bldr, corpus)
    
    #@test edited = "something"
end