{ pkgs, system }:

{
  caddy = pkgs.callPackage ./caddy.nix { };
  mitogen = pkgs.callPackage ./mitogen.nix { };
}
