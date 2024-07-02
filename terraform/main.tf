provider "aws" {
  region     = var.region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

resource "aws_instance" "nodejs_app" {
  ami           = ami-06c68f701d8090592
  instance_type = var.instance_type
  key_name      = key.pem

  tags = {
    Name = "nodejs-docker-app"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -y",
      "sudo apt-get install -y docker.io",
      "sudo systemctl start docker",
      "sudo systemctl enable docker",
      "sudo docker run -d -p 3000:3000 --name nodejs-app ${var.docker_image}"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.key_path)
      host        = self.public_ip
    }
  }
}
