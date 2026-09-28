variable "terraform_token" {
    type            = string
    description     = "API Token for PVE Authentication"
    sensitive       = true
} 

variable "terraform_user" {
    type            = string
    description     = "API Token ID for PVE Authentication"
    sensitive       = true
}

variable "pve_host" {
    type            = string
    description     = "API Access point for connecting to PVE API"
    sensitive       = true
}

variable "terraform_build_pass" {
    type            = string
    description     = "Wazuh startup Password"
    sensitive       = true
}