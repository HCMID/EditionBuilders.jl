
@testset "Test construction of MidDiplomaticBuilder" begin
    bldr = MidDiplomaticBuilder("Diplomatic edition", "dipl")
    @test supertype(typeof(bldr)) == MidBasicBuilder
end

@testset "Test collecting diplomatic text" begin
    bldr = MidDiplomaticBuilder("Diplomatic edition", "dipl")
    doc = parsexml("<choice><abbr>Dr.</abbr><expan>Doctor</expan></choice>")    
    n = root(doc)
    #@test editedtext(bldr, n) == "Dr."
    editedtext(bldr, n)
end


