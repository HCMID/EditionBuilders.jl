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


## Exported function: `edited_passage`

Subtypes of `EditionBuilder` should implement tjhe exported function `edited_passage`.




Let's create a `CitablePassage` to work from:

```jldoctest edbuild
using CitableText
using CitableCorpus
urn = CtsUrn("urn:cts:trmilli:tl.106.v1:1")
xml = """<ab n="1"><w>ebe<choice><sic>M</sic><corr>h</corr></choice>i</w> xopa : mei ti siyEni : <persName><w>sbiKaza</w></persName> Θortta : miNtehi : pddEneh : Mmi :</ab>"""
cn = CitablePassage(urn, xml)
cn.urn

# output

urn:cts:trmilli:tl.106.v1:1
```

We use `edited_passage` to apply our builder to a single `CitablePassage`. This creates a new `CitablePassage`.  The URN of the new passage is the same except that the version identifier is now the one we specified for our builder.  The text content is the literal text that our builder extracted from the XML source.

```jldoctest edbuild
edited = edited_passage(builder, cn)
edited

# output

CitablePassage(urn:cts:trmilli:tl.106.raw:1, "ebeMhi xopa : mei ti siyEni : sbiKaza Θortta : miNtehi : pddEneh : Mmi :")
```


## Creating an edition

The `edition` function can simply apply `edited_passage` to each passage of a `CitableTextCorpus` to create a new citable corpus.

Let's first make a (very short) corpus containing our previous citable passage.

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

CitableTextCorpus(CitablePassage[CitablePassage(urn:cts:trmilli:tl.106.raw:1, "ebeMhi xopa : mei ti siyEni : sbiKaza Θortta : miNtehi : pddEneh : Mmi :")])
```
