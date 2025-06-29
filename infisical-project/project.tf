locals {
  subdomain = "${trimsuffix(var.APP_SHORTNAME, "-${var.ENV_SLUG}")}"
}

# New project in Infisical for app secrets
resource "infisical_project" "app_secrets" {
  lifecycle {
    ignore_changes = [
      kms_secret_manager_key_id
    ]
  }
  name = "${local.subdomain}.${var.DOMAIN}"
  slug = "${local.subdomain}-${var.ORG_SHORTNAME}"
  description = "Application secrets for https://github.com/${var.GITHUB_REPOSITORY}"
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

resource "infisical_secret" "project_id" {
  name         = "INFISICAL_PROJECT_ID"
  value        = infisical_project.app_secrets.id
  env_slug     = var.ENV_SLUG
  workspace_id = infisical_project.app_secrets.id
  folder_path  = "/"
}