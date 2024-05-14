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
          port {
            container_port = 8080
          }
        }
      }
    }
  }
}

provider "kubernetes" {
  load_config_file = false
  host             = "https://${google_container_cluster.cluster.endpoint}"
  token            = var.kubernetes_token
  # Set other authentication parameters as needed
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

resource "kubernetes_service" "hello_world_service" {
  metadata {
    name      = "hello-world-service"
    namespace = "default"
  }

  spec {
    selector = {
      app = "hello-world"
    }

    port {
      protocol   = "TCP"
      port       = 80
      target_port = 8080
    }

    type = "LoadBalancer"
  }
}

resource "kubernetes_ingress" "hello_world_ingress" {
  metadata {
    name      = "hello-world-ingress"
    namespace = "default"
    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
    }
  }

  spec {
    rule {
      http {
        path {
          path = "/"
          backend {
            service_name = kubernetes_service.hello_world_service.metadata[0].name
            service_port = kubernetes_service.hello_world_service.spec[0].port[0].port
          }
        }
      }
    }
  }
}
