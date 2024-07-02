
variable "region" {
  default = "us-east-1"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "ami_id" {
  default = "ami-06c68f701d8090592"  # Replace with your preferred AMI ID
}

variable "key_name" {
  description = "key"
}


variable "docker_image" {
  description = "docker pull venkey3413/my-node-app:latest"
}
