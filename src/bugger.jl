using EditionBuilders
using EzXML

bldr = MidDiplomaticBuilder("Diplomatic edition", "dipl")
doc = parsexml("<choice><sic>speling</sic><corr>spelling</corr></choice>")    
n = root(doc)


txt = wtoken(bldr, n)
