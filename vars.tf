variable "env" {}
variable "name" {
  default = "redis"
}
variable "vpc_id" {}
variable "subnet_ids" {}
variable "tags" {}
variable "allow_db_cidr" {}
variable "port" {
  default = 6379
}
variable "engine_version" {}
variable "num_node_groups" {}
variable "replicas_per_node_group" {}
variable "node_type" {}

