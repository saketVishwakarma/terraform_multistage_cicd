output "public_key_openssh" {
  value       = tls_private_key.ssh_key.public_key_openssh
  description = "The generated public key in OpenSSH format"
}

output "private_key_pem" {
  value       = tls_private_key.ssh_key.private_key_pem
  description = "The generated private key in PEM format"
  sensitive   = true
}