variable "RESOURCE_GROUP_NAME" {
  type        = string
  description = "Resource group"
}

variable "APP_GATEWAY_NAME" {
  type        = string
  description = "Application name. Use only lowercase letters and numbers"

}

# variable "LOCATION" {
#   type        = string
#   description = "Azure region where to create resources."
# }

# variable "APP_GATEWAY_NAME" {
#   type        = string
#   description = "define the name of the application gateway"
# }

variable "APPGW_PUBLIC_IP_NAME" {
  type        = string
  description = "PUBLIC IP. This service will create subnets in this network."
}
