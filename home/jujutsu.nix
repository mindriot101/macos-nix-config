{...}: {
  programs.jujutsu = {
    # disabled to prevent the warning
    #
    # ```
    # Warning: `jj util completion --fish` will be removed in a future version, and this will be a hard error
    # Hint: Use `jj util completion fish` instead
    # ```
    enable = false;
    settings = {
      user = {
        name = "Simon Walker";
        email = "s.r.walker101@gmail.com";
      };
    };
  };
}