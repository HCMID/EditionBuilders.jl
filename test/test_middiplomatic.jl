
@testset "Test construction of MidDiplomaticBuilder" begin
    bldr = MidDiplomaticBuilder("Diplomatic edition", "dipl")
    @test supertype(typeof(bldr)) == MidBasicBuilder
end