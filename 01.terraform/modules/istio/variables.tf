variable "endpoint" {
  type = string
}

variable "cluster_ca_certificate" {
  type = string
}

variable "access_token" {
  type = string
}

variable "istio-version" {
  type = string
  default = "1.12.0"
}
 