{ pkgs, system }:

{
  caddy = pkgs.callPackage ./caddy.nix { };
}
