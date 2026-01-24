output "server_name" {
  value = var.server_name
}

output "hostname" {
  value = "${var.server_name}.${var.domain_name}"
}
