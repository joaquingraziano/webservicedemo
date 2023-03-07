provider "docker" {
  host = "unix:///var/run/docker.sock"
}

resource "docker_container" "ubuntu" {
    name = "ubuntu1"
    image = "ubuntu:18.04"
    command = [ "/bin/bash","-c","while true; do sleep 60000; done"]
}

