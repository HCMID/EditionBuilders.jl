
@testset "Test buildling diplomatic corpus" begin
    
    urn = CtsUrn("urn:cts:mid:testset.c:1")
    txt = "<p n=\"1\"><choice><sic>speling</sic><corr>spelling</corr></choice></p>"
    cn = CitablePassage(urn, txt)
    corpus = CitableTextCorpus([cn])

    dipl = MidDiplomaticBuilder("Diplomatic edition", "dipl")
    dipledition = edition(dipl, corpus)
    @test isa(dipledition, CitableTextCorpus)
    @test length(dipledition.passages) == 1
    @test dipledition.passages[1].urn == CtsUrn("urn:cts:mid:testset.c.dipl:1")
    @test dipledition.passages[1].text == "speling"

 
end

@testset "Test building normalized corpus" begin

    urn = CtsUrn("urn:cts:mid:testset.c:1")
    txt = "<p n=\"1\"><choice><sic>speling</sic><corr>spelling</corr></choice></p>"
    cn = CitablePassage(urn, txt)
    corpus = CitableTextCorpus([cn])

    normer = MidNormalizedBuilder("Normalized edition", "normed")
    normededition =  edition(normer, corpus)
    @test isa(normededition, CitableTextCorpus)
    @test length(normededition.passages) == 1
    @test normededition.passages[1].urn == CtsUrn("urn:cts:mid:testset.c.normed:1")
    @test normededition.passages[1].text == "spelling"
    
end
