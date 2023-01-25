{ pkgs, ... }:
{
  home.packages = with pkgs; [
    _1password
    _1password-gui
    awscli2
    bat
    comma
    curlie
    customCurl
    deadnix
    du-dust
    element-desktop
    entr
    fd
    file
    fx
    gcc
    go
    graphviz
    hey
    htop
    httpie
    hub
    input-fonts
    jetbrains.pycharm-community
    lsof
    mkcert
    multitail
    ncdu
    nixpkgs-fmt
    nix-tree
    nodejs
    noti
    notion
    nurl
    obsidian
    openssh
    pinentry-gtk2
    playerctl
    pre-commit
    pyright
    python3
    python3.pkgs.pipx
    python3.pkgs.send2trash
    python3.pkgs.virtualenv
    ripgrep
    rofi
    slack
    telegram-desktop
    tree-grepper
    universal-ctags
    unzip
    virt-manager
    zeal
    zip
    zsh
  ] ++ [
    # local packages
    cftail
    listprojects
    snslistener
    notify-wrapper
  ];
}
