output "private_key_pem" {
  value     = tls_private_key.ecs_key.private_key_pem
  sensitive = true
}