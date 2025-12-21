{ main-user, ... }: {
	services.openssh = {
		enable = true;
		ports = [ 4269 ];
		settings.AllowUsers = [ main-user ];
		settings.PasswordAuthentication = false;
	};
}
