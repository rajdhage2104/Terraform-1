variable "instances" {
  type = list(object ({
    name = string
    ami_id = string
    instance_type = string
    key_name = string
  }))
}