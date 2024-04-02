#!nu

# Increase the volume by x (relative) and show it with wob
def main [x: int] {
  if ($x == 0) {
    wpctl set-mute @DEFAULT_SINK@ toggle
    let res = wpctl get-volume @DEFAULT_SINK@ | str contains "MUTED"
    if ($res) {
      "0\n" | save -a /run/user/1000/wob.sock
      return
    }
  } else if ($x < 0) {
    let x = $x | math abs
    wpctl set-volume @DEFAULT_SINK@ $"($x)%-"
  } else {
    wpctl set-volume @DEFAULT_SINK@ $"($x)%+"
  }
  let vol = (wpctl get-volume @DEFAULT_SINK@ | split row ": " | get 1 | into float) * 100 | into int
  ($vol | to text) + "\n" | save -a /run/user/1000/wob.sock
}
