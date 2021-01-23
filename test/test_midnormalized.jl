
@testset "Test construction of MidNormalizEdBuilder" begin
    bldr = MidNormalizEdBuilder("Normalized edition", "normed")
    @test supertype(typeof(bldr)) == MidBasicBuilder
end