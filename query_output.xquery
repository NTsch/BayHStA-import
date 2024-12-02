xquery version "3.1";
declare namespace cei = "http://www.monasterium.net/NS/cei";

let $collections := collection('cei')/cei:cei
(:for $charter in $collection//cei:text[@type = 'charter']:)

(:return $charter/base-uri():)

(:return count($collection//cei:text[@type = 'charter']):)

(:return $charter//cei:date[@value = '99999999']:)

(:for $name in distinct-values($charter//*/name())
return concat($name, ': ', count($charter//*[name() = $name and string-join(//normalize-space()) = ''])):)

for $collection in $collections
return <result>{$collection//cei:title}</result>