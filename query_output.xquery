xquery version "3.1";
declare namespace cei = "http://www.monasterium.net/NS/cei";

(:let $collection := collection('archives_original/cei')/cei:cei
for $charter in $collection//cei:text[@type = 'charter']
return $charter/base-uri():)

let $collection := collection('archives_original/cei')/cei:cei
return count($collection//cei:text[@type = 'charter'])