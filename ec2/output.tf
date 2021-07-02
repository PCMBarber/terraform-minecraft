output "server_private_ip" {
  value = aws_instance.minecraft-instance.private_ip
}
output "server_public_ip" {
  value = aws_instance.minecraft-instance.public_ip
}
output "server_id" {
  value = aws_instance.minecraft-instance.id
}