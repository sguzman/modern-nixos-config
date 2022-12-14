# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, fetchFromGitHub, rustPlatform, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  #boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelPackages = pkgs.linuxPackages_5_15;
  boot.extraModulePackages = [
    config.boot.kernelPackages.zfs
  ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Enable network manager applet
  programs.nm-applet.enable = true;

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.utf8";

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the LXQT Desktop Environment.
  services.xserver.displayManager.lightdm.enable = true;
  #services.xserver.windowManager.i3.enable = true;
  services.xserver.desktopManager.xfce.enable = true;
  #services.xserver.displayManager.defaultSession = "none+i3";
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "sguzman";

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  security.doas.extraRules = [
	  { groups = [ "wheel" ]; noPass = true; keepEnv = true; }
  ];

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.sguzman = {
    isNormalUser = true;
    shell = pkgs.fish;
    description = "Salvador Guzman";
    extraGroups = [ "networkmanager" "wheel" "video" "audio" "docker" "wireshark" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  fonts.fonts = with pkgs; [
    atkinson-hyperlegible
    dina-font
    fira-code
    fira-code-symbols
    liberation_ttf
    mplus-outline-fonts.githubRelease
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    proggyfonts
  ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #cudaPackages.cudnn
    #cudaPackages.nccl
    #cudaPackages.nvidia_fs
    amass
    aria
    atkinson-hyperlegible
    pavucontrol
    bat
    bind
    bingrep
    binutils
    brotli
    calibre
    cayley
    clang
    clang-tools
    cmake
    deno
    dfc
    doas
    docker
    exa
    fd
    ffmpeg
    file
    fish
    font-manager
    fortune
    freetype
    gambit
    gcc
    gdb
    gerbil
    git
    glib
    gnufdisk
    gnumake
    google-chrome
    htop
    hyperfine
    jq
    jujutsu
    kitty
    kmon
    linux-manual
    linuxHeaders
    linuxKernel.packages.linux_5_15.zfs
    litecli
    lld
    lldb
    llvm
    lua
    luajit
    masscan
    mcfly
    mlocate
    mpv
    musl
    mycli
    nasm
    neovim
    nerdfonts
    nodePackages.pnpm
    ntfs3g
    nvidia-docker
    openssh
    openssl
    perl
    pgcli
    pkg-config
    ponysay
    pv
    python310
    python310Packages.pip
    rofi
    rofi-pass
    rustup
    sccache
    vivaldi
    vivaldi-ffmpeg-codecs
    vivaldi-widevine
    vmtouch
    vscode-with-extensions
    unzip
    wabt
    wasm-pack
    wasm-pack
    wasmer
    wasmtime
    watchexec
    wget
    wireshark
    xclip
    yasm
    zdns
    zip
    zmap
    zoxide
    zpaq
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.xserver.videoDrivers = [ "nvidia" ];
  services.openssh.enable = true;
  virtualisation.docker = {
    enable = true;
    #enableNvidia = true;
    enableOnBoot = true;
  };
  services.bind = {
    enable = false;
    listenOn = [ "any" ];
    listenOnIpv6 = [ "any" ];
    forwarders = [ "8.8.8.8" ];
  };
  security.doas.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?

}
