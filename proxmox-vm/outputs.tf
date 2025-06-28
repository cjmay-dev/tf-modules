output "ansible_password" {
  value = random_password.ansible_password.result
  sensitive = true
}

output "ansible_ssh_private_key" {
  value = tls_private_key.ansible_ssh_key.private_key_openssh
  sensitive = true
}