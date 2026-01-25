output "master_internal_ip" {
  value = module.master.networks[1].address
}
output "worker_internal_ips" {
  value = [for wp in values(module.worker_pool) : wp.networks[1].address]
}