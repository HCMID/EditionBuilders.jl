
@testset "Test valid element names" begin
    bldr = MidDiplomaticBuilder("Diplomatic edition", "dipl")
    @test supertype(typeof(bldr)) == EditionBuilder

    @test validelname(bldr, "p")
    @test validelname(bldr, "fake") == false
end