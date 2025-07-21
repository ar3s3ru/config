{ pkgs, config, ... }:

{
  home.packages = with pkgs; [
    k9s
    kubectl
    kubelogin-oidc
    kubernetes-helm
    helmfile
  ];

  sops.secrets.kubeconfig.path = "${config.home.homeDirectory}/.kube/config";
}
