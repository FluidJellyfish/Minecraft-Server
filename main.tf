provider "aws" {
  region = "us-east-1"
}

resource "aws_key_pair" "minecraftSSH" {
  key_name = "serverKey"
  public_key = file("${path.module}/Minecraft.pub")
}

resource "aws_security_group" "MCServer-SG" {
  name = "Server-SG"
  description = "Allows SSH connection and TCP access"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 25565
    to_port = 25565
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "MinecraftServer" {
  ami = "ami-091138d0f0d41ff90"
  instance_type = "t3.medium"
  key_name = aws_key_pair.minecraftSSH.key_name
  vpc_security_group_ids = [aws_security_group.MCServer-SG.id]

  tags = {
    Name = "Minecraft Server"
  }
}

resource "aws_eip" "elasticIP" {
  instance = aws_instance.MinecraftServer.id
  domain = "vpc"
}

resource "time_sleep" "sleep" {
  depends_on = [aws_instance.MinecraftServer]
  create_duration = "30s"
}

resource "local_file" "createHosts" {
  depends_on = [time_sleep.sleep]
  content = "[minecraft]\n${aws_eip.elasticIP.public_ip} ansible_user=ubuntu ansible_ssh_private_key_file=${path.module}/Minecraft"
  filename = "${path.module}/hosts.ini"
}

resource "null_resource" "Ansible" {
  depends_on = [local_file.createHosts]
  provisioner "local-exec" {
    command = "ansible-playbook -i hosts.ini playbook.yml -v"
    working_dir = path.module
  }
}

output "Minecraft_Server_IP" {
  value = aws_eip.elasticIP.public_ip
}