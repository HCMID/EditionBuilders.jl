@testset "Test versioning of resulting passages" begin
    struct DemoBuilder <: EditionBuilder end
    db = DemoBuilder()
    @test versionid(db) == "univocal"

    norm = normalizedbuilder()
    @test versionid(norm) == "normed"

    norm2 = normalizedbuilder(; versionid = "normalized")
    @test versionid(norm2) == "normalized"

    dip = diplomaticbuilder()
    @test versionid(dip) == "dipl"

    dip2 = diplomaticbuilder(versionid = "diplomatic")
    @test versionid(dip2) == "diplomatic"
end