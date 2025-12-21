prev: final:
let build = {mkDerivation, fetchFromGitHub, ...}:
	mkDerivation rec {
		pname = "flog-symbols";
		version = "v1.1.0";
		installPhase = ''
		runHook preInstall

		install -Dm644 -t $out/share/fonts/truetype ./FlogSymbols.ttf

		runHook postInstall
		'';
		src = fetchFromGitHub {
			owner = "rbong";
			repo = "flog-symbols";
			tag = version;
			hash = "sha256-kGk1I3u9MT3E/yalNaNhopsItKsomcBfsoUUiccE+Tw=";
		};
	};
in {
	flog-symbols = build {
		inherit (prev.stdenv) mkDerivation;
		inherit (prev) fetchFromGitHub;
	};
}
