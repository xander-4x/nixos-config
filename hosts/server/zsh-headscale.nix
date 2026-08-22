{ ... }:
{
  programs.zsh.shellAliases = {
    hs            = "sudo headscale";
    hs-users      = "sudo headscale users list";
    hs-nodes      = "sudo headscale nodes list";
    hs-routes     = "sudo headscale routes list";
    hs-preauth    = "sudo headscale preauthkeys list --all-users";
    hs-apikey     = "sudo headscale apikeys list";
    hs-apikey-new = "sudo headscale apikeys create --expiration 90d";
  };
}
