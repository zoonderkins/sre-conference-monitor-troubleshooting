resource "kubernetes_secret" "elasticsearch_password" {
  metadata {
    name      = "elasticsearch-password"
    namespace = "kube-system"
  }

  data = {
    password = base64encode("ul8x5B01s5kf3sk")
  }
}

resource "kubernetes_secret" "elastic_users_roles" {
  metadata {
    name      = "elastic-users-roles"
    namespace = "kube-system"
  }

  data = {
    users_roles = base64encode("user:superuser")
  }
}