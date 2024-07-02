variable "aws_access_key" {
  description = "AWS access key"
}

variable "aws_secret_key" {
  description = "AWS secret key"
}

variable "region" {
  default = "us-west-2"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "ami_id" {
  default = "ami-0c55b159cbfafe1f0"  # Replace with your preferred AMI ID
}

variable "key_name" {
  description = "Name of the key pair"
}

variable "key_path" {
  description = "Path to the private key file"
}

variable "docker_image" {
  description = "Docker image to deploy"
}
