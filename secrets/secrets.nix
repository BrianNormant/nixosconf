let
laptop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFwz+vA7/WJ5rIJe57Wa7FepBchOKEt927fGROKS0LMB";
desktop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICoRQkcpX2vEgxm01iJVrDkZ5Mnw2tOHs98qgyJ/dyBf";
in
{
	"desecio.age".publicKeys = [ laptop ];
	"open-webui.age".publicKeys = [ desktop ];
	"ollama-nginx-token.age".publicKeys = [ laptop desktop ];
	"ollama-basic-auth.age".publicKeys = [ laptop desktop ];
}
