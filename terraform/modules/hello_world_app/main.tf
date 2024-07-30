locals {
  namespaces = ["team-a", "team-b", "team-c"]
}

resource "kubernetes_namespace" "teams" {
  count = length(local.namespaces)

  metadata {
    name = local.namespaces[count.index]
  }
}

resource "helm_release" "hello_world" {
  count            = length(local.namespaces)
  name             = "hello-world-${local.namespaces[count.index]}"
  chart            = "${path.module}/../../hello-world"
  namespace        = local.namespaces[count.index]
  create_namespace = true

  set {
    name  = "replicaCount"
    value = 2
  }

  set {
    name  = "image.tag"
    value = "latest"
  }

  set {
    name  = "ingress.annotations.alb\\.ingress\\.kubernetes\\.io/group\\.name"
    value = "hello-world"
  }

  depends_on = [kubernetes_namespace.teams]
}
