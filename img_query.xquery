xquery version "3.1";

let $base-folder := 'imgs'
let $all-files := collection($base-folder)
let $folders := distinct-values(
  $all-files ! base-uri(.) => tokenize('/') => tail() => string-join('/')
)
return
  for $folder in $folders
  let $folder-files := collection(concat($base-folder, '/', $folder))
  let $only-images := every $file in $folder-files satisfies
    ends-with(base-uri($file), '.jpg') or ends-with(base-uri($file), '.png') or ends-with(base-uri($file), '.gif')
  where $only-images
  return $folder