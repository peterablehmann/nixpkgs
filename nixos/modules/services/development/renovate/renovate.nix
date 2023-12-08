{ config, lib, pkgs, ... }:

let
  cfg = config.services.renovate;
  settingsFormat = pkgs.format.json {};
  configFile = settingsFormat.generate "config.json" cfg.config;
in {
  options = {
    services.renovate = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = lib.mdDoc ''
          Enables the renovate service
        '';
      };
      package = lib.mkOption {
        default = pkgs.renovate;
        type = lib.types.package;
        description = lib.mdDoc ''
          The renovate package to use.
        '';
        defaultText = lib.literalExpression "pkgs.renovate";
      };
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
    systemd.user.services.renovate = {
      description = "renovate service";
      environment = { RENOVATE_CONFIG_FILE = configFile };
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/renovate";
        PrivateTmp = true;
        ProtectSystem = "strict";
        ProtectHome = "read-only";
        Restart = "on-failure";
      };
    };
  };
}
