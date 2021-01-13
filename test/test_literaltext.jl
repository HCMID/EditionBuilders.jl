
@testset "Test construction of builder" begin
    builder = LiteralTextBuilder("Literal text builder", "rawtext")
    @test builder.name == "Literal text builder"
    @test builder.versionid == "rawtext"
end

@testset "Test generic literal text builder" begin
    urn = CtsUrn("urn:cts:trmilli:tl.106.v1:1")
    xml = """<ab n="1"><w>ebe<choice><sic>M</sic><corr>h</corr></choice>i</w> xopa : mei ti siyEni : <persName><w>sbiKaza</w></persName> Θortta : miNtehi : pddEneh : Mmi :</ab>"""
    cn = CitableNode(urn, xml)

    builder = LiteralTextBuilder("Literal text builder", "rawtext")

    edited = editednode(builder, cn)
    @test isa(edited, CitableNode)
    
    expectedtext = "ebeMhi xopa : mei ti siyEni : sbiKaza Θortta : miNtehi : pddEneh : Mmi :"
    @test edited.text == expectedtext
end