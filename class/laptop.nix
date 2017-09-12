{pkgs, ...}: {
  networking.networkmanager.enable = true;

  environment.systemPackages = with pkgs; [
					   powertop
					   acpi
					   ];

  systemd.services.powertop-autotune = {
    description = "Power Management tunings";
    wantedBy = [ "multi-user.target" ];
    script = ''${pkgs.powertop}/bin/powertop --auto-tune'';
    serviceConfig.Type = "oneshot";
  };
}
