// projects
resource "rancher2_project" "showcase_project" {
  name       = "showcase"
  cluster_id = data.rancher2_cluster.tetra.id

  labels = {
    "tenant"  = "showcase"
  }
}

resource "rancher2_project_role_template_binding" "showcase_project_binding" {
  name              = "showcase-binding"
  project_id        = rancher2_project.showcase_project.id
  role_template_id  = "read-only"
  user_principal_id = "github_org://${data.github_organization.org.id}"
}

resource "rancher2_namespace" "showcase_namespace" {
  name       = "showcase"
  project_id = rancher2_project.showcase_project.id

  labels = {
    "tenant"  = "showcase"
  }
}