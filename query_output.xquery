xquery version "3.1";
declare namespace cei = "http://www.monasterium.net/NS/cei";
declare default element namespace "http://www.openarchives.org/OAI/2.0/";

let $cei := collection('archives_original/cei')

let $charters := $cei//cei:text[@type = 'charter']

for $charter in $charters
return $charter//cei:condition
