ollamaAPIEndpoint:
{...}: {
	services.nextjs-ollama-llm-ui = {
		enable = true;
		host = "127.0.0.1"; # hide this behind nginx
		port = 43941;
		hostname = "0.0.0.0";
		ollamaUrl = ollamaAPIEndpoint;
	};
}
