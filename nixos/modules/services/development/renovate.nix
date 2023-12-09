{ config, lib, pkgs, ... }:

let
  cfg = config.services.renovate;
  settingsFormat = pkgs.format.json {};
  configFile = settingsFormat.generate "config.json" cfg.config;
in {
  options = {
    services.renovate = {
      enable = mkEnableOption (lib.mdDoc "Renovatebot");

      config = lib.mkOption {
        default = null;
        type = settingsFormat.type;
        description = lib.mdDoc ''
          Set options for renovate.
          See https://docs.renovatebot.com/self-hosted-configuration/ for possible values
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.renovate = {
      description = "renovate service";
      environment = { RENOVATE_CONFIG_FILE = configFile };
      serviceConfig = {
        ExecStart = "${pkgs.renovate}/bin/renovate";
        PrivateTmp = true;
        ProtectSystem = "strict";
        ProtectHome = "read-only";
        Restart = "on-failure";
      };
    };
  };
}
