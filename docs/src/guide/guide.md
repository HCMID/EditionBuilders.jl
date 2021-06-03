# User's guide

`EditionBuilder` is an abstract type. We'll illustrate how it works with a `LiteralTextBuilder` that simply extracts all text contents from an XML source.

## An example: `LiteralTextBuilder`


```jldoctest edbuild
using EditionBuilders
builder = LiteralTextBuilder("Literal text builder", "raw")
builder

# output

LiteralTextBuilder("Literal text builder", "raw")
```


## Exported function: `editednode`

Subtypes of `EditionBuilder` should implement tjhe exported function `editednode`.




Let's create a `CitableNode` to work from:

```jldoctest edbuild
using CitableText
using CitableCorpus
urn = CtsUrn("urn:cts:trmilli:tl.106.v1:1")
xml = """<ab n="1"><w>ebe<choice><sic>M</sic><corr>h</corr></choice>i</w> xopa : mei ti siyEni : <persName><w>sbiKaza</w></persName> Θortta : miNtehi : pddEneh : Mmi :</ab>"""
cn = CitableNode(urn, xml)
cn.urn

# output

CtsUrn("urn:cts:trmilli:tl.106.v1:1")
```

We use `editednode` to apply our builder to a single `CitableNode`. This creates a new `CitableNode`.  The URN of the new node is the same except that the version identifier is now the one we specified for our builder.  The text content is the literal text that our builder extracted from the XML source.

```jldoctest edbuild
edited = editednode(builder, cn)
edited

# output

CitableNode(CtsUrn("urn:cts:trmilli:tl.106.raw:1"), "ebeMhi xopa : mei ti siyEni : sbiKaza Θortta : miNtehi : pddEneh : Mmi :")
```


## Creating an edition

The `edition` function can simply apply `editednode` to each node of a `CitableTextCorpus` to create a new citable corpus.

Let's first make a (very short) corpus containing our previous citable node.

```jldoctest edbuild
corpus = CitableTextCorpus([cn])
typeof(corpus)

# output

CitableTextCorpus
```

Here's the new, univocal edition we wanted.

```jldoctest edbuild
univocal = edition(builder, corpus)
univocal

# output

CitableTextCorpus(CitableNode[CitableNode(CtsUrn("urn:cts:trmilli:tl.106.raw:1"), "ebeMhi xopa : mei ti siyEni : sbiKaza Θortta : miNtehi : pddEneh : Mmi :")])
```
