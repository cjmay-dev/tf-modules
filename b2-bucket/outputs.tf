output "bucket_name" {
    description = "Name of the bucket -- used for Terraform state migration"
    value = b2_bucket.backups.bucket_name
}

output "bucket_s3_uri" {
    description = "URI of the bucket for the restic repository"
    value = "s3:${data.b2_account_info.account.s3_api_url}/${b2_bucket.backups.bucket_name}"
}

output "bucket_key_id" {
    description = "Application Key ID that can access the backup bucket"
    value       = b2_application_key.backups_key.application_key_id
    sensitive   = true
}

output "bucket_key_secret" {
    description = "Appliction Key Secret that can access the backup bucket"
    value       = b2_application_key.backups_key.application_key
    sensitive   = true
}
