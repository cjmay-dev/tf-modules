variable "APP_SHORTNAME" {
    description = "Subdomain where the app is hosted"
    type        = string
}

variable "LOCAL_DOMAIN" {
    description = "Local domain of the network where the host is located"
    type        = string
}

variable "ADMIN_USERNAME" {
    description = "Username of the admin user"
    type        = string
}

variable "ADMIN_SSH_PUBLIC_KEY" {
    description = "SSH public key of the admin user"
    type        = string
}

variable "ANSIBLE_SSH_PUBLIC_KEY" {
    description = "SSH public key of the ansible user"
    type        = string
}

variable "DATASTORE_ID" {
    description = "ID of the datastore where the VM disk will be created"
    type        = string
}