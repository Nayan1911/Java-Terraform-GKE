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

resource "kubernetes_service" "hello_world_service" {
  metadata {
    name      = "hello-world-service"
    namespace = "default"
    labels = {
      app = "hello-world"
    }
  }

  spec {
    selector = {
      app = "hello-world"
    }

    port {
      protocol = "TCP"
      port     = 8080
      target_port = 8080
    }

    type = "LoadBalancer"
  }
}

resource "kubernetes_ingress" "hello_world_ingress" {
  metadata {
    name      = "hello-world-ingress"
    namespace = "default"
    labels = {
      app = "hello-world"
    }
    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
    }
  }

  spec {
    rule {
      host = "example.com" # Replace with your domain once you have one
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
