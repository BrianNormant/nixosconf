let
  laptop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGjM940DY/Cfc96WuSqcm4UUohJtqhPitYqBYOTL0Obn";
  laptopRoot = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEdyEcCUGjohUNMJ4xbkawLC/W9kzG9Qz3P8OWoqJBqF";
  desktop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO0NPhVAQijKPo4f+3t2ha+P0sgcfJOo9iTwPhpLRKTj";
  desktopRoot = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICoRQkcpX2vEgxm01iJVrDkZ5Mnw2tOHs98qgyJ/dyBf";
in
{
  "desecio.age".publicKeys = [ laptopRoot ];
  "open-webui.age".publicKeys = [ desktopRoot desktop ];
}
