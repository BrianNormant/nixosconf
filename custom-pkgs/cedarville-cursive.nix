prev: final:
	let build =
	{mkDerivation, ...}:
	mkDerivation {
		pname = "cedarville-cursive";
		version = "1.0.1";
		src = ./cedarville-cursive;
		installPhase = ''
		runHook preInstall

		install -Dm644 -t $out/share/fonts/truetype ./*.ttf

		runHook postInstall
		'';
	};
in {
	cedarville-cursive = build {
		inherit (prev.stdenv) mkDerivation;
	};
}
