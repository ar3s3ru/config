{ lib, ... }:

{
  services.aerospace.enable = true;
  services.aerospace.settings = {
    # start-at-login = true;
    key-mapping.preset = "qwerty";

    default-root-container-layout = "tiles";
    enable-normalization-flatten-containers = false;
    enable-normalization-opposite-orientation-for-nested-containers = false;

    on-focused-monitor-changed = [ "move-mouse monitor-lazy-center" ];

    # NOTE: the PATH environment variable passed to Aerospace doesn't contain
    # the paths where Nix adds soft-links to the current version executables.
    exec.inherit-env-vars = true;
    exec.env-vars.PATH = "/etc/profiles/per-user/ar3s3ru/bin:\${PATH}";

    gaps = {
      outer.left = 20;
      outer.bottom = 20;
      outer.top = 20;
      outer.right = 20;
      inner.horizontal = 10;
      inner.vertical = 10;
    };

    mode.main.binding =
      let
        mod = "alt";
        left = "j";
        bottom = "k";
        top = "i";
        right = "l";
      in
      {
        "${mod}-enter" = [ "exec-and-forget alacritty" ];

        "${mod}-b" = "split horizontal";
        "${mod}-v" = "split vertical";
        "${mod}-f" = "fullscreen";
        "${mod}-shift-space" = "layout floating tiling";

        "${mod}-${left}" = "focus --boundaries-action wrap-around-the-workspace left";
        "${mod}-${bottom}" = "focus --boundaries-action wrap-around-the-workspace down";
        "${mod}-${top}" = "focus --boundaries-action wrap-around-the-workspace up";
        "${mod}-${right}" = "focus --boundaries-action wrap-around-the-workspace right";

        "${mod}-shift-${left}" = "move left";
        "${mod}-shift-${bottom}" = "move down";
        "${mod}-shift-${top}" = "move up";
        "${mod}-shift-${right}" = "move right";

        "${mod}-c" = "reload-config";
      } // lib.lists.foldl
        (acc: n: acc // {
          "${mod}-${n}" = "workspace ${n}";
          "${mod}-shift-${n}" = "move-node-to-workspace ${n}";
        })
        { }
        (map toString (lib.range 0 9));
  };
}
