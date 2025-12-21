ollamaAPIEndpoint:
{...}: {
	services.nextjs-ollama-llm-ui = {
		enable = true;
		port = 43941;
		hostname = "0.0.0.0";
		ollamaUrl = ollamaAPIEndpoint;
	};
}
