locals {
  fqdn = "${var.APP_SHORTNAME}.${var.DOMAIN}"
}

# New project in Infisical for app secrets
resource "infisical_project" "app_secrets" {
  name = local.fqdn
  slug = replace(local.fqdn, ".", "-")
}

resource "infisical_project_user" "admin_user" {
  project_id = infisical_project.app_secrets.id
  username   = var.INFISICAL_ADMIN_USER
  roles = [
    {
      role_slug = "admin"
    }
  ]
}

resource "infisical_secret" "app_secrets" {
  for_each     = var.APP_SECRETS
  name         = each.key
  value        = each.value
  env_slug     = var.ENV_SLUG
  workspace_id = infisical_project.app_secrets.id
  folder_path  = "/"
}