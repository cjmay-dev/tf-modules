variable "APP_SHORTNAME" {
    description = "Subdomain where the app is hosted"
    type        = string
}

variable "ORG_SHORTNAME" {
    description = "Single-word name of organization"
    type        = string
}

variable "ENV_SLUG" {
    description = "Environment slug"
    type        = string
}

variable "B2_KEY_ID"{
    description = "Application Key ID with writeBuckets,writeKeys permissions"
    type        = string
    sensitive   = true
}

variable "B2_KEY_SECRET"{
    description = "Application Key Secret with writeBuckets,writeKeys permissions"
    type        = string
    sensitive   = true
}