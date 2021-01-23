
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




