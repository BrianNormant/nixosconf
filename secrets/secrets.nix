let
  laptop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGjM940DY/Cfc96WuSqcm4UUohJtqhPitYqBYOTL0Obn";
  laptopRoot = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEdyEcCUGjohUNMJ4xbkawLC/W9kzG9Qz3P8OWoqJBqF";
  desktop = "";
in
{
  "desecio.age".publicKeys = [ laptopRoot ];
}
