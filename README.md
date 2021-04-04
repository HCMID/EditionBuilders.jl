
# EditionBuilders

A Julia package to build specified editions from multivalent sources.

## What does it do?

Scholarly editing projects often encode texts in complex documents (typically using XML) that record multiple possible readings.  Possible readings might include corrections, additions or alterations by the author or a later reader, or editorial intervention by modern editor to expand abbreviations, normalize the text, or otherwise explain the text to a modern reader.

To analyze or read a text computationally, however, we need to extract one or more *univocal* editions from a source document: that is, a single reading of the text.  It might be a purely dipomatic reading, the reading of a later hand in a manuscript, or an editorially normalized reading, for example.  It could even be a reading optimized for computational processing such as a lemmatized text or a text omitting "stop words".

The `EditionBuilders` package defines a standard interface for extracting univocal texts from source documents.


## Documentation


See the [documentation site](https://hcmid.github.io/EditionBuilders.jl/stable/).