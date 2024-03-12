# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      <home-manager/nixos>
    ];

  # Use the recommanded option : systemd-boot
  boot.loader.systemd-boot.enable = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelPatches = [ {
    name = "beyondfix";
    patch = ./beyond.patch;
  } ];

  hardware.opengl.enable = true;

  nixpkgs.config.allowUnfree = true;
  nix.settings.sandbox = "relaxed";
  # nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # For logitech G29
  hardware.new-lg4ff.enable = true;
  hardware.usb-modeswitch.enable = true;
  
  #OpenXR
  # services.monado = {
    # enable = true;
    # defaultRuntime = true;
  # };

  networking.hostName = "BrianNixDesktop"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "America/Montreal";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire
  sound.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  services.pipewire.wireplumber.configPackages = [
  	(pkgs.writeTextDir "share/wireplumber/bluetooth.lua.d/51-bluez-config.lua" ''
  		bluez_monitor.properties = {
  			["bluez5.enable-sbc-xq"] = true,
  			["bluez5.enable-msbc"] = true,
  			["bluez5.enable-hw-volume"] = true,
  			["bluez5.headset-roles"] = "[ hsp_hs hsp_ag hfp_hf hfp_ag ]"
  		}
  	'')
  ];
  # Enable bluetooth
  hardware.bluetooth = {
       enable = true;
       powerOnBoot = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  services.ollama = {
    enable = true;
    acceleration = "rocm";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.brian = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user. Change this to use doas
    shell = pkgs.zsh;
    packages = with pkgs; [
		# Burautique
      onlyoffice-bin
      hyprland hyprpaper hyprshot # Window manager
      cmus
      vesktop
      btop
                # Terminal Tools
      kitty # terminal emulators
      #TODO ./zutty.nix
      lsd
      zoxide
      tldr
      dust
      fzf
      bat bat-extras.batman
      tree
                # Devellopment related
      vifm
      lazygit
      nushell
      gh # Github CLI tool
      nodejs_21 yarn          # Web (Javascript)
		# Gaming
      prismlauncher
      oterm
      		#Other
      copyq # clipboard manager
      dunst # notification daemom
      wob   # Ligthweight overlay to show volume changes
      rofi-wayland # Menu for desktop
      playerctl
      appimage-run

      # gaming
      gamescope
      gamemode
      mangohud
    ];
  };
  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
  };
  home-manager.users.brian = { pkgs, ...}: {
    home.packages = [ pkgs.waybar pkgs.cava ];
    home.file.".icons/default".source = "${pkgs.phinger-cursors}/share/icons/phinger-cursors";
    home.stateVersion = "23.11";
    # xdg.portal.enable = true;
    xdg.portal.configPackages = [ pkgs.xdg-desktop-portal-gtk ];

    # programs.git = {
    #   enable = true;
    #   userName = "BrianNixDesktop";
    #   userEmail = "briannormant@gmail.com";
    # };

    programs.firefox.enable = true;
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      plugins = [
        {
          name = "zsh-nix-shell";
          file = "nix-shell.plugin.zsh";
          src = pkgs.fetchFromGitHub {
            owner = "chisui";
            repo = "zsh-nix-shell";
            rev = "v0.8.0";
            sha256 = "1lzrn0n4fxfcgg65v0qhnj7wnybybqzs4adz7xsrkgmcsr0ii8b7";
          };
        }
      ];
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    git
    curl
    lxqt.lxqt-policykit
    file
    bluez # Bluetooth
    mesa # AMD drivers?
    unzip
    p7zip
    neofetch # Extrement important!!!
  ];
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts.githubRelease
    dina-font
    proggyfonts
    (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
  ];

  # Programs enabled
  programs.dconf.enable = true;


  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      ls = "lsd";
      l = "lsd -la";
      ll = "lsd -l";
      cd = "z";
      icat = "kitty +kitten icat --clear";
      lg = "lazygit";
      man = "batman";
    };
    shellInit = ''
  source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
  eval "$(zoxide init zsh)"
