{ pkgs, ... }:

pkgs.caddy.withPlugins {
  plugins = [ "github.com/caddy-dns/cloudflare@v0.2.4" ];
  hash = "sha256-Olz4W84Kiyldy+JtbIicVCL7dAYl4zq+2rxEOUTObxA=";
}
