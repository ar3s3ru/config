{ config, pkgs, ... }:

{
  home.file."kubeconfig" = {
    executable = false;
    target = ".kube/config.homelab.yaml";
    source = ./kubeconfig.yaml;
  };

  home.sessionVariables = {
    KUBECONFIG = ".kube/config:${config.home.file."kubeconfig".target}";
  };

  home.packages = with pkgs; [
    k9s
    kubectl
    kubernetes-helm
  ];
}
