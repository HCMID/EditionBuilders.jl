# User's guide

`EditionBuilder` is an abstract type. We'll illustrate how it works with a `LiteralTextBuilder` that simply extracts all text contents from an XML source.

```jldoctest edbuild
using EditionBuilders
builder = LiteralTextBuilder("Literal text builder", "raw")
builder

# output

LiteralTextBuilder("Literal text builder", "raw")
```

Subtypes of `EditionBuilder` should implement these three exported functions:

- editedtext
- editednode
- edition



Let's create a `CitableNode` to work from:

```jldoctest edbuild
using CitableText
urn = CtsUrn("urn:cts:trmilli:tl.106.v1:1")
xml = """<ab n="1"><w>ebe<choice><sic>M</sic><corr>h</corr></choice>i</w> xopa : mei ti siyEni : <persName><w>sbiKaza</w></persName> Θortta : miNtehi : pddEneh : Mmi :</ab>"""
cn = CitableNode(urn, xml)
cn.urn

# output

CtsUrn("urn:cts:trmilli:tl.106.v1:1")
```
When we apply `editednode`, we get a new `CitableNode`.  The URN is the same but with the new version identifier we specified for our builder.  The text content is the literal text that our builder extracted from the XML source.

```@example edbuild
edited = editednode(builder, cn)
edited

# output

CitableNode(CtsUrn("urn:cts:trmilli:tl.106.raw:1"), "ebeMhi xopa : mei ti siyEni : sbiKaza Θortta : miNtehi : pddEneh : Mmi :")
```