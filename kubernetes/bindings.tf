

data "azuread_group" "dev" {
  display_name     = "k8s dev"
  security_enabled = true
}

data "azuread_group" "test" {
  display_name     = "k8s test"
  security_enabled = true
}

resource "kubernetes_role" "dev" {
  metadata {
    name      = "dev-access"
    namespace = "dev"
    labels = {
      test = "dev"
    }
  }

  rule {
    api_groups = ["", "extensions", "apps"]
    resources  = ["*"]
    verbs      = ["*"]
  }
  rule {
    api_groups = ["batch"]
    resources  = ["jobs,cronjobs"]
    verbs      = ["*"]
  }
}

resource "kubernetes_role" "test" {
  metadata {
    name      = "test-access"
    namespace = "test"
    labels = {
      test = "test"
    }
  }

  rule {
    api_groups = ["", "extensions", "apps"]
    resources  = ["*"]
    verbs      = ["*"]
  }
  rule {
    api_groups = ["batch"]
    resources  = ["jobs,cronjobs"]
    verbs      = ["*"]
  }
}

resource "kubernetes_role_binding" "dev" {
  metadata {
    name      = "dev-access"
    namespace = "dev"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "dev-access"
  }
  subject {
    kind      = "User"
    name      = "admin"
    api_group = "rbac.authorization.k8s.io"
  }
  subject {
    kind      = "Group"
    name      = data.azuread_group.dev.id
    namespace = "dev"
  }
}

resource "kubernetes_role_binding" "test" {
  metadata {
    name      = "test-access"
    namespace = "dev"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "dev-access"
  }
  subject {
    kind      = "Group"
    name      = data.azuread_group.test.id
    namespace = "dev"
  }
}