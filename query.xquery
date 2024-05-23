xquery version "3.1";
declare namespace atom = "http://www.w3.org/2005/Atom";
declare namespace cei = "http://www.monasterium.net/NS/cei";
declare namespace xrx = "http://www.monasterium.net/NS/xrx";
declare default element namespace "urn:isbn:1-931666-22-9";

let $archives := collection('archives_original')
let $charters := $archives/ead/archdesc/dsc/c/c[did/unittitle/text() = 'Urkunden']/c

(:for $archive in $archives
let $title := $archive/ead/eadheader/filedesc/titlestmt/titleproper
return $title:)

(:for $charter in $charters
return <id>{$charter/@id/data()}</id>:)

(::)
for $val in distinct-values($charters//odd[head/text()= 'Unternummer']/p)
return <value>{$val}</value>