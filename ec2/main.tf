data "aws_ebs_snapshot" "minecraft-persistence" {
  most_recent = true

  filter {
    name   = "description"
    values = ["MINECRAFT_SNAPSHOT"]
  }
}

resource "aws_ami" "minecraft" {
  name                = "minecraft-persistence-ami"
  virtualization_type = "hvm"
  root_device_name    = "/dev/xvda"

  ebs_block_device {
    device_name = "/dev/xvda"
    snapshot_id = data.aws_ebs_snapshot.minecraft-persistence.id
    volume_type = "gp2"
  }
}

resource "aws_iam_instance_profile" "mine-profile" {
  name = "minecraft-profile"
  role = "minecraft"
}

resource "aws_instance" "minecraft-instance" {
  ami                  = aws_ami.minecraft.id
  instance_type        = "t2.medium"
  availability_zone    = "eu-west-2a"
  key_name             = "minecraft"
  user_data            = "${file("install.sh")}"
  iam_instance_profile = aws_iam_instance_profile.mine-profile.name

  network_interface {
    device_index         = 0
    network_interface_id = var.net_id
  }

  tags = {
    Name = "Minecraft"
  }

  provisioner "local-exec" {
    command = "aws ec2 create-snapshot --description MINECRAFT_SNAPSHOT --volume-id ${self.root_block_device.0.volume_id}"
    when    = "destroy"
  }
}

resource "null_resource" "null" {
  provisioner "file" {
    source   = "mods/"
    destination    = "~/opt/minecraft/ForgeServer/"
  }

  provisioner "local-exec" {
    command = "/etc/init/startServer.sh"
  }

  connection {
    type     = "ssh"
    user     = "ubuntu"
    host     = aws_instance.minecraft-instance.public_ip
    private_key = file("~/.ssh/minecraft.pem")
  }
}