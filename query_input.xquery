xquery version "3.1";
declare namespace cei = "http://www.monasterium.net/NS/cei";
declare default element namespace "urn:isbn:1-931666-22-9";

let $archives := collection('archives_original')//ead
for $file in $archives
where $file//c[@level='class' and c[@level='file']]
return $file/base-uri()

(:for $archive in $archives
let $title := $archive/ead/eadheader/filedesc/titlestmt/titleproper
return $title:)

(:return distinct values for certain fields:)
(:for $val in distinct-values($charters//odd[head/text() = 'Änderungsdatum Archivtektonik']/p)
return <value>{$val}</value>:)

(:for $val in distinct-values($charters//odd/head/text())
return <value>{$val}</value>:)

(:are there empty values?:)
(:for $charter in $charters//odd[head/text() = 'Monat']/p[text()='']
return <value>{concat($charter/ancestor::ead/eadheader/eadid/text(), ' - ', $charter/ancestor::c[1]/@id/data())}</value>:)

(:does not have a certain element:)
(:for $charter in $charters
where $charter[not(odd/head/text() = 'Jahr')]
return <value>{concat($charter/ancestor::ead/eadheader/eadid/text(), ' - ', $charter/ancestor::c[1]/@id/data())}</value>:)

(:return charters that contain a certain value:)
(:for $charter in $charters/odd/p[contains(text(), 'Analoges Archivale')]
return <value>{concat($charter/ancestor::ead/eadheader/eadid/text(), ' - ', $charter/ancestor::c[1]/@id/data())}</value>:)

(:return charters that don't contain a certain value:)
(:for $charter in $charters
where $charter[not(//odd/p[contains(text(), 'Analoges Archivale')])]
return <value>{concat($charter/ancestor::ead/eadheader/eadid/text(), ' - ', $charter/@id/data())}</value>:)