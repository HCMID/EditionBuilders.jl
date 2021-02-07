
"Minimize whitespace as allowed by XML syntax."
function cleanws(s)
    rmnls = replace(s, "\n" => " ")
    reducedws = replace(rmnls, r"[ \t]+" => " ")
    strip(reducedws) 
end

function ezxmlstring(n::EzXML.Node)
	ibuff = IOBuffer()
	print(ibuff, n)
	String(take!(ibuff))
end

"True if `n` has an attribute named `a`."
function hasattribute(n, attname::AbstractString)::Bool
    attnames = map(a -> a.name, attributes(n))
    attname in attnames
end