if [[ -v TMUX ]]; then
  source ${pkgs.zsh-autocomplete}/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh
fi
  # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
  # Initialization code that may require console input (password prompts, [y/n]
  # confirmations, etc.) must go above this block; everything else may go below.
  if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
    source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
  fi


# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

if [[ ! ( -o login || -v TMUX ) ]]; then
    #Set up $TERM
    #export TERM="xterm-256color"
    # export MICRO_TRUECOLOR=1
    export TERM="tmux-256color"
    nbsession=$(tmux ls 2> /dev/null | wc -l)
    if [[ $nbsession -eq 0 ]]; then
        exec tmux -2 new-session -t Main
    elif [[ $nbsession -lt 5 ]]; then
        # If a session is not attached, attach to it.
        tmuxsession=$(tmux ls 2> /dev/null)
        for session in ''${(f)tmuxsession}; do
            # echo session = $session
            local name=$(echo $session | cut -d ":" -f 1)
            # echo name = $name
            clients=$(tmux list-clients -t $name 2> /dev/null | wc -l)
            if [[ $clients -eq 0 ]]; then
                # If it's not attached, attach to it
                #echo attach to $name who is disconnect
                exec tmux attach -t "$name"
                break;
            fi;
        done
        exec tmux -2 new-session
    else
        exec tmux -2 attach
    fi
fi
    '';
  };
  programs.tmux = {
    enable = true;
    keyMode = "vi";
    plugins = [ pkgs.tmuxPlugins.gruvbox ];
    extraConfig = ''
set -g mouse on
# set -g base-index 1
# setw -g pane-base-index 1
set -g automatic-rename off # dont change the name of the window after each dir change
#set -g default-terminal "screen-256color"
set -g default-terminal "tmux-256color"
set -ag terminal-overrides ",*:RGB"
set-option -g set-titles on
set-option -g set-titles-string "TMUX<#S> ¦ #W"
# Keybinds
# bind-key -T root WheelUpPane
bind-key -T prefix 1 select-window -t :=0
bind-key -T prefix 2 select-window -t :=1
bind-key -T prefix 3 select-window -t :=2
bind-key -T prefix 4 select-window -t :=3
bind-key -T prefix 5 select-window -t :=4
bind-key -T prefix 6 select-window -t :=5
bind-key -T prefix 7 select-window -t :=6
bind-key -T prefix 8 select-window -t :=7
bind-key -T prefix 9 select-window -t :=8
bind-key -T prefix 0 select-window -t :=9
bind-key -T prefix "%" splitw -h -c "#{pane_current_path}"
bind-key -T prefix '"' splitw -v -c "#{pane_current_path}"
bind-key -T prefix "n" new-session
bind-key -T prefix S 'setw synchronize-panes'
# Default Layout
# set-hook -g window-linked[1] "splitp -h; resizep -x30%; select-pane -t 0"
#send-keys -t 1 -l "clear"
#send-keys -t 1 "Enter"
#send-keys -t 0 -l "clear"
#send-keys -t 0 "Enter"

set -g @tmux-gruvbox 'dark'
    '';
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    gamescopeSession.enable = true;
  };

  security.doas.enable = true;
  programs.hyprland.enable = true;
  programs.git.enable = true;
  

  environment.sessionVariables.NIXOS_OZONE_WL = "1"; # Hint electron to use wayland:

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  nixpkgs.config.packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      inherit pkgs;
    };
  };

  # Overlays
  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url = https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz; # Nvim 10.0 and +
    }))
  ];
  

# Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    ports = [ 4269 ];
    settings.AllowUsers = [ "brian" ];
    settings.PasswordAuthentication = false;
  };

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 4269 4270 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # I guess it's easier to put in a git repo, making rollbacking changes even easier
  system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?

}

