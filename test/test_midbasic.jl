
@testset "Test valid element names" begin
    dipl = MidDiplomaticBuilder("Diplomatic edition", "dipl")
    @test supertype(typeof(dipl)) == MidBasicBuilder

    @test validelname(dipl, "p")
    @test validelname(dipl, "fake") == false

    normed = MidNormalizedBuilder("Normalized edition", "normed")
    @test supertype(typeof(normed)) == MidBasicBuilder

    @test validelname(normed, "p")
    @test validelname(normed, "fake") == false
end

@testset "Test valid TEI choice syntax" begin
    
end