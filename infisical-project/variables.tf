variable "APP_SECRETS" {
    type = map(string)
}

variable "APP_SHORTNAME" {
  description = "The short name of the app"
  type        = string
}

variable "ORG_SHORTNAME" {
  description = "The short name of the organization"
  type        = string
}

variable "DOMAIN" {
  description = "The domain for where the app will be hosted"
  type        = string
}

variable "ENV_SLUG" {
  description = "The environment slug (e.g., dev, staging, prod)"
  type        = string
}

variable "INFISICAL_ADMIN_USER" {
  description = "The username of the admin user in Infisical"
  type        = string
}