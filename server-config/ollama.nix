{pkgs, main-user, ...}:
{
	services.llama-cpp = {
		enable = true;
		package = pkgs.llama-cpp-vulkan;
		settings = {
			host = "127.0.0.1";
			port = 11434;
			parallel = 2;
			models-preset = (pkgs.formats.ini { }).generate "models-preset.ini" {
				"Qwen3.8" = {
					hf-repo = "unsloth/Qwen3.8-27B-GGUF";
					hf-file = "Qwen3.8-27B-UD-Q4_K_M.gguf";
					cache-type-k = "q8_0";
					cache-type-v = "q8_0";
					ctx-size = 131072;
				};
				"QwenUncensored" = {
					hf-repo = "JonathanColetti/Qwen3.8-27B-Uncensored-GGUF";
					hf-file = "Qwen3.8-27B-Uncensored-noMTP-Q4_K_M.gguf";
					temp = "0.8";
					reasoning = "off";
					ctx-size = 8192;
					flash-attn = "on";
					cache-type-k = "q8_0";
					cache-type-v = "q8_0";
				};
				"SweepEdit" = {
					hf-repo = "sweepai/sweep-next-edit-1.5B";
					hf-file = "sweep-next-edit-1.5b.q8_0.v2.gguf";
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
