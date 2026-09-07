{pkgs, main-user, ...}:
{
	services.llama-cpp = {
		enable = true;
		package = pkgs.llama-cpp-vulkan;
		settings = {
			host = "127.0.0.1";
			port = 11434;
			ctx-size = 16384;
			models-preset = (pkgs.formats.ini { }).generate "models-preset.ini" {
				"Qwen3.8" = {
					hf-repo = "unsloth/Qwen3.8-27B-GGUF";
					hf-file = "Qwen3.8-27B-UD-Q4_K_M.gguf";
				};
				"QwenUncensored" = {
					hf-repo = "JonathanColetti/Qwen3.8-27B-Uncensored-GGUF";
					hf-file = "Qwen3.8-27B-Uncensored-noMTP-Q4_K_M.gguf";
					temp = "0.8";
				};
				"QwenCoder" = {
					hf-repo = "Qwen/Qwen2.5-Coder-1.5B-Instruct-GGUF";
					hf-file = "qwen2.5-coder-1.5b-instruct-q6_k.gguf";
				};
			};
		};
	};
	systemd.services.llama-cpp = {
		environment = {
			XDG_CACHE_HOME = "/var/cache/llama-cpp";
			MESA_SHADER_CACHE_DIR = "/var/cache/llama-cpp";
		};
	};
}
