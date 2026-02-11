xquery version "3.1";
declare namespace cei = "http://www.monasterium.net/NS/cei";
declare namespace tei = "http://www.tei-c.org/ns/1.0";

(:let $img_locations := doc('jpg_files.xml')
let $correspondence_entries := collection('char_ids_tei')//tei:row

for $charter in collection('cei')//cei:text[@type='charter']

let $id := $charter//cei:idno/@id/data()

(\: where $id = 'BayHStA, Kloster Weltenburg Urkunden 1' :\)

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
):)

let $img-locations := doc('jpg_files.xml')/Files
for $charter in collection('/db/niklas/import/bayhsta/cei')//cei:text[@type='charter']
let $delete := update delete $charter//cei:witnessOrig//cei:figure
let $archIdentifier := $charter/cei:body/cei:chDesc/cei:witnessOrig/cei:archIdentifier
let $fond-name := $archIdentifier/cei:archFond/text()
let $img-dir := substring-before(substring-after($archIdentifier/cei:ref/@target/data(), 'show/'), '/')
let $img-names :=
    for $name in $img-locations/Directory[ends-with(@path, $img-dir)]/File/@name/data()
    order by $name
    return $name
let $figures :=
    for $img-name in $img-names
    let $img-link :=
        replace(concat('http://images.monasterium.net/img/DE-BayHStA/',$fond-name, '/', $img-dir, '/', $img-name), ' ', '')
    return
        <cei:figure>
            <cei:graphic url="{$img-link}"/>
        </cei:figure>
where $figures
return update insert $figures into $charter//cei:witnessOrig