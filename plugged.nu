#!env nu

if ( (^acpi | size).bytes == 0 ) { return }

let charging = (^acpi -V | lines | parse "{Categorie}: {Value}" | where Categorie =~ Adapter).Value.0 == "on-line"
mut charge = ^acpi | split column , | get column2 | get 0 | str replace -ra '[^0-9]+' '' | into int
if (not $charging) {
  brightnessctl set 50%
  $charge += 100
} else {
  brightnessctl set 100%
}


($charge | to text) + "\n" | save -a /run/user/1000/wob.sock
