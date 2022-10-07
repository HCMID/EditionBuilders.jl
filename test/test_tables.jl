

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



@testset "Test some real tabular data" begin
    longrow = """ <row n="198_1">
            <cell role="spatium"/>
            <cell><num>IX</num></cell>
            <cell><persName>Archelaus</persName> nono <choice>
                <abbr>ano</abbr>
                <expan>anno</expan>
              </choice> regni sui in <placeName><choice>
                  <abbr>uienna</abbr>
                  <expan>uiennam</expan>
                </choice></placeName> urbem <placeName>gallie</placeName>
              <choice>
                <abbr>relegat</abbr>
                <expan>relegatur</expan>
              </choice>.</cell>
            <cell><num>LVI</num></cell>
            <cell>Defectio solis facta: et <persName>Augustus</persName>
              <num>LXXVI</num> aetatis anno: <persName>atelle</persName>
              <choice>
                <abbr>i</abbr>
                <expan>in</expan>
              </choice>
              <placeName>campania</placeName>
              <choice>
                <abbr>morit</abbr>
                <expan>moritur</expan>
              </choice>. <choice>
                <abbr>sepellitq</abbr>
                <expan>sepelliturque</expan>
              </choice>
              <placeName>romae</placeName>
              <choice>
                <abbr>i</abbr>
                <expan>in</expan>
              </choice>
              <placeName>campo martio</placeName>.</cell>
          </row>"""
          txt = replace(longrow,"\n" => "")
        u = CtsUrn("urn:cts:latinLit:stoa0162.stoa005.gen49:30.t1.198_1")
        cp = CitablePassage(u, txt)
end

#=

=#
#=


          <row role="header" n="header_4">
            <cell role="annimundi"><choice>
              <abbr>ANN</abbr>
              <expan>ANNI</expan>
            </choice>. MVNDI.</cell>
            <cell role="filum" n="Judean Hebrews"><rs type="ethnic">IVDAEORVM</rs></cell>
            <cell role="spatium"/>
            <cell role="filum" n="Romans"><rs type="ethnic">ROMANORVM</rs>.</cell>
            <cell role="spatium"/>
          </row>
          <row n="197_4">
            <cell role="spatium"/>
            <cell><num>VIII</num></cell>
            <cell role="spatium"/>
            <cell><num>LV</num></cell>
            <cell><persName>Augustus</persName> cum <persName>Tiberio</persName> filio suo <choice>
                <abbr>censu</abbr>
                <expan>censum</expan>
              </choice>
              <placeName>rome</placeName> agitans. Inuenit <choice>
                <abbr>hinu</abbr>
                <expan>himnum</expan>
              </choice> nonagies ter centena et sexaginta milia. <persName>Socio</persName>
              <choice>
                <abbr>phus</abbr>
                <expan>philosophus</expan>
              </choice>
              <rs type="ethnic">Alexandrinus</rs>
              <choice>
                <abbr>pceptor</abbr>
                <expan>praeceptor</expan>
              </choice> senece: clarus <choice>
                <abbr>hr</abbr>
                <expan>habetur</expan>
              </choice>.</cell>
          </row>
          <row role="olympiad" n="198">
            <cell role="spatium"/>
            <cell><choice>
                <abbr>Olymp</abbr>
                <expan>Olympias</expan>
              </choice>.
              <num>CXCVIII</num>.</cell>
            <cell role="spatium"/>
            <cell role="spatium"/>
            <cell role="spatium"/>
          </row>
          <row n="198_1">
            <cell role="spatium"/>
            <cell><num>IX</num></cell>
            <cell><persName>Archelaus</persName> nono <choice>
                <abbr>ano</abbr>
                <expan>anno</expan>
              </choice> regni sui in <placeName><choice>
                  <abbr>uienna</abbr>
                  <expan>uiennam</expan>
                </choice></placeName> urbem <placeName>gallie</placeName>
              <choice>
                <abbr>relegat</abbr>
                <expan>relegatur</expan>
              </choice>.</cell>
            <cell><num>LVI</num></cell>
            <cell>Defectio solis facta: et <persName>Augustus</persName>
              <num>LXXVI</num> aetatis anno: <persName>atelle</persName>
              <choice>
                <abbr>i</abbr>
                <expan>in</expan>
              </choice>
              <placeName>campania</placeName>
              <choice>
                <abbr>morit</abbr>
                <expan>moritur</expan>
              </choice>. <choice>
                <abbr>sepellitq</abbr>
                <expan>sepelliturque</expan>
              </choice>
              <placeName>romae</placeName>
              <choice>
                <abbr>i</abbr>
                <expan>in</expan>
              </choice>
              <placeName>campo martio</placeName>.</cell>
          </row>
          <row role="regnal" n="198_1_r1">
            <cell role="spatium"/>
            <cell><rs type="ethnic">IVDaeorum</rs>
              <choice>
                <abbr>pncipatum</abbr>
                <expan>principatum</expan>
              </choice> tenet <persName>herodes</persName> tetrarcha <choice>
                <abbr>ann</abbr>
                <expan>annis</expan>
              </choice>.
              <num>XXIIII</num>.</cell>
            <cell role="spatium"/>
            <cell><rs type="ethnic"><choice>
                  <abbr>ROMANORV</abbr>
                  <expan>ROMANORVM</expan>
                </choice></rs>. <num>III</num>. <persName>TIBERIVS</persName>. <choice>
                <abbr>Ann</abbr>
                <expan>Annis</expan>
              </choice>.
              <num>XXIII</num>.</cell>
            <cell role="spatium"/>
          </row>
          <row n="198_2">
            <cell role="spatium"/>
            <cell><num>I</num></cell>
            <cell role="spatium"/>
            <cell><num>I</num></cell>
            <cell><persName><choice>
                  <abbr>C.</abbr>
                  <expan>Gaius</expan>
                </choice> Asinnius gallus</persName> orator <persName>Asinii pollionis</persName>
              filius. Cuius <choice>
                <abbr>et</abbr>
                <expan>etiam</expan>
              </choice>
              <persName>uirgilius</persName> meminit: diris a <persName>tiberio</persName> supliciis <choice>
                <abbr>enecat</abbr>
                <expan>enecatur</expan>
              </choice>.</cell>
          </row>
          <row n="198_3">
            <cell role="spatium"/>
            <cell><num>II</num></cell>
            <cell role="spatium"/>
            <cell><num>II</num></cell>
            <cell role="spatium"/>
          </row>
=#