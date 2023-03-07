terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.1"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}
resource "docker_container" "ubuntu" {
    name = "ubuntu1"
    image = "ubuntu:18.04"
    command = [ "/bin/bash","-c","while true; do sleep 60000; done"]

    provisioner "local-exec" {
        command = "echo ${docker_container.ubuntu.network_data[0].ip_address} >> inventario.txt"
    }
}

