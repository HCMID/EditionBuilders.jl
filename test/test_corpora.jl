
@testset "Test buildling diplomatic corpus" begin
    
    urn = CtsUrn("urn:cts:mid:testset.c:1")
    txt = "<p n=\"1\"><choice><sic>speling</sic><corr>spelling</corr></choice></p>"
    cn = CitableNode(urn, txt)
    corpus = CitableCorpus([cn])

    dipl = MidDiplomaticBuilder("Diplomatic edition", "dipl")
    dipledition = edition(dipl, corpus)
    @test isa(dipledition, CitableCorpus)
    @test length(dipledition.corpus) == 1
    @test dipledition.corpus[1].urn == CtsUrn("urn:cts:mid:testset.c.dipl:1")
    @test dipledition.corpus[1].text == "speling"

 
end

@testset "Test building normalized corpus" begin

    urn = CtsUrn("urn:cts:mid:testset.c:1")
    txt = "<p n=\"1\"><choice><sic>speling</sic><corr>spelling</corr></choice></p>"
    cn = CitableNode(urn, txt)
    corpus = CitableCorpus([cn])

    normer = MidNormalizedBuilder("Normalized edition", "normed")
    normededition =  edition(normer, corpus)
    @test isa(normededition, CitableCorpus)
    @test length(normededition.corpus) == 1
    @test normededition.corpus[1].urn == CtsUrn("urn:cts:mid:testset.c.normed:1")
    @test normededition.corpus[1].text == "spelling"
    
end
