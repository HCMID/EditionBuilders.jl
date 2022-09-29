

@testset "Test MidDiplomaticTableBuilder" begin
    tabcex = """
    #!ctsdata
    urn:cts:latinLit:stoa0162.stoa005.gen49:14.t1.header|<row role="header" n="header"><cell>Header data 1</cell><cell>Header data 2</cell></row>
    urn:cts:latinLit:stoa0162.stoa005.gen49:14.t1.regnal| <row n="regnal"><cell>Regnal declaration</cell><cell>Regnal declaration 2</cell></row>
    urn:cts:latinLit:stoa0162.stoa005.gen49:14.t1.1|<row  n="1"><cell>Row 1 data</cell><cell>R1 C2</cell></row>
    urn:cts:latinLit:stoa0162.stoa005.gen49:14.t1.2>|<row n="2"><cell>Row 2 data</cell><cell>R2 C2</cell></row>
    """

    c = fromcex(tabcex, CitableTextCorpus)

    ncorpus = edited(normedtable(), c)
    @test length(ncorpus) == 4
    @test length(split(ncorpus.passages[1].text ,"\n")) == 2


    dcorpus = edited(diplomatictable(), c)
    @test length(dcorpus) == 4
    @test length(split(dcorpus.passages[1].text ,"\n")) == 2

    ncorpus = edited(normedtable(), c)
    @test length(dcorpus) == 4
    @test length(split(dcorpus.passages[1].text ,"\n")) == 2
end

