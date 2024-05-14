provider "google" {
  project     = var.project_id
  region      = var.region
  zone        = var.zone
}

resource "google_container_cluster" "cluster" {
  name               = var.cluster_name
  location           = var.zone
  initial_node_count = 1

  node_config {
    machine_type = "n1-standard-1"
    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring"
    ]
  }

  timeouts {
    create = "30m"
    update = "30m"
  }
}

resource "kubernetes_deployment" "hello_world_deployment" {
  metadata {
    name      = "hello-world-deployment"
    namespace = "default"
  }

  spec {
    selector {
      match_labels = {
        app = "hello-world"
      }
    }

    template {
      metadata {
        labels = {
          app = "hello-world"
        }
      }

      spec {
        container {
          image = "sharmanayan/hello-world:0.1.RELEASE"
          name  = "hello-world"
          ports {
            container_port = 8080
          }
        }
      }
    }
  }
}
