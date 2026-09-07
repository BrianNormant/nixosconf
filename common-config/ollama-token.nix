{...}: {
	age.secrets."ollama-nginx-token" = {
		file = ../secrets/ollama-nginx-token.age;
		owner = "brian";
		group = "users";
	};
}
