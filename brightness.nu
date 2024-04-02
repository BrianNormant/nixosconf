#!env nu
# Increase the brightness by x (relative) and display it with wob

let MAX = brightnessctl m | into int

def main [x:int] {
  if ($x > 0) {
    brightnessctl set $"+($x)%"
  } else {
    brightnessctl set $"($x | math abs)%-"
  }
  let br = brightnessctl g | into int
  ($br * 100 / $MAX | math floor | to text) + "\n" | save -a /run/user/1000/wob.sock
}
