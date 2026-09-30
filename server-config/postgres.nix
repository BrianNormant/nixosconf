{pkgs, lib, ...}: {
	# Create and enable a local postgresql server to test and thinker with sql
	# Here is the connection string for vim's DB and DBUI
	# The service won't autostart to save resources
	# postgresql://brian@%2Frun%2Fpostgresql/brian
	services.postgresql = {
		enable = true;
		ensureUsers = [
			{
				name = "brian";
				ensureDBOwnership = true;
			}
		];
		ensureDatabases = [
			"brian"
		];
	};
	systemd.services.postgresql = {
		wantedBy = lib.mkForce [];
	};
}
