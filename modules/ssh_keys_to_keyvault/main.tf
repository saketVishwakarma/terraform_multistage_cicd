#resource to create a new SSH key pair using the TLS provider
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

