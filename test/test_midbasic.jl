
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
    doc = parsexml("<choice><abbr>Dr.</abbr><expan>Doctor</expan></choice>")
    n = root(doc)
    @test EditionBuilders.validchoice(n)
    # test does not depend on element order:
    doc2 = parsexml("<choice><expan>Doctor</expan><abbr>Dr.</abbr></choice>")
    n2 = root(doc2)
    @test EditionBuilders.validchoice(n2)

    doc3 = parsexml("<choice><abbr>Dr.</abbr></choice>")
    n3 = root(doc3)
    @test EditionBuilders.validchoice(n3) == false

    doc4 = parsexml("<choice><add>Doctor</add><del>Dr.</del></choice>")
    n4 = root(doc4)
    @test EditionBuilders.validchoice(n4) == false
end

@testset "Test error messages on invalid choice syntax" begin
    doc = parsexml("<choice><add>Doctor</add><del>Dr.</del></choice>")
    n = root(doc)
    bldr = MidDiplomaticBuilder("Diplomatic edition", "dipl")
    @test_throws  DomainError("Invalid children of `choice` element: add, del") editedtext(bldr, n) 
end

@testset "Test tokenization of TEI w element" begin
    raw = """<p>A bunch of <w><unclear>ha</unclear>
    rd</w> to read stuff.</p>"""
    doc = parsexml(raw)
    n = root(doc)
    bldr = MidDiplomaticBuilder("Diplomatic edition", "dipl")
    @test editedtext(bldr, n) == "A bunch of hard to read stuff."
end