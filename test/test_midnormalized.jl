
@testset "Test construction of MidNormalizedBuilder" begin
    bldr = MidNormalizedBuilder("Normalized edition", "normed")
    @test supertype(typeof(bldr)) == MidBasicBuilder
end