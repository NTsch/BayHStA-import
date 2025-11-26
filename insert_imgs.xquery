xquery version "3.1";
declare namespace cei = "http://www.monasterium.net/NS/cei";
declare namespace tei = "http://www.tei-c.org/ns/1.0";

let $img_locations := doc('jpg_files.xml')
let $correspondence_entries := collection('char_ids_tei')//tei:row

for $charter in collection('cei')//cei:text[@type='charter']

let $id := $charter//cei:idno/@id/data()

(: where $id = 'BayHStA, Kloster Weltenburg Urkunden 1' :)

let $entry := $correspondence_entries/tei:cell[@n='1' and text() = $id]
let $fond_name := replace(substring-before($id, ' Urkunde'), '[\s,.]', '')
let $img_dir := $entry/parent::tei:*/child::tei:cell[@n='2']/text()
where $img_dir != ''

for $img_name in $img_locations//Directory[contains(@path, $img_dir)]/File/@name/data()
order by $img_name
let $img_link := concat('http://images.monasterium.net/img/DE-BayHStA/', $fond_name, '/', $img_dir, '/', $img_name)

let $fig := <cei:figure><cei:graphic url="{$img_link}"/></cei:figure>

return (
delete nodes $charter//cei:witnessOrig//cei:figure,
insert node $fig into $charter//cei:witnessOrig
)
