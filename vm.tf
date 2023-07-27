
resource "google_compute_instance" "nginx1" {
  name = "nginx1"
  machine_type = var.machine_type
  zone = var.zone

    boot_disk {
        initialize_params {
        image = var.image
        }
    } 

    network_interface {
        network = google_compute_network.vpc_network.id
        subnetwork = google_compute_subnetwork.app_server_subnet.id
        access_config {
        }
    }

    metadata = {
      "ssh-keys" = <<EOT
        ansible:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPYhKX9bahvEiR7JyhUmufgUy3kc6OmczHyEpX/w5rg5 ansible
       EOT
    }

    provisioner "remote-exec" {
        inline = ["echo 'Wait until SSH is ready'"]

        connection {
            type = "ssh"
            user = var.ssh_user
            private_key = file(var.private_key_path)
            host = google_compute_instance.nginx1.network_interface[0].access_config[0].nat_ip
        }
    }

    provisioner "local-exec" {
        command = "ansible-playbook -i ${google_compute_instance.nginx1.network_interface[0].access_config[0].nat_ip}, --private-key ${var.private_key_path} ${local.ansible.appserver}"
    } 
}



resource "google_compute_instance" "nginx2" {
  name = "nginx2"
  machine_type = var.machine_type
  zone = var.zone

    boot_disk {
        initialize_params {
        image = var.image
        }
    } 

    network_interface {
        network = google_compute_network.vpc_network.id
        subnetwork = google_compute_subnetwork.app_server_subnet.id
        access_config {
        }
    }

    metadata = {
      "ssh-keys" = <<EOT
        ansible:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPYhKX9bahvEiR7JyhUmufgUy3kc6OmczHyEpX/w5rg5 ansible
       EOT
    }


    provisioner "remote-exec" {
        inline = ["echo 'Wait until SSH is ready!'"]

        connection {
            type = "ssh"
            user = var.ssh_user
            private_key = file(var.private_key_path)
            host = google_compute_instance.nginx2.network_interface[0].access_config[0].nat_ip
        }
    }

    provisioner "local-exec" {
        command = "ansible-playbook -i ${google_compute_instance.nginx2.network_interface[0].access_config[0].nat_ip}, --private-key ${var.private_key_path} ${local.ansible.appserver2}"
    } 
}

resource "google_compute_instance_group" "web_private_group" {
  name        = "vm-group"
  description = "Web servers instance group"
  zone         = var.zone
  instances   = [
    google_compute_instance.nginx1.self_link,
    google_compute_instance.nginx2.self_link
  ]
}



resource "google_compute_address" "static_ip" {
  name = "mysql-static-ip"
  region = var.region
}

resource "google_compute_instance" "mysql" {
  name = "mysql"
  machine_type = var.machine_type 
  zone = var.zone

    boot_disk {
        initialize_params {
        image = var.image #ubuntu-os-cloud/ubuntu-2004-lts
        }
    } 

    network_interface {
        network = google_compute_network.vpc_network.id
        subnetwork = google_compute_subnetwork.mysql_server_subnet.id
        network_ip = "10.0.2.2"
        access_config {
            nat_ip = google_compute_address.static_ip.address
        }
    }

    metadata = {
      "ssh-keys" = <<EOT
        ansible:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPYhKX9bahvEiR7JyhUmufgUy3kc6OmczHyEpX/w5rg5 ansible
       EOT
    }


    provisioner "remote-exec" {
        inline = ["echo 'Wait until SSH is ready'"]

        connection {
            type = "ssh"
            user = var.ssh_user
            private_key = file(var.private_key_path)
            host = google_compute_address.static_ip.address
        }
    }

    provisioner "local-exec" {
        command = "ansible-playbook -i ${google_compute_instance.mysql.network_interface[0].access_config[0].nat_ip}, --private-key ${var.private_key_path} ${local.ansible.mysqlserver} --vault-password-file ${local.ansible.vault_pass}"
    } 
}

resource "google_compute_instance" "jenkins" {
  name = "jenkins"
  machine_type = "e2-medium"  # e2.medium
  zone = var.zone

    boot_disk {
        initialize_params {
        image = "ubuntu-os-cloud/ubuntu-2004-lts"
        }
    } 

    network_interface {
        network = google_compute_network.vpc_network_cicd.id
        subnetwork = google_compute_subnetwork.server_subnet.id
        access_config {
        }
    }

    metadata = {
      "ssh-keys" = <<EOT
        ansible:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPYhKX9bahvEiR7JyhUmufgUy3kc6OmczHyEpX/w5rg5 ansible
       EOT
    }

    provisioner "remote-exec" {
        inline = ["echo 'Wait until SSH is ready'"]

        connection {
            type = "ssh"
            user = var.ssh_user
            private_key = file(var.private_key_path)
            host = google_compute_instance.jenkins.network_interface[0].access_config[0].nat_ip
        }
    }

    provisioner "local-exec" {
        command = "ansible-playbook -i ${google_compute_instance.jenkins.network_interface[0].access_config[0].nat_ip}, --private-key ${var.private_key_path} ${local.ansible.jenkins}"
    } 
}
