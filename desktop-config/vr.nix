{pkgs, config, main-user, ...}:
let inherit (config.users.users.${main-user}) home;
in {
	#================================[ Kernel ]===================================
	boot = {
		kernelPackages = pkgs.linuxPackages_6_18;
		kernelPatches = [
			# For Bigscreen Beyond
			{
				name = "parse-drm-edid-bpp-target";
				patch = ./0001-drm-edid-parse-DRM-VESA-dsc-bpp-target.patch;
			}
			{
				name = "use-fixed-dsc-bits-per-pixel-from-edid";
				patch = ./0002-drm-amd-use-fixed-dsc-bits-per-pixel-from-edid.patch;
			}
			# For vr performance
			{
				name = "amdgpu-ignore-ctx-privileges";
				patch = pkgs.fetchpatch {
					name = "cap_sys_nice_begone.patch";
					url = "https://github.com/Frogging-Family/community-patches/raw/master/linux61-tkg/cap_sys_nice_begone.mypatch";
					hash = "sha256-Y3a0+x2xvHsfLax/uwycdJf3xLxvVfkfDVqjkxNaYEo=";
				};
			}
		];
	};
	
	#================================[ GPUoc ]===================================
	# Enable overclocking for amdgpu
	hardware.amdgpu.overdrive = {
		enable = true;
		ppfeaturemask = "0xffffffff";
	};


	#================================[ Monado ]===================================
	services = {
		udev.extraRules = ''
SUBSYSTEM=="hidraw", ATTRS{idVendor}=="35bd", ATTRS{idProduct}=="0101", MODE="0666"
		'';
		monado = {
			package = pkgs.monado;
			enable = true;
			highPriority = true;
			defaultRuntime = true;
		};
	};

	systemd.user.services.monado.environment = {
		STEAMVR_LH_ENABLE = "1";
		XRT_COMPOSITOR_DESIRED_MODE = "0"; # 0 for 2560*2560 | 1 for 1920 * 1920
		XRT_COMPOSITOR_SCALE_PERCENTAGE = "100";
		XRT_COMPOSITOR_COMPUTE = "1";
	};
	
	#===========================[ OpenComposite && XRizer ]==============================
	systemd.tmpfiles.settings = {
		"11-vr" = {
			"${home}/OpenComposite" = {
				L = {
					group = "users";
					user = main-user;
					mode = "0444";
					argument = "${pkgs.opencomposite}/lib/opencomposite";
				};
			};
			"${home}/Xrizer" = {
				L = {
					group = "users";
					user = main-user;
					mode = "0444";
					argument = "${pkgs.xrizer}/lib/xrizer";
				};
			};
			"${home}/.config/openxr/1/active_runtime-monado.json" = {
				f = {
					group = "users";
					user = main-user;
					mode = "0444";
					argument = ''
{
	"file_format_version": "1.0.0",
		"runtime": {
			"name": "Monado",
			"library_path": "${pkgs.monado}/lib/libopenxr_monado.so"
		}
}
					'';
				};
			};
			"${home}/.config/openxr/1/active_runtime-steam.json" = {
				L = {
					group = "users";
					user = main-user;
					mode = "0444";
					argument = "${home}/.local/share/Steam/steamapps/common/SteamVR/steamxr_linux64.json";
				};
			};
			"${home}/.config/openvr/openvrpaths.vrpath" = {
				f = {
					group = "users";
					user = main-user;
					mode = "0444";
					argument = ''
{
	"config" : 
	[
		"${home}/.local/share/Steam/config"
	],
	"external_drivers" : 
	[
		"${home}/GamesSSD/SteamLibrary/steamapps/common/Bigscreen Beyond Driver"
	],
	"jsonid" : "vrpathreg",
	"log" : 
	[
		"${home}/.local/share/Steam/logs"
	],
	"runtime" : 
	[
		"${home}/Xrizer/"
	],
	"version" : 1
}
						'';
					};
				};
		};
	};

	environment.variables = {
		# necessary for wayvr-dashboard to find the monado runtime
		# might help some other vr games?
		XR_RUNTIME_JSON = "${pkgs.monado}/share/openxr/1/openxr_monado.json";
	};

}
