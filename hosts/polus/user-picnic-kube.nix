{ pkgs, ... }:

{
  home.packages = with pkgs; [
    k9s
    kubectl
    kubelogin-oidc
    kubernetes-helm
    helmfile
  ];

  home.file.".kube/config".source = ./secrets/kubeconfig;
}
