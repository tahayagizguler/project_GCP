
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

    provisioner "remote-exec" {
        inline = ["echo 'Wait until SSH is ready'"]

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

    # output "nginx_ip" {
    #     value = {
    #         for k, v in google_compute_instance.nginx : k => "http://${v.network_interface[0].access_config[0].nat_ip}"
    #     }
    # }
    


resource "google_compute_instance_group" "web_private_group" {
  name        = "vm-group"
  description = "Web servers instance group"
  zone         = var.zone
  instances   = [
    google_compute_instance.nginx1.self_link,
    google_compute_instance.nginx2.self_link
  ]
}


resource "google_compute_instance" "mysql" {
  name = "mysql"
  machine_type = var.machine_type #ubuntu-os-cloud/ubuntu-2004-lts
  zone = var.zone

    boot_disk {
        initialize_params {
        image = var.image
        }
    } 

    network_interface {
        network = google_compute_network.vpc_network.id
        subnetwork = google_compute_subnetwork.mysql_server_subnet.id
        access_config {
        }
    }

    provisioner "remote-exec" {
        inline = ["echo 'Wait until SSH is ready'"]

        connection {
            type = "ssh"
            user = var.ssh_user
            private_key = file(var.private_key_path)
            host = google_compute_instance.mysql.network_interface[0].access_config[0].nat_ip
        }
    }

    provisioner "local-exec" {
        command = "ansible-playbook -i ${google_compute_instance.mysql.network_interface[0].access_config[0].nat_ip}, --private-key ${var.private_key_path} ${local.ansible.mysqlserver} --vault-password-file ${local.ansible.vault_pass}"
    } 
}