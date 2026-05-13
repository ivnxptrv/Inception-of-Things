{
  description = "K3s Vagrant (libvirt) Development Environment in WSL2";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          (final: prev: {
            vagrant = (prev.vagrant.override { withLibvirt = true; }).overrideAttrs (old: {
              doInstallCheck = false;
              postInstall = (old.postInstall or "") + ''
                mkdir -p "$out/vagrant-plugins"
                echo '{"version":"1","installed":{}}' > "$out/vagrant-plugins/plugins.json"
              '';
            });
          })
        ];
      };
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          vagrant
          libvirt
          qemu
          kubectl
          kubernetes-helm
        ];

        shellHook = ''
          export VAGRANT_DEFAULT_PROVIDER=libvirt
          export LIBVIRT_DEFAULT_URI="qemu:///system"

          echo "--- K3s Vagrant (libvirt) Environment ---"
          echo "Vagrant version: $(vagrant --version)"
          echo "Kubectl version: $(kubectl version --client)"

          if ! systemctl is-active --quiet libvirtd.socket 2>/dev/null; then
            echo "WARNING: libvirtd is not active. Enable it in your NixOS config:"
            echo "  virtualisation.libvirtd.enable = true;"
            echo "  users.users.<you>.extraGroups = [ \"libvirtd\" \"kvm\" ];"
          fi

          if [ ! -e /dev/kvm ]; then
            echo "WARNING: /dev/kvm missing. Nested virt not exposed to WSL."
            echo "Check .wslconfig: [wsl2] nestedVirtualization=true"
          elif [ ! -r /dev/kvm ] || [ ! -w /dev/kvm ]; then
            echo "WARNING: /dev/kvm not accessible by current user. Add yourself to the kvm group."
          fi
        '';
      };
    };
}

# Enable KVM in your NixOS-WSL config. In your NixOS configuration:
# virtualisation.libvirtd.enable = true;
# users.users.<username>.extraGroups = [ "libvirtd" "kvm" ];